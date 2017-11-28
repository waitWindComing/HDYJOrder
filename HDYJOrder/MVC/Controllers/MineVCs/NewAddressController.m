//
//  NewAddressController.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "NewAddressController.h"
#import "NewAddressCell.h"
#import "NewAddressModel.h"
#import "AddressPickerVIew.h"
#import "ShopCartModel.h"

static NSString *identifier = @"newAddress_cell";
#define kPICKER_HEIGHT 250
@interface NewAddressController ()<UITableViewDelegate,UITableViewDataSource,newAddressCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) AddressPickerVIew *pickerView;
@end

@implementation NewAddressController
-(void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)setAid:(NSString *)aid{
    _aid = aid;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubViews];
    if (_aid) {
        self.title = @"编辑收货地址";
        [self loadData];
    }else{
        self.title = @"新增收货地址";
    }
    
}
-(void)setupSubViews{
    self.myTableView.tableFooterView.backgroundColor =
    self.myTableView.backgroundColor =
    self.view.backgroundColor;
    //regist cell
    [self.myTableView registerNib:[UINib
                                   nibWithNibName:@"NewAddressCell"
                                   bundle:nil]
           forCellReuseIdentifier:identifier];
   
}
-(void)loadData{
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aid"] = _aid;
    params[@"uid"] = user.user_id;
    //request
    [LANetworking requestUrl:kGetaddress
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             NSString *address = dic[@"data"][@"address"];
                             NSArray *array = [address componentsSeparatedByString:@","];
                             for (int i = 0; i < self.dataArray.count; i++) {
                                 NewAddressModel *model = self.dataArray[i];
                                 switch (i) {
                                     case 0:
                                         //姓名
                                         model.text = dic[@"data"][@"name"];
                                         break;
                                     case 1:
                                         //电话
                                         model.text = dic[@"data"][@"mobile"];
                                         break;
                                     case 2:
                                         //省市区
                                         model.text = [NSString stringWithFormat:@"%@,%@,%@",array[0],array[1],array[2]];
                                         break;
                                     case 3:
                                         //详细地址
                                         model.text = array.lastObject;
                                         break;
                                     default:
                                         break;
                                 }
                             }
                         }
                         [self.myTableView reloadData];
                     } 
                     failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - Tableview_datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == self.dataArray.count - 1 ? 70 : 50;
}
#pragma mark - 选择省市区
-(void)newAddressCellPickerAddress:(UILabel *)contentLabel withModel:(NewAddressModel *)model{
    //结束编辑状态
    [self.view endEditing:YES];
    
    [[UIApplication sharedApplication].windows[0] addSubview:self.pickerView];
    CGRect rec = self.pickerView.frame;
    rec.origin.y = kScreenHeight - kPICKER_HEIGHT;
    
    [UIView animateWithDuration:.25 animations:^{
        self.maskView.alpha = 0.7;
        self.pickerView.frame = rec;
        
    } completion:^(BOOL finished) {
        
    }];
    //picker
    __weak typeof(self)weakSelf = self;
    self.pickerView.sureBlock = ^(NSString *str1, NSString *str2, NSString *str3) {
        model.text = [NSString stringWithFormat:@"%@,%@,%@",str1,str2,str3];
        contentLabel.text = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        [weakSelf closePicker:nil];
    };
    self.pickerView.closeBlock = ^{
        [weakSelf closePicker:nil];
    };
}
#pragma mark - 保存地址
- (IBAction)saveAddressAction:(UIButton *)sender {
    [self.view endEditing:YES];

    NewAddressModel *model1 = self.dataArray[0];
    if (!model1.text || model1.text.length == 0) {
        [self.view makeToast:@"请输入收货人姓名"];
        return;
    }
    NewAddressModel *model2 = self.dataArray[1];
    if (!model2.text || model2.text.length != 11) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    NewAddressModel *model3 = self.dataArray[2];
    if (!model3.text || model3.text.length == 0) {
        [self.view makeToast:@"请选择收货地址"];
        return;
    }
    NewAddressModel *model4 = self.dataArray[3];
    if (!model4.text || model4.text.length == 0) {
        [self.view makeToast:@"请填写详细收货地址"];
        return;
    }
    NSString *str1 = [self.dataArray[2] text];
    NSString *str2 = [self.dataArray.lastObject text];
    NSString *address = [NSString stringWithFormat:@"%@,%@",str1,str2];
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address"] = address;
    params[@"uid"] = user.user_id;
    params[@"name"] = [self.dataArray.firstObject text];
    params[@"mobile"] = [self.dataArray[1] text];
    if (_aid) {
        //编辑地址
        params[@"aid"] = _aid;
    }
    //request
    [LANetworking requestUrl:kAddress
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             
                             if (self.goodsArray.count > 0) {
                                 //生成订单
                                 NSString *aid = [NSString stringWithFormat:@"%@",dic[@"data"][@"id"]];
                                 [self setupOrder:aid];
                             }else{
                                 [self.view makeToast:dic[@"message"]];
                                 //编辑成功,通知列表页刷新
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"address_refresh" object:nil];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 });
                             }
                             
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - 订单生成
-(void)setupOrder:(NSString *)aid{
    //模型转数组
    NSArray *array = [GoodsModel mj_keyValuesArrayWithObjectArray:self.goodsArray];
    NSDictionary *dict = @{@"product":array};
    NSError *error = nil;
    //转json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"product"] = jsonString;
    params[@"uid"] = user.user_id;
    params[@"address_id"] = aid;
    //request
    [LANetworking requestUrl:kAdd
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code= [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             [self.view makeToast:dic[@"message"]];
                             //结算成功通知购物车刷新
                             self.paymentSucceedBlock();
                            
                             //修改购物车商品数量
                             UserModel *user = GET_USERMSG();
                             NSString *count = user.carcount;
                             user.carcount = [NSString stringWithFormat:@"%lu",[count intValue] - array.count];
                             UPDATA_CARTCOUNT(user.carcount);
                             SAVE_USERMSG(user);
                             
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 //下单成功,跳至订单页
                                 self.tabBarController.selectedIndex = 1;
                                 [self.navigationController popViewControllerAnimated:NO];
                             });
                             
                         }
                         
                     }
                     failure:^(NSError *error) {
                         
                     }];
    
}
#pragma mark - 关闭选择器
-(void)closePicker:(UITapGestureRecognizer *)tap{
    CGRect rec = self.pickerView.frame;
    rec.origin.y = kScreenHeight;
    
    [UIView animateWithDuration:.25 animations:^{
        
        self.pickerView.frame = rec;
        self.maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@"收货人姓名",
                           @"手机号码",
                           @"省/市/区",
                           @"详细地址"];
        for (int i = 0; i < array.count; i++) {
            NewAddressModel *model = [NewAddressModel new];
            model.placeHolder = array[i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _maskView.alpha = 0;
        _maskView.userInteractionEnabled = YES;
        [self.view addSubview:_maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker:)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}
-(AddressPickerVIew *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerVIew alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPICKER_HEIGHT)];
        
    }
    return _pickerView;
}
@end

