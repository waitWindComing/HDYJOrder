//
//  PickerAddressCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/21.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "PickerAddressCell.h"
#import "NSString+Common.h"

@implementation PickerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(AddressModel *)model{
    _model = model;
    self.nameLabel.text = _model.name;
    self.mobileLabel.text = _model.mobile;
    NSArray *array = [_model.address componentsSeparatedByString:@","];
    NSString *address = @"";
    for (int i = 0; i<array.count; i++) {
        address = [NSString stringWithFormat:@"%@%@",address,array[i]];
    }
    if ([_model.is_default isEqualToString:@"1"]) {
        address = [NSString stringWithFormat:@"[默认地址]%@",address];
        self.addressLabel.attributedText = [NSString getAttriWith:address];
    }else{
        self.addressLabel.text = address;
    }
   
}
@end
