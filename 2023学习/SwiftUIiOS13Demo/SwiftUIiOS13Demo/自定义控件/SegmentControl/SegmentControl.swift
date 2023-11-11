//
//  SegmentControl.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentControl: View {
    @State var selectIndex: Int = 0
    let config = TPSegmentControlConfig(alignment: .leading,
                                        spacing: 0,
                                        type: .capsule,
                                        pickerConfig: TPCapsuleSegmentPickerConfig(titles: ["one", "two"], textNormalColor: .gray, textSelectedColor: .red, capsuleColor: .black.opacity(0.87)))
    //    @EnvironmentObject var selectIndex: Int
    
    var body: some View {
        TPSegmentControl(numOfPages: 2,
                         selectIndex: selectIndex,
                         config: config) { _ in
            GiftCollectionView()
        }
                         .onAppear{
                             selectIndex = 0
                         }
    }
}

#Preview {
    SegmentControl(selectIndex: 0)
}
