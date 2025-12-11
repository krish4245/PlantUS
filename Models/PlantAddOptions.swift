
import Foundation

struct PlantAddOptions: Codable {
    var title: String?
    init(title: String) {
        self.title = title
    }
}
