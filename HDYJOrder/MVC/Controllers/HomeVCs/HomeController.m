//
//  HomeController.m
//  Demo
//
//  Created by libertyAir on 2017/11/13.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "HomeController.h"
#import "HomeLeftCell.h"
#import "HomeRIghtCell.h"
//#import "PurchaseCarAnimationTool.h"
#import "HomeLeftModel.h"
#import "HomeRightModel.h"
#import "HomePopView.h"

static NSString *identifier_left = @"homeleft_cell";
static NSString *identifier_right = @"homeright_cell";
#define Pop_Height  kScreenHeight * 0.65
#define kLeftCell_H 51
#define kRightCell_H 106
@interface HomeController ()<UITableViewDelegate,UITableViewDataSource,HomeRightCellDelegate>
{
    NSString *_edition;
}
@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic ,strong) HomePopView *popView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) NSMutableArray *leftArray;
@property (nonatomic,strong) NSMutableArray *rightArray;
@property (nonatomic,strong) UIView *sectionView;
@end

@implementation HomeController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置购物车角标
    UserModel *user = GET_USERMSG();
    UPDATA_CARTCOUNT(user.carcount);
    
    [self setupSubViews];
    [self loadDataLeftTableView];
    //登录成功,刷新通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refushNoti:)
                                                name:@"refush_homeVC" object:nil];
    
}
- (void)refushNoti:(NSNotification *)notifi{
    [self loadDataLeftTableView];
    //get banner url
    UserModel *user = GET_USERMSG();
    //设置banner]
    [self.bannerView sd_setImageWithURL:[NSURL URLWithString:user.banner]];
    //设置购物车角标
    UPDATA_CARTCOUNT(user.carcount);
}
- (void)setupSubViews{
    //get banner url
    UserModel *user = GET_USERMSG();
    //设置banner
    [self.bannerView sd_setImageWithURL:[NSURL URLWithString:user.banner]];
    
    self.leftTableView.backgroundColor =
    self.view.backgroundColor;
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    self.leftTableView.tableFooterView = [[UIView alloc]init];
    self.leftTableView.rowHeight = kLeftCell_H;
    self.rightTableView.rowHeight = kRightCell_H;
    //regist cell
    [self.leftTableView registerNib:[UINib nibWithNibName:@"HomeLeftCell" bundle:nil] forCellReuseIdentifier:identifier_left];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"HomeRIghtCell" bundle:nil] forCellReuseIdentifier:identifier_right];
    //下拉刷新rightTableview
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataRightTableView)];
    [header setImages:nil forState:MJRefreshStateIdle];
    // Set header
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.rightTableView.mj_header = header;
    
    
    WeakSelf(self);
    self.popView.closePopViewBlock = ^{
        [weakself close:nil];
    };
    
    //确定加入购物车
    self.popView.sureShopBlock = ^(NSString *goodsId, NSString *num) {
        if ([num isEqualToString:@"0"]) {
            [weakself close:nil];
            return;
        }

        //get uid
        UserModel *user = GET_USERMSG();
        //params
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSError *error = nil;
        
        NSDictionary *dict = @{@"product":@[@{@"id":goodsId,
                                              @"num":num,
                                              @"edition":_edition
                                              }]};
        //转json
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        params[@"product"]=jsonString;
        params[@"uid"] = user.user_id;
        params[@"type"] = @"goods";
        [weakself addShopCart:params];
    };
}
#pragma mark - 获取版本数据
- (void)loadDataLeftTableView{
    //params
    UserModel *user = GET_USERMSG();
    if (!user.user_id) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = user.user_id;
    //request
    [LANetworking requestUrl:kGoodsedition
                      params:params
                 showLoading:NO
                  controller:nil
                     success:^(id responseObject) {
                         [self.leftArray removeAllObjects];
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             
                             self.leftArray = [HomeLeftModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                             //设置默认id
                             if (!_edition) {
                                 _edition = [[self.leftArray firstObject] edition];
                             }
                         }
                         [self.leftTableView reloadData];
                         //设置默认选中
                         [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                         //获取商品列表
                         [self loadDataRightTableView];
                     } failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - 获取商品列表数据
- (void)loadDataRightTableView{
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"edition"] = _edition;
    
    //request
    [LANetworking requestUrl:kGoodLists
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             self.rightArray = [HomeRightModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                             
                         }
                         [self.rightTableView reloadData];
                         [self.rightTableView.mj_header endRefreshing];
                        
                     }
                     failure:^(NSError *error) {
                         //[self.rightTableView.mj_header endRefreshing];
                     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == _leftTableView ? self.leftArray.count : self.rightArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        HomeLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:identifier_left forIndexPath:indexPath];
        leftCell.model = self.leftArray[indexPath.row];
        return leftCell;
    }else{
        HomeRIghtCell *rightCell = [tableView dequeueReusableCellWithIdentifier:identifier_right forIndexPath:indexPath];
        rightCell.indexPath = indexPath;
        rightCell.delegate = self;
        rightCell.model = self.rightArray[indexPath.row];
        return rightCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSString *eid = [self.leftArray[indexPath.row] edition];
        if ([eid isEqualToString:_edition]) {
            return;
        }
        _edition = eid;
        [self loadDataRightTableView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView == self.rightTableView ? kLeftCell_H : CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return tableView == self.rightTableView ? self.sectionView : nil;
}
#pragma mark - HomeRightCell_deleagte
-(void)HomeRightCellAddShopCart:(HomeRIghtCell *)cell withGoods:(UIImageView *)goods withIndexPath:(NSIndexPath *)indexPath{
    //传递model
    self.popView.model = self.rightArray[indexPath.row];
    //popView加载到window上
    [[UIApplication sharedApplication].windows[0] addSubview:self.popView];
    CGRect rec = self.popView.frame;
    rec.origin.y = kScreenHeight - Pop_Height;
    
    [UIView animateWithDuration:.25 animations:^{
        self.maskView.alpha = 0.7;
        self.popView.frame = rec;
        
    } completion:^(BOOL finished) {
   
    }];
}
#pragma mark - 加入购物车
-(void)addShopCart:(NSMutableDictionary *)params{
    
    //request
    [LANetworking requestUrl:kAddCart
                      params:params
                 showLoading:YES
                  controller:nil
                     success:^(id responseObject) {
                         NSDictionary *dic = responseObject;
                         NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                         if ([code isEqualToString:@"0"]) {
                             [self.view makeToast:dic[@"message"]];
                             [self close:nil];
                             //通知购物车刷新
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"refrush_cart" object:nil];
                             //修改购物车商品数量
                             UserModel *user = GET_USERMSG();
                             user.carcount = [NSString stringWithFormat:@"%@",dic[@"data"][@"carcount"]];
                             UPDATA_CARTCOUNT(user.carcount);
                             SAVE_USERMSG(user);
                         }
                     }
                     failure:^(NSError *error) {
                         
                     }];
}
#pragma mark - 关闭popView
- (void)close:(id)sender
{
    //收起键盘
    [self.popView.numField resignFirstResponder];
    CGRect rec = self.popView.frame;
    rec.origin.y = kScreenHeight+18;
    
    [UIView animateWithDuration:.25 animations:^{
        
        self.popView.frame = rec;
        self.maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
   
    }];
    
}

-(NSMutableArray *)leftArray{
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
-(NSMutableArray *)rightArray{
    if (!_rightArray) {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
}
-(HomePopView *)popView{
    if (!_popView) {
        _popView = [[HomePopView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 18, kScreenWidth, Pop_Height)];
    }
    return _popView;
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _maskView.alpha = 0;
        _maskView.userInteractionEnabled = YES;
        [self.view addSubview:_maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}
-(UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.rightTableView.width, kLeftCell_H)];
        _sectionView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [UIView new];
        line.backgroundColor = RGBCOLOR(28, 168, 253);
        [_sectionView addSubview:line];
        line.sd_layout
        .leftSpaceToView(_sectionView, 10)
        .centerYEqualToView(_sectionView)
        .heightIs(12)
        .widthIs(3);
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = @"产品展示";
        tipLabel.textColor = RGBCOLOR(140, 140, 140);
        tipLabel.font = [UIFont systemFontOfSize:14];
        [_sectionView addSubview:tipLabel];
        tipLabel.sd_layout
        .leftSpaceToView(line, 5)
        .heightIs(13)
        .rightSpaceToView(_sectionView, 10)
        .centerYEqualToView(line);
    }
    return _sectionView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refush_homeVC" object:nil];
}
@end
