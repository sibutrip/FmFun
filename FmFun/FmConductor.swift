//
//  FmConductor.swift
//  FmFun
//
//  Created by Cory Tripathy on 2/27/24.
//

import SwiftUI
import AudioKit
import SoundpipeAudioKit

class FmConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var osc = FMOscillator()
    
    func start() { osc.start() }
    
    func stop() { osc.stop() }
    
    var baseFrequency: AUValue {
        get { osc.baseFrequency }
        set { osc.baseFrequency = newValue
            objectWillChange.send() }
    }
    
    var carrierMultiplier: AUValue {
        get { osc.carrierMultiplier }
        set { osc.carrierMultiplier = newValue
            objectWillChange.send() }
    }
    
    var modulatingMultiplier: AUValue {
        get { osc.modulatingMultiplier }
        set { osc.modulatingMultiplier = newValue
            objectWillChange.send() }
    }
    
    var modulationIndex: AUValue {
        get { osc.modulationIndex }
        set { osc.modulationIndex = newValue
            objectWillChange.send() }
    }
    
    func randomize() {
        osc.baseFrequency = AUValue.random(in: 0 ... 800)
        osc.carrierMultiplier = AUValue.random(in: 0 ... 20)
        osc.modulatingMultiplier = AUValue.random(in: 0 ... 20)
        osc.modulationIndex = AUValue.random(in: 0 ... 100)
        objectWillChange.send()
    }
    
    init() {
        engine.output = osc
    }
}
