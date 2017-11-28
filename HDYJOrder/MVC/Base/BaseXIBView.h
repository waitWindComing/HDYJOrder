//
//  BaseXIBView.h
//  Demo
//
//  Created by libertyAir on 2017/11/9.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseXIBView : UIView
@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@property(nonatomic,assign) IBInspectable BOOL maskToBounds;
@end


@interface BaseXIBButton : UIButton
@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@property(nonatomic,assign) IBInspectable BOOL maskToBounds;
@end

@interface BaseXibImageView : UIImageView
@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@property(nonatomic,assign) IBInspectable BOOL maskToBounds;
@end

@interface BaseXibLabel : UILabel
@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@property(nonatomic,assign) IBInspectable BOOL maskToBounds;
@end

@interface BaseXIBTextView : UITextView
@property(nonatomic,copy) IBInspectable NSString *placholder;
@property(nonatomic,assign) IBInspectable NSInteger placeholderFont;
@property(nonatomic,strong) IBInspectable UIColor *placeholderColor;
@end

