//
//  ShopCartHeaderView.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "ShopCartHeaderView.h"

@implementation ShopCartHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.selectBtn = [UIButton new];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_options_box"] forState:0];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_check_box"] forState:UIControlStateSelected];
    [self addSubview:self.selectBtn];
    [self.selectBtn addTarget:self
                       action:@selector(clickSelectBtnAction)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = kFONT_COLOR_1;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    
//    self.editBtn = [UIButton new];
//    [self.editBtn setTitle:@"编辑" forState:0];
//    [self.editBtn setTitleColor:[UIColor blackColor] forState:0];
//    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    self.editBtn.titleLabel.textAlignment = 2;
//    [self addSubview:self.editBtn];
    
    self.selectBtn.sd_layout
    .leftSpaceToView(self, 10)
    .centerYEqualToView(self)
    .widthIs(20)
    .heightIs(20);
    
//    self.editBtn.sd_layout
//    .rightSpaceToView(self, 15)
//    .centerYEqualToView(self)
//    .heightIs(30)
//    .widthIs(50);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.selectBtn, 10)
    .centerYEqualToView(self)
    .rightSpaceToView(self, 10)
    .heightIs(20);
}
-(void)setSection:(NSInteger)section{
    _section = section;
}
-(void)setModel:(ShopCartModel *)model{
    _model = model;
    self.titleLabel.text = _model.edition_text;
    self.selectBtn.selected = _model.allSelect;
}
-(void)clickSelectBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cartHeaderDidSelect:atIndex:)]) {
        [self.delegate cartHeaderDidSelect:self.selectBtn atIndex:_section];
    }
}
@end
