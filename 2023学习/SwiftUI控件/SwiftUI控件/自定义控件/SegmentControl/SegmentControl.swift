//
//  SegmentControl.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentControl: View {
    var body: some View {
        VStack(alignment: .leading) {
            SegmentPickerStyle2(titles: ["one", "two"])
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    GiftCollectionView()
                    GiftCollectionView()
                }
            }
//            .scrollTargetBehavior(.paging) // iOS 17才能使用
        }
    }
}

#Preview {
    SegmentControl()
}
