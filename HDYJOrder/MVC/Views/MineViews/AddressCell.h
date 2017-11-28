//
//  AddressCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressCellDelegate <NSObject>
-(void)addressCellSetDefaultAddress:(UIButton *)btn atIndex:(NSInteger )index;//设置默认地址
-(void)addressCellEditAddress:(UIButton *)btn atIndex:(NSInteger )index;//编辑地址
-(void)addressCellDeleteAddress:(UIButton *)btn atIndex:(NSInteger )index;//删除地址
@end

@interface AddressCell : UITableViewCell
@property (nonatomic,weak) id<AddressCellDelegate>delegate;
@property (nonatomic,strong) AddressModel *model;
@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *defBtn;

@end
