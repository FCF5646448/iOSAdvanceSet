//
//  IdineOrderView.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/6.
//

import SwiftUI

struct IdineOrderView: View {
    
    @EnvironmentObject var order: Order
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                }
                
                Section {
                    NavigationLink("Place Order") {
                        Text("Check out")
                    }
                }
            }
            .navigationTitle("Order")
        }
    }
}

#Preview {
    IdineOrderView().environmentObject(Order())
}
