//
//  AddressCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

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
    self.addressLabel.text = address;
    if ([_model.is_default isEqualToString:@"1"]) {
        self.defBtn.selected = YES;
    }else{
        self.defBtn.selected = NO;
    }
}
-(void)setIndex:(NSInteger)index{
    _index = index;
}
- (IBAction)deletAddressAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressCellDeleteAddress:atIndex:)]) {
        //删除地址
        [self.delegate addressCellDeleteAddress:nil atIndex:_index];
    }
}
- (IBAction)editAddressAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressCellEditAddress:atIndex:)]) {
        //编辑地址
        [self.delegate addressCellEditAddress:nil atIndex:_index];
    }
}
- (IBAction)setDefaultAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressCellSetDefaultAddress:atIndex:)]) {
        //设置默认地址
        [self.delegate addressCellSetDefaultAddress:nil atIndex:_index];
    }
}

@end
