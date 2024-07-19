//
//  ContentView.swift
//  WeSplit
//
//  Created by Apple on 12/7/24.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.red)
    }
}

extension View {
    func codeRed() -> some View{
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var checkAmout = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPer = 20
    @FocusState private var amoutIsFocused: Bool
    @State private var codeRedState = false
    let tipPers = [10, 15, 20, 30, 0]
    
    var totalPerPerson: Double{
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPer)
        let tipValue = checkAmout / 100 * tipSelection
        let grandTotal = checkAmout + tipValue
        
        return grandTotal / peopleCount
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPer)
        let tipValue = checkAmout / 100 * tipSelection
        let grandTotal = checkAmout + tipValue
        
        return grandTotal
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    TextField("Amount: ", value: $checkAmout, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amoutIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                    
                Section("Tips?"){
                    Picker("Tip percentage", selection: $tipPer){
                        ForEach(tipPers, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: tipPer) { newValue in
                                            codeRedState = (newValue == 0)}
                }
                Section("Total amount"){
                    if codeRedState {
                        Text(totalAmount, format:
                                .currency(code: Locale.current.currency? .identifier ?? "USD")
                        )
                        .codeRed()
                    } else {
                        Text(totalAmount, format:
                                .currency(code: Locale.current.currency? .identifier ?? "USD")
                             )
                    }
                }
                
                
                Section("Amount per person"){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                         )
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if amoutIsFocused {
                    Button("Done") {
                        amoutIsFocused = false
                    }
                }
            }
        }
        
    }
}









#Preview {
    ContentView()
}
