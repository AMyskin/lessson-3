import Foundation

// MARK: - Friend
struct FriendData: Codable {
    let id: Int
    let firstName, lastName: String
    let avatar: String
    let online: Int


    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_50"
        case online

    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.online = try container.decode(Int.self, forKey: .online)
    }
    
}


