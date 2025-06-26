import Foundation
import SwiftData

@Model
class CompletionData {
    var date: Date
    var color: String

    init(date: Date = Date(), color: String) {
        self.date = date
        self.color = color
    }
}
