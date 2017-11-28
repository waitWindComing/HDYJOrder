//
//  ShopCartHeaderView.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"

@protocol CartHeaderDelegate <NSObject>
- (void)cartHeaderDidSelect:(UIButton *)btn atIndex:(NSInteger)section;
@end
@interface ShopCartHeaderView : UITableViewHeaderFooterView
@property(nonatomic,weak) id<CartHeaderDelegate>delegate;
@property(nonatomic,assign) NSInteger section;
@property(nonatomic,strong) ShopCartModel *model;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *editBtn;
@end
