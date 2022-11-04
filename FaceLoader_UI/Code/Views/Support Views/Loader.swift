//
//  Loader.swift
//  FaceLoader_UI
//
//  Created by Ashish Dutt on 04/11/22.
//

import SwiftUI

enum LoaderState: CaseIterable{
    case right
    case down
    case left
    case up
    
    var aligment: Alignment{
        switch self{
        case .right, .down:
            return .topLeading
        case .left:
            return .topTrailing
        case .up:
            return .bottomLeading
        }
    }
    
    var capsuleDimension: CGFloat{
        return 40
    }
    
    var increaseOffset: CGFloat{
        return 72
    }
    
    var incrementBeforeAnimation: (CGFloat, CGFloat, CGFloat, CGFloat){ // xOffset, yOffset, width, height
        switch self{
        case .right:
            return (0, 0, capsuleDimension + increaseOffset, capsuleDimension)
            
        case .down:
            return (increaseOffset,0,capsuleDimension,capsuleDimension + increaseOffset)
            
        case .left:
            return (increaseOffset, increaseOffset, capsuleDimension + increaseOffset, capsuleDimension)

        case .up:
            return (0, capsuleDimension + increaseOffset, capsuleDimension, capsuleDimension + increaseOffset)
        }
        
    }
    
    var incrementAfterAnimation: (CGFloat, CGFloat, CGFloat, CGFloat){ // xOffset, yOffset, width, height
        switch self{
        case .right:
            return (increaseOffset, 0, capsuleDimension, capsuleDimension)
            
        case .down:
            return (increaseOffset, increaseOffset, capsuleDimension, capsuleDimension)
            
        case .left:
            return (0, increaseOffset, capsuleDimension, capsuleDimension)
        case .up:
            return (0, capsuleDimension, capsuleDimension, capsuleDimension)
        }
        
    }
    
}

struct Loader: View {
    // MARK: - Variables
    
    @State var capsuleWidth: CGFloat = 40
    @State var capsuleHeight: CGFloat = 40
    
    @State var xOffset: CGFloat = 0
    @State var yOffset: CGFloat = 0
    
    @State var loaderState: LoaderState
    
    @State var currentIndex = 0
    @Binding var startAnimation: Bool
    
    var timerDuration: TimeInterval = 0
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
            Capsule()
                .stroke(style: StrokeStyle(lineWidth: 14,lineCap: .round))
                .foregroundColor(.white)
                .frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                .animation(.easeOut(duration: 0.35))
                .offset(x:self.xOffset, y:self.yOffset)
        }
        .frame(width: 40,height: 0,alignment: loaderState.aligment)
        .onAppear(){
            //set the initial offset and assign the state
            self.setIndexAndOffset()
            
            //animate the capsule after the delay
            //each loader starts after the other one has finished, at a given time a single loader expands
            Timer.scheduledTimer(withTimeInterval: self.timerDuration, repeats: false) {separatorTimer in
                
                self.animateCapsule()
                self.repeatAnimation()
            }
            
            
        }
    }
    
    func getNextAnimationCase() -> LoaderState {
        
        let allCases = LoaderState.allCases
        
        if (self.currentIndex == allCases.count - 1){
            self.currentIndex = -1
        }
        
        self.currentIndex += 1
        
        return allCases[currentIndex]
    }
    
    func setIndexAndOffset(){
        
        for (ix, loaderCase) in LoaderState.allCases.enumerated() {
            
            if (loaderCase == self.loaderState){
                self.currentIndex = ix
                self.xOffset = LoaderState.allCases[self.currentIndex].incrementBeforeAnimation.0
                self.yOffset = LoaderState.allCases[self.currentIndex].incrementBeforeAnimation.1
            }
        }
    }
    
    func animateCapsule(){
        self.xOffset = self.loaderState.incrementBeforeAnimation.0
        self.yOffset = self.loaderState.incrementBeforeAnimation.1
        
        self.capsuleWidth = self.loaderState.incrementBeforeAnimation.2
        self.capsuleHeight = self.loaderState.incrementBeforeAnimation.3
        
        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false){_ in
            self.xOffset = self.loaderState.incrementAfterAnimation.0
            self.yOffset = self.loaderState.incrementAfterAnimation.1
            
            self.capsuleWidth = self.loaderState.incrementAfterAnimation.2
            self.capsuleHeight = self.loaderState.incrementAfterAnimation.3
        }
    }
    
    func repeatAnimation(){
        Timer.scheduledTimer(withTimeInterval: 2.1, repeats: true){ _ in
            self.loaderState = self.getNextAnimationCase()
            self.animateCapsule()
        }
    }
    
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            Loader(loaderState: .right, startAnimation: .constant(true), timerDuration: 0.35)
        }
    }
}
