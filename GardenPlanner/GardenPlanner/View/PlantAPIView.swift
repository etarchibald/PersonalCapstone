import SwiftUI

struct PlantAPIView: View {
    @StateObject var plantsViewModel = PlantsViewModel()
    @State private var searchText = ""
    @State private var showCancelButton = false
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        fetchPlants()
                    })
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
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
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                }
            }
        }
        .padding(.horizontal)
        .background(Color(hex: GardenColors.plantGreen.rawValue))
        
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
        Spacer()
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
