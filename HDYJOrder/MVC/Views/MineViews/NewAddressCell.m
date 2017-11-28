//
//  NewAddressCell.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "NewAddressCell.h"

@implementation NewAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.contentField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress:)];
    [self.contentLabel addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (_index == 2) {
        self.contentLabel.hidden = NO;
        self.contentField.hidden = YES;
        self.textView.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(_index == 3){
        self.contentLabel.hidden = YES;
        self.contentField.hidden = YES;
        self.textView.hidden = NO;
    }else{
        self.contentLabel.hidden = YES;
        self.contentField.hidden = NO;
        self.textView.hidden = YES;
    }
}
-(void)selectAddress:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newAddressCellPickerAddress:withModel:)]) {
        [self.delegate newAddressCellPickerAddress:self.contentLabel withModel:_model];
    }
}
-(void)setModel:(NewAddressModel *)model{
    _model = model;
    //placeholder
    if (_index == 2) {
        self.contentLabel.text = _model.placeHolder;
    }else{
        self.contentField.placeholder = _model.placeHolder;
    }
    //text
    if (_model.text.length > 0) {
        if (_index == 2) {
            self.contentLabel.text = [_model.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        }else if(_index == 3){
            self.textView.text = _model.text;
            [self textView:self.textView
   shouldChangeTextInRange:NSMakeRange(0, _model.text.length)
           replacementText:model.text];
        }else{
            self.contentField.text = _model.text;
        }
        
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _model.text = self.contentField.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _model.text = self.textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UILabel *label = [textView viewWithTag:1122];
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        label.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        label.hidden = NO;
    }
    return YES;
    
}
@end
