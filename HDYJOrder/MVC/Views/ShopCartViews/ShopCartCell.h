//
//  ShopCartCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"
@class ShopCartCell;

@protocol ShopCartCellDelegate <NSObject>
//选择商品
-(void)shopCartDidSelect:(UIButton *)btn index:(NSIndexPath *)indexPath;

//加减商品
-(void)shopCartAddGoods:(BOOL)isAdd atIndexPath:(NSIndexPath *)indexPath;
//修改商品数量
-(void)shopCartAlertGoodsNum:(UILabel *)label atIndexPath:(NSIndexPath *)indexPath;
@end
@interface ShopCartCell : UITableViewCell
@property(nonatomic,weak) id<ShopCartCellDelegate>delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic,strong) GoodsModel *model;
@end
