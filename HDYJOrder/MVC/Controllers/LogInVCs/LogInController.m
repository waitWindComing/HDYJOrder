//
//  LogInController.m
//  Demo
//
//  Created by libertyAir on 2017/11/9.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "LogInController.h"

@interface LogInController () <UITextFieldDelegate>
{
    NSInteger _index;
    int _second;
    NSString *_code;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
- (IBAction)codeLoginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LogInController

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //set field
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc]initWithString:self.userNameField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:0.3]}];
    self.userNameField.attributedPlaceholder = attri1;
    NSMutableAttributedString *attri2 = [[NSMutableAttributedString alloc]initWithString:self.pswField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:0.3]}];
    self.pswField.attributedPlaceholder = attri2;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = NAVI_COLOR;
    self.title = @"登录";
    
    self.userNameField.delegate = self;
    self.pswField.delegate = self;
    
    //init
    _second = 60;
    _index = 0;
    _codeBtnWidth.constant = 0;
    self.loginBtn.enabled = NO;
    [self.userNameField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pswField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

}
- (void)textFieldTextChange:(UITextField *)textField {
    if (self.userNameField.text.length > 0 && self.pswField.text.length > 0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = RGBCOLOR(132, 206, 255);
        [self.loginBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:104/255.0 blue:149/255.0 alpha:1] forState:UIControlStateNormal];
    }else {
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.loginBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
    }
    
}


//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)logInAction:(id)sender {
    [self.view endEditing:YES];
    
    if (_index == 0) {
        [self userNameLogIn];
    }else{
        [self phoneCodeLogin];
    }
}
- (IBAction)codeLoginBtnAction:(id)sender {
    _index = !_index;
    self.userNameField.text = nil;
    self.pswField.text = nil;
    [self.view endEditing:YES];
    self.loginBtn.enabled = NO;
    
    self.loginBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.loginBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
    
    if (_index == 1) {
        [self.codeLoginBtn setTitle:@"账号登录" forState:0];
        self.userNameField.placeholder = @"请输入手机号";
        self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
        self.pswField.placeholder = @"请输入验证码";
        _codeBtnWidth.constant = 81;
        self.sendCodeBtn.backgroundColor = [UIColor colorWithRed:132/255.0 green:206/255.0 blue:255/255.0 alpha:1];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:104/255.0 blue:149/255.0 alpha:1] forState:0];
        self.view.backgroundColor = [UIColor colorWithRed:65/255.0 green:175/255.0 blue:253/255.0 alpha:1];
        self.pswField.keyboardType = UIKeyboardTypeNumberPad;

    }else{
        [self.codeLoginBtn setTitle:@"验证码登录" forState:0];
        self.userNameField.placeholder = @"请输入用户名/手机号";
        self.pswField.placeholder = @"请输入密码";
        _codeBtnWidth.constant = 0;
        self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:168/255.0 blue:253/255.0 alpha:1];
        self.pswField.keyboardType = UIKeyboardTypeDefault;

        
    }
}
#pragma mark - 手机动态码登录
- (void)phoneCodeLogin{
    //username
    NSString *userName = self.userNameField.text;
    NSString *pwd = self.pswField.text;
    if (userName.length != 11) {
        [self.view makeToast:@"请输入正确手机号!"];
        return;
    }
    if (pwd.length == 0) {
        [self.view makeToast:@"请输入动态密码!"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = userName;
    params[@"code"] = pwd;
    [LANetworking requestUrl:kLogincode
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             //储存用户信息
                             UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"data"]];
                             SAVE_USERMSG(user);
                             //登陆成功,通知首页刷新
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"refush_homeVC" object:nil];
                             [self dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          
                                                      }];
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - 账号登录
-(void)userNameLogIn{
    NSString *userName = self.userNameField.text;
    NSString *pwd = self.pswField.text;
    if (userName.length == 0) {
        [self.view makeToast:@"请输入用户名/手机号!"];
        return;
    }
    if (pwd.length == 0) {
        [self.view makeToast:@"请输入密码!"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = userName;
    params[@"password"] = pwd;
    [LANetworking requestUrl:kLogin
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             //储存用户信息
                             UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"data"]];
                             
                             SAVE_USERMSG(user);
                             //登陆成功,通知首页刷新
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"refush_homeVC" object:nil];
                             [self dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          
                                                      }];
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
- (IBAction)SendCodeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *mobile = self.userNameField.text;
    if (mobile.length != 11) {
        [self.view makeToast:@"请输入正确的手机号!"];
        return;
    }    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    //params[@"token"] = token;
    //发送动态密码
    [LANetworking requestUrl:kSendlogin
                      params:params
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
        self.sendCodeBtn.backgroundColor = [UIColor colorWithRed:132/255.0 green:206/255.0 blue:255/255.0 alpha:1];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithRed:25/255.0 green:104/255.0 blue:149/255.0 alpha:1] forState:0];
        [self.sendCodeBtn setTitle:@"发送验证码" forState:0];
    }else{
        _second--;
        self.sendCodeBtn.enabled = NO;
        self.sendCodeBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:0];
        
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds",_second] forState:0];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

@end
