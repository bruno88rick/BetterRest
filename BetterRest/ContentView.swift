//
//  ContentView.swift
//  BetterRest
//
//  Created by Bruno Oliveira on 15/01/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Enter a time you want to wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of Sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily Coffe intake")
                    .font(.headline)
                
                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
                
                
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime () {
        
    }
    
}

#Preview {
    ContentView()
}
