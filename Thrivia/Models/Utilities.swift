//
//  Utilities.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 01/08/2023.
//

import Foundation

class Utilities {
    
    static func retrieveCryptoUserFromUserDefaults() -> CryptoUser? {
        var cryptoUser: CryptoUser?
        
        let defaults = UserDefaults.standard
        var codableCryptoUser: CodableCryptoUser?
        
        if let codableCryptoUserData = defaults.data(forKey: "codableCryptoUser") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                codableCryptoUser = try decoder.decode(CodableCryptoUser.self, from: codableCryptoUserData)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if let retrievedCodableCryptoUser = codableCryptoUser {
            cryptoUser = CryptoUser(codableCryptoUser: retrievedCodableCryptoUser)
        }
        
        return cryptoUser
    }
    
    static func replaceOneTimePrekeyInUserDefaults(prekeyIdentifier: Int) -> String? {
        var newOneTimePrekey: String?
        
        if var cryptoUser = retrieveCryptoUserFromUserDefaults() {
            newOneTimePrekey = cryptoUser.replaceOneTimePrekeyAndGetPublicKeyString(prekeyIdentifier: prekeyIdentifier)
        }
        
        return newOneTimePrekey
    }
    
    static func saveConversationToUserDefaults(conversation: Conversation, chatId: String) -> Bool {
        var conversationSaved = false
        
        let defaults = UserDefaults.standard
        
        let codableConversation = CodableConversation(conversation: conversation)
        let ephemeralKeySet = conversation.previouslyReceivedEphemeralKeys
        let ephemeralKeyArray = Array(ephemeralKeySet)
        let storedMessageKeys = conversation.storedMessageKeys
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(codableConversation)
            let storedKeyData = try encoder.encode(storedMessageKeys)
            
            // Write/Set Data
            defaults.set(data, forKey: chatId)
            defaults.set(ephemeralKeyArray, forKey: "previouslyReceivedEphemeralKeys-\(chatId)")
            defaults.set(storedKeyData, forKey: "storedMessageKeys-\(chatId)")
            
            conversationSaved = true
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        
        return conversationSaved
    }
    
    static func retrieveConversationFromUserDefaults(chatId: String) -> Conversation? {
        var conversation: Conversation?
        
        let defaults = UserDefaults.standard
        var codableConversation: CodableConversation?
        
        if let conversationData = defaults.data(forKey: chatId) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                codableConversation = try decoder.decode(CodableConversation.self, from: conversationData)
            } catch {
                print("Unable to Decode (\(error))")
            }
        }
        
        if let retrievedConversation = codableConversation {
            let previouslyReceivedEphemeralKeys = defaults.object(forKey: "previouslyReceivedEphemeralKeys-\(chatId)") as? [Data] ?? []
            
            if let savedData = defaults.object(forKey: "storedMessageKeys-\(chatId)") as? Data {

                do {
                    let storedMessageKeys = try JSONDecoder().decode([StoredKey].self, from: savedData)
                    let setOfPreviouslyReceivedEphemeralKeys = Set(previouslyReceivedEphemeralKeys)
                    
                    conversation = Conversation(codableConversation: retrievedConversation, previouslyReceivedEphemeralKeys: setOfPreviouslyReceivedEphemeralKeys, storedMessageKeys: storedMessageKeys)
                } catch {
                    print("Unable to Decode (\(error))")
                }
            }
        }
        
        return conversation
    }
}
