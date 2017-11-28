//
//  PickerAddressCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/21.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface PickerAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property(nonatomic,strong) AddressModel *model;
@end
