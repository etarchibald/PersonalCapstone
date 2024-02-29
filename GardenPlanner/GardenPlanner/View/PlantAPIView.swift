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
                
                if showCancelButton {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundStyle(Color(.systemBlue))
                }
                
            }
        }
        .padding(.horizontal)
        
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
