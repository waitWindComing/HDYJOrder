//
//  MineController.m
//  Demo
//
//  Created by libertyAir on 2017/11/13.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "MineController.h"
#import "MineCell.h"
#import <objc/runtime.h>
#import "LogInController.h"
#import "MineHeader.h"

static NSString *identifier = @"mine_cell";
#define kHEIGHT kScreenWidth * 0.45
@interface MineController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) MineHeader *header;
@end

@implementation MineController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    //设置用户名和头像
    UserModel *user = GET_USERMSG();
    self.header.nameLabel.text = user.username;
    self.header.iconView.image = [UIImage imageNamed:@"avatar"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubViews];

}
-(void)setupSubViews{
    //set tableview
    self.myTableview.rowHeight = 48;
    self.myTableview.backgroundColor = self.view.backgroundColor;
    self.myTableview.contentInset = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
    
    [self.myTableview addSubview:self.header];
    //ios 11
    if (@available(iOS 11, *)) {
        self.myTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.myTableview registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:identifier];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == self.titles.count - 1) {
        cell.accessoryType = NO;
    }
    cell.titleLabel.text = self.titles[indexPath.row][@"title"];
    cell.iconVIew.image = [UIImage imageNamed:self.titles[indexPath.row][@"icon"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == self.titles.count - 1){
        //退出登录
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LogInController *logInVC = [LogInController new];
            [self presentViewController:logInVC
                               animated:YES
                             completion:^{
                                 self.tabBarController.selectedIndex = 0;
                                 //清除用户信息
                                 SAVE_USERMSG([UserModel new]);
                                 //清除token
                                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hdyj_token"];
                             }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sure];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC
                           animated:YES
                         completion:NULL];
    }else{
        NSString *vcName = self.titles[indexPath.row][@"vcName"];
        Class classVC = objc_getClass([vcName UTF8String]);
        UIViewController *vc = (UIViewController *)[classVC new];
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -kHEIGHT) {
        CGRect rect =self.header.frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        self.header.frame = rect;
    }else{
        
    }
}
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@{@"title":@"修改密码",
                        @"vcName":@"AlterPswController",
                        @"icon":@"icon_modify-password"},
                      @{@"title":@"收货地址",
                        @"vcName":@"AddressController",
                        @"icon":@"icon_receiving-address"},
                      @{@"title":@"历史订单",
                        @"vcName":@"",
                        @"icon":@"icon_order"},
                      @{@"title":@"退出登录",
                        @"vcName":@"",
                        @"icon":@"signout"}];
    }
    return _titles;
}
-(MineHeader *)header{
    if (!_header) {
        _header = [[MineHeader alloc]initWithFrame:CGRectMake(0, -kHEIGHT, kScreenWidth, kHEIGHT)];
        _header.backgroundColor = [UIColor whiteColor];
    }
    return _header;
}
@end
