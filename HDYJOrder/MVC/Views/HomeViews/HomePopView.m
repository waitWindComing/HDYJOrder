//
//  HomePopView.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/17.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "HomePopView.h"

#define kBack_H 215
@implementation HomePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 5.0f;
        [self setupSubViews];
        
        //鍵盤出現
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShown:)
                                                     name:UIKeyboardWillChangeFrameNotification object:nil];
        //鍵盤隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)setupSubViews{
    //backView
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.frame = CGRectMake(0, 0, self.width, kBack_H);
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [_backView addGestureRecognizer:tap];
    //商品图片
    _goodsImgView = [UIImageView new];
    _goodsImgView.layer.cornerRadius = 3;
    _goodsImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _goodsImgView.layer.borderWidth = 2.f;
    _goodsImgView.layer.masksToBounds = YES;
    _goodsImgView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_goodsImgView];
    //关闭btn
    _closeBtn = [UIButton new];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:0];
    [_backView addSubview:_closeBtn];
    [_closeBtn addTarget:self
                  action:@selector(closeAction)
        forControlEvents:UIControlEventTouchUpInside];
    //title
    _titleLabel = [UILabel new];
    _titleLabel.textColor = RGBCOLOR(40, 40, 40);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 2;
    [_backView addSubview:_titleLabel];
    //单价
    _priceLabel = [UILabel new];
    _priceLabel.textColor = RGBCOLOR(255, 164, 0);
    _priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [_backView addSubview:_priceLabel];
    //库存
    _surplusLabel = [UILabel new];
    _surplusLabel.textColor = RGBCOLOR(180, 180, 180);
    _surplusLabel.font = [UIFont systemFontOfSize:14];
    [_backView addSubview:_surplusLabel];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"购买数量";
    tipLabel.textColor = RGBCOLOR(40, 40, 40);
    tipLabel.font = [UIFont systemFontOfSize:14];
    [_backView addSubview:tipLabel];
    
    //加
    UIButton *plusBtn = [UIButton new];
    plusBtn.tag = 222;
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"s_icon_puls"] forState:0];
    [_backView addSubview:plusBtn];
    [plusBtn addTarget:self
                action:@selector(alertGoodsNumAction:)
      forControlEvents:UIControlEventTouchUpInside];
    //数量
    _numField = [UITextField new];
    _numField.textColor = RGBCOLOR(40, 40, 40);
    _numField.textAlignment = 1;
    _numField.font = [UIFont systemFontOfSize:16];
    _numField.layer.borderColor = RGBCOLOR(180, 180, 180).CGColor;
    _numField.layer.borderWidth = 0.5;
    _numField.keyboardType = UIKeyboardTypeNumberPad;
    [_backView addSubview:_numField];
    //添加完成键
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 7.5, 50, 30);
    btn.titleLabel.textAlignment = 2;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:NAVI_COLOR forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    _numField.inputAccessoryView = topView;
    [btn addTarget:self
            action:@selector(clickCompleteAction)
  forControlEvents:UIControlEventTouchUpInside];
    
    //减
    UIButton *minusBtn = [UIButton new];
    minusBtn.tag = 111;
    [minusBtn setBackgroundImage:[UIImage imageNamed:@"s_icon_minus_sign"] forState:0];
    [_backView addSubview:minusBtn];
    [minusBtn addTarget:self
                action:@selector(alertGoodsNumAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    //确定
    _sureBtn = [UIButton new];
    [_sureBtn setTitle:@"加入购物车" forState:0];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _sureBtn.backgroundColor = NAVI_COLOR;
    [self addSubview:_sureBtn];
    [_sureBtn addTarget:self
                 action:@selector(sureAction)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    _goodsImgView.sd_layout
    .leftSpaceToView(_backView, 15)
    .topSpaceToView(_backView, 25)
    .widthIs(91)
    .heightIs(96);
    
    _closeBtn.sd_layout
    .rightSpaceToView(_backView, 10)
    .topSpaceToView(_backView, 10)
    .heightIs(19)
    .widthIs(19);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_goodsImgView, 11)
    .topSpaceToView(_backView, 27)
    .rightSpaceToView(_backView, 68)
    .autoHeightRatio(0);
    
    _priceLabel.sd_layout
    .leftSpaceToView(_goodsImgView, 11)
    .topSpaceToView(_titleLabel, 15)
    .heightIs(13);
    
    _surplusLabel.sd_layout
    .leftEqualToView(_priceLabel)
    .topSpaceToView(_priceLabel, 10)
    .heightIs(12);
    
    
    tipLabel.sd_layout
    .leftEqualToView(_goodsImgView)
    .topSpaceToView(_goodsImgView, 20)
    .heightIs(14)
    .widthIs(60);
    
    minusBtn.sd_layout
    .leftEqualToView(tipLabel)
    .topSpaceToView(tipLabel, 15)
    .widthIs(45)
    .heightIs(35);
    
    _numField.sd_layout
    .leftSpaceToView(minusBtn, -1)
    .centerYEqualToView(minusBtn)
    .heightIs(35)
    .widthIs(71);
    
    plusBtn.sd_layout
    .leftSpaceToView(_numField, -1)
    .centerYEqualToView(minusBtn)
    .widthIs(45)
    .heightIs(35);

    
    _sureBtn.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(46);
    
}
-(void)setModel:(HomeRightModel *)model{
    _model = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    //title
    self.titleLabel.text = _model.goods_name;
    //单价
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    //库存
    self.surplusLabel.text = [NSString stringWithFormat:@"还剩%@件",_model.stock];
    //num
    if ([_model.stock isEqualToString:@"0"]) {
        _numField.text = @"0";
    }else{
        _numField.text = @"1";
    }
}
-(void)alertGoodsNumAction:(UIButton *)sender{
    [self.numField resignFirstResponder];
    if ([_model.stock intValue] == 0) {
        [self.superview makeToast:@"单品已达上限"];
        return;
    }
    int num = [_numField.text intValue];

    if (sender.tag == 111) {
        //减
        if (num > 0) {
            num --;
        }
    }else{
        num ++;
        
        if(num > [_model.stock intValue]){
            [self.superview makeToast:@"单品已达上限"];
            return;
        }
    }
    _numField.text = [NSString stringWithFormat:@"%d",num];
}
-(void)closeAction{
    self.closePopViewBlock();
}
-(void)sureAction{
    self.sureShopBlock(_model.goods_id, _numField.text);
}
-(void)dismissKeyBoard{
    [self.numField resignFirstResponder];
}
#pragma mark - 点击完成
-(void)clickCompleteAction{
    [_numField resignFirstResponder];
    if ([_numField.text intValue] > [_model.stock intValue]) {
        [self makeToast:@"单品已达上限"];
        _numField.text = _model.stock;
    }else{
        self.sureShopBlock(_model.goods_id, _numField.text);
    }
}
#pragma mark - 键盘出现
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat h = self.height - kBack_H;
    CGFloat offsetY = h - keyboardSize.height;
    if (offsetY > 0) {
        return;
    }
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
}
#pragma mark - 键盘隐藏
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.backView.transform = CGAffineTransformIdentity;
    }];
}

@end
