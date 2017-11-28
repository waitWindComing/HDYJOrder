//
//  DashedView.m
//  Demo
//
//  Created by libertyAir on 2017/11/13.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "DashedView.h"

@implementation DashedView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 0, 0);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {5,5};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,1);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, self.frame.origin.x + self.frame.size.width,0);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}


@end
