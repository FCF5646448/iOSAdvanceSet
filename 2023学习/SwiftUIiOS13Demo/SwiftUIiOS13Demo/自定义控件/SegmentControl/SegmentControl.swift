//
//  SegmentControl.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentControl: View {
    @State var selectIndex: Int = 0
//    @EnvironmentObject var selectIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            SegmentPickerStyle2(titles: ["one", "two"], selectedIndex: self.$selectIndex).padding(.horizontal, 12)
            ScrollViewPager(axis: .horizontal,
                            numberOfPages: 2,
                            selectedPageNum: self.$selectIndex) {
                HStack(spacing: 10) {
                    GiftCollectionView()
                    GiftCollectionView()
                }
            }
        }
        .onAppear {
            selectIndex = 0
        }
    }
}

#Preview {
    SegmentControl(selectIndex: 0)
}
