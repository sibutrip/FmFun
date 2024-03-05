//
//  SynthParam.swift
//  FmFun
//
//  Created by Cory Tripathy on 2/28/24.
//

import Foundation

struct SynthParam: Identifiable {
    static var screenSize: CGSize = .init(width: 1, height: 1)
    let id = UUID()
    let baseFrequency: Float
    let carrierMutliplier: Float
    let modulatingMultiplier: Float
    let modulationIndex: Float
    let location: CGPoint
    
    var scaledBaseFreq: Float { baseFrequency / 800 }
    var scaledCarrierMult: Float { carrierMutliplier / 20 }
    var scaledModMult: Float { modulatingMultiplier / 20 }
    var scaledModIndex: Float { modulationIndex / 100 }
    var scaledLocation: CGPoint {
        let scaledX = location.x / Self.screenSize.width
        let scaledY = location.y / Self.screenSize.height
        return CGPoint(x: scaledX, y: scaledY)
    }
    
    init(baseFrequency: Float, carrierMutliplier: Float, modulatingMultiplier: Float, modulationIndex: Float, location: CGPoint) {
        self.baseFrequency = baseFrequency
        self.carrierMutliplier = carrierMutliplier
        self.modulatingMultiplier = modulatingMultiplier
        self.modulationIndex = modulationIndex
        self.location = location
    }
    
//    init(scaledBaseFreq: Float, scaledCarrierMult: Float, scaledModMult: Float, scaledModIndex: Float, scaledLocation: CGPoint) {
//        self.baseFrequency = scaledBaseFreq * 800
//        self.carrierMutliplier = scaledCarrierMult * 20
//        self.modulatingMultiplier = scaledModMult * 20
//        self.modulationIndex = scaledModIndex * 100
//        var location = scaledLocation
//        location.x = scaledLocation.x * Self.screenSize.width
//        location.y = scaledLocation.y * Self.screenSize.height
//        self.location = location
//    }
}
