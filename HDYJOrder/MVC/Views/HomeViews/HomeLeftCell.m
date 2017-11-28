//
//  HomeLeftCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "HomeLeftCell.h"

@implementation HomeLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected){
        self.titleLabel.textColor = NAVI_COLOR;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = RGBCOLOR(240, 240, 240);
    }
}
-(void)setModel:(HomeLeftModel *)model{
    _model = model;
    self.titleLabel.text = _model.edition_text;
}
@end
