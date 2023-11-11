//
//  TPIconTextItem.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

/// TODO: fcf 扩展不同布局
struct TPIconTextItem: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 1.0) {
            Image(icon)
                .resizable()
                .scaledToFit()
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.5))
        }
    }
}
