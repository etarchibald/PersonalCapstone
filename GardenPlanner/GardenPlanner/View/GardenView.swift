//
//  GardenView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import SwiftUI
import SwiftData

struct GardenView: View {
    @Query var myGardenPlants: [YourPlant]
    
    @State private var showingSearchBar = false
    @State private var searchText = ""
    @State private var showingXButton = false
    
    //Arry to store plants and to filter array according to searchText String
    @State private var myGarden = [YourPlant]()
    
    var body: some View {
        NavigationStack() {
            ZStack {
                VStack {
                    ScrollView {
                        if myGarden.isEmpty {
                            Spacer(minLength: 300)
                            VStack {
                                Text("Looks like your garden is empty.")
                                Text("Press the \(Text("Plus").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) button to add Plants")
                            }
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 20, pinnedViews: [], content: {
                                
                                ForEach(myGarden, id: \.self) { gardenPlant in
                                    NavigationLink {
                                        GardenPlantDetailView(plant: gardenPlant)
                                    } label: {
                                        GardenPlantCellView(imageURl: gardenPlant.imageURL, name: gardenPlant.name)
                                    }
                                }
                                
                            })
                        }
                    }
                }
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(hex: GardenColors.skyBlue.rawValue))
                            .frame(width: showingSearchBar ? 380 : 50, height: 50)
                        
                        HStack {
                            if showingSearchBar {
                                HStack {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                        TextField("search", text: $searchText)
                                            .onChange(of: searchText) {
                                                withAnimation(.easeIn) {
                                                    self.showingXButton = true
                                                }
                                            }
                                            .onSubmit {
                                                withAnimation(.smooth) {
                                                    filterMyGarden(filterString: searchText)
                                                }
                                            }
                                            .foregroundColor(.primary)
                                        
                                        if showingXButton {
                                            Button(action: {
                                                withAnimation(.smooth) {
                                                    self.searchText = ""
                                                }
                                            }) {
                                                withAnimation {
                                                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                                                }
                                            }
                                        }
                                        
                                    }
                                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                                    .foregroundStyle(.secondary)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(.rect(cornerRadius: 10))
                                }
                                .padding()
                            }
                            
                            Button {
                                withAnimation(.bouncy) {
                                    showingSearchBar.toggle()
                                }
                            } label: {
                                if showingSearchBar {
                                    
                                    Button("Cancel") {
                                        UIApplication.shared.endEditing(true)
                                        self.searchText = ""
                                        withAnimation(.smooth) {
                                            self.showingSearchBar = false
                                            self.showingXButton = false
                                            myGarden = myGardenPlants
                                        }
                                    }
                                    .padding(.trailing)
                                    .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                    
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .frame(maxWidth: 50, maxHeight: 50)
                                        .font(.title2)
                                        .background(Color(hex: GardenColors.skyBlue.rawValue))
                                        .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                
                HStack(alignment: .bottom) {
                    NavigationLink {
                        NotificationsView()
                    } label: {
                        Image(systemName: "bell.fill")
                            .frame(maxWidth: 50, maxHeight: 50)
                            .font(.title2)
                            .background(Color(hex: GardenColors.skyBlue.rawValue))
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(Circle())
                    }
                    .shadow(radius: 5)
                    
                    NavigationLink {
                        PlantAPIView()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 70, height: 70)
                            .font(.largeTitle)
                            .background(Color(hex: GardenColors.plantGreen.rawValue))
                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                            .clipShape(Circle())
                    }
                    .shadow(radius: 5)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(x: -30)
            }
            .onAppear(perform: {
                myGarden = myGardenPlants
            })
        }
    }
    
    func filterMyGarden(filterString: String) {
        myGarden = myGarden.filter { $0.name.lowercased().contains(filterString.lowercased())
        }
    }
}

#Preview {
    GardenView()
}
