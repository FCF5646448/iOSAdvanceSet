//
//  CalculatorDataApp.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/9.
//

import SwiftUI

@main
struct CalculatorDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CalculatorModel())
        }
    }
}
