//
//  AlertNumView.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/22.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AlertNumView.h"


@interface AlertNumView ()
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIView *maskView;
@end
@implementation AlertNumView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setupSubViews];
    }
    return self;
}
- (void)showAnimated:(BOOL)animated {
    
    _currentView = self;
    CGFloat halfScreenWidth = kScreenWidth * 0.5;
    CGFloat halfScreenHeight = kScreenHeight * 0.35;
    // center
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    self.center = screenCenter;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:self];
    
    if (animated) {
        // 将view宽高缩至无限小（点）
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3 animations:^{
            // 以动画的形式将view慢慢放大至原始大小的1.2倍
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                // 以动画的形式将view恢复至原始大小
                self.transform = CGAffineTransformIdentity;
                
            }];
        }];
    }
}

- (void)closeAnimated:(BOOL)animated {
    [self.numField endEditing:YES];
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                self.maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [_currentView removeFromSuperview];
                [self.maskView removeFromSuperview];
            }];
        }];
    } else {
        [self.maskView removeFromSuperview];
        [_currentView removeFromSuperview];
    }
}
-(void)clickClose{
    [self closeAnimated:YES];
}
-(void)sureAction{
    int n = [_numField.text intValue];
    if (n <= 0) {
        [self.superview makeToast:@"对不起,数量不能小于0!"];
        return;
    }
    if(![self isPureInt:_numField.text]){
        [self.superview makeToast:@"对不起,您的输入有误!"];
        return;
    }
    self.alertBlock(self.numField.text);
    [self closeAnimated:YES];
}
- (BOOL)isPureInt:(NSString*)string{
    //判断字符串是否为纯数字
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(void)alertNumAction:(UIButton *)sender{
    int n = [_numField.text intValue];
    if (sender.tag == 111) {
        //➕
        n++;
        
    }else if (sender.tag == 222){
        //－
        n --;
    }
    _numField.text = [NSString stringWithFormat:@"%d",n];
}
-(void)setupSubViews{
    UILabel *tip = [UILabel new];
    tip.frame = CGRectMake(0, 25, 100, 16);
    tip.centerX = self.centerX;
    tip.text = @"修改购买数量";
    tip.textAlignment = 1;
    tip.font = [UIFont systemFontOfSize:16];
    tip.textColor = RGBCOLOR(40, 40, 40);
    [self addSubview:tip];
    
    _numField = [UITextField new];
    _numField.textAlignment = 1;
    _numField.font = [UIFont systemFontOfSize:16];
    _numField.keyboardType = UIKeyboardTypeNumberPad;
    _numField.layer.borderColor = RGBCOLOR(180, 180, 180).CGColor;
    _numField.layer.borderWidth = .5;
    [self addSubview:_numField];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 222;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"s_icon_minus_sign"] forState:0];
    [leftBtn addTarget:self
                action:@selector(alertNumAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 111;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"s_icon_puls"] forState:0];
    [rightBtn addTarget:self
                action:@selector(alertNumAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, self.height -50, self.width/2, 50);
    [cancelBtn setTitle:@"取消" forState:0];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:RGBCOLOR(40, 40, 40)
     forState:0];
    [cancelBtn addTarget:self
                  action:@selector(clickClose)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.width/2, self.height - 50, self.width/2, 50);
    sureBtn.backgroundColor = NAVI_COLOR;
    [sureBtn setTitle:@"确定" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self
                action:@selector(sureAction)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    //line
    UIView *line = [UIView new];
    line.backgroundColor = RGBCOLOR(220, 220, 220);
    line.frame = CGRectMake(0, 0, self.width/2, 1);
    [cancelBtn addSubview:line];

    
    //num
    _numField.sd_layout
    .topSpaceToView(tip, 20)
    .widthIs(71)
    .heightIs(35)
    .centerXEqualToView(tip);
    
    //-
    leftBtn.sd_layout
    .rightSpaceToView(_numField, -1)
    .heightRatioToView(_numField, 1)
    .widthIs(45)
    .centerYEqualToView(_numField);

    //+
    rightBtn.sd_layout
    .leftSpaceToView(_numField, -1)
    .heightRatioToView(_numField, 1)
    .widthIs(45)
    .centerYEqualToView(_numField);
    
    //弹出键盘
    [_numField becomeFirstResponder];

}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _maskView.userInteractionEnabled = YES;
        _maskView.alpha = .7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickClose)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}

@end
