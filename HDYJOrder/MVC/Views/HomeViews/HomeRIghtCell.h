//
//  HomeRIghtCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRightModel.h"
@class HomeRIghtCell;

@protocol HomeRightCellDelegate <NSObject>

@optional
-(void)HomeRightCellAddShopCart:(HomeRIghtCell *)cell withGoods:(UIImageView *)goods withIndexPath:(NSIndexPath *)indexPath;
@end

@interface HomeRIghtCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) HomeRightModel *model;
@property (nonatomic,weak) id<HomeRightCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgVIew;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;

@end
