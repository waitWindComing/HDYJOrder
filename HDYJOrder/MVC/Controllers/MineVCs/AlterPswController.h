//
//  AlterPswController.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "BaseViewController.h"

@interface AlterPswController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *newpwdTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishBtnAction:(id)sender;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendCodeBtnConstraint;
    @property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
- (IBAction)sendCodeBtnAction:(id)sender;
    
@end
