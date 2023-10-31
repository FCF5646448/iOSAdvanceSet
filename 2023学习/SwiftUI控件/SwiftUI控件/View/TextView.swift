//
//  TextView.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/10/31.
//

import SwiftUI

struct TextView: View {
    var body: some View {
        Text("Stay Hungry, Stay Foolish")
            .fontWeight(.bold) //
            .font(.title)
//            .font(.system(.largeTitle, design: .rounded))
//            .font(.system(size: 20))
            .foregroundColor(.green)
        
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.")
            .fontWeight(.medium)
            .font(.system(size: 16, design: .rounded))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center) // 文本剧种对齐
            .lineLimit(3) // 限制3行
            .truncationMode(.head) // 多出的内容截断方式
        
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking.")
            .fontWeight(.medium)
            .font(.title3)
            .multilineTextAlignment(.leading)
            .lineSpacing(10.0) // 行间距
            .padding() // 边距
        
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking.")
            .fontWeight(.medium)
            .font(.title3)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineSpacing(5)
            .padding()
//            .rotationEffect(.degrees(45)) // 旋转，传入的是角度degrees，以文本视图中心来旋转
//            .rotationEffect(.degrees(20), anchor: UnitPoint(x: 0, y: 0)) // 以左上角为中心旋转
            .rotation3DEffect(
                .degrees(60),
                                      axis: (x: 1.0, y: 0.0, z: 0.0)
            ) // 3D 旋转
            .shadow(color: .red, radius: 2, x: 0, y: 10) // 文字阴影
        
        Text("Your time is limited, so don’t waste it living someone else’s life. ")
            .font(.custom("Agbalumo", size: 25))
        
        Text("**This is how you bold a text**. *This is how you make text italic.* You can [click this link](https://www.appcoda.com) to go to appcoda.com").font(.title)
        
    }
}

#Preview {
    TextView()
}
