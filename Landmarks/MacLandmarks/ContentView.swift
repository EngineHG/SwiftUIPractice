//
//  ContentView.swift
//  MacLandmarks
//
//  Created by huangguojian on 2022/5/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
            .frame(width: 700, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
