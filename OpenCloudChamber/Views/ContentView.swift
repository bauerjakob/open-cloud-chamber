//
//  ContentView.swift
//  OpenCloudChamber
//
//  Created by Jakob Bauer on 28.04.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var peripheralCommunication = PeripheralCommunication.shared
    
    @State private var cooler: Double = 0
    @State private var light: Double = 0
    @State private var present: Bool = true
    @State private var currentMeasurementCooler: Double? = 0
    @State var rotation = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    CloudChamberModelView(rotation: $rotation)
                    VStack {
                        Image(systemName: "snow").foregroundColor(.blue).font(.title).padding(.bottom, 5)
                        Text("Live measurment of cooler").bold()
                        Text("\(cooler, specifier: "%.2f")°C")
                    }.padding().background(.gray.opacity(0.11))
                        .cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 0)
                        )
                }.padding()
                    
            }
            .navigationTitle("Cloud Chamber")
        }
        .sheet(isPresented: $present) {
            ScrollView {
                VStack {
                    Text("Controls").font(.title2).bold().padding(.vertical)
                    SliderControl(label: "Cooler", value: $cooler, currentMeasurment: $currentMeasurementCooler)
                        .padding(.bottom)
                        .onChange(of: cooler) {
                            peripheralCommunication.changeCooler(value: Int(cooler))
                        }
                    SliderControl(label: "Light", value: $light)
                        .onChange(of: light) {
                            peripheralCommunication.changeCooler(value: Int(light))
                        }
                    Spacer()
                    
                }
            }.scrollDisabled(true)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .presentationDetents([.fraction(0.12), .medium, .fraction(0.9)])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ContentView()
}
