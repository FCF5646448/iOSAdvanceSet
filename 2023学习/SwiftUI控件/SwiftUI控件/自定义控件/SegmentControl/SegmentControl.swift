//
//  SegmentControl.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct SegmentControl: View {
    @Binding private var selection: Int
    @State private var segmentSize: CGSize = .zero
    
    private let items: [String]
    
    private let xSpace: CGFloat = 0.0
    
    public init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: xSpace) {
                    ForEach(0..<items.count, id: \.self) { index in
                        
                    }
                }
            }
        }
    }
}

#Preview {
    SegmentControl()
}
