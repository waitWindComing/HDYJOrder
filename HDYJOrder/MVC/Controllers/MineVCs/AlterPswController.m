//
//  AlterPswController.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AlterPswController.h"
#import "LogInController.h"

@interface AlterPswController ()
{
    int _second;
}
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AlterPswController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName:[UIColor blackColor]};

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    self.newpwdTF.text = @"";
    self.codeTF.text = @"";
    if (GET_USERMSG().mobile.length == 11) {
        NSString *sufStr = [GET_USERMSG().mobile substringFromIndex:7];
        NSString *preStr = [GET_USERMSG().mobile substringToIndex:3];
        self.mobileLabel.text = [NSString stringWithFormat:@"已绑定手机号: %@****%@", preStr, sufStr];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _second = 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)finishBtnAction:(id)sender {
    
    [LANetworking requestUrl:kEditpassword
                      params:[@{@"mobile": GET_USERMSG().mobile, @"code":self.codeTF.text, @"password":self.newpwdTF.text} mutableCopy]
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         if ([responseObject[@"code"] integerValue] != 0) {
                             return;
                         }
                         [self.view makeToast:responseObject[@"message"]];
                         UserModel *user = GET_USERMSG();
                         user.pwd = self.newpwdTF.text;
                         SAVE_USERMSG(user);
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self.navigationController popViewControllerAnimated:YES];
                         });
                         
    } failure:^(NSError *error) {

    }];
}
- (IBAction)sendCodeBtnAction:(id)sender {
    [self.view endEditing:YES];
    UserModel *model = GET_USERMSG();
    //发送动态密码
    [LANetworking requestUrl:kSendpwd
                      params:[@{@"mobile": model.mobile} mutableCopy]
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             //发送动态密码
                             self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
    
    
}

- (void) countDownAction {
    if (_second == 0) {
        _second = 60;
        [self.timer invalidate];
        self.sendCodeBtn.enabled = YES;
        self.sendCodeBtn.backgroundColor = [UIColor colorWithRed:28/255.0 green:168/255.0 blue:253/255.0 alpha:1];
        [self.sendCodeBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.sendCodeBtn setTitle:@"发送验证码" forState:0];
    }else{
        _second--;
        self.sendCodeBtn.enabled = NO;
        self.sendCodeBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:0];
        
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds",_second] forState:0];
    }
}



@end
