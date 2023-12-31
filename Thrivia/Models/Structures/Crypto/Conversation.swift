//
//  Conversation.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct Conversation {
    // static constants
    private static let rootDerivationInfo = "root key derivation info".data(using: .utf8)!
    private static let singleByte1 = Int8(bitPattern: 0x01).description.data(using: .utf8)!
    private static let singleByte2 = Int8(bitPattern: 0x02).description.data(using: .utf8)!
    
    // users
    private var user: CryptoUser
    private var otherUser: CryptoOtherUser
    
    // decrypted messages
    private var messages: [Message] = []
    
    // boolean to show whether last message was received from other user
    private var lastMessageReceived: Bool?
    
    // dh ratchet keys
    private var dhRatchetPrivateKey: Curve25519.KeyAgreement.PrivateKey
    private var dhRatchetPublicKey: Curve25519.KeyAgreement.PublicKey
    
    // other user dh key
    private var otherUserDhRatchetKey: Curve25519.KeyAgreement.PublicKey?
    
    // symmetric ratchet chainkeys
    private var rootChainKey: SymmetricKey?
    private var sendChainKey: SymmetricKey?
    private var receiveChainKey: SymmetricKey?
    
    // send chain lengths
    private var previousSendChainLength = 0
    private var currentSendChainLength = 0
    
    // receive chain length
    private var currentReceiveChainLength = 0
    
    // last ephemeral key received
    private var lastEphemeralKeyReceived: Data?
    
    // previous ephemeral keys received to check if message is new or old chain
    private var previouslyReceivedEphemeralKeys: Set<Data> = []
    
    // store message keys for missed messages
    private var storedMessageKeys: [StoredKey] = []
    
    // new object initialiser
    init(user: CryptoUser, otherUser: CryptoOtherUser) {
        self.user = user
        self.otherUser = otherUser
        
        dhRatchetPrivateKey = user.getSignedPrekeyPrivate()
        dhRatchetPublicKey = user.getSignedPrekeyPublic()
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
    
    func getUser() -> CryptoUser {
        return user
    }
    
    func getOtherUser() -> CryptoOtherUser {
        return otherUser
    }
    
    func lastMessageWasReceived() -> Bool? {
        return lastMessageReceived
    }
    
    func getMessages() -> [Message] {
        return messages
    }
    
    func getDhRatchetPrivateKey() -> Curve25519.KeyAgreement.PrivateKey {
        return dhRatchetPrivateKey
    }
    
    func getDhRatchetPublicKey() -> Curve25519.KeyAgreement.PublicKey {
        return dhRatchetPublicKey
    }
    
    func getOtherUserDhRatchetKey() -> Curve25519.KeyAgreement.PublicKey? {
        return otherUserDhRatchetKey
    }
    
    func getRootChainKey() -> SymmetricKey? {
        return rootChainKey
    }
    
    func getSendChainKey() -> SymmetricKey? {
        return sendChainKey
    }
    
    func getReceiveChainKey() -> SymmetricKey? {
        return receiveChainKey
    }
    
    func getPreviousSendChainLength() -> Int {
        return previousSendChainLength
    }
    
    func getCurrentSendChainLength() -> Int {
        return currentSendChainLength
    }
    
    func getCurrentReceiveChainLength() -> Int {
        return currentReceiveChainLength
    }
    
    func getLastEphemeralKeyReceived() -> Data? {
        return lastEphemeralKeyReceived
    }
    
    func getPreviouslyReceivedEphemeralKeys() -> Set<Data> {
        return previouslyReceivedEphemeralKeys
    }
    
    func getStoredMessageKeys() -> [StoredKey] {
        return storedMessageKeys
    }
    
    mutating func resetMessages() {
        messages = []
    }
    
    mutating func removeMessages(messageIds: Set<String>) {
        var editedMessages: [Message] = []
        
        for message in messages {
            if !messageIds.contains(message.id) {
                editedMessages.append(message)
            }
        }
        
        messages = editedMessages
    }
    
    func isFirstMessage() -> Bool {
        return lastMessageReceived == nil
    }
    
    private func convertSharedSecretToByteSequence(sharedSecret: SharedSecret) -> Data {
        var result: Data?
        sharedSecret.withUnsafeBytes { result = Data($0) }
        return result!
    }
    
    private func convertSymmetricKeyToByteSequence(symmetricKey: SymmetricKey) -> Data {
        var result: Data?
        symmetricKey.withUnsafeBytes { result = Data($0) }
        return result!
    }
    
    private func generateMasterKeyFromDH(dh1: SharedSecret, dh2: SharedSecret, dh3: SharedSecret, dh4: SharedSecret) -> SymmetricKey {
        // combine shared secrets to calculate master symmetric key
        var byteSequence = convertSharedSecretToByteSequence(sharedSecret: dh1)
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh2))
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh3))
        byteSequence.append(convertSharedSecretToByteSequence(sharedSecret: dh4))
        
        let masterSecret = SymmetricKey(data: byteSequence)
        let masterKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: masterSecret, outputByteCount: 32)
        
        return masterKey
    }
    
    private func validatePrekeySignature() -> Bool {
        let signedPrekey = otherUser.getSignedPrekeySigning()
        let prekeySignature = otherUser.getPrekeySignature()
        let identityKey = otherUser.getIdentityKey()
        return signedPrekey.isValidSignature(prekeySignature, for: identityKey.rawRepresentation)
    }
    
    private func generateSenderMasterKey(ephemeralKeyPrivate: Curve25519.KeyAgreement.PrivateKey) -> SymmetricKey? {
        // verify prekey signature
        if !validatePrekeySignature() {
            return nil
        }
        
        // generate Diffie-Hellman shared secrets
        do {
            let dh1 = try user.getIdentityKeyPrivate().sharedSecretFromKeyAgreement(with: otherUser.getSignedPrekey())
            let dh2 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.getIdentityKey())
            let dh3 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.getSignedPrekey())
            let dh4 = try ephemeralKeyPrivate.sharedSecretFromKeyAgreement(with: otherUser.getOneTimePrekey())
            
            // generate and return master key
            let masterKey = generateMasterKeyFromDH(dh1: dh1, dh2: dh2, dh3: dh3, dh4: dh4)
            return masterKey
        } catch {
            return nil
        }
    }
    
    private func generateAssociatedData(senderId: String, senderIdentityKey: Data, recipientId: String, recipientIdentityKey: Data) -> Data {
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
    
    private func getKdfKeyFromKdfOutput(output: SymmetricKey) -> SymmetricKey {
        var outputBytes = Data()
        output.withUnsafeBytes { outputBytes = Data($0) }
        let kdfKeyBytes = outputBytes[..<32]
        return SymmetricKey(data: kdfKeyBytes)
    }
    
    private func getOutputKeyFromKdfOutput(output: SymmetricKey) -> SymmetricKey {
        var outputBytes = Data()
        output.withUnsafeBytes { outputBytes = Data($0) }
        let messageKey = outputBytes[32...]
        return SymmetricKey(data: messageKey)
    }
    
    mutating private func generateDhRatchetPair() {
        dhRatchetPrivateKey = Curve25519.KeyAgreement.PrivateKey()
        dhRatchetPublicKey = dhRatchetPrivateKey.publicKey
    }
    
    private func generateDhOutputKey(otherUserDhRatchetKey: Curve25519.KeyAgreement.PublicKey) -> SymmetricKey? {
        do {
            let dhOutput = try dhRatchetPrivateKey.sharedSecretFromKeyAgreement(with: otherUserDhRatchetKey)
            let dhOutputBytes = convertSharedSecretToByteSequence(sharedSecret: dhOutput)
            let dhOutputKey = SymmetricKey(data: dhOutputBytes)
            return dhOutputKey
        } catch {
            return nil
        }
    }
    
    private func kdfRoot(dhOutputKey: SymmetricKey) -> [SymmetricKey] {
        let rootChainKeyBytes = convertSymmetricKeyToByteSequence(symmetricKey: rootChainKey!)
        let rootChainOutput = HKDF<SHA256>.deriveKey(inputKeyMaterial: dhOutputKey, salt: rootChainKeyBytes, info: Conversation.rootDerivationInfo, outputByteCount: 64)
        
        // derive and store root chain key
        let rootKey = getKdfKeyFromKdfOutput(output: rootChainOutput)
        
        let chainKey = getOutputKeyFromKdfOutput(output: rootChainOutput)
        
        // derive and return chain key
        return [rootKey, chainKey]
    }
    
    private func kdfMessage(currentChainKey: SymmetricKey) -> [SymmetricKey] {
        let messageKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: currentChainKey, info: Conversation.singleByte1, outputByteCount: 32)
        let chainKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: currentChainKey, info: Conversation.singleByte2, outputByteCount: 32)
        return [chainKey, messageKey]
    }
    
    private func encryptMessage(messageData: Data, messageKey: SymmetricKey) -> Data? {
        // generate associated data
        let associatedData = generateAssociatedData(senderId: user.getId(), senderIdentityKey: user.getIdentityKeyPublic().rawRepresentation, recipientId: otherUser.getId(), recipientIdentityKey: otherUser.getIdentityKey().rawRepresentation)
        
        do {
            let encryptedMessage = try ChaChaPoly.seal(messageData, using: messageKey, authenticating: associatedData).combined
            
            return encryptedMessage
        } catch {
            return nil
        }
    }
    
    mutating func sendMessage(messageContent: String) -> EncryptedMessage? {
        // RESET ROOT CHAIN IF LAST MESSAGE RECEIVED
        if lastMessageReceived == nil || lastMessageReceived! {
            // if enters block, DH ratchet step is triggered
            
            // generate new DH ratchet key pair
            generateDhRatchetPair()
            
            // calculate dh output
            let dhRatchetKey = otherUserDhRatchetKey != nil ? otherUserDhRatchetKey! : otherUser.getSignedPrekey()
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
        
        // convert message content to data
        let messageData = messageContent.data(using: .utf8)!
        
        // encrypt message content
        if let encryptedMessage = encryptMessage(messageData: messageData, messageKey: messageKey) {
            // create new message
            let messageId = UUID().uuidString
            
            let message = EncryptedMessage(id: messageId, content: encryptedMessage.base64EncodedString(), timestamp: Date.now, identityKey: user.getIdentityKeyPublic().rawRepresentation.base64EncodedString(), ephemeralKey: dhRatchetPublicKey.rawRepresentation.base64EncodedString(), oneTimePreKeyIdentifier: otherUser.getPrekeyIdentifier(), sendChainLength: currentSendChainLength, previousSendChainLength: previousSendChainLength)
            
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
    
    private func generateRecipientMasterKey(oneTimePrekeyIdentifier: Int, senderIdentityKey: Curve25519.KeyAgreement.PublicKey, ephemeralKey: Curve25519.KeyAgreement.PublicKey) -> SymmetricKey? {
        do {
            // generate Diffie-Hellman shared secrets
            let dh1 = try user.getSignedPrekeyPrivate().sharedSecretFromKeyAgreement(with: senderIdentityKey)
            let dh2 = try user.getIdentityKeyPrivate().sharedSecretFromKeyAgreement(with: ephemeralKey)
            let dh3 = try user.getSignedPrekeyPrivate().sharedSecretFromKeyAgreement(with: ephemeralKey)
            let dh4 = try user.getOneTimePrekeysPrivate()[oneTimePrekeyIdentifier].sharedSecretFromKeyAgreement(with: ephemeralKey)
            
            // generate and return master key
            let masterKey = generateMasterKeyFromDH(dh1: dh1, dh2: dh2, dh3: dh3, dh4: dh4)
            return masterKey
        } catch {
            return nil
        }
    }
    
    private func decryptMessage(message: EncryptedMessage, messageKey: SymmetricKey) -> Data? {
        // generate associated data
        let associatedData = generateAssociatedData(senderId: otherUser.getId(), senderIdentityKey: otherUser.getIdentityKey().rawRepresentation, recipientId: user.getId(), recipientIdentityKey: user.getIdentityKeyPublic().rawRepresentation)
        
        do {
            let cipherText = Data(base64Encoded: message.getContent())!
            let sealedBox = try ChaChaPoly.SealedBox(combined: cipherText)
            let decryptedData = try ChaChaPoly.open(sealedBox, using: messageKey, authenticating: associatedData)
            return decryptedData
        } catch {
            return nil
        }
    }
    
    mutating private func findStoredKey(ephemeralKeyRaw: Data, messageNumber: Int) -> StoredKey? {
        var foundKeyIndex: Int?
        
        for i in 0..<storedMessageKeys.count {
            let storedKey = storedMessageKeys[i]
            
            if storedKey.getRawEphemeralKey() == ephemeralKeyRaw && storedKey.getMessageNumber() == messageNumber {
                foundKeyIndex = i
                break
            }
        }
        
        guard let index = foundKeyIndex else { return nil }
        
        return storedMessageKeys.remove(at: index)
    }
    
    mutating private func storeSkippedMessageKeys(skippedMessages: Int, messageNumber: Int, ephemeralKeyRaw: Data) {
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
    
    mutating func receiveMessage(message: EncryptedMessage) {
        var senderIdentityKey: Curve25519.KeyAgreement.PublicKey
        var ephemeralKey: Curve25519.KeyAgreement.PublicKey
        
        do {
            senderIdentityKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: message.getIdentityKey())!)
            ephemeralKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: Data(base64Encoded: message.getEphemeralKey())!)
        } catch {
            return
        }
        
        otherUserDhRatchetKey = ephemeralKey
        let prekeyIdentifier = message.getOneTimePrekeyIdentifier()
        let N = message.getSendChainLength()
        let PN = message.getPreviousSendChainLength()
        
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
            messageKey = SymmetricKey(data: storedMessageKey!.getKey())
        }
        
        // decrypt message
        if let decryptedData = decryptMessage(message: message, messageKey: messageKey) {
            // add new message object to messages array
            let messageContent = String(data: decryptedData, encoding: .utf8)!
            let newMessage = Message(id: message.id, content: messageContent, sent: false, read: true, timestamp: message.getTimestamp())
            messages.append(newMessage)
            
            messages.sort {
                $0.getTimestamp() < $1.getTimestamp()
            }
        }
    }
}
