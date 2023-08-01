//
//  Conversation.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

class Conversation {
    // static constants
    private static let rootDerivationInfo = "root key derivation info".data(using: .utf8)!
    private static let singleByte1 = Int8(bitPattern: 0x01).description.data(using: .utf8)!
    private static let singleByte2 = Int8(bitPattern: 0x02).description.data(using: .utf8)!
    
    // users
    var user: CryptoUser
    var otherUser: CryptoOtherUser
    
    // decrypted messages
    var messages: [Message]
    
    // boolean to show whether last message was received from other user
    var lastMessageReceived: Bool?
    
    // dh ratchet keys
    var dhRatchetPrivateKey: Curve25519.KeyAgreement.PrivateKey
    var dhRatchetPublicKey: Curve25519.KeyAgreement.PublicKey
    
    // other user dh key
    var otherUserDhRatchetKey: Curve25519.KeyAgreement.PublicKey?
    
    // symmetric ratchet chainkeys
    var rootChainKey: SymmetricKey?
    var sendChainKey: SymmetricKey?
    var receiveChainKey: SymmetricKey?
    
    // send chain lengths
    var previousSendChainLength = 0
    var currentSendChainLength = 0
    
    // receive chain length
    var currentReceiveChainLength = 0
    
    // last ephemeral key received
    var lastEphemeralKeyReceived: Data?
    
    // previous ephemeral keys received to check if message is new or old chain
    var previouslyReceivedEphemeralKeys: Set<Data>
    
    // store message keys for missed messages
    var storedMessageKeys: [StoredKey]
    
    // new object initialiser
    init(user: CryptoUser, otherUser: CryptoOtherUser) {
        self.user = user
        self.otherUser = otherUser
        
        messages = []
        
        dhRatchetPrivateKey = user.signedPrekeyPrivate
        dhRatchetPublicKey = user.signedPrekeyPublic
        
        previouslyReceivedEphemeralKeys = []
        storedMessageKeys = []
    }
    
    // initialiser to restore object from local storage codable format
    init(codableConversation: CodableConversation, previouslyReceivedEphemeralKeys: Set<Data>, storedMessageKeys: [StoredKey]) {
        // users
        user = CryptoUser(codableCryptoUser: codableConversation.user)
        
        otherUser = CryptoOtherUser(codableCryptoOtherUser: codableConversation.otherUser)
        
        messages = codableConversation.messages
        
        // last message received
        lastMessageReceived = codableConversation.lastMessageReceived
        
        // dh ratchet key pair
        dhRatchetPrivateKey = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: codableConversation.dhRatchetPrivateKey)
        dhRatchetPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableConversation.dhRatchetPublicKey)
        
        // other user dh ratchet key
        if let otherUserDhRatchetKey = codableConversation.otherUserDhRatchetKey {
            self.otherUserDhRatchetKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: otherUserDhRatchetKey)
        }
        
        // chain keys
        if let rootChainKey = codableConversation.rootChainKey {
            self.rootChainKey = SymmetricKey(data: rootChainKey)
        }
        
        if let sendChainKey = codableConversation.sendChainKey {
            self.sendChainKey = SymmetricKey(data: sendChainKey)
        }
        
        if let receiveChainKey = codableConversation.receiveChainKey {
            self.receiveChainKey = SymmetricKey(data: receiveChainKey)
        }
        
        // send chain lengths
        previousSendChainLength = codableConversation.previousSendChainLength
        currentSendChainLength = codableConversation.currentSendChainLength
        
        // receive chain length
        currentReceiveChainLength = codableConversation.currentReceiveChainLength
        
        // last ephemeral key received
        lastEphemeralKeyReceived = codableConversation.lastEphemeralKeyReceived
        
        // previous ephemeral keys received to check if message is new or old chain
        self.previouslyReceivedEphemeralKeys = previouslyReceivedEphemeralKeys
        
        // store message keys for missed messages
        self.storedMessageKeys = storedMessageKeys
    }
    
    func convertSharedSecretToByteSequence(sharedSecret: SharedSecret) -> Data {
        var result: Data?
        sharedSecret.withUnsafeBytes { result = Data($0) }
        return result!
    }
    
    func convertSymmetricKeyToByteSequence(symmetricKey: SymmetricKey) -> Data {
        var result: Data?
        symmetricKey.withUnsafeBytes { result = Data($0) }
        return result!
    }
    
    func generateMasterKeyFromDH(dh1: SharedSecret, dh2: SharedSecret, dh3: SharedSecret, dh4: SharedSecret) -> SymmetricKey {
        // combine shared secrets to calculate master symmetric key
        var byteSequence = convertSharedSecretToByteSequence(sharedSecret: dh1)
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh2))
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh3))
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh4))
        
        let masterSecret = SymmetricKey(data: byteSequence)
        let masterKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: masterSecret, outputByteCount: 32)
        
        return masterKey
    }
    
    func generateSenderMasterKey(ephemeralKeyPrivate: Curve25519.KeyAgreement.PrivateKey) -> SymmetricKey? {
        // verify prekey signature
        let signedPrekey = otherUser.signedPrekeySigning
        let prekeySignature = otherUser.prekeySignature
        let identityKey = otherUser.identityKey
        let isValidSignature = signedPrekey.isValidSignature(prekeySignature, for: identityKey.rawRepresentation)
        
        if !isValidSignature {
            return nil
        }
        
        // generate Diffie-Hellman shared secrets
        do {
            let dh1 = try user.identityKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.signedPrekey)
            let dh2 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.identityKey)
            let dh3 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.signedPrekey)
            let dh4 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.oneTimePrekey)
            
            // generate and return master key
            let masterKey = generateMasterKeyFromDH(dh1: dh1, dh2: dh2, dh3: dh3, dh4: dh4)
            return masterKey
        } catch {
            return nil
        }
    }
    
    func generateAssociatedData(senderId: String, senderIdentityKey: Data, recipientId: String, recipientIdentityKey: Data) -> Data {
        // calculate associated data byte sequence - ***THIS SHOULD BE HASHED*** this forms the safety number
        // safety number is shown publicly for a conversation in signal to verify identities - should be same on both ends
        var associatedData = Data()
        // order of addition = sender IK + recipient IK + sender ID + recipient ID
        associatedData.append(senderIdentityKey)
        associatedData.append(recipientIdentityKey)
        associatedData.append(senderId.data(using: .utf8)!)
        associatedData.append(recipientId.data(using: .utf8)!)
        
        // hash associated data using SHA256
        let hashedAD = SHA256.hash(data: associatedData)
        
        var hashData = Data()
        hashedAD.withUnsafeBytes { hashData = Data($0) }
        
        return hashData
    }
    
    func getKdfKeyFromKdfOutput(output: SymmetricKey) -> SymmetricKey {
        var outputBytes = Data()
        output.withUnsafeBytes { outputBytes = Data($0) }
        let kdfKeyBytes = outputBytes[..<32]
        return SymmetricKey(data: kdfKeyBytes)
    }
    
    func getOutputKeyFromKdfOutput(output: SymmetricKey) -> SymmetricKey {
        var outputBytes = Data()
        output.withUnsafeBytes { outputBytes = Data($0) }
        let messageKey = outputBytes[32...]
        return SymmetricKey(data: messageKey)
    }
    
    func generateDhRatchetPair() {
        dhRatchetPrivateKey = Curve25519.KeyAgreement.PrivateKey()
        dhRatchetPublicKey = dhRatchetPrivateKey.publicKey
    }
    
    func generateDhOutputKey(otherUserDhRatchetKey: Curve25519.KeyAgreement.PublicKey) -> SymmetricKey? {
        do {
            let dhOutput = try dhRatchetPrivateKey.sharedSecretFromKeyAgreement(with: otherUserDhRatchetKey)
            let dhOutputBytes = convertSharedSecretToByteSequence(sharedSecret: dhOutput)
            let dhOutputKey = SymmetricKey(data: dhOutputBytes)
            return dhOutputKey
        } catch {
            return nil
        }
    }
    
    func kdfRoot(dhOutputKey: SymmetricKey) -> [SymmetricKey] {
        let rootChainKeyBytes = convertSymmetricKeyToByteSequence(symmetricKey: rootChainKey!)
        let rootChainOutput = HKDF<SHA256>.deriveKey(inputKeyMaterial: dhOutputKey, salt: rootChainKeyBytes, info: Conversation.rootDerivationInfo, outputByteCount: 64)
        
        // derive and store root chain key
        let rootKey = getKdfKeyFromKdfOutput(output: rootChainOutput)
        
        let chainKey = getOutputKeyFromKdfOutput(output: rootChainOutput)
        
        // derive and return chain key
        return [rootKey, chainKey]
    }
    
    func kdfMessage(currentChainKey: SymmetricKey) -> [SymmetricKey] {
        let messageKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: currentChainKey, info: Conversation.singleByte1, outputByteCount: 32)
        let chainKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: currentChainKey, info: Conversation.singleByte2, outputByteCount: 32)
        return [chainKey, messageKey]
    }
    
    func encryptMessage(messageData: Data, messageKey: SymmetricKey, associatedData: Data) -> Data? {
        do {
            let encryptedMessage = try ChaChaPoly.seal(messageData, using: messageKey, authenticating: associatedData).combined
            
            return encryptedMessage
        } catch {
            return nil
        }
    }
    
    func sendMessage(messageContent: String) -> EncryptedMessage? {
        // RESET ROOT CHAIN IF LAST MESSAGE RECEIVED
        if lastMessageReceived == nil || lastMessageReceived! {
            // if enters block, DH ratchet step is triggered
            
            // generate new DH ratchet key pair
            generateDhRatchetPair()
            
            // calculate dh output
            let dhRatchetKey = otherUserDhRatchetKey != nil ? otherUserDhRatchetKey! : otherUser.signedPrekey
            guard let dhOutputKey = generateDhOutputKey(otherUserDhRatchetKey: dhRatchetKey) else { return nil }
            
            // derive root chain and send chain keys from KDF output
            if rootChainKey == nil {
                if let masterKey = generateSenderMasterKey(ephemeralKeyPrivate: dhRatchetPrivateKey) {
                    rootChainKey = masterKey
                } else {
                    return nil
                }
            }
            
            // derive and store new root and send chain keys
            let kdfRootOutput = kdfRoot(dhOutputKey: dhOutputKey)
            rootChainKey = kdfRootOutput[0]
            sendChainKey = kdfRootOutput[1]
            
            // set previous send chain length equal to current send chain length
            previousSendChainLength = currentSendChainLength
            
            // reset current send chain length
            currentSendChainLength = 0
        }
        
        // derive new send chain key and message key for encryption
        let kdfMessageOutput = kdfMessage(currentChainKey: sendChainKey!)
        sendChainKey = kdfMessageOutput[0]
        
        let messageKey = kdfMessageOutput[1]
        
        // generate associated data
        let associatedData = generateAssociatedData(senderId: user.id, senderIdentityKey: user.identityKeyPublic.rawRepresentation, recipientId: otherUser.id, recipientIdentityKey: otherUser.identityKey.rawRepresentation)
        
        // convert message content to data
        let messageData = messageContent.data(using: .utf8)!
        
        // encrypt message content
        if let encryptedMessage = encryptMessage(messageData: messageData, messageKey: messageKey, associatedData: associatedData) {
            // create new message
            let messageId = UUID().uuidString
            
            let message = EncryptedMessage(id: messageId, timestamp: Date.now, cipherText: encryptedMessage.base64EncodedString(), identityKey: user.identityKeyPublic.rawRepresentation.base64EncodedString(), ephemeralKey: dhRatchetPublicKey.rawRepresentation.base64EncodedString(), oneTimePreKeyIdentifier: otherUser.prekeyIdentifier, sendChainLength: currentSendChainLength, previousSendChainLength: previousSendChainLength)
            
            // set last message received to false since user sending this message
            lastMessageReceived = false
            
            // increase length of current send chain
            currentSendChainLength += 1
            
            messages.append(Message(id: messageId, content: messageContent, sent: true, read: true, timestamp: Date.now))
            
            return message
        } else {
            return nil
        }
    }
    
    func generateRecipientMasterKey(oneTimePrekeyIdentifier: Int, senderIdentityKey: Curve25519.KeyAgreement.PublicKey, ephemeralKey: Curve25519.KeyAgreement.PublicKey) -> SymmetricKey? {
        do {
            // generate Diffie-Hellman shared secrets
            let dh1 = try user.signedPrekeyPrivate.sharedSecretFromKeyAgreement(with: senderIdentityKey)
            let dh2 = try user.identityKeyPrivate.sharedSecretFromKeyAgreement(with: ephemeralKey)
            let dh3 = try user.signedPrekeyPrivate.sharedSecretFromKeyAgreement(with: ephemeralKey)
            let dh4 = try user.oneTimePrekeysPrivate[oneTimePrekeyIdentifier].sharedSecretFromKeyAgreement(with: ephemeralKey)
            
            // generate and return master key
            let masterKey = generateMasterKeyFromDH(dh1: dh1, dh2: dh2, dh3: dh3, dh4: dh4)
            return masterKey
        } catch {
            return nil
        }
    }
    
    func decryptMessage(message: EncryptedMessage, messageKey: SymmetricKey, associatedData: Data) -> Data? {
        do {
            let cipherText = Data(base64Encoded: message.cipherText)!
            let sealedBox = try ChaChaPoly.SealedBox(combined: cipherText)
            let decryptedData = try ChaChaPoly.open(sealedBox, using: messageKey, authenticating: associatedData)
            return decryptedData
        } catch {
            print("failed to decrypt")
            return nil
        }
    }
    
    func findStoredKey(ephemeralKeyRaw: Data, messageNumber: Int) -> StoredKey? {
        var foundKeyIndex: Int?
        
        for i in 0..<storedMessageKeys.count {
            let storedKey = storedMessageKeys[i]
            
            if storedKey.rawEphemeralKey == ephemeralKeyRaw && storedKey.messageNumber == messageNumber {
                foundKeyIndex = i
                break
            }
        }
        
        guard let index = foundKeyIndex else { return nil }
        
        return storedMessageKeys.remove(at: index)
    }
    
    func storeSkippedMessageKeys(skippedMessages: Int, messageNumber: Int, ephemeralKeyRaw: Data) {
        var count = skippedMessages
        var N = messageNumber
        
        while count > 0 {
            let kdfMessageOutput = kdfMessage(currentChainKey: receiveChainKey!)
            receiveChainKey = kdfMessageOutput[0]
            let messageKey = kdfMessageOutput[1]
            let keyToStore = StoredKey(messageNumber: N, key: convertSymmetricKeyToByteSequence(symmetricKey: messageKey), rawEphemeralKey: ephemeralKeyRaw)
            storedMessageKeys.append(keyToStore)
            N += 1
            count -= 1
            currentReceiveChainLength += 1
        }
    }
    
    func receiveMessage(message: EncryptedMessage) {
        var senderIdentityKey: Curve25519.KeyAgreement.PublicKey
        var ephemeralKey: Curve25519.KeyAgreement.PublicKey
        
        do {
            senderIdentityKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: message.identityKey)!)
            ephemeralKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: message.ephemeralKey)!)
        } catch {
            return
        }
        
        otherUserDhRatchetKey = ephemeralKey
        let prekeyIdentifier = message.oneTimePreKeyIdentifier
        let N = message.sendChainLength
        let PN = message.previousSendChainLength
        
        var storedMessageKey: StoredKey?
        var messageKey: SymmetricKey
        
        if previouslyReceivedEphemeralKeys.contains(ephemeralKey.rawRepresentation) {
            storedMessageKey = findStoredKey(ephemeralKeyRaw: ephemeralKey.rawRepresentation, messageNumber: N)
        }
        
        if storedMessageKey == nil {
            // RESET ROOT CHAIN IF LAST MESSAGE SENT
            if (lastMessageReceived == nil || !lastMessageReceived!) && (lastEphemeralKeyReceived == nil || lastEphemeralKeyReceived! != ephemeralKey.rawRepresentation) {
                // if enters block, DH ratchet step is triggered
                
                // check if any messages missed from previous chain
                var skippedMessages = PN - currentReceiveChainLength
                
                if skippedMessages > 0 {
                    storeSkippedMessageKeys(skippedMessages: skippedMessages, messageNumber: PN - 1, ephemeralKeyRaw: lastEphemeralKeyReceived!)
                }
                
                // calculate dh output
                guard let dhOutputKey = generateDhOutputKey(otherUserDhRatchetKey: ephemeralKey) else { return }
                
                // derive root chain and send chain keys from KDF output
                if rootChainKey == nil {
                    rootChainKey = generateRecipientMasterKey(oneTimePrekeyIdentifier: prekeyIdentifier, senderIdentityKey: senderIdentityKey, ephemeralKey: ephemeralKey)
                }
                
                // derive and store new root and receive chain keys
                let kdfRootOutput = kdfRoot(dhOutputKey: dhOutputKey)
                rootChainKey = kdfRootOutput[0]
                receiveChainKey = kdfRootOutput[1]
                
                // reset receive chain length after Diffie-Hellman
                currentReceiveChainLength = 0
                
                // check if any missed messages from current chain
                skippedMessages = N
                
                if skippedMessages > 0 {
                    storeSkippedMessageKeys(skippedMessages: skippedMessages, messageNumber: 0, ephemeralKeyRaw: ephemeralKey.rawRepresentation)
                }
                
                // set last message received to true since user received this message
                lastMessageReceived = true
            } else {
                // check if any messages missed
                let skippedMessages = N - currentReceiveChainLength
                
                if skippedMessages > 0 {
                    storeSkippedMessageKeys(skippedMessages: skippedMessages, messageNumber: currentReceiveChainLength, ephemeralKeyRaw: lastEphemeralKeyReceived!)
                }
            }
            
            // derive new receive chain key and message key for decryption
            let kdfMessageOutput = kdfMessage(currentChainKey: receiveChainKey!)
            receiveChainKey = kdfMessageOutput[0]
            messageKey = kdfMessageOutput[1]
            
            // set last ephemeral key received to current ephemeral key
            lastEphemeralKeyReceived = ephemeralKey.rawRepresentation
            
            // add ephemeral key to previously received ephemeral keys array
            previouslyReceivedEphemeralKeys.insert(lastEphemeralKeyReceived!)
            
            // increment receive chain length
            currentReceiveChainLength += 1
        } else {
            messageKey = SymmetricKey(data: storedMessageKey!.key)
        }
        
        // generate associated data
        let associatedData = generateAssociatedData(senderId: otherUser.id, senderIdentityKey: otherUser.identityKey.rawRepresentation, recipientId: user.id, recipientIdentityKey: user.identityKeyPublic.rawRepresentation)
        
        // decrypt message
        if let decryptedData = decryptMessage(message: message, messageKey: messageKey, associatedData: associatedData) {
            // add new message object to messages array
            let messageContent = String(data: decryptedData, encoding: .utf8)!
            let newMessage = Message(id: message.id, content: messageContent, sent: false, read: true, timestamp: message.timestamp)
            messages.append(newMessage)
            
            messages.sort {
                $0.timestamp < $1.timestamp
            }
        }
    }
    
    func resetMessages() {
        messages = []
    }
    
    func removeMessage(messageIds: Set<String>) {
        var editedMessages: [Message] = []
        
        for message in messages {
            if !messageIds.contains(message.id) {
                editedMessages.append(message)
            }
        }
        
        messages = editedMessages
    }
}
