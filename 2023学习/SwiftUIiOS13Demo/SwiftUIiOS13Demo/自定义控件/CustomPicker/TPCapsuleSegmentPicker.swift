//
//  TPCapsuleSegmentPicker.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

/// TPSegmentPicker背景是圆角色块
struct TPCapsuleSegmentPicker: View {
    let type: SegmentPickerType = .capsule
    let config: TPCapsuleSegmentPickerConfig
    @Binding private var selectedIndex: Int
    
    init(config: TPCapsuleSegmentPickerConfig,
         selectedIndex: Binding<Int> = .constant(0)) {
        self.config = config
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        SegmentedPicker(
            config.titles,
            selectedIndex: self.$selectedIndex,
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(isSelected ? config.textSelectedColor : config.textNormalColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            },
            selection: {
                Capsule()
                    .fill(config.capsuleColor)
            })
            .animation(.easeInOut(duration: 0.3))
    }
}
