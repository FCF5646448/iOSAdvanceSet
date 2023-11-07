//
//  SwiftUIPicker.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/7.
//

import SwiftUI

struct SwiftUIPicker: View {
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    
    @State private var paymentType = "Cash"
    
    var body: some View {
        VStack {
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.automatic)
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.inline)
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.navigationLink)
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.palette)
            
            Picker("How do you want to pay?", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    SwiftUIPicker()
}
