//
//  IdineChecoutView.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/7.
//

import SwiftUI

struct IdineChecoutView: View {
    @EnvironmentObject var order: Order
    
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    
    @State private var paymentType = "Cash"
    
    var body: some View {
        VStack {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.navigationLink)
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    IdineChecoutView().environmentObject(Order())
}
