//
//  MineHeader.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/17.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "MineHeader.h"

@interface MineHeader()
@property(nonatomic,assign) CGFloat headerViewHeight;
@end
@implementation MineHeader


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.headerViewHeight = kScreenWidth * 0.45;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    CGFloat w = kScreenWidth * 0.16;
    self.iconView.sd_layout
    .leftSpaceToView(self, 20)
    .topSpaceToView(self, self.headerViewHeight*0.35)
    .heightIs(w)
    .widthIs(w);
    self.iconView.sd_cornerRadius = @(w/2);
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.iconView, 10)
    .heightIs(14)
    .centerYEqualToView(self.iconView)
    .rightSpaceToView(self, 20);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self setNeedsDisplay];     // 重绘
}

// 绘制曲线
- (void)drawRect:(CGRect)rect {
    //获取上下文
    //CGContextRef 用来保存图形信息.输出目标
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置颜色
    CGContextSetRGBFillColor(context, 28/255.f, 168/255.f, 253/255.f, 1.0);
    
    CGFloat h1 = self.headerViewHeight - 40;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    //起点
    CGContextMoveToPoint(context, w, h1);
    //画线
    CGContextAddLineToPoint(context, w, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, h1);
    CGContextAddQuadCurveToPoint(context, w * 0.5, h + (h - h1) * 0.6, w, h1);
    //闭合
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill);
}

-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_iconView];
    }
    return _iconView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(228,255,255);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
@end
