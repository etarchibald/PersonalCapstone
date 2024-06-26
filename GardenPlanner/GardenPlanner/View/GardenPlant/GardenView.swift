//
//  GardenView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import SwiftUI
import SwiftData
import Vortex

struct GardenView: View {
    @Query var myGardenPlants: [YourPlant]
    
    @FocusState private var isSearchBarFocused: Bool
    
    @EnvironmentObject var navigation: Navigation
    
    @State private var showingSearchBar = false
    @State private var searchText = ""
    @State private var showingXButton = false
    
    @State private var myGarden = [YourPlant]()
    
    private var cornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            
            VortexView(.customSlowRain) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .tag("circle")
            }
            .ignoresSafeArea(.all)
            
            VStack {
                ScrollView {
                    HStack {
                        if !showingSearchBar {
                            
                            HStack(spacing: 30) {
                                
//                                NavigationLink {
//                                    PlantAPIView()
//                                } label: {
                                    
                                    Button {
                                        navigation.navStack.append(PlantNavigation.plantAPIView)
                                    } label: {
                                        
                                        Image(systemName: "plus")
                                            .font(.title3)
                                            .padding()
                                            .foregroundStyle(.white)
                                            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(Color(hex: GardenColors.plantGreen.rawValue)))
                                    }
//                                }
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(Color(hex: GardenColors.plantGreen.rawValue))
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
                                                        filterMyGarden(filterString: searchText)
                                                        if searchText == "" {
                                                            myGarden = myGardenPlants
                                                        }
                                                    }
                                                }
                                                .onSubmit {
                                                    withAnimation(.smooth) {
                                                        filterMyGarden(filterString: searchText)
                                                    }
                                                }
                                                .foregroundColor(.primary)
                                                .focused($isSearchBarFocused)
                                            
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
                                        .clipShape(.rect(cornerRadius: cornerRadius))
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                Button {
                                    withAnimation(.bouncy) {
                                        showingSearchBar.toggle()
                                        isSearchBarFocused.toggle()
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
                                            .background(Color(hex: GardenColors.plantGreen.rawValue))
                                            .foregroundStyle(Color(hex: GardenColors.whiteSmoke.rawValue))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding()
                    
                    if myGarden.isEmpty {
                        if isSearchBarFocused {
                            Spacer(minLength: 300)
                            VStack {
                                Text("You do not have \(Text(searchText).foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) in your garden")
                                    .padding()
                            }
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                        } else {
                            Spacer(minLength: 300)
                            VStack {
                                Text("Looks like your garden is empty.")
                                Text("Press the \(Text("Plus").foregroundStyle(Color(hex: GardenColors.plantGreen.rawValue))) button to add Plants")
                            }
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                        }
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
        }
        .onAppear(perform: {
            myGarden = myGardenPlants
            searchText = ""
            showingSearchBar = false
        })
    }
    
    func filterMyGarden(filterString: String) {
        myGarden = myGardenPlants
        myGarden = myGarden.filter {
            $0.name.lowercased().contains(filterString.lowercased())
        }
    }
}

#Preview {
    GardenView()
}
