//
//  AddressPickerVIew.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AddressPickerVIew.h"
#import "AreaModel.h"

#define kTOOL_HEIGHT 45
@interface AddressPickerVIew ()<UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSString *_provinceName;
    NSString *_cityName;
    NSString *_regionName;
    
    NSInteger _provinceIndex;
    NSInteger _cityIndex;
    NSInteger _regionIndex;
}
// 省
@property (nonatomic, strong) NSMutableArray *provinces;

// 城
@property (nonatomic, strong) NSMutableArray *cities;

// 区
@property (nonatomic, strong) NSMutableArray *regions;

@property (nonatomic,strong) UIPickerView *pickerView;
@end
@implementation AddressPickerVIew

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self parseData];
        [self setupSubViews];
    }
    return self;
}
- (void)parseData {
    
    _provinceIndex = 0;
    _cityIndex = 0;
    _regionIndex = 0;
    _provinces = [NSMutableArray array];
    _cities = [NSMutableArray array];
    _regions = [NSMutableArray array];
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"ProCityRegion" ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filename];  //读取数据
    for (NSUInteger i = 0; i < rootDic.allKeys.count; i ++) {
        NSDictionary *dic = [rootDic objectForKey:[NSString stringWithFormat:@"%zd",i]];
        AreaModel *model = [AreaModel new];
        model.name = [dic objectForKey:@"name"];
        model.subArea = [dic objectForKey:model.name];
        [self.provinces addObject:model];
    }
    
    AreaModel *provinceModel = [self.provinces firstObject];
    if (provinceModel.subArea.count > 0) {
        for (NSDictionary *dic in provinceModel.subArea) {
            AreaModel *model = [AreaModel new];
            model.name = [dic objectForKey:@"name"];
            model.subArea = [dic objectForKey:model.name];
            [self.cities addObject:model];
        }
    }
    
    AreaModel *cityModel = [self.cities firstObject];
    if (cityModel.subArea.count > 0) {
        for (NSDictionary *dic in cityModel.subArea) {
            AreaModel *model = [AreaModel new];
            model.name = [dic objectForKey:@"name"];
            [self.regions addObject:model];
        }
    }
}
-(void)setupSubViews{
    self.backgroundColor = RGBCOLOR(240, 240, 240);
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kTOOL_HEIGHT)];
    toolView.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolView];
    
    //取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, kTOOL_HEIGHT)];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:NAVI_COLOR forState:0];
    [toolView addSubview:cancelBtn];
    [cancelBtn addTarget:self
                  action:@selector(closeAction)
        forControlEvents:UIControlEventTouchUpInside];
    //确定
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 60, 0, 60, kTOOL_HEIGHT)];
    [sureBtn setTitle:@"确定" forState:0];
    [sureBtn setTitleColor:NAVI_COLOR forState:0];
    [toolView addSubview:sureBtn];
    [sureBtn addTarget:self
                action:@selector(confimAction:)
      forControlEvents:UIControlEventTouchUpInside];
    // 选择器
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,kTOOL_HEIGHT,self.width, self.height - kTOOL_HEIGHT)];
    _pickerView.backgroundColor = self.backgroundColor;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [self addSubview:_pickerView];
    
    
}
- (void)confimAction:(UIButton *)button {
    
    AreaModel *provinceModel = self.provinces[_provinceIndex];
    AreaModel *cityModel = self.cities[_cityIndex];
    AreaModel *regionModel = self.regions[_regionIndex];
    
    _provinceName = provinceModel.name;
    _cityName = cityModel.name;
    _regionName = regionModel.name;
    
    self.sureBlock(_provinceName,_cityName,_regionName);
}
-(void)closeAction{
    self.closeBlock();
}
#pragma mark-选择器代理和数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    }else if(component == 1){
        return self.cities.count;
    }else if(component == 2){
        return self.regions.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.textAlignment = 1;
    }
    if (component == 0) {
        AreaModel *model = self.provinces[row];
        pickerLabel.text = model.name;
    }else if (component == 1){
        AreaModel *model = self.cities[row];
        pickerLabel.text = model.name;
    }else if (component == 2){
        AreaModel *model = self.regions[row];
        pickerLabel.text = model.name;
    }
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        AreaModel *provinceModel = self.provinces[row];
        NSMutableArray *temp = [NSMutableArray array];
        if (provinceModel.subArea.count > 0) {
            for (NSDictionary *dic in provinceModel.subArea) {
                AreaModel *model = [AreaModel new];
                model.name = [dic objectForKey:@"name"];
                model.subArea = [dic objectForKey:model.name];
                [temp addObject:model];
            }
            self.cities = temp;
            _provinceIndex = row;
            AreaModel *cityModel = [self.cities firstObject];
            NSMutableArray *temp = [NSMutableArray array];
            if (cityModel.subArea.count > 0) {
                for (NSDictionary *dic in cityModel.subArea) {
                    AreaModel *model = [AreaModel new];
                    model.name = [dic objectForKey:@"name"];
                    model.subArea = [dic objectForKey:model.name];
                    [temp addObject:model];
                }
                self.regions = temp;
                _cityIndex = 0;
                _regionIndex = 0;
            }
            [_pickerView reloadComponent:1];
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
        }
    } else if (component == 1) {
        AreaModel *cityModel = self.cities[row];
        NSMutableArray *temp = [NSMutableArray array];
        if (cityModel.subArea.count > 0) {
            for (NSDictionary *dic in cityModel.subArea) {
                AreaModel *model = [AreaModel new];
                model.name = [dic objectForKey:@"name"];
                [temp addObject:model];
            }
            self.regions = temp;
            _cityIndex = row;
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
        }
    } else if (component == 2) {
        _regionIndex = row;
        
    }
    
}

@end
