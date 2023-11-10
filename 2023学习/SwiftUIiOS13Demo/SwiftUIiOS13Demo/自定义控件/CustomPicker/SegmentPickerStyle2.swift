//
//  SegmentPickerStyle2.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentPickerStyle2: View {
    let titles: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        SegmentedPicker(
            titles,
            selectedIndex: //self.$selectedIndex,
                Binding(
                get: { selectedIndex },
                set: { selectedIndex = $0 }),
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(isSelected ? Color.white : Color.gray )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            },
            selection: {
                Capsule()
                    .fill(Color.gray)
            })
            .animation(.easeInOut(duration: 0.3))
    }
}

#Preview {
    SegmentPickerStyle2(titles: ["one", "two", "three", "four"], selectedIndex: .constant(0))
}
