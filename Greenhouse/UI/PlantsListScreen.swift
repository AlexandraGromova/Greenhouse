import SwiftUI
import Combine

struct PlantsListScreen: View {
    
    @StateObject var vm = AppContainer.resolve(PlantsListVM.self)
    
    
    var body: some View {
        ZStack() {
            VStack() {
                Spacer().frame(height: 40)
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(Array(vm.plants.enumerated()), id: \.element) { index, plant in
                            NavigationLink(destination: PlantDetailScreen(plant: plant)) {
                                PlantsListSell(plant: plant) { plant in
                                    vm.savePlant(plant: plant)
                                } onDeleteTapAction: { id in
                                    vm.deletePlant(plantID: id)
                                }
                                .background(Color.lightGray)
                                .cornerRadius(20)
                                .padding(.vertical, 5)
                                .onAppear() {
                                    if vm.plants.count - 4 == index {
                                        vm.tryUpdatePlants()
                                    }
                                }
                            }
                        }
                    }
                }
                if !vm.hasError {
                    Spacer()
                        .frame(height: 0)
                    Text("No Internet Connection")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 15))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 20 , alignment: .center)
                        .background(Color.red)
                }
            }
            VStack() {
                Spacer()
                    .frame(height: 0)
                SearchBarView(onSearchTapAction: vm.getSearchPlants)
                Spacer()
                
            }
        }
    }
}

#Preview {
    PlantsListScreen()
}

struct PlantsListSell: View {
    @State var plant: UIPlant
    var onFavoriteTapAction: (UIPlant) -> ()
    var onDeleteTapAction: (Int) -> ()
    
    var body: some View {
        HStack {
            Spacer()
            if plant.image == "" {
                Image("plug_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .background(Color.gray)
                    .cornerRadius(15)
            } else {
                AsyncImage(url: URL(string: (plant.image ?? "https://perenual.com/storage/species_image/714_alocasia_low_rider/small/8415446715_799e70b503_b.jpg"))) { image in
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .background(Color.gray)
                        .cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .background(Color.gray)
                .cornerRadius(15)
            }
            
            Spacer()
            VStack() {
                Spacer()
                Text(plant.name)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("\(plant.id)")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 15))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            Spacer()
            Button(action: {
                if plant.isFavorite == true {
                    onDeleteTapAction(plant.id)
                }
                else {
                    onFavoriteTapAction(plant)
                }
            }) {
                Image(systemName: plant.isFavorite == true ? "heart.circle.fill" : "heart.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 8)
                    .foregroundStyle(plant.isFavorite == true ? Color.lightGreen : Color.white)
            }
            Spacer()
        }
        .frame(width: UIScreen.screenWidth - 40, height: 100 )
    }
}

struct SearchBarView: View {
    
    var onSearchTapAction: () -> ()
    let sunlight = ["full_shade", "part_shade", "sun-part_shade", "full_sun", ""]
    let watering = ["frequent", "average", "minimum", ""]
    @State var paramsSunlight = "all"
    @State var paramsWatering = "all"
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Spacer()
            Image(systemName: "sun.min.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.lightGreen)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
            ParametersButton(
                primaryButton: ExplandableButtonItem(label: paramsSunlight), secondaryButtons: [
                    ExplandableButtonItem(label: "full_shade") {
                        paramsSunlight = "full_shade"
                    }
                    ,
                    ExplandableButtonItem(label: "part_shade") {
                        paramsSunlight = "part_shade"
                    }
                ]
            )
            Spacer()
            Image(systemName: "drop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.lightGreen)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
            ParametersButton(
                primaryButton: ExplandableButtonItem(label: paramsWatering), secondaryButtons: [
                    ExplandableButtonItem(label: "frequent") {
                        paramsWatering = "frequent"
                    }
                    ,
                    ExplandableButtonItem(label: "average") {
                        paramsWatering = "average"
                    }
                ]
            )
            Spacer()
            Button(action: {
                onSearchTapAction()
            }, label: {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            Spacer()
        }
    }
}



struct ParametersButton: View {
    @State private var isExplanded = false
    
    let primaryButton: ExplandableButtonItem
    let secondaryButtons: [ExplandableButtonItem]
    
    var body: some View {
        VStack {
            if isExplanded {
                ForEach(secondaryButtons) { button in
                    Button(action: {
                        button.action?()
                        withAnimation {
                            isExplanded.toggle()
                        }
                    }, label: {
                        Text(button.label)
                    })
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white)
                    .frame(width: 90, height: 20)
                }
            }
            Button(action: {
                withAnimation {
                    self.isExplanded.toggle()
                }
                self.primaryButton.action?()
            }, label: {
                Text(self.primaryButton.label)
            })
            .font(.system(size: 15))
            .foregroundStyle(Color.white)
            .frame(width: 90, height: 30)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        }
        .background(Color.lightGreen)
        .cornerRadius(15)
    }
}

struct ExplandableButtonItem: Identifiable {
    var id = UUID()
    let label: String
    var action: (() -> Void)? = nil
}




