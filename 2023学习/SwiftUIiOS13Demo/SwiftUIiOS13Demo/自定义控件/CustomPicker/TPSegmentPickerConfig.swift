//
//  TPSegmentPickerConfig.swift
//  Chat
//
//  Created by fengcaifan on 2023/11/10.
//  Copyright © 2023 Baidu. All rights reserved.
//

import SwiftUI

protocol TPSegmentPickerConfigProtocol {
    var type: SegmentPickerType { get }
    var titles: [String] { get }
}

/// TPLineSegmentPicker的对应配置
struct TPLineSegmentPickerConfig: TPSegmentPickerConfigProtocol {
    let type: SegmentPickerType = .line
    var titles: [String]
    var textNormalColor: Color = .gray
    var textSelectedColor: Color = .black
    var lineHeight: CGFloat = 1.0
    var lineWidth: CGFloat = 20.0
    var lineColor: Color = .black
}

/// TPCapsuleSegmentPicker 的对应配置
struct TPCapsuleSegmentPickerConfig: TPSegmentPickerConfigProtocol {
    let type: SegmentPickerType = .capsule
    var titles: [String]
    var textNormalColor: Color = .gray
    var textSelectedColor: Color = .white
    var capsuleColor: Color = .black
}
