//
//  TPSegmentControl.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

enum SegmentPickerType {
    case line
    case capsule
}

struct TPSegmentControlConfig {
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 0.0
    var type: SegmentPickerType = .line
    var pickerConfig: TPSegmentPickerConfigProtocol
    var scrollConfig: TPPageScrollViewConfig = TPPageScrollViewConfig()
}

struct TPSegmentControl<BottomContent>: View where BottomContent: View {
    @State var selectIndex: Int
    private let numOfPages: Int
    private let config: TPSegmentControlConfig
    private let bottomContent: (_ index: Int) -> BottomContent
    
    init(numOfPages: Int,
         selectIndex: Int,
         config: TPSegmentControlConfig,
         @ViewBuilder bottomContent: @escaping (_ index: Int) -> BottomContent) {
        self.numOfPages = numOfPages
        self._selectIndex = State(wrappedValue: selectIndex)
        self.config = config
        self.bottomContent = bottomContent
    }
    
    var body: some View {
        VStack(alignment: config.alignment, spacing: config.spacing) {
            getSegmentPicker(config.pickerConfig)
            TPPageScrollView(numOfPages: numOfPages,
                             config: config.scrollConfig,
                             selectedPageNum: self.$selectIndex) {
                HStack(spacing: 10) {
                    ForEach(0..<numOfPages, id: \.self) { index in
                        bottomContent(index)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func getSegmentPicker(_ config: TPSegmentPickerConfigProtocol) -> some View {
        switch config.type {
        case .line:
            // ⚠️注意：这里使用guard会报错
            if let lineConfig = config as? TPLineSegmentPickerConfig {
                TPLineSegmentPicker(config: lineConfig,
                                    selectedIndex: self.$selectIndex)
            }
        case .capsule:
            if let capsuleConfig = config as? TPCapsuleSegmentPickerConfig {
                TPCapsuleSegmentPicker(config: capsuleConfig,
                                              selectedIndex: self.$selectIndex)
            }
        }
        EmptyView()
    }
}
