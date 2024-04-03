import SwiftUI
import Vortex

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var searchText = ""
    @State private var showCancelButton = false
    
    private var pageNumber = 1
    
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
                            fetchPlants()
                        }
                        .foregroundStyle(.primary)
                    
                    Button(action: {
                        self.searchText = ""
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
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                
                if showCancelButton {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        withAnimation(.bouncy) {
                            self.searchText = ""
                            plantsViewModel.plants = []
                            self.showCancelButton = false
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    .foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))
                }
            }
        }
        .padding(.horizontal)
        
        Spacer()
        
        ZStack {
            
            VortexView(.customSlowRain) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .tag("circle")
            }
            .ignoresSafeArea(.all)
            
            if plantsViewModel.plants.isEmpty {
                Spacer()
                VStack {
                    Text("Search for \(Text("Plants").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) to add to your garden")
                }
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            } else {
                ScrollView {
                    VStack {
                        ForEach(plantsViewModel.plants) { plant in
                            NavigationLink {
                                PlantDetailView(plantid: plant.id)
                            } label: {
                                withAnimation(.smooth) {
                                    PlantCellView(plant: plant)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        
        Spacer()
    }
    
    func fetchPlants() {
        Task {
            await plantsViewModel.fetchPlants(using: searchText, pageNumber: pageNumber)
        }
    }
}

#Preview {
    PlantAPIView()
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.endEditing(force)
    }
}

struct ResignKeyBoardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesuture() -> some View {
        return modifier(ResignKeyBoardOnDragGesture())
    }
}
