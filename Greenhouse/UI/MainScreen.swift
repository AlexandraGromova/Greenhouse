import SwiftUI

struct MainScreen: View {
    
    @State var selectedPage = 2
    
    var body: some View {
            NavigationView {
                TabView(selection: $selectedPage) {
                    FavoriteListScreen()
                        .tabItem {
                            Image(systemName: "magnifyingglass.circle.fill")
                        }
                        .tag(1)
                    PlantsListScreen()
                        .tabItem {
                            Image(systemName: "leaf.fill")
                        }
                        .tag(2)
                }
                .navigationTitle(selectedPage == 1 ? "Favorites" : "All Plants")
                .accentColor(Color.lightGreen)
            }
    }
}

#Preview {
    MainScreen()
}