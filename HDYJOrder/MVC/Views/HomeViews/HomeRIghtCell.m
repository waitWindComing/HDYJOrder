//
//  HomeRIghtCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "HomeRIghtCell.h"

@implementation HomeRIghtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (IBAction)addCartAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomeRightCellAddShopCart:withGoods:withIndexPath:)]) {
        [self.delegate HomeRightCellAddShopCart:self
                                      withGoods:self.goodsImgVIew
                                  withIndexPath:self.indexPath];
    }
}
-(void)setModel:(HomeRightModel *)model{
    _model = model;
    self.goodsNameLabel.text = _model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    [self.goodsImgVIew sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    self.surplusLabel.text = [NSString stringWithFormat:@"还剩%@件",_model.stock];
}
@end
