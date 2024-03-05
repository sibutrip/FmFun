//
//  SynthViewModel.swift
//  FmFun
//
//  Created by Cory Tripathy on 2/28/24.
//

import Foundation

enum AppState {
    case training, running, addingParams, finishedTraining
}

@MainActor
class SynthViewModel: ObservableObject {
    var neuralNetwork = NeuralNetwork(inputSize: 2, hiddenSize: 3, outputSize: 4)
    let fmSynth = FmConductor()
    @Published var synthParams = [SynthParam]()
    @Published var appState: AppState = .addingParams
    @Published var dragLocation: CGPoint? {
        didSet {
            guard dragLocation != nil else {
                fmSynth.stop()
                return
            }
            if dragLocation != nil && oldValue == nil {
                fmSynth.start()
            }
            updateSynthParams()
        }
    }
    
    func updateSynthParams() {
        guard let dragLocation else { return }
        let rawOutput: [Float] = neuralNetwork.run(input: [Float(dragLocation.x / SynthParam.screenSize.width), Float(dragLocation.y / SynthParam.screenSize.height)])
        let processedOutput = [
            rawOutput[0] * 800,
            rawOutput[1] * 20,
            rawOutput[2] * 20,
            rawOutput[3] * 100
        ]
        fmSynth.baseFrequency = processedOutput[0]
        fmSynth.carrierMultiplier = processedOutput[1]
        fmSynth.modulatingMultiplier = processedOutput[2]
        fmSynth.modulationIndex = processedOutput[3]
        print(processedOutput)
    }
    
    func train() async {
        neuralNetwork = NeuralNetwork(inputSize: 2, hiddenSize: 3, outputSize: 4)
        appState = .training
        await neuralNetwork.train(withParams: synthParams)
        appState = .finishedTraining
    }
    
    func run() {
        print("params are: \(synthParams)")
        try! fmSynth.engine.start()
        appState = .running
    }
    
    func stop() {
        appState = .addingParams
    }
    
    func reset() {
        neuralNetwork = NeuralNetwork(inputSize: 2, hiddenSize: 3, outputSize: 4)
        synthParams.removeAll()
        appState = .addingParams
    }
    
    func newParam(atLocation location: CGPoint,
                  baseFrequency: Float,
                  carrierMutliplier: Float,
                  modulatingMultiplier: Float,
                  modulationIndex: Float) {
        let param = SynthParam(baseFrequency: baseFrequency, carrierMutliplier: carrierMutliplier, modulatingMultiplier: modulatingMultiplier, modulationIndex: modulationIndex, location: location)
        synthParams.append(param)
    }
    
    func randomParam(atLocation location: CGPoint) {
        let baseFrequency = Float.random(in: 0 ... 800)
        let carrierMultiplier = Float.random(in: 0 ... 20)
        let modulatingMultiplier = Float.random(in: 0 ... 20)
        let modulationIndex = Float.random(in: 0 ... 100)
        let param = SynthParam(baseFrequency: baseFrequency, carrierMutliplier: carrierMultiplier, modulatingMultiplier: modulatingMultiplier, modulationIndex: modulationIndex, location: location)
        self.synthParams.append(param)
        print(param)
    }
}
