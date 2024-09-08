//
//  LandmarkList.swift
//  Landmarks
//
//  Created by huangguojian on 2022/5/5.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly: Bool = false
    @State private var filter = FilterCatergory.all
    @State private var selectedLandmark: Landmark?
    
    enum FilterCatergory: String, CaseIterable, Identifiable {
        case all = "All"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
        
        var id: Self { self }
    }
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter {
            (!showFavoritesOnly || $0.isFavorite)
            && (filter == .all || filter.rawValue == $0.category.rawValue)
        }
    }
    
    var title: String {
        let title = filter == .all ? "Landmarks" : filter.rawValue
        return showFavoritesOnly ? "Favorite \(title)" : title
    }
    
    var index: Int? {
        modelData.landmarks.firstIndex(where: { $0.id == selectedLandmark?.id })
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectedLandmark) {
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                    .tag(landmark)
                }
            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Category", selection: $filter) {
                            ForEach(FilterCatergory.allCases) { catergory in
                                Text(catergory.rawValue).tag(catergory)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Toggle(isOn: $showFavoritesOnly) {
                            Label("Favorites only", systemImage: "star.fill")
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
            }
            
            Text("Select a Landmark")
        }
        .focusedValue(\.selectedLandmark, $modelData.landmarks[index ?? 0])
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
