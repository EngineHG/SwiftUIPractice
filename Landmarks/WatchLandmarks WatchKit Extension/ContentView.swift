//
//  ContentView.swift
//  WatchLandmarks WatchKit Extension
//
//  Created by huangguojian on 2022/5/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
