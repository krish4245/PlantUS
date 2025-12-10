import Foundation
import UIKit

class CommunityDataStore {
    
    static let shared = CommunityDataStore()
    
    private var users: [User] = []
    private var posts: [Post] = []
    private var comments: [String: [Comment]] = [:]
    
    var currentLoggedInUserID: String = "u2"
    
    private init() {
        seedDummyData()
    }
    
    // MARK: - API
    
    // This function MUST be named 'fetchAllPosts' to match your Controller
    func fetchAllPosts(completion: @escaping ([Post]) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.posts)
        }
    }
    
    func fetchPosts(forUserId userId: String, completion: @escaping ([Post]) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let userPosts = self.posts.filter { $0.userId == userId }
                completion(userPosts)
            }
        }
    
    func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.users)
        }
    }
    
    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let foundUser = self.users.first(where: { $0.id == self.currentLoggedInUserID })
                completion(foundUser)
            }
        }
    func isCurrentUser(userID: String) -> Bool {
        return currentLoggedInUserID == userID
    }

    // MARK: - Seed Data
    private func seedDummyData() {
        // Users
        let vedant = User(id: "u1", name: "Vedant Arya", username: "vedantarya.22", profileImageString: "person.circle", plantCount: 12, friendCount: 5, isFriend: false)
        let shubham = User(id: "u2", name: "Shubham", username: "Shubham_r24", profileImageString: "person.fill", plantCount: 32, friendCount: 15, isFriend: true)
        
        self.users = [vedant, shubham]
        
        // Posts
        let p1 = Post(id: "p1", userId: "u1", postImageString: "plant_vedant", caption: "New leaf alert! 🌿", timestamp: Date(), author: vedant)
        let p2 = Post(id: "p2", userId: "u2", postImageString: "plant_shubham", caption: "Watering day 💧", timestamp: Date(), author: shubham)
        
        self.posts = [p1, p2]
    }
    
    func addNewPost(caption: String, image: UIImage, currentUser: User, completion: @escaping (Bool) -> Void) {
            
            // 1. Save Image to Disk (Simulate Upload)
            let imageID = UUID().uuidString // Generate unique name
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent(imageID)
                try? data.write(to: filename)
            }
            
            // 2. Create the Post Object
            let newPost = Post(
                id: UUID().uuidString,
                userId: currentUser.id,
                postImageString: imageID, // We store the ID, not the image itself
                caption: caption,
                timestamp: Date(),
                author: currentUser
            )
            
            // 3. Add to the top of the list
            self.posts.insert(newPost, at: 0)
            
            // 4. Return success
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(true)
            }
        }
        
        // Helper to find where to save images on the phone
        private func getDocumentsDirectory() -> URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
}
