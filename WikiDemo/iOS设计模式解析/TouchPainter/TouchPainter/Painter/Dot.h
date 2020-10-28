//
//  Dot.h
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/21.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Vertex.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dot : Vertex
@property (nonatomic, assign) CGFloat size_;
@property (nonatomic, strong) UIColor * color_;
- (id) copyWithZone:(NSZone *)zone;
@end

NS_ASSUME_NONNULL_END
