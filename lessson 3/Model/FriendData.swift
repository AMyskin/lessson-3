import Foundation

// MARK: - Friend
struct FriendData: Codable {
    let id: Int
    let firstName, lastName: String
    let photo50: String
    let online: Int
    let trackCode: String
    let lists: [Int]?
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
        case online
        case trackCode = "track_code"
        case lists, deactivated
    }
}


