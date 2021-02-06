//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by CodeMan on 2021/2/6.
//

import SwiftUI

struct ContentView: View {
    
    @State var counter: Int = 0
    var body: some View {
        VStack(content: {
            Button(action: { counter += 1 }, label: {
                Text("Tap Me!")
            })
            .padding()
            .background(Color(.tertiarySystemFill))
            .cornerRadius(5)
            
            if counter > 0{
                Text("You have tapped \(counter) times")
            }
        })
        .debug()
        .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .border(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
