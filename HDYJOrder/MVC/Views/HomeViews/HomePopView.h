//
//  HomePopView.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/17.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRightModel.h"
@interface HomePopView : UIView
@property(nonatomic,copy) void(^closePopViewBlock)(void);//关闭popview
@property(nonatomic,copy) void(^sureShopBlock)(NSString *goodsId,NSString *num);//确定
@property(nonatomic,strong) HomeRightModel *model;

@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIImageView *goodsImgView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *priceLabel;
@property(nonatomic,strong) UILabel *surplusLabel;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UITextField *numField;
@end
