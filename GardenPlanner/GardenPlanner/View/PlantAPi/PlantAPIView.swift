import SwiftUI

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var searchText = ""
    @State private var showCancelButton = false
    
    private let spaceName = "scroll"
    @State private var pageNumber = 1
    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("search", text: $searchText)
                        .onChange(of: searchText) {
                            withAnimation(.easeIn) {
                                if !searchText.isEmpty {
                                    self.showCancelButton = true
                                }
                            }
                        }
                        .onSubmit {
                            plantsViewModel.plants = []
                            fetchPlants(for: pageNumber)
                        }
                        .foregroundStyle(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                        plantsViewModel.plants = []
                        pageNumber = 1
                    }) {
                        withAnimation {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundStyle(.secondary)
                .background(Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 10))
                .padding(.bottom)
                
                if showCancelButton {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        withAnimation(.bouncy) {
                            self.searchText = ""
                            plantsViewModel.plants = []
                            pageNumber = 1
                            self.showCancelButton = false
                        }
                    }
                    .padding(.bottom)
                    .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                }
            }
        }
        .padding(.horizontal)
        
        Spacer()
        
        ZStack {
            
            if plantsViewModel.plants.isEmpty {
                Spacer()
                VStack {
                    Text("Search for \(Text("Plants").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) to add to your garden")
                }
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            } else {
                ChildSizeReader(size: $wholeSize) {
                    ScrollView {
                        ChildSizeReader(size: $scrollViewSize) {
                            LazyVStack {
                                ForEach(plantsViewModel.plants) { plant in
                                    NavigationLink {
                                        PlantDetailView(plantid: plant.id)
                                    } label: {
                                        PlantCellView(plant: plant)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: ViewOffsetKey.self,
                                        value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                                    )
                                }
                            )
                            .onPreferenceChange(
                                ViewOffsetKey.self,
                                perform: { value in
                                    if value >= scrollViewSize.height - wholeSize.height {
                                        pageNumber += 1
                                        print(pageNumber)
                                        fetchPlants(for: pageNumber)
                                    }
                                }
                            )
                            
                        }
                    }
                    .coordinateSpace(name: spaceName)
                }
            }
            Spacer()
        }
        
        Spacer()
    }
    
    func fetchPlants(for page: Int) {
        Task {
            await plantsViewModel.fetchPlants(using: searchText, pageNumber: page)
        }
    }
}

#Preview {
    PlantAPIView()
}
