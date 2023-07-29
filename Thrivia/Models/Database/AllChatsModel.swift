//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import FirebaseFirestore

class AllChatsModel {
    
    private let db = Firestore.firestore()
    
    let blockedWords: Set = ["abbo", "abo", "abortion", "abuse", "addict", "addicts", "adult", "africa", "african", "alla", "allah", "alligatorbait", "amateur", "american", "anal", "analannie", "analsex", "angie", "angry", "anus", "arab", "arabs", "areola", "argie", "aroused", "arse", "arsehole", "asian", "ass", "assassin", "assassinate", "assassination", "assault", "assbagger", "assblaster", "assclown", "asscowboy", "asses", "assfuck", "assfucker", "asshat", "asshole", "assholes", "asshore", "assjockey", "asskiss", "asskisser", "assklown", "asslick", "asslicker", "asslover", "assman", "assmonkey", "assmunch", "assmuncher", "asspacker", "asspirate", "asspuppies", "assranger", "asswhore", "asswipe", "athletesfoot", "attack", "australian", "babe", "babies", "backdoor", "backdoorman", "backseat", "badfuck", "balllicker", "balls", "ballsack", "banging", "baptist", "barelylegal", "barf", "barface", "barfface", "bast", "bastard", "bazongas", "bazooms", "beaner", "beast", "beastality", "beastial", "beastiality", "beatoff", "beat-off", "beatyourmeat", "beaver", "bestial", "bestiality", "bi", "biatch", "bible", "bicurious", "bigass", "bigbastard", "bigbutt", "bigger", "bisexual", "bi-sexual", "bitch", "bitcher", "bitches", "bitchez", "bitchin", "bitching", "bitchslap", "bitchy", "biteme", "black", "blackman", "blackout", "blacks", "blind", "blow", "blowjob", "boang", "bogan", "bohunk", "bollick", "bollock", "bomb", "bombers", "bombing", "bombs", "bomd", "bondage", "boner", "bong", "boob", "boobies", "boobs", "booby", "boody", "boom", "boong", "boonga", "boonie", "booty", "bootycall", "bountybar", "bra", "brea5t", "breast", "breastjob", "breastlover", "breastman", "brothel", "bugger", "buggered", "buggery", "bullcrap", "bulldike", "bulldyke", "bullshit", "bumblefuck", "bumfuck", "bunga", "bunghole", "buried", "burn", "butchbabes", "butchdike", "butchdyke", "butt", "buttbang", "butt-bang", "buttface", "buttfuck", "butt-fuck", "buttfucker", "butt-fucker", "buttfuckers", "butt-fuckers", "butthead", "buttman", "buttmunch", "buttmuncher", "buttpirate", "buttplug", "buttstain", "byatch", "cacker", "cameljockey", "cameltoe", "canadian", "cancer", "carpetmuncher", "carruth", "catholic", "catholics", "cemetery", "chav", "cherrypopper", "chickslick", "children's", "chin", "chinaman", "chinamen", "chinese", "chink", "chinky", "choad", "chode", "christ", "christian", "church", "cigarette", "cigs", "clamdigger", "clamdiver", "clit", "clitoris", "clogwog", "cocaine", "cock", "cockblock", "cockblocker", "cockcowboy", "cockfight", "cockhead", "cockknob", "cocklicker", "cocklover", "cocknob", "cockqueen", "cockrider", "cocksman", "cocksmith", "cocksmoker", "cocksucer", "cocksuck", "cocksucked", "cocksucker", "cocksucking", "cocktail", "cocktease", "cocky", "cohee", "coitus", "color", "colored", "coloured", "commie", "communist", "condom", "conservative", "conspiracy", "coolie", "cooly", "coon", "coondog", "copulate", "cornhole", "corruption", "cra5h", "crabs", "crack", "crackpipe", "crackwhore", "crack-whore", "crap", "crapola", "crapper", "crappy", "crash", "creamy", "crime", "crimes", "criminal", "criminals", "crotch", "crotchjockey", "crotchmonkey", "crotchrot", "cum", "cumbubble", "cumfest", "cumjockey", "cumm", "cummer", "cumming", "cumquat", "cumqueen", "cumshot", "cunilingus", "cunillingus", "cunn", "cunnilingus", "cunntt", "cunt", "cunteyed", "cuntfuck", "cuntfucker", "cuntlick", "cuntlicker", "cuntlicking", "cuntsucker", "cybersex", "cyberslimer", "dago", "dahmer", "dammit", "damn", "damnation", "damnit", "darkie", "darky", "datnigga", "dead", "deapthroat", "death", "deepthroat", "defecate", "dego", "demon", "deposit", "desire", "destroy", "deth", "devil", "devilworshipper", "dick", "dickbrain", "dickforbrains", "dickhead", "dickless", "dicklick", "dicklicker", "dickman", "dickwad", "dickweed", "diddle", "die", "died", "dies", "dike", "dildo", "dingleberry", "dink", "dipshit", "dipstick", "dirty", "disease", "diseases", "disturbed", "dive", "dix", "dixiedike", "dixiedyke", "doggiestyle", "doggystyle", "dong", "doodoo", "doo-doo", "doom", "dope", "dragqueen", "dragqween", "dripdick", "drug", "drunk", "drunken", "dumb", "dumbass", "dumbbitch", "dumbfuck", "dyefly", "dyke", "easyslut", "eatballs", "eatme", "eatpussy", "ecstacy", "ejaculate", "ejaculated", "ejaculating", "ejaculation", "enema", "enemy", "erect", "erection", "ero", "escort", "ethiopian", "ethnic", "european", "evl", "excrement", "execute", "executed", "execution", "executioner", "explosion", "facefucker", "faeces", "fag", "fagging", "faggot", "fagot", "failed", "failure", "fairies", "fairy", "faith", "fannyfucker", "fart", "farted", "farting", "farty", "fastfuck", "fat", "fatah", "fatass", "fatfuck", "fatfucker", "fatso", "fckcum", "fear", "feces", "felatio", "felch", "felcher", "felching", "fellatio", "feltch", "feltcher", "feltching", "fetish", "fight", "filipina", "filipino", "fingerfood", "fingerfuck", "fingerfucked", "fingerfucker", "fingerfuckers", "fingerfucking", "fire", "firing", "fister", "fistfuck", "fistfucked", "fistfucker", "fistfucking", "fisting", "flange", "flasher", "flatulence", "floo", "flydie", "flydye", "fok", "fondle", "footaction", "footfuck", "footfucker", "footlicker", "footstar", "fore", "foreskin", "forni", "fornicate", "foursome", "fourtwenty", "fraud", "freakfuck", "freakyfucker", "freefuck", "fu", "fubar", "fuc", "fucck", "fuck", "fucka", "fuckable", "fuckbag", "fuckbuddy", "fucked", "fuckedup", "fucker", "fuckers", "fuckface", "fuckfest", "fuckfreak", "fuckfriend", "fuckhead", "fuckher", "fuckin", "fuckina", "fucking", "fuckingbitch", "fuckinnuts", "fuckinright", "fuckit", "fuckknob", "fuckme", "fuckmehard", "fuckmonkey", "fuckoff", "fuckpig", "fucks", "fucktard", "fuckwhore", "fuckyou", "fudgepacker", "fugly", "fuk", "fuks", "funeral", "funfuck", "fungus", "fuuck", "gangbang", "gangbanged", "gangbanger", "gangsta", "gatorbait", "gay", "gaymuthafuckinwhore", "gaysex", "geez", "geezer", "geni", "genital", "german", "getiton", "gin", "ginzo", "gipp", "girls", "givehead", "glazeddonut", "gob", "god", "godammit", "goddamit", "goddammit", "goddamn", "goddamned", "goddamnes", "goddamnit", "goddamnmuthafucker", "goldenshower", "gonorrehea", "gonzagas", "gook", "gotohell", "goy", "goyim", "greaseball", "gringo", "groe", "gross", "grostulation", "gubba", "gummer", "gun", "gyp", "gypo", "gypp", "gyppie", "gyppo", "gyppy", "hamas", "handjob", "hapa", "harder", "hardon", "harem", "headfuck", "headlights", "hebe", "heeb", "hell", "henhouse", "heroin", "herpes", "heterosexual", "hijack", "hijacker", "hijacking", "hillbillies", "hindoo", "hiscock", "hitler", "hitlerism", "hitlerist", "hiv", "ho", "hobo", "hodgie", "hoes", "hole", "holestuffer", "homicide", "homo", "homobangers", "homosexual", "honger", "honk", "honkers", "honkey", "honky", "hook", "hooker", "hookers", "hooters", "hore", "hork", "horn", "horney", "horniest", "horny", "horseshit", "hosejob", "hoser", "hostage", "hotdamn", "hotpussy", "hottotrot", "hummer", "husky", "hussy", "hustler", "hymen", "hymie", "iblowu", "idiot", "ikey", "illegal", "incest", "insest", "intercourse", "interracial", "intheass", "inthebuff", "israel", "israeli", "israel's", "italiano", "itch", "jackass", "jackoff", "jackshit", "jacktheripper", "jade", "jap", "japanese", "japcrap", "jebus", "jeez", "jerkoff", "jesus", "jesuschrist", "jew", "jewish", "jiga", "jigaboo", "jigg", "jigga", "jiggabo", "jigger", "jiggy", "jihad", "jijjiboo", "jimfish", "jism", "jiz", "jizim", "jizjuice", "jizm", "jizz", "jizzim", "jizzum", "joint", "juggalo", "jugs", "junglebunny", "kaffer", "kaffir", "kaffre", "kafir", "kanake", "kid", "kigger", "kike", "kill", "killed", "killer", "killing", "kills", "kink", "kinky", "kissass", "kkk", "knife", "knockers", "kock", "kondum", "koon", "kotex", "krap", "krappy", "kraut", "kum", "kumbubble", "kumbullbe", "kummer", "kumming", "kumquat", "kums", "kunilingus", "kunnilingus", "kunt", "ky", "kyke", "lactate", "laid", "lapdance", "latin", "lesbain", "lesbayn", "lesbian", "lesbin", "lesbo", "lez", "lezbe", "lezbefriends", "lezbo", "lezz", "lezzo", "liberal", "libido", "licker", "lickme", "lies", "limey", "limpdick", "limy", "lingerie", "liquor", "livesex", "loadedgun", "lolita", "looser", "loser", "lotion", "lovebone", "lovegoo", "lovegun", "lovejuice", "lovemuscle", "lovepistol", "loverocket", "lowlife", "lsd", "lubejob", "lucifer", "luckycammeltoe", "lugan", "lynch", "macaca", "mad", "mafia", "magicwand", "mams", "manhater", "manpaste", "marijuana", "mastabate", "mastabater", "masterbate", "masterblaster", "mastrabator", "masturbate", "masturbating", "mattressprincess", "meatbeatter", "meatrack", "meth", "mexican", "mgger", "mggor", "mickeyfinn", "mideast", "milf", "minority", "mockey", "mockie", "mocky", "mofo", "moky", "moles", "molest", "molestation", "molester", "molestor", "moneyshot", "mooncricket", "mormon", "moron", "moslem", "mosshead", "mothafuck", "mothafucka", "mothafuckaz", "mothafucked", "mothafucker", "mothafuckin", "mothafucking", "mothafuckings", "motherfuck", "motherfucked", "motherfucker", "motherfuckin", "motherfucking", "motherfuckings", "motherlovebone", "muff", "muffdive", "muffdiver", "muffindiver", "mufflikcer", "mulatto", "muncher", "munt", "murder", "murderer", "muslim", "naked", "narcotic", "nasty", "nastybitch", "nastyho", "nastyslut", "nastywhore", "nazi", "necro", "negro", "negroes", "negroid", "negro's", "nig", "niger", "nigerian", "nigerians", "nigg", "nigga", "niggah", "niggaracci", "niggard", "niggarded", "niggarding", "niggardliness", "niggardliness's", "niggardly", "niggards", "niggard's", "niggaz", "nigger", "niggerhead", "niggerhole", "niggers", "nigger's", "niggle", "niggled", "niggles", "niggling", "nigglings", "niggor", "niggur", "niglet", "nignog", "nigr", "nigra", "nigre", "nip", "nipple", "nipplering", "nittit", "nlgger", "nlggor", "nofuckingway", "nook", "nookey", "nookie", "noonan", "nooner", "nude", "nudger", "nuke", "nutfucker", "nymph", "ontherag", "oral", "orga", "orgasim", "orgasm", "orgies", "orgy", "osama", "paki", "palesimian", "palestinian", "pansies", "pansy", "panti", "panties", "payo", "pearlnecklace", "peck", "pecker", "peckerwood", "pee", "peehole", "pee-pee", "peepshow", "peepshpw", "pendy", "penetration", "peni5", "penile", "penis", "penises", "penthouse", "period", "perv", "phonesex", "phuk", "phuked", "phuking", "phukked", "phukking", "phungky", "phuq", "pi55", "picaninny", "piccaninny", "pickaninny", "piker", "pikey", "piky", "pimp", "pimped", "pimper", "pimpjuic", "pimpjuice", "pimpsimp", "pindick", "piss", "pissed", "pisser", "pisses", "pisshead", "pissin", "pissing", "pissoff", "pistol", "pixie", "pixy", "playboy", "playgirl", "pocha", "pocho", "pocketpool", "pohm", "polack", "pom", "pommie", "pommy", "poo", "poon", "poontang", "poop", "pooper", "pooperscooper", "pooping", "poorwhitetrash", "popimp", "porchmonkey", "porn", "pornflick", "pornking", "porno", "pornography", "pornprincess", "pot", "poverty", "premature", "pric", "prick", "prickhead", "primetime", "propaganda", "pros", "prostitute", "protestant", "pu55i", "pu55y", "pube", "pubic", "pubiclice", "pud", "pudboy", "pudd", "puddboy", "puke", "puntang", "purinapricness", "puss", "pussie", "pussies", "pussy", "pussycat", "pussyeater", "pussyfucker", "pussylicker", "pussylips", "pussylover", "pussypounder", "pusy", "quashie", "queef", "queer", "quickie", "quim", "ra8s", "rabbi", "racial", "racist", "radical", "radicals", "raghead", "randy", "rape", "raped", "raper", "rapist", "rearend", "rearentry", "rectum", "redlight", "redneck", "reefer", "reestie", "refugee", "reject", "remains", "rentafuck", "republican", "rere", "retard", "retarded", "ribbed", "rigger", "rimjob", "rimming", "roach", "robber", "roundeye", "rump", "russki", "russkie", "sadis", "sadom", "samckdaddy", "sandm", "sandnigger", "satan", "scag", "scallywag", "scat", "schlong", "screw", "screwyou", "scrotum", "scum", "semen", "seppo", "servant", "sex", "sexed", "sexfarm", "sexhound", "sexhouse", "sexing", "sexkitten", "sexpot", "sexslave", "sextogo", "sextoy", "sextoys", "sexual", "sexually", "sexwhore", "sexy", "sexymoma", "sexy-slim", "shag", "shaggin", "shagging", "shat", "shav", "shawtypimp", "sheeney", "shhit", "shinola", "shit", "shitcan", "shitdick", "shite", "shiteater", "shited", "shitface", "shitfaced", "shitfit", "shitforbrains", "shitfuck", "shitfucker", "shitfull", "shithapens", "shithappens", "shithead", "shithouse", "shiting", "shitlist", "shitola", "shitoutofluck", "shits", "shitstain", "shitted", "shitter", "shitting", "shitty", "shoot", "shooting", "shortfuck", "showtime", "sick", "sissy", "sixsixsix", "sixtynine", "sixtyniner", "skank", "skankbitch", "skankfuck", "skankwhore", "skanky", "skankybitch", "skankywhore", "skinflute", "skum", "skumbag", "slant", "slanteye", "slapper", "slaughter", "slav", "slave", "slavedriver", "sleezebag", "sleezeball", "slideitin", "slime", "slimeball", "slimebucket", "slopehead", "slopey", "slopy", "slut", "sluts", "slutt", "slutting", "slutty", "slutwear", "slutwhore", "smack", "smackthemonkey", "smut", "snatch", "snatchpatch", "snigger", "sniggered", "sniggering", "sniggers", "snigger's", "sniper", "snot", "snowback", "snownigger", "sob", "sodom", "sodomise", "sodomite", "sodomize", "sodomy", "sonofabitch", "sonofbitch", "sooty", "sos", "soviet", "spaghettibender", "spaghettinigger", "spank", "spankthemonkey", "sperm", "spermacide", "spermbag", "spermhearder", "spermherder", "spic", "spick", "spig", "spigotty", "spik", "spit", "spitter", "splittail", "spooge", "spreadeagle", "spunk", "spunky", "squaw", "stagg", "stiffy", "strapon", "stringer", "stripclub", "stroke", "stroking", "stupid"]
    
    func listenToActiveUsers(userId: String, activeUsersSetter: @escaping ([OtherUser]) -> Void, listenerSetter: @escaping (ListenerRegistration) -> Void) {
        // get user blocked IDs
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                let setOfBlockedUserIds: Set<String> = Set(blockedUserIds ?? [])
                
                let listener = self.db.collection("users")
                    .whereField("isActive", isEqualTo: true)
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        
                        if let error = error {
                            print("Error getting documents: \(error)")
                            return
                        }
                        
                        var activeUsers: [OtherUser] = []
                        
                        for document in documents {
                            // check if user is the signed in user
                            if document.documentID == userId {
                                continue
                            }
                            
                            let data = document.data()
                            
                            // check if signed in user has blocked this user
                            if setOfBlockedUserIds.contains(document.documentID) {
                                print("signed in user has blocked this user")
                                continue
                            }
                            
                            // check if this user has blocked the signed in user
                            if let otherUserBlockedIds = data["blockedUserIds"] as? [String] {
                                let setOfOtherUserBlockedIds: Set<String> = Set(otherUserBlockedIds)
                                
                                if setOfOtherUserBlockedIds.contains(userId) {
                                    print("this user has blocked the signed in user")
                                    continue
                                }
                            }
                            
                            if let username = data["username"] as? String,
                               let iconColour = data["iconColour"] as? String {
                                let otherUser = OtherUser(id: document.documentID, username: username, iconColour: Color(iconColour))
                                activeUsers.append(otherUser)
                            }
                        }
                        
                        activeUsersSetter(activeUsers)
                    }
                
                listenerSetter(listener)
            }
        }
    }
    
    func listenForChatUpdates(userId: String, userChatsSetter: @escaping ([Chat]) -> Void, listenerSetter: @escaping (ListenerRegistration) -> Void) {
        // get user blocked IDs
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                let setOfBlockedUserIds: Set<String> = Set(blockedUserIds ?? [])
                
                // listen to chats
                let listener = self.db.collection("chats").whereField("userIds", arrayContains: userId)
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        
                        // initialise user chats array
                        var userChats: [Chat] = []
                        
                        // initialise chats dispatch group
                        let chatsDispatchGroup = DispatchGroup()
                        
                        for chatDoc in documents {
                            let chatData = chatDoc.data()
                            let chatId = chatDoc.documentID
                            
                            if let userIds = chatData["userIds"] as? [String] {
                                // get other user data
                                let otherUserId = userIds[0] == userId ? userIds[1] : userIds[0]
                                
                                // check if signed in user has blocked this user
                                if setOfBlockedUserIds.contains(otherUserId) {
                                    continue
                                }
                                
                                let docRef = self.db.collection("users").document(otherUserId)
                                
                                chatsDispatchGroup.enter()
                                
                                docRef.getDocument { (document, error) in
                                    if let otherUserDoc = document, otherUserDoc.exists {
                                        let otherUserData = otherUserDoc.data()
                                        
                                        // check if this user has blocked the signed in user
                                        var userIsBlocked = false
                                        
                                        if let otherUserBlockedIds = otherUserData?["blockedUserIds"] as? [String] {
                                            let setOfOtherUserBlockedIds: Set<String> = Set(otherUserBlockedIds)
                                            
                                            if setOfOtherUserBlockedIds.contains(userId) {
                                                userIsBlocked = true
                                            }
                                        }
                                        
                                        if !userIsBlocked, let otherUser = self.createOtherUserObjectFromData(otherUserId: otherUserId, data: otherUserData) {
                                            
                                            var numberOfUnreadMessages = 0
                                            
                                            // initialise messages dispatch group
                                            let messagesDispatchGroup = DispatchGroup()
                                            
                                            if let messageIds = chatData["messageIds"] as? [String] {
                                                // get message data
                                                for messageId in messageIds {
                                                    let docRef = self.db.collection("messages").document(messageId)
                                                    
                                                    messagesDispatchGroup.enter()
                                                    
                                                    docRef.getDocument { (document, error) in
                                                        if self.createEncryptedMessageObjectFromDocument(document: document, userId: userId) != nil {
                                                            numberOfUnreadMessages += 1
                                                        }
                                                        
                                                        messagesDispatchGroup.leave()
                                                    }
                                                }
                                            }
                                            
                                            messagesDispatchGroup.notify(queue: .main) {
                                                // retrieve stored conversation
                                                let conversation = self.retrieveConversationFromUserDefaults(chatId: chatId)
                                                
                                                // initialise empty messages array
                                                var messages: [Message] = conversation?.messages ?? []
                                                
                                                for _ in 0..<numberOfUnreadMessages {
                                                    messages.append(Message(id: UUID().uuidString, content: "\(numberOfUnreadMessages) new message\(numberOfUnreadMessages > 1 ? "s" : "")", sent: false, read: false, timestamp: Date.now))
                                                }
                                                
                                                let chat = Chat(id: chatId, otherUser: otherUser, messages: messages)
                                                userChats.append(chat)
                                                chatsDispatchGroup.leave()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        chatsDispatchGroup.notify(queue: .main) {
                            userChatsSetter(userChats)
                        }
                    }
                
                listenerSetter(listener)
            }
        }
    }
    
    func retrieveChat(userId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        let otherUserId = otherUser.id
        
        let chatId = generateChatId(userId: userId, otherUserId: otherUserId)
        
        let chatDocRef = db.collection("chats").document(chatId)
        
        chatDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            if let document = document, document.exists {
                let chat = Chat(id: chatId, otherUser: otherUser, messages: [])
                chatSetter(chat, true)
            } else {
                self.createNewChat(userId: userId, otherUser: otherUser, chatSetter: chatSetter)
            }
        }
    }
    
    func generateChatId(userId: String, otherUserId: String) -> String {
        let id1Numbers = userId.asciiValues
        let id2Numbers = otherUserId.asciiValues
        
        var averagedNumbers: [UInt8] = []
        
        for i in 0..<id1Numbers.count {
            let num1 = id1Numbers[i]
            let num2 = id2Numbers[i]
            
            averagedNumbers.append((num1 + num2) / 2)
        }
        
        return averagedNumbers.map( { String(UnicodeScalar(UInt8($0))) }).reduce("", +)
    }
    
    func createNewChat(userId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        let otherUserId = otherUser.id
        
        let chatId = generateChatId(userId: userId, otherUserId: otherUserId)
        print(chatId)
        
        // create new chat doc
        self.db.collection("chats").document(chatId).setData([
            "userIds": [userId, otherUserId]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                // add chatId to user and otherUser docs
                self.addChatIdToUserDoc(userId: userId, chatId: chatId)
                self.addChatIdToUserDoc(userId: otherUserId, chatId: chatId)
                
                // set chat
                let chat = Chat(id: chatId, otherUser: otherUser, messages: [])
                chatSetter(chat, true)
            }
        }
    }
    
    func listenToChat(chatId: String, userId: String, messagesSetter: @escaping ([Message]) -> Void) -> ListenerRegistration {
        let listener = db.collection("chats").document(chatId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                let chatId = document.documentID
                
                if let messageIds = data["messageIds"] as? [String],
                   let userIds = data["userIds"] as? [String] {
                    
                    // get other user data
                    let otherUserId = userIds[0] == userId ? userIds[1] : userIds[0]
                    
                    let docRef = self.db.collection("users").document(otherUserId)
                    
                    docRef.getDocument { (document, error) in
                        var conversation: Conversation? = nil
                        
                        if let retrievedConversation = self.retrieveConversationFromUserDefaults(chatId: chatId) {
                            conversation = retrievedConversation
                            self.decryptAndSetMessages(chatId: chatId, messageIds: messageIds, userId: userId, conversation: conversation, messagesSetter: messagesSetter)
                        } else {
                            if let cryptoUser = self.retrieveCryptoUserFromUserDefaults(),
                               let prekeyBundle = self.getPrekeyBundleFromDocument(document: document) {
                                let codableCryptoOtherUser = CodableCryptoOtherUser(prekeyBundle: prekeyBundle)
                                let cryptoOtherUser = CryptoOtherUser(codableCryptoOtherUser: codableCryptoOtherUser)
                                conversation = Conversation(user: cryptoUser, otherUser: cryptoOtherUser)
                                self.decryptAndSetMessages(chatId: chatId, messageIds: messageIds, userId: userId, conversation: conversation, messagesSetter: messagesSetter)
                            }
                        }
                    }
                }
            }
        
        return listener
    }
    
    func decryptAndSetMessages(chatId: String, messageIds: [String], userId: String, conversation: Conversation?, messagesSetter: @escaping ([Message]) -> Void) {
        // initialise empty messages array
        var encryptedMessages: [EncryptedMessage] = []
        
        // initialise messages dispatch group
        let messagesDispatchGroup = DispatchGroup()
        
        // get message data
        for messageId in messageIds {
            let docRef = self.db.collection("messages").document(messageId)
            
            messagesDispatchGroup.enter()
            
            docRef.getDocument { (document, error) in
                if let encryptedMessage = self.createEncryptedMessageObjectFromDocument(document: document, userId: userId) {
                    encryptedMessages.append(encryptedMessage)
                }
                
                messagesDispatchGroup.leave()
            }
        }
        
        messagesDispatchGroup.notify(queue: .main) {
            encryptedMessages.sort {
                $0.timestamp < $1.timestamp
            }
            
            // decrypt messages
            if let conversation = conversation {
                for message in encryptedMessages {
                    
                    // remove message doc from db
                    self.removeMessageDocFromDB(messageId: message.id)
                    
                    // remove message ID from chat doc
                    self.removeMessageIdFromChatDoc(chatId: chatId, messageId: message.id)
                    
                    let isFirstMessage = conversation.lastMessageReceived == nil
                    
                    // decrypt message
                    conversation.receiveMessage(message: message)
                    
                    // if first message, delete local private OTK, replace and send public key to server
                    if isFirstMessage {
                        let prekeyIdentifier = message.oneTimePreKeyIdentifier
                        if let newOneTimePrekey = self.replaceOneTimePrekeyInUserDefaults(prekeyIdentifier: prekeyIdentifier) {
                            self.saveOneTimePrekeyInDB(userId: userId, oneTimePrekey: newOneTimePrekey)
                        }
                    }
                }
                
                if self.saveConversationToUserDefaults(conversation: conversation, chatId: chatId) {
                    // set messages
                    messagesSetter(conversation.messages)
                }
            }
        }
    }
    
    func saveOneTimePrekeyInDB(userId: String, oneTimePrekey: String) {
        let docRef = db.collection("users").document(userId)
        
        docRef.updateData([
            "oneTimePrekeys": FieldValue.arrayUnion([oneTimePrekey])
        ])
    }
    
    func replaceOneTimePrekeyInUserDefaults(prekeyIdentifier: Int) -> String? {
        var newOneTimePrekey: String?
        
        if var cryptoUser = retrieveCryptoUserFromUserDefaults() {
            newOneTimePrekey = cryptoUser.replaceOneTimePrekeyAndGetPublicKeyString(prekeyIdentifier: prekeyIdentifier)
            print("New OTPK: \(newOneTimePrekey ?? "none")")
        }
        
        return newOneTimePrekey
    }
    
    func removeMessageDocFromDB(messageId: String) {
        db.collection("messages").document(messageId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func removeMessageIdFromChatDoc(chatId: String, messageId: String) {
        let docRef = db.collection("chats").document(chatId)
        
        docRef.updateData([
            "messageIds": FieldValue.arrayRemove([messageId])
        ])
    }
    
    func saveConversationToUserDefaults(conversation: Conversation, chatId: String) -> Bool {
        var conversationSaved = false
        
        let defaults = UserDefaults.standard
        
        let codableConversation = CodableConversation(conversation: conversation)
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(codableConversation)
            
            // Write/Set Data
            defaults.set(data, forKey: chatId)
            
            print("Saved conversation locally")
            conversationSaved = true
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        
        return conversationSaved
    }
    
    func createEncryptedMessageObjectFromDocument(document: DocumentSnapshot?, userId: String) -> EncryptedMessage? {
        var encryptedMessage: EncryptedMessage? = nil
        
        if let messageDoc = document, messageDoc.exists {
            if let messageData = messageDoc.data() {
                if let senderId = messageData["senderId"] as? String {
                    if senderId != userId {
                        if let timestamp = (messageData["timestamp"] as? Timestamp)?.dateValue(),
                           let cipherText = messageData["cipherText"] as? String,
                           let identityKey = messageData["identityKey"] as? String,
                           let ephemeralKey = messageData["ephemeralKey"] as? String,
                           let oneTimePreKeyIdentifier = messageData["oneTimePreKeyIdentifier"] as? Int,
                           let sendChainLength = messageData["sendChainLength"] as? Int,
                           let previousSendChainLength = messageData["previousSendChainLength"] as? Int {
                            encryptedMessage = EncryptedMessage(id: messageDoc.documentID, timestamp: timestamp, cipherText: cipherText, identityKey: identityKey, ephemeralKey: ephemeralKey, oneTimePreKeyIdentifier: oneTimePreKeyIdentifier, sendChainLength: sendChainLength, previousSendChainLength: previousSendChainLength)
                        }
                    }
                }
            }
        }
        
        return encryptedMessage
    }
    
    func checkMessageForUrl(message: String) -> Bool {
        let words = message.split(separator: " ")
        
        for word in words {
            if let urlString = URL(string: String(word).lowercased()) {
                return UIApplication.shared.canOpenURL(urlString)
            }
        }
        
        return false
    }
    
    func checkMessageForBlockedWords(message: String) -> String? {
        let words = message.split(separator: " ")
        
        for word in words {
            let word = String(word).lowercased()
            
            if blockedWords.contains(word) {
                return word
            }
        }
        
        return nil
    }
    
    func sendMessage(senderId: String, receiverId: String, content: String, chatId: String, errorSetter: @escaping (String) -> Void, messageSentSetter: @escaping () -> Void) {
        if checkMessageForUrl(message: content) {
            errorSetter("Sending URLs is forbidden.")
            return
        }
        
        if let blockedWord = checkMessageForBlockedWords(message: content) {
            errorSetter("'\(blockedWord.capitalized)' is a banned word. Please use clean, polite language.")
            return
        }
        
        if let storedConversation = self.retrieveConversationFromUserDefaults(chatId: chatId) {
            sendMessageDB(senderId: senderId, receiverId: receiverId, content: content, chatId: chatId, errorSetter: errorSetter, messageSentSetter: messageSentSetter)
        } else {
            let chatDocRef = db.collection("chats").document(chatId)
            
            // transaction to prevent other user accessing data at same time
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let chatDoc: DocumentSnapshot
                
                do {
                    try chatDoc = transaction.getDocument(chatDocRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                if let userIdSendingMessage = chatDoc.data()?["userIdSendingMessage"] as? String {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(chatDoc)"
                        ]
                    )
                    
                    return nil
                }
                
                transaction.updateData(["userIdSendingMessage": senderId], forDocument: chatDocRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                    errorSetter("An error occurred while sending this message.")
                    return
                }
                
                self.sendMessageDB(senderId: senderId, receiverId: receiverId, content: content, chatId: chatId, errorSetter: errorSetter, messageSentSetter: messageSentSetter)
            }
        }
    }
    
    private func sendMessageDB(senderId: String, receiverId: String, content: String, chatId: String, errorSetter: @escaping (String) -> Void, messageSentSetter: @escaping () -> Void) {
        // get user blocked IDs
        let userDocRef = self.db.collection("users").document(senderId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                let setOfBlockedUserIds: Set<String> = Set(blockedUserIds ?? [])
                
                if setOfBlockedUserIds.contains(receiverId) {
                    errorSetter("You cannot message this user because you have blocked them.")
                    return
                }
                
                let receiverDocRef = self.db.collection("users").document(receiverId)
                
                receiverDocRef.getDocument { (document, error) in
                    if let otherUserBlockedUserIds = document?.data()?["blockedUserIds"] as? [String] {
                        let otherUserSetOfBlockedUserIds = Set(otherUserBlockedUserIds)
                        
                        if otherUserSetOfBlockedUserIds.contains(senderId) {
                            errorSetter("This user has blocked you from messaging them.")
                            return
                        }
                    }
                    
                    var conversation = self.retrieveConversationFromUserDefaults(chatId: chatId)
                    
                    if conversation == nil {
                        // get stored crypto user and prekey bundle from server
                        if let cryptoUser = self.retrieveCryptoUserFromUserDefaults(),
                           let prekeyBundle = self.getPrekeyBundleFromDocument(document: document) {
                            self.deleteOneTimePrekey(userId: receiverId, oneTimePrekey: prekeyBundle["oneTimePrekey"]!)
                            let codableCryptoOtherUser = CodableCryptoOtherUser(prekeyBundle: prekeyBundle)
                            let cryptoOtherUser = CryptoOtherUser(codableCryptoOtherUser: codableCryptoOtherUser)
                            conversation = Conversation(user: cryptoUser, otherUser: cryptoOtherUser)
                        }
                    }
                    
                    // create encrypted message using conversation object
                    if let encryptedMessage = conversation!.sendMessage(messageContent: content) {
                        
                        // save conversation locally and to db
                        if self.saveConversationToUserDefaults(conversation: conversation!, chatId: chatId) {
                            // create message doc
                            self.createMessageDocInDB(senderId: senderId, chatId: chatId, encryptedMessage: encryptedMessage)
                            
                            // set messages
                            messageSentSetter()
                        }
                    } else {
                        errorSetter("Error establishing encryption.")
                    }
                }
            }
        }
    }
    
    private func deleteOneTimePrekey(userId: String, oneTimePrekey: String) {
        let docRef = db.collection("users").document(userId)
        
        // delete one time prekey from DB
        docRef.updateData([
            "oneTimePrekeys": FieldValue.arrayRemove([oneTimePrekey])
        ])
    }
    
    private func createMessageDocInDB(senderId: String, chatId: String, encryptedMessage: EncryptedMessage) {
        db.collection("messages").document(encryptedMessage.id).setData([
            "senderId": senderId,
            "cipherText": encryptedMessage.cipherText,
            "identityKey": encryptedMessage.identityKey,
            "ephemeralKey": encryptedMessage.ephemeralKey,
            "oneTimePreKeyIdentifier": encryptedMessage.oneTimePreKeyIdentifier,
            "sendChainLength": encryptedMessage.sendChainLength,
            "previousSendChainLength": encryptedMessage.previousSendChainLength,
            "timestamp": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                // add message id to chat doc
                let chatDocRef = self.db.collection("chats").document(chatId)
                
                chatDocRef.updateData([
                    "messageIds": FieldValue.arrayUnion([encryptedMessage.id])
                ])
            }
        }
    }
    
    private func addChatIdToUserDoc(userId: String, chatId: String) {
        let userDocRef = self.db.collection("users").document(userId)
        
        userDocRef.updateData([
            "chatIds": FieldValue.arrayUnion([chatId])
        ])
    }
    
    private func createOtherUserObjectFromData(otherUserId: String, data: [String: Any]?) -> OtherUser? {
        var otherUser: OtherUser?
        
        if let username = data?["username"] as? String,
           let iconColour = data?["iconColour"] as? String {
            otherUser = OtherUser(id: otherUserId, username: username, iconColour: Color(iconColour))
        }
        
        return otherUser
    }
    
    private func retrieveCryptoUserFromUserDefaults() -> CryptoUser? {
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
    
    private func retrieveConversationFromUserDefaults(chatId: String) -> Conversation? {
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
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if let retrievedConversation = codableConversation {
            let previouslyReceivedEphemeralKeys = defaults.array(forKey: "previouslyReceivedEphemeralKeys-\(chatId)") as? [Data]
            let storedMessageKeys = defaults.array(forKey: "storedMessageKeys-\(chatId)") as? [StoredKey] ?? []
            let setOfPreviouslyReceivedEphemeralKeys = Set(previouslyReceivedEphemeralKeys ?? [])
            
            conversation = Conversation(codableConversation: retrievedConversation, previouslyReceivedEphemeralKeys: setOfPreviouslyReceivedEphemeralKeys, storedMessageKeys: storedMessageKeys)
        }
        
        return conversation
    }
    
    private func getPrekeyBundleFromDocument(document: DocumentSnapshot?) -> [String: String]? {
        var prekeyBundle: [String: String] = [:]
        
        if let document = document, document.exists {
            if let data = document.data() {
                if let identityKey = data["identityKey"] as? String,
                   let signedPrekey = data["signedPrekey"] as? String,
                   let signedPrekeySigning = data["signedPrekeySigning"] as? String,
                   let signedPrekeySignature = data["signedPrekeySignature"] as? String,
                   let oneTimePrekeys = data["oneTimePrekeys"] as? [String] {
                    let prekeyIdentifier = Int.random(in: 0..<oneTimePrekeys.count)
                    let oneTimePrekey = oneTimePrekeys[prekeyIdentifier]
                    
                    prekeyBundle.updateValue(document.documentID, forKey: "id")
                    prekeyBundle.updateValue(identityKey, forKey: "identityKey")
                    prekeyBundle.updateValue(signedPrekey, forKey: "signedPrekey")
                    prekeyBundle.updateValue(signedPrekeySigning, forKey: "signedPrekeySigning")
                    prekeyBundle.updateValue(signedPrekeySignature, forKey: "signedPrekeySignature")
                    prekeyBundle.updateValue(oneTimePrekey, forKey: "oneTimePrekey")
                    prekeyBundle.updateValue("\(prekeyIdentifier)", forKey: "prekeyIdentifier")
                }
            }
        }
        
        return prekeyBundle.isEmpty ? nil : prekeyBundle
    }
    
    func deleteChat(chatId: String) {
        if let conversation = retrieveConversationFromUserDefaults(chatId: chatId) {
            conversation.resetMessages()
            
            if saveConversationToUserDefaults(conversation: conversation, chatId: chatId) {
                print("Messages successfully cleared")
            } else {
                print("Failed to clear messages")
            }
        }
    }
    
    func deleteMessages(chatId: String, messageIds: Set<String>, messagesSetter: ([Message]) -> Void) {
        if let conversation = retrieveConversationFromUserDefaults(chatId: chatId) {
            conversation.removeMessage(messageIds: messageIds)
            
            if saveConversationToUserDefaults(conversation: conversation, chatId: chatId) {
                print("Messages successfully deleted")
                messagesSetter(conversation.messages)
            } else {
                print("Failed to delete messages")
            }
        }
    }
}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}
