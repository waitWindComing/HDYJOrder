//
//  ShopCartController.m
//  Demo
//
//  Created by libertyAir on 2017/11/13.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "ShopCartController.h"
#import "ShopCartCell.h"
#import "ShopCartHeaderView.h"
#import "ShopCartModel.h"
#import "PickerAddressView.h"
#import "AlertNumView.h"
#import "AddressModel.h"
#import "NewAddressController.h"

static NSString *identifier = @"shopcart_cell";
static NSString *identifier_header = @"cart_header";
#define kPicker_H 341
@interface ShopCartController ()<UITableViewDelegate,UITableViewDataSource,ShopCartCellDelegate,CartHeaderDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *goodsArray;//已勾选商品
@property(nonatomic,strong) PickerAddressView *pickerView;
@property (nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) AlertNumView *alertView;
@end

@implementation ShopCartController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:NAVI_COLOR];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"购物车";
    [self setupSubViews];
    //刷新购物车
    [self updataCart];
    
    //通知:接收刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataCart) name:@"refrush_cart" object:nil];
}

-(void)updataCart{
    self.allSelectBtn.selected = NO;
    [self.goodsArray removeAllObjects];
    [self loadData];
    [self updataCartData];
}
- (void)setupSubViews{
    self.myTableVIew.backgroundColor = self.view.backgroundColor;
    self.myTableVIew.emptyDataSetSource = self;
    self.myTableVIew.emptyDataSetDelegate = self;
    self.myTableVIew.rowHeight = 96;
    //regist cell
    [self.myTableVIew registerNib:[UINib
                                   nibWithNibName:@"ShopCartCell"
                                   bundle:nil]
           forCellReuseIdentifier:identifier];
}
- (void)loadData{
    //get uid
    UserModel *user = GET_USERMSG();
    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = user.user_id;
    [LANetworking requestUrl:kCartList
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             self.dataArray = [ShopCartModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"cat"]];
                             if (self.dataArray.count > 0) {
                                 self.bottomView.hidden = NO;
                             }else{
                                 self.bottomView.hidden = YES;
                             }
                         }
                         [self.myTableVIew reloadData];
                     }
                     failure:^(NSError *error) {
                         self.bottomView.hidden = YES;
                     }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShopCartModel *model = self.dataArray[section];
    return [model data].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    ShopCartModel *model = self.dataArray[indexPath.section];
    cell.model = model.data[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShopCartHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier_header];
    if(!header){
        header = [[ShopCartHeaderView alloc]initWithReuseIdentifier:identifier_header];
    }
    header.delegate = self;
    header.section = section;
    header.model = self.dataArray[section];
    return header;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该商品吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //确认删除
            [self deleteGoodsAction:indexPath];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        [alertVC addAction:sure];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:NULL];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - DZN_Delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    //空白页显示图片
    return [UIImage imageNamed:@"shopping_cart"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    //空白页描述
    NSString *text = @"购物车空空如也";
    
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
    return 25.0f;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -70;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}

#pragma mark - ShopCart_delgate
-(void)shopCartAddGoods:(BOOL)isAdd atIndexPath:(NSIndexPath *)indexPath{
    ShopCartModel *mode = self.dataArray[indexPath.section];
    GoodsModel *goods = mode.data[indexPath.row];
    int num = [goods.num intValue];
    int current = num;
    if(isAdd){
        //判断库存
        if(current == [goods.stock intValue]){
            [self.view makeToast:@"对不起,库存不足!"];
            return;
        }
        //加商品
        current = num + 1;
    }else{
        //减商品
        current = num - 1;
        if (current == 0) {
            //删除该商品
            [self deleteGoodsAction:indexPath];
            return;
        }
    }
    goods.num = [NSString stringWithFormat:@"%d",current];
    //模型转字典
    //NSDictionary *dict = goods.mj_keyValues;
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSError *error = nil;
    NSDictionary *dict = @{@"product":@[@{@"id":goods.goods_id,
                                          @"num":goods.num
                                          }]};
    //转json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"product"]=jsonString;
    params[@"uid"] = user.user_id;
    params[@"type"] = @"cat";
    //request
    [LANetworking requestUrl:kAddCart
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"] || [code isEqualToString:@"4"]) {
                             //刷新当前row
                             [self.myTableVIew reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             //刷新商品总价
                             [self updataCartData];
                         }else if ([code isEqualToString:@"3"]){
                             //库存改变处理
                             NSString *newNum = [NSString stringWithFormat:@"%@",dic[@"data"][@"num"]];;
                             goods.num = newNum;
                             [self.myTableVIew reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                         }else{
                             goods.num = [NSString stringWithFormat:@"%d",num];
                         }
                     }
                     failure:^(NSError *error) {
                         goods.num = [NSString stringWithFormat:@"%d",num];
                     }];
}
#pragma mark - 删除商品
-(void)deleteGoodsAction:(NSIndexPath *)indexPath{
    ShopCartModel *mode = self.dataArray[indexPath.section];
    GoodsModel *goods = mode.data[indexPath.row];
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = goods.goods_id;
    params[@"uid"] = user.user_id;
    //request
    [LANetworking requestUrl:kDelCat
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             //删除该商品
                             [mode.data removeObject:goods];
                             if (mode.data.count == 0) {
                                 [self.dataArray removeObject:self.dataArray[indexPath.section]];
                                 //判断购物车是否为空
                                 if (self.dataArray.count > 0) {
                                     self.bottomView.hidden = NO;
                                 }else{
                                     self.bottomView.hidden = YES;
                                 }
                             }
                             [self.goodsArray removeObject:goods];
                             //刷新商品总价
                             [self updataCartData];
                             [self.myTableVIew reloadData];
                             
                             //修改购物车商品数量
                             UserModel *user = GET_USERMSG();
                             NSString *count = user.carcount;
                             user.carcount = [NSString stringWithFormat:@"%d",[count intValue] - 1];
                             UPDATA_CARTCOUNT(user.carcount);
                             SAVE_USERMSG(user);
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
-(void)shopCartDidSelect:(UIButton *)btn index:(NSIndexPath *)indexPath{
    ShopCartModel *model = self.dataArray[indexPath.section];
    GoodsModel *gModel = model.data[indexPath.row];
    gModel.selected = !gModel.selected;
    btn.selected = gModel.selected;
    //已选中商品
    if (gModel.selected) {
        if (![self.goodsArray containsObject:gModel]) {
            [self.goodsArray addObject:gModel];
        }
    }else{
        [self.goodsArray removeObject:gModel];
    }
    
    //刷新版本的选中状态
    for (GoodsModel *goods in model.data) {
        if (!goods.selected) {
            model.allSelect = NO;
            break;
        }
        model.allSelect= YES;
    }
    //更新全选btn的状态
    [self updataAllSelectBtnAction:gModel.selected];
    //刷新商品总价
    [self updataCartData];
    
    [self.myTableVIew reloadSections:[NSIndexSet
                                      indexSetWithIndex:indexPath.section]
                    withRowAnimation:UITableViewRowAnimationNone];
}
-(void)shopCartAlertGoodsNum:(UILabel *)label atIndexPath:(NSIndexPath *)indexPath{
    //修改购物车数量
     _alertView = [[AlertNumView alloc]initWithFrame:CGRectMake(0, 0, 316, 181)];
    [_alertView showAnimated:YES];
    
    ShopCartModel *model = self.dataArray[indexPath.section];
    GoodsModel *goods = model.data[indexPath.row];
    _alertView.numField.text = goods.num;
    
    WeakSelf(self);
    _alertView.alertBlock = ^(NSString *num) {
        //编辑购物车数量
        [weakself alertCartNum:num atIndexPath:indexPath];
    };
  
}
-(void)alertCartNum:(NSString *)num atIndexPath:(NSIndexPath *)indexPath{
    ShopCartModel *model = self.dataArray[indexPath.section];
    GoodsModel *goods = model.data[indexPath.row];
    //get uid
    UserModel *user = GET_USERMSG();
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSError *error = nil;
    
    NSDictionary *dict = @{@"product":@[@{@"id":goods.goods_id,
                                          @"num":num
                                          }]};
    //转json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"product"]=jsonString;
    params[@"uid"] = user.user_id;
    params[@"type"] = @"cat";
    
    //request
    [LANetworking requestUrl:kAddCart
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"] || [code isEqualToString:@"4"]) {
                             [self.view makeToast:dic[@"message"]];
                             goods.num = num;
                             //数量修改成功,刷新cell
                             [self.myTableVIew reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                         }else if ([code isEqualToString:@"3"]){
                             [self.view makeToast:dic[@"message"]];
                             NSString *newNum = [NSString stringWithFormat:@"%@",dic[@"data"][@"num"]];
                             goods.num = newNum;
                             //超出库存,添加最大数量
                             [self.myTableVIew reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - ShopCartHeader_delegate
-(void)cartHeaderDidSelect:(UIButton *)btn atIndex:(NSInteger)section{
    ShopCartModel *model = self.dataArray[section];
    model.allSelect = !model.allSelect;

    for (GoodsModel *goods in model.data) {
        //修改版本下商品的选中状态
        goods.selected = model.allSelect;
        if (goods.selected) {
            if (![self.goodsArray containsObject:goods]) {
                [self.goodsArray addObject:goods];
            }
        }else{
            [self.goodsArray removeObject:goods];
        }
    }
    //更新全选btn的状态
    [self updataAllSelectBtnAction:model.allSelect];
    //刷新商品总价
    [self updataCartData];
    //刷新操作组
    [self.myTableVIew reloadSections:[NSIndexSet
                                      indexSetWithIndex:section]
                    withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 全选
- (IBAction)allSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    //清空已选中商品集合
    [self.goodsArray removeAllObjects];

    for (ShopCartModel *model in self.dataArray) {
        model.allSelect = sender.selected;
        for (GoodsModel *goods in model.data) {
            //修改版本下商品的选中状态
            goods.selected = model.allSelect;
            //修改已选中商品集合
            if(model.allSelect){
                [self.goodsArray addObject:goods];
            }
        }
        
    }
    //刷新商品总价
    [self updataCartData];
    //刷新tableview
    [self.myTableVIew reloadData];
}

#pragma mark - 更新全选btn选中状态
-(void)updataAllSelectBtnAction:(BOOL)isSelect{
    NSInteger num = 0;
    if(isSelect){
        for (ShopCartModel *model in self.dataArray) {
            num = model.data.count + num;
        }
        if (num == self.goodsArray.count) {
            self.allSelectBtn.selected = YES;
        }else{
            self.allSelectBtn.selected = NO;
        }
    }else{
        self.allSelectBtn.selected = NO;
    }
}
- (IBAction)allSelectBtn:(UIButton *)sender {
    self.allSelectBtn.selected = !self.allSelectBtn.selected;
    [self allSelectAction:sender];
    [self updataAllSelectBtnAction:self.allSelectBtn.selected];
}
#pragma mark - 更新总价和数量
-(void)updataCartData{
    if (self.goodsArray.count == 0) {
        self.accountBtn.backgroundColor = RGBCOLOR(220, 220, 220);
        [self.accountBtn setTitleColor:RGBCOLOR(140, 140, 140) forState:0];
    }else{
        self.accountBtn.backgroundColor = RGBCOLOR(255, 164, 0);
        [self.accountBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    [self.accountBtn setTitle:[NSString stringWithFormat:@"结算(%ld)",self.goodsArray.count] forState:0];
    float money = 0.f;
    for (GoodsModel *goods in self.goodsArray) {
        //计算选中商品总价
        money = [goods.price floatValue]*[goods.num intValue] + money;
    }
    //用户折扣
    UserModel *user = GET_USERMSG();
    money = money * [user.level intValue]/100;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",money];
}
#pragma mark - 去结算
- (IBAction)payAccountAction:(UIButton *)sender {
    if(self.goodsArray.count == 0){
        [self.view makeToast:@"请先选择商品!"];
        return;
    }
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
                             NSArray *array = [AddressModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                             //地址列表请求成功
                             [self selectAddressReback:array];
                         }else if([code isEqualToString:@"1"]){
                             //添加地址
                             NewAddressController *vc = [NewAddressController new];
                             vc.goodsArray = self.goodsArray;
                             WeakSelf(self)
                             vc.paymentSucceedBlock = ^{
                                 [weakself loadData];
                                 [weakself.goodsArray removeAllObjects];
                                 [weakself updataCartData];
                             };
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                         
                     }
                     failure:^(NSError *error) {
                         
                     }];
   
    
}
#pragma mark - 选择地址回调
-(void)selectAddressReback:(NSArray *)array{
    if(array.count == 0){
        //添加地址
        NewAddressController *vc = [NewAddressController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //set datasource
    self.pickerView.dataArray = array;
    //popView加载到window上
    [[UIApplication sharedApplication].windows[0] addSubview:self.pickerView];
    CGRect rec = self.pickerView.frame;
    rec.origin.y = kScreenHeight - kPicker_H;
    
    [UIView animateWithDuration:.25 animations:^{
        self.maskView.alpha = 0.7;
        self.pickerView.frame = rec;
        
    } completion:NULL];
    
    WeakSelf(self);
    self.pickerView.selectBlock = ^(NSString *aid) {
        [weakself setupOrder:aid];
    };
    
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
                             [self closePicker];
                             [self.view makeToast:dic[@"message"]];
                             //下单成功,清空购物车
                             [self.goodsArray removeAllObjects];
                             [self updataCartData];
                             [self loadData];
                             
                             
                             //修改购物车商品数量
                             UserModel *user = GET_USERMSG();
                             NSString *count = user.carcount;
                             user.carcount = [NSString stringWithFormat:@"%lu",[count intValue] - array.count];
                             UPDATA_CARTCOUNT(user.carcount);
                             SAVE_USERMSG(user);
                             
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 //下单成功,跳至订单页
                                 self.tabBarController.selectedIndex = 1;
                             });
                             
                         }
                         
                     }
                     failure:^(NSError *error) {
                         
                     }];
    
}
#pragma mark - 关闭pickerView
- (void)closePicker{
    CGRect rec = self.pickerView.frame;
    rec.origin.y = kScreenHeight;
    
    [UIView animateWithDuration:.25 animations:^{
        
        self.pickerView.frame = rec;
        self.maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    }];
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}
-(PickerAddressView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[PickerAddressView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kPicker_H)];
        _pickerView.backgroundColor = self.view.backgroundColor;
        
    }
    return _pickerView;
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _maskView.alpha = 0;
        _maskView.userInteractionEnabled = YES;
        [self.view addSubview:_maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePicker)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refrush_cart" object:nil];
}
@end
