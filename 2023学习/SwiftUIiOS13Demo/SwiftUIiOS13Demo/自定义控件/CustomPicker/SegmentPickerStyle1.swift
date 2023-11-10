//
//  SegmentPickerStyle1.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentPickerStyle1: View {
    let titles: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        SegmentedPicker(
            titles,
            selectedIndex: self.$selectedIndex,
            selectionAlignment: .bottom,
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(isSelected ? Color.black : Color.gray )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    Color.black.frame(height: 1)
                }
                .frame(width: 20)
            })
            .onAppear { // 出现时，默认选中
                selectedIndex = 0
            }
            .animation(.easeInOut(duration: 0.3))
    }
}

#Preview {
    SegmentPickerStyle1(titles: ["one", "two", "three", "four"], selectedIndex: .constant(0))
}
