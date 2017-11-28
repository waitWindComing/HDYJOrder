//
//  PickerAddressView.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/21.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "PickerAddressView.h"
#import "PickerAddressCell.h"
#import "AddressModel.h"

static NSString *identifier = @"picker_address";
@interface PickerAddressView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong) UIView *sectionView;
@end
@implementation PickerAddressView
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.myTableView reloadData];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.myTableView.estimatedRowHeight = 120;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //regist
    [self.myTableView registerNib:[UINib
                                   nibWithNibName:@"PickerAddressCell"
                                   bundle:nil]
           forCellReuseIdentifier:identifier];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PickerAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *aid = [self.dataArray[indexPath.row] address_id];
    self.selectBlock(aid);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _myTableView.backgroundColor = self.backgroundColor;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [self addSubview:_myTableView];
    }
    return _myTableView;
}
-(UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _sectionView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = @"请选择地址";
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.font = [UIFont systemFontOfSize:13];
        [_sectionView addSubview:tipLabel];
        tipLabel.sd_layout
        .leftSpaceToView(_sectionView, 15)
        .centerYEqualToView(_sectionView)
        .heightIs(20)
        .widthIs(80);
    }
    return _sectionView;
}
@end
