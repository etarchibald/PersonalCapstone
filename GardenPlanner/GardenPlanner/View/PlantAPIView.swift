import SwiftUI

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var searchText = ""
    
    var dummyPlants = PlantArray.dummyArrayOfPlants
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.4, blue: 0.2), location: 0.3),
                    .init(color: Color(red: 0.0, green: 0.7, blue: 0.99), location: 0.3),
                ], center: .top, startRadius: 600, endRadius: 100)
                    .ignoresSafeArea()
                Spacer()
                ScrollView {
                    ForEach(plantsViewModel.plants) { plant in
                        NavigationLink {
                            PlantDetailView(plantid: plant.id)
                        } label: {
                            PlantCellView(plant: plant)
                        }
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText, prompt: "Search for a plant")
            .onSubmit(of: .search) {
                fetchPlants()
            }
//            .toolbarBackground(Color(red: 0.0, green: 0.7, blue: 0.99), for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
        }
    }
    
    func fetchPlants() {
        Task {
            await plantsViewModel.fetchPlants(using: searchText)
        }
    }
}

#Preview {
    PlantAPIView()
}
