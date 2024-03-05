//
//  NewSynthView.swift
//  FmFun
//
//  Created by Cory Tripathy on 2/28/24.
//

import SwiftUI

struct NewSynthView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var synth = FmConductor()
    let location: CGPoint
    @EnvironmentObject var synthVm: SynthViewModel
    @State private var isPlaying = false
#warning("dont frame")
    var body: some View {
        NavigationStack {
            List {
                Section("Parameters") {
                    HStack {
                        Text("\(synth.baseFrequency, specifier: "%.2f")")
                            .frame(maxWidth: 75)
                        Slider(value: $synth.baseFrequency, in: 0...800)
                    }
                    HStack {
                        Text("\(synth.carrierMultiplier, specifier: "%.2f")")
                            .frame(maxWidth: 75)
                        Slider(value: $synth.carrierMultiplier, in: 0...20)
                    }
                    HStack {
                        Text("\(synth.modulatingMultiplier, specifier: "%.2f")")
                            .frame(maxWidth: 75)
                        Slider(value: $synth.modulatingMultiplier, in: 0...20)
                    }
                    HStack {
                        Text("\(synth.modulationIndex, specifier: "%.2f")")
                            .frame(maxWidth: 75)
                        Slider(value: $synth.modulationIndex, in: 0...100)
                    }
                    Button("Randomize") {
                        synth.randomize()
                    }
                    .frame(maxWidth: .infinity)
                }
                Section {
                    Button {
                        isPlaying.toggle()
                        if isPlaying {
                            try! synth.engine.start()
                            synth.start()
                        } else {
                            synth.stop()
                        }
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .foregroundStyle(isPlaying ? Color.red : Color.green )
                            .font(.title)
                            .frame(maxWidth: .infinity)
                    }
                }
                Section {
                    Button("Create") {
                        synthVm.newParam(atLocation: location,
                                         baseFrequency: synth.baseFrequency,
                                         carrierMutliplier: synth.carrierMultiplier,
                                         modulatingMultiplier: synth.modulatingMultiplier,
                                         modulationIndex: synth.modulationIndex)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .bold()
                }
            }
            .navigationTitle("New Parameter")
        }
    }
}

#Preview {
    NewSynthView(location: .zero)
        .environmentObject(SynthViewModel())
}
