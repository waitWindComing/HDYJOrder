//
//  AddressController.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/13.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AddressController.h"
#import "AddressCell.h"
#import "NewAddressController.h"
#import "AddressModel.h"

static NSString *identifier = @"address_cell";
@interface AddressController ()<UITableViewDelegate,UITableViewDataSource,AddressCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIBarButtonItem *rightItem;
@end

@implementation AddressController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBar];
}
-(void)setNaviBar{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName:[UIColor blackColor]};
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"管理收货地址";
    [self setupSubViews];
    [self loadData];
    
    //刷新通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadData)
                                                name:@"address_refresh"
                                              object:nil];
}
- (void)setupSubViews{
    //set tableview
    self.myTableVIew.backgroundColor = self.view.backgroundColor;
    self.myTableVIew.emptyDataSetSource = self;
    self.myTableVIew.emptyDataSetDelegate = self;
    self.myTableVIew.estimatedRowHeight = 200;
    self.myTableVIew.rowHeight = UITableViewAutomaticDimension;
    
    //regist cell
    [self.myTableVIew registerNib:[UINib
                                   nibWithNibName:@"AddressCell"
                                   bundle:nil]
           forCellReuseIdentifier:identifier];
}
- (void)loadData{
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = user.user_id;
    [LANetworking requestUrl:kAddressList
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             [self.dataArray removeAllObjects];
                             self.dataArray = [AddressModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                         }
                         //判断有无地址
                         if (self.dataArray.count == 0) {
                             self.addBtn.hidden = YES;
                             [self.navigationItem setRightBarButtonItem:self.rightItem];
                         }else{
                             self.addBtn.hidden = NO;
                             [self.navigationItem setRightBarButtonItem:nil];
                         }
                         [self.myTableVIew reloadData];
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - DZN_Delegate
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -70;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    //空白页显示图片
    return [UIImage imageNamed:@"icon_shipping_address"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    //空白页描述
    NSString *text = @"请添加收货地址";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGBCOLOR(140, 140, 140),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    //调整组件间距
    return 19.0f;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}

#pragma mark - addressCell_delegate
-(void)addressCellSetDefaultAddress:(UIButton *)btn atIndex:(NSInteger)index{
    //设置默认地址
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = user.user_id;
    params[@"aid"] = [self.dataArray[index] address_id];
    //request
    [LANetworking requestUrl:kEditDefalut
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *coede = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([coede isEqualToString:@"0"]) {
                             [self.view makeToast:dic[@"message"]];
                         }
                         [self loadData];
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
-(void)addressCellEditAddress:(UIButton *)btn atIndex:(NSInteger)index{
    //编辑地址
    AddressModel *model = self.dataArray[index];
    NewAddressController *vc = [NewAddressController new];
    vc.aid = model.address_id;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}
-(void)addressCellDeleteAddress:(UIButton *)btn atIndex:(NSInteger)index{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定删除此地址?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除地址
        //get uid
        UserModel *user = GET_USERMSG();
        //params
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uid"] = user.user_id;
        params[@"aid"] = [self.dataArray[index] address_id];
        //request
        [LANetworking requestUrl:kDeladdress
                          params:params
                     showLoading:YES
                      controller:nil
                         success:^(id responseObject) {
                             NSDictionary *dic = responseObject;
                             NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                             if ([code isEqualToString:@"0"]) {
                                 
                                 [self.view makeToast:dic[@"message"]];
                                 [self.dataArray removeObjectAtIndex:index];
                                 [self.myTableVIew reloadData];
                             }
                             //判断地址列表是否为空
                             if (self.dataArray.count == 0) {
                                 self.addBtn.hidden = YES;
                                 [self.navigationItem setRightBarButtonItem:self.rightItem];
                                 
                             }else{
                                 self.addBtn.hidden = NO;
                                 [self.navigationItem setRightBarButtonItem:nil];
                                 
                             }
                             
                         }
                         failure:^(NSError *error) {
                             
                         }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:sure];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC
                       animated:YES
                     completion:NULL];
    
}
#pragma mark - 新增收货地址
- (IBAction)newAddressAction:(UIButton *)sender {
    [self.navigationController pushViewController:[NewAddressController new]
                                         animated:YES];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"新增" forState:0];
        [btn setTitleColor:NAVI_COLOR forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(20, 0, 44, 44);
        btn.titleLabel.textAlignment = 2;
        [btn addTarget:self
                action:@selector(newAddressAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 54, 44)];
        [view addSubview:btn];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    }
    return _rightItem;
}
@end
