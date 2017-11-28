//
//  NewAddressCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewAddressModel.h"

@protocol newAddressCellDelegate <NSObject>
-(void)newAddressCellPickerAddress:(UILabel *)contentLabel withModel:(NewAddressModel *)model;
@end

@interface NewAddressCell : UITableViewCell<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,weak) id<newAddressCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@property(nonatomic,strong) NewAddressModel *model;
@property(nonatomic,assign) NSInteger index;
@end
