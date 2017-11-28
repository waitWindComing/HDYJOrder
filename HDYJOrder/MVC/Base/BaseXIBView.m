//
//  BaseXIBView.m
//  Demo
//
//  Created by libertyAir on 2017/11/9.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "BaseXIBView.h"

@implementation BaseXIBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
-(void)setMaskToBounds:(BOOL)maskToBounds{
    _maskToBounds = maskToBounds;
    self.layer.masksToBounds = _maskToBounds;
}
@end


@implementation BaseXIBButton
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
-(void)setMaskToBounds:(BOOL)maskToBounds{
    _maskToBounds = maskToBounds;
    self.layer.masksToBounds = _maskToBounds;
}
@end

@implementation BaseXibImageView
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
-(void)setMaskToBounds:(BOOL)maskToBounds{
    _maskToBounds = maskToBounds;
    self.layer.masksToBounds = _maskToBounds;
}
@end

@implementation BaseXibLabel
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
-(void)setMaskToBounds:(BOOL)maskToBounds{
    _maskToBounds = maskToBounds;
    self.layer.masksToBounds = _maskToBounds;
}
@end

@interface BaseXIBTextView()
@property(nonatomic,strong) UILabel *placeLabel;
@end
@implementation BaseXIBTextView
-(UILabel *)placeLabel{
    if (!_placeLabel) {
        //self.delegate = self;
        _placeLabel = [UILabel new];
        _placeLabel.tag = 1122;
        [self addSubview:_placeLabel];
        _placeLabel.sd_layout
        .leftSpaceToView(self, 2.5)
        .topSpaceToView(self, 7)
        .rightSpaceToView(self, 0)
        .heightIs(15);
    }
    return _placeLabel;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeLabel.textColor = _placeholderColor;
}
-(void)setPlacholder:(NSString *)placholder{
    _placholder = placholder;
    self.placeLabel.text = _placholder;
}
-(void)setPlaceholderFont:(NSInteger)placeholderFont{
    _placeholderFont = placeholderFont;
    self.placeLabel.font = [UIFont systemFontOfSize:_placeholderFont];
}

@end
