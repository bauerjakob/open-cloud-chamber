//
//  SliderControl.swift
//  OpenCloudChamber
//
//  Created by Jakob Bauer on 28.04.24.
//

import Foundation
import SwiftUI

struct SliderControl:  View {
    @Binding var value: Double
    @Binding var currentMeasurment: Double?;
    private var label: String;
    
    init(label: String, value: Binding<Double>, currentMeasurment: Binding<Double?>? = nil) {
        self.label = label
        self._value = value
        self._currentMeasurment = currentMeasurment ?? Binding.constant(nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).bold().font(.title3)
            Slider(
                value: $value,
                in: 0...255,
                step: 1
            ).padding()
            
            if (currentMeasurment != nil) {
                Divider()
                HStack {
                    Text("Live measurment").bold()
                    Spacer()
                    Text("\(currentMeasurment!, specifier: "%.2f")°C")
                }
            }
        }.padding()
            .background(.gray.opacity(0.11))
            .cornerRadius(15) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blue, lineWidth: 0)
            )
    }
}

#Preview {
    struct Preview: View {
        @State var value: Double = 10
        @State var currentMeasurment: Double? = 87
            var body: some View {
                SliderControl(label: "Cooler", value: $value, currentMeasurment: $currentMeasurment)
            }
        }

        return Preview()
}
