//
//  BaseTabbarController.m
//  Demo
//
//  Created by libertyAir on 2017/11/9.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNaviController.h"
#import "HomeController.h"
#import "OrderController.h"
#import "ShopCartController.h"
#import "MineController.h"

static BaseTabbarController *_instance;
@interface BaseTabbarController ()
{
    BaseNaviController *_homeNavi;
    BaseNaviController *_orderNavi;
    BaseNaviController *_shopCartNavi;
    BaseNaviController *_mineNavi;
    NSInteger _itemIndex;
}
@end

@implementation BaseTabbarController
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubControllers];
    
}
-(void)setupSubControllers{
    _homeNavi = [[BaseNaviController alloc]initWithRootViewController:[HomeController new]];
    _orderNavi = [[BaseNaviController alloc]initWithRootViewController:[OrderController new]];
    _shopCartNavi = [[BaseNaviController alloc]initWithRootViewController:[ShopCartController new]];
    _mineNavi = [[BaseNaviController alloc] initWithRootViewController:[MineController new]];
    NSArray *controllers = @[_homeNavi,
                             _orderNavi,
                             _shopCartNavi,
                             _mineNavi];
    //title
    NSArray *titles = @[@"首页",
                        @"订单",
                        @"购物车",
                        @"我的"];
    NSArray *imgs = @[@"shouye_xian",
                      @"order_xian-",
                      @"shoppingcart_xian",
                      @"wode_xian"];
    NSArray *selectImgs = @[@"shouye_mian",
                            @"order_mian",
                            @"shoppingcart_mian",
                            @"wode_mian"];
    self.viewControllers = controllers;
    self.tabBar.tintColor = RGBCOLOR(28, 168, 253);
    [self setContollers:controllers
        setTabbarTitles:titles
            tabbarImags:imgs
     selectTabbarImages:selectImgs];
    
    //self.tabBar.tintColor = [UIColor whiteColor];
}
-(void)setContollers:(NSArray *)ctls
     setTabbarTitles:(NSArray *)titles
         tabbarImags:(NSArray *)imgs
  selectTabbarImages:(NSArray *)selectImgs{
    for (int i = 0; i<ctls.count; i++) {
        BaseViewController *vc = ctls[i];
        [vc.tabBarItem setTitle:titles[i]];
        [vc.tabBarItem setImage:[UIImage
                                 imageNamed:imgs[i]]];
        [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectImgs[i]]];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:RGBCOLOR(140, 140, 140)} forState:0];
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:RGBCOLOR(28, 168, 253)} forState:UIControlStateSelected];
    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (_itemIndex != index) {
        [self animationWithIndex:index];
    }
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [[tabbarbuttonArray[index] layer]
     addAnimation:animation forKey:nil];
    
    _itemIndex = index;
    
}
@end
