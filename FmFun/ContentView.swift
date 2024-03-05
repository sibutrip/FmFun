//
//  ContentView.swift
//  FmFun
//
//  Created by Cory Tripathy on 2/27/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var synthVm = SynthViewModel()
    @State private var location: CGPoint?
    private var addingNewSynth: Binding<Bool> {
        Binding {
            location != nil
        } set: { _ in location = nil }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Color.primary.colorInvert()
                    if synthVm.synthParams.isEmpty {
                        Text("Tap anywhere to add a new synth!")
                    } else if synthVm.synthParams.count == 1 {
                        Text("Add (at least) one more!")
                    }
                    ForEach(synthVm.synthParams) { param in
                        Rectangle()
                            .frame(width: geo.size.width / 8,
                                   height: geo.size.width / 8,
                                   alignment: .center)
                            .overlay {
                                VStack {
                                    Text(param.baseFrequency.description)
                                    Text(param.carrierMutliplier.description)
                                    Text(param.modulatingMultiplier.description)
                                    Text(param.modulationIndex.description)
                                }
                                .fixedSize()
                                .foregroundStyle(Color.red)
                            }
                            .position(param.location)
                            .onAppear { SynthParam.screenSize = geo.size }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture(count:1) { location in
                    if synthVm.appState == .addingParams {
                        self.location = location
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if synthVm.appState == .running {
                                synthVm.dragLocation = value.location
                            }
                        }
                        .onEnded { _ in synthVm.dragLocation = nil}
                )
            }
            .toolbar {
                if synthVm.synthParams.count > 1 {
                    Button("Delete", systemImage: "trash") {
                        synthVm.reset()
                    }
                }
            }
        }
        .sheet(isPresented: addingNewSynth) {
            if let location {
                NewSynthView(location: location)
                    .environmentObject(synthVm)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if synthVm.synthParams.count > 1 {
                switch synthVm.appState {
                case .training:
                    Button(action: { }) {
                        ProgressView()
                    }
                    .buttonStyle(.borderedProminent)
                case .running:
                    Button("Stop") {
                        synthVm.stop()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                case .addingParams:
                    Button("Train") {
                        Task { await synthVm.train() }
                    }
                    .buttonStyle(.borderedProminent)
                case .finishedTraining:
                    Button("Run") {
                        synthVm.run()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
