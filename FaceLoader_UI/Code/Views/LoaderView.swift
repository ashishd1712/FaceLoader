//
//  ContentView.swift
//  FaceLoader_UI
//
//  Created by Ashish Dutt on 02/11/22.
//

import SwiftUI

struct LoaderView: View {
    // MARK: - Variables
    @State var animateLoaders = false
    
    // MARK: - views
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            
            Loader(loaderState: .down, startAnimation: $animateLoaders, timerDuration: 0.35)
            Loader(loaderState: .right, startAnimation: $animateLoaders, timerDuration: 1.05)
            Loader(loaderState: .up, startAnimation: $animateLoaders, timerDuration: 1.75)
        }
        .offset(x: -40, y: -80)
        .onAppear() {
            self.animateLoaders.toggle()
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea(.all)
            LoaderView()
        }
        
    }
}
