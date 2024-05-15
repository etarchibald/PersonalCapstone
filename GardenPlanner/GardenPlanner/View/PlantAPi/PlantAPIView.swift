import SwiftUI
import CoreLocation

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    
    @EnvironmentObject var navigation: Navigation
    
    @State private var searchText = ""
    @State private var showCancelButton = false
    
    @State private var noResultsFound = false
    
    @State private var isGettingPlants = false
    
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
                        noResultsFound = false
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
                            noResultsFound = false
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
                if noResultsFound {
                    Spacer()
                    VStack {
                        Text("No results found for \(Text(searchText).foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue)))")
                    }
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    Spacer()
                    VStack {
                        Text("Search for \(Text("Plants").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) to add to your garden")
                        plantSuggestions()
                    }
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                }
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
                                        if searchText != "" {
                                            if !isGettingPlants {
                                                pageNumber += 1
                                                print(pageNumber)
                                                fetchPlants(for: pageNumber)
                                            }
                                        } else {
                                            if !isGettingPlants {
                                                pageNumber += 1
                                                print(pageNumber)
                                                // fetch suggesting based on slug
                                                fetchPlantSuggestions(for: nil, or: plantsViewModel.userSlug, on: pageNumber)
                                            }
                                        }
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
        .onAppear {
            
        }
        
        Spacer()
    }
    
    func fetchPlants(for page: Int) {
        isGettingPlants = true
        Task {
            await plantsViewModel.fetchPlants(using: searchText, pageNumber: page)
            if plantsViewModel.plants == [] {
                noResultsFound = true
            }
            isGettingPlants = false
        }
    }
    
    func plantSuggestions() -> some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                
                let locationOfUser = CLLocation(latitude: Double(locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0), longitude: Double(locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0))
                
                //make bool call here to display if user can plant here
                HStack {
                    
                }
                .onAppear {
                    //get plant suggestions
                    fetchPlantSuggestions(for: locationOfUser, or: nil, on: pageNumber)
                }
                
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorize
                
                VStack {
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    } label: {
                        Text("Press here to enable locations and get plant suggestions")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
                
            default:
                ProgressView()
            }
        }
    }
    
    func fetchPlantSuggestions(for location: CLLocation?, or slug: String?, on page: Int) {
        
        if let userLocation = location {
            userLocation.placemark { placemark, error in
                if let placemark = placemark {
                    
                    if let slug = locationDataManager.slugDictionary[placemark.state] {
                        isGettingPlants = true
                        Task{
                            await plantsViewModel.fetchPlantSuggestions(using: slug, page: page)
                            isGettingPlants = false
                        }
                    }
                }
            }
        }
        
        if let userSlug = slug {
            isGettingPlants = true
            Task {
                await plantsViewModel.fetchPlantSuggestions(using: userSlug, page: page)
                isGettingPlants = false
            }
        }
    }
}

#Preview {
    PlantAPIView()
}
