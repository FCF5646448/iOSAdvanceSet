//
//  TPLineSegmentPicker.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

/// TPSegmentPicker底部是线条
struct TPLineSegmentPicker: View {
    let type: SegmentPickerType = .line
    let config: TPLineSegmentPickerConfig
    @Binding private var selectedIndex: Int
    
    init(config: TPLineSegmentPickerConfig,
         selectedIndex: Binding<Int> = .constant(0)) {
        self.config = config
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        SegmentedPicker(
            config.titles,
            selectedIndex: self.$selectedIndex,
            selectionAlignment: .bottom,
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(isSelected ? config.textSelectedColor : config.textNormalColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    config.lineColor.frame(height: config.lineHeight)
                }
                .frame(width: config.lineWidth)
            })
            .onAppear { // 出现时，默认选中
                selectedIndex = 0
            }
            .animation(.easeInOut(duration: 0.3))
    }
}
