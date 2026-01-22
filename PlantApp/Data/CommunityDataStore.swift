import Foundation
import UIKit

class CommunityDataStore {
    
    static let shared = CommunityDataStore()
    
    private var users: [User] = []
    private var posts: [Post] = []
    //private var comments: [String: [Comment]] = [:]
    
    var currentLoggedInUserID: String = "u2"
    
    private init() {
        seedDummyData()
    }
    
    func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
        completion(self.posts)
    }
    
    func fetchPosts(forUserId userId: String, completion: @escaping ([Post]) -> Void) {
        // Return immediately
        let userPosts = self.posts.filter { $0.userId == userId }
        completion(userPosts)
    }
    
    func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        completion(self.users)
    }
    
    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        let foundUser = self.users.first(where: { $0.id == self.currentLoggedInUserID })
        completion(foundUser)
    }
    
    func isCurrentUser(userID: String) -> Bool {
        return currentLoggedInUserID == userID
    }
    
    // MARK: - Seed Data
    private func seedDummyData() {
        let vedant = User(id: "u1", name: "Vedant Arya", username: "vedantarya.22", profileImageString: "person.circle", plantCount: 12, friendCount: 5, isFriend: false)
        let shubham = User(id: "u2", name: "Shubham", username: "Shubham_r24", profileImageString: "person.circle.fill", plantCount: 32, friendCount: 15, isFriend: true)
        
        self.users = [vedant, shubham]
        
        let p1 = Post(id: "p1", userId: "u1", postImageString: "plant_vedant", likesCount: 5, caption: "New leaf alert! 🌿", timestamp: Date(), author: vedant)
        let p2 = Post(id: "p2", userId: "u2", postImageString: "plant_shubham", likesCount: 3, caption: "Watering day 💧", timestamp: Date(), author: shubham)
        
        self.posts = [p1, p2]
    }
    
    func updateLikeStatus(forPostId postId: String, isLiked: Bool, newCount: Int) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isLiked = isLiked
            posts[index].likesCount = newCount
        }
    }
    //        func addFriend(userId: String) {
    //            if let index = users.firstIndex(where: { $0.id == userId }) {
    //                users[index].isFriend = true
    //                // If you have a separate "friends" list, append them there too
    //            }
    //        }
    
    func addNewPost(caption: String, image: UIImage, currentUser: User, completion: @escaping (Bool) -> Void) {
        
        //Save Image to Disk
        let imageID = UUID().uuidString // Generate unique name
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageID)
            try? data.write(to: filename)
        }
        
        //Create the Post Object
        let newPost = Post(
            id: UUID().uuidString,
            userId: currentUser.id,
            postImageString: imageID,
            likesCount: 0,
            caption: caption,
            timestamp: Date(),
            author: currentUser
        )
        
        //Add to the top of the list
        self.posts.insert(newPost, at: 0)
        
        // show success
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(true)
        }
    }
    
    // Helper to find where to save images on the phone
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

