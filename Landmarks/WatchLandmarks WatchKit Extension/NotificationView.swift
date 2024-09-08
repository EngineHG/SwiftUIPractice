//
//  NotificationView.swift
//  WatchLandmarks WatchKit Extension
//
//  Created by huangguojian on 2022/5/20.
//

import SwiftUI

struct NotificationView: View {
    var title: String?
    var message: String?
    var landmark: Landmark?
    
    var body: some View {
        VStack {
            if let landmark = landmark {
                CircleImage(image: landmark.image.resizable()).scaledToFit()
            }
            
            Text(title ?? "Unknown Landmark").font(.headline)
            
            Divider()
            
            Text(message ?? "You are wihtnin 5 miles of one of your favorite landmarks.")
        }
        .lineLimit(0)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationView()
            NotificationView(
                title: "Turtle Rock",
                message: "you are whithin 5 miles of Turtle Rock.",
                landmark: ModelData().landmarks.first)
        }
    }
}
