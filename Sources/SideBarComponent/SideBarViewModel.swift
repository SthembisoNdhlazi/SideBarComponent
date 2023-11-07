import Foundation
import SwiftUI
@available(iOS 13.0, *)
@available(iOS 13.0, *)

public struct SideBarViewModel: Hashable {
    public static func == (lhs: SideBarViewModel, rhs: SideBarViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = UUID()
    var view: AnyView
    var category: String
    public init(category: String, view: AnyView) {
        self.category = category
        self.view = view
    }
}
