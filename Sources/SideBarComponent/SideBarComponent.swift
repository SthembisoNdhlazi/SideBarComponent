import SwiftUI
@available(iOS 13.0, *)

public protocol SideBarConfigurable: ObservableObject {
    var categories: [SideBarViewModel] { get set }
}

@available(iOS 16.0, *)
public struct SidebarComponent<Provider: SideBarConfigurable>: View {
    @StateObject public var dataProvider: Provider
    @State var selectedView: AnyView = AnyView(EmptyView())
    @State var index = 0
    @State var navPath = NavigationPath()
    var title: String
    
    public init(dataProvider: Provider, title: String) {
        self._dataProvider = StateObject(wrappedValue: dataProvider)
        self.title = title
    }
    
    public var body: some View {
        NavigationStack(path: $navPath) {
            HStack(spacing: 0) {
                
                VStack {
                    Group {
                        
                        ForEach(Array((dataProvider.categories.enumerated())), id: \.offset) { index, category in
                            Button(action: {
                                self.index = index
                                self.selectedView = category.view
                            }) {
                                VStack {
                                    Text(category.category)
                                        .frame(width: 120,height: 35)
                                        .foregroundColor(self.index == index ? Color.black : Color.gray)
                                        .underline(self.index == index)
                                }
                            }
                            .rotationEffect(.init(degrees: -90))
                            .padding(.top, 80)
                        }
                    }
                    .padding(.leading, 15)
                }
                .padding(.vertical)
                .frame(width: 50)
                .background(Color.clear)
                .onFirstAppear {
                    if let displayView = dataProvider.categories.last?.view {
                        index = dataProvider.categories.count - 1
                        selectedView = displayView
                    } else {
                        selectedView = AnyView(EmptyView())
                    }
                }
                
                GeometryReader { reader in
                    
                    HStack {
                        Spacer(minLength: reader.size.width * 0.1)
                        Text(title)
                            .font(.system(size: 20,weight: .bold))
                        Spacer(minLength: reader.size.width * 0.45)
                    }
                    .padding(.top, 60)
                    
                    VStack {
                        selectedView
                        //                        .padding(.trailing, 5)
                    }
                    .padding(.top, 100)
                }
            }
            .padding(.bottom)
            .edgesIgnoringSafeArea(.all)
        }
        .accentColor(.black)
    }
}

@available(iOS 13.0.0, *)
extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}

@available(iOS 13.0.0, *)
private struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
