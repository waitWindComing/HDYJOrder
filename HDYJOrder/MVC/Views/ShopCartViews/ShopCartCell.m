//
//  ShopCartCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "ShopCartCell.h"

@interface ShopCartCell ()
@property (weak, nonatomic) IBOutlet UIView *numView;

@end
@implementation ShopCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertGoodsNum:)];
    [self.numLabel addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCartAddGoods:atIndexPath:)]) {
        [self.delegate shopCartAddGoods:YES atIndexPath:_indexPath];
    }
}
- (IBAction)reduceAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCartAddGoods:atIndexPath:)]) {
        [self.delegate shopCartAddGoods:NO atIndexPath:_indexPath];
    }
    
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
-(void)setModel:(GoodsModel *)model{
    _model = model;
    self.selectBtn.selected = _model.selected;
    [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:_model.image]];
    self.titleLabel.text = _model.goods_name;
    self.numLabel.text = _model.num;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    self.surplusLabel.text = [NSString stringWithFormat:@"还剩%@件",_model.stock];
    NSInteger num = [_model.num integerValue];
    if (num > 0) {
        self.numView.hidden = NO;
    }else{
        self.numView.hidden = YES;
    }

}
- (IBAction)selectAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopCartDidSelect:index:)]) {
        [self.delegate shopCartDidSelect:self.selectBtn index:_indexPath];
    }
}
-(void)alertGoodsNum:(UITapGestureRecognizer *)tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shopCartAlertGoodsNum:atIndexPath:)]){
        [self.delegate shopCartAlertGoodsNum:self.numLabel atIndexPath:_indexPath];
    }
}
@end
