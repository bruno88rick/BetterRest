//
//  ContentView.swift
//  BetterRest
//
//  Created by Bruno Oliveira on 15/01/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var numberOfCups = 0...20
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                //VStack(alignment: .leading, spacing: 0){
                Section("When do you want to wake up?") {
                    //Text("When do you want to wake up?")
                        //.font(.headline)
                    
                    DatePicker("Enter a time you want to wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                //VStack (alignment: .leading, spacing: 0) {
                Section("Desired amount of Sleep"){
                    //Text("Desired amount of Sleep")
                        //.font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                //VStack (alignment: .leading, spacing: 0) {
                Section("Daily Coffe intake"){
                    //Text("Daily Coffe intake")
                    //.font(.headline)
                    
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 0...20)
                    
                    Picker("Numer Of Cups", selection: $coffeeAmount) {
                        ForEach(numberOfCups, id: \.self)  {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
            }
            .navigationTitle("BetterRest")
            //.toolbar{
                //Button("Calculate", action: calculateBedTime)
            //}
            Button {
                calculateBedTime()
            } label: {
                Text("Calculate")
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                    .padding()
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Ok") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime () {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, . minute], from: wakeUp)
            let hour  = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your bed time is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bed time!"
        }
        
        showingAlert = true
        
    }
    
}

#Preview {
    ContentView()
}
