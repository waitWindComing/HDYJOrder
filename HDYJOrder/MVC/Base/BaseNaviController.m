//
//  BaseNaviController.m
//  Demo
//
//  Created by libertyAir on 2017/11/9.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "BaseNaviController.h"

#define kLeftX -kScreenWidth*0.3
const static CGFloat  distanceToPop = 100.0f;
const static CGFloat  popAnimationDuration = 0.30f;
const static CGFloat  pushAnimationDuration = 0.35f;
const static CGFloat  maskAlpha = 0.4f;

#pragma mark - ScreenShotView
@interface ScreenShotView ()
@property (nonatomic,strong) UIImageView *screenShot;
@property (nonatomic,strong) UIView *maskView;

-(void)setupShotImage:(UIImage *)image;
-(void)setupLeft:(CGFloat)x;

@end

@implementation ScreenShotView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *screenShot = [[UIImageView alloc]init];
        _screenShot = screenShot;
        [self addSubview:screenShot];
        
        UIView *maskView = [[UIView alloc]init];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;
        _maskView = maskView;
        [self addSubview:maskView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    _screenShot.frame = self.bounds;
    _maskView.frame = self.bounds;
}

- (void)setupShotImage:(UIImage *)image
{
    self.screenShot.image = image;
}

- (void)setupLeft:(CGFloat)x
{
    self.x = x;
    self.maskView.alpha = x*maskAlpha/(kLeftX);
}

@end

@interface BaseNaviController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray *screenShotsArray;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) ScreenShotView *backgroundView;
@end

@implementation BaseNaviController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // 侧滑左侧阴影
        CAGradientLayer * b_gradientLayer = [CAGradientLayer layer];
        b_gradientLayer.frame = CGRectMake(-10, 0, 10, kScreenHeight);
        [self.view.layer addSublayer:b_gradientLayer];
        
        b_gradientLayer.startPoint = CGPointMake(1, 0);
        b_gradientLayer.endPoint = CGPointMake(0, 0);
        b_gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0.2 alpha:0.3].CGColor,
                                   (__bridge id)[UIColor colorWithWhite:0.3 alpha:0.0].CGColor]
        ;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTintColor:NAVI_COLOR];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //gesture
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandle:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (nil == viewController) {
        return;
    }
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 0)
    {

        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"]style:UIBarButtonItemStylePlain target:self action:@selector(backClicked)];
    }
    if(self.viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = YES;
    
    UIImage *screenShot = [self capture];
    [self.screenShotArray addObject:screenShot];
    [self.backgroundView setupShotImage:screenShot];
    [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
    
    if (animated) {
        [self.backgroundView setupLeft:0];
        self.view.x = self.view.width;
        [super pushViewController:viewController animated:NO];
        
        [UIView animateWithDuration:pushAnimationDuration animations:^{
            self.view.x = 0;
            [self.backgroundView setupLeft:kLeftX];
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        [super pushViewController:viewController animated:animated];
    }
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (animated) {
        [self.backgroundView setupLeft:kLeftX];
        [UIView animateWithDuration:popAnimationDuration animations:^{
            self.view.x = self.view.width;
            [self.backgroundView setupLeft:0];
        } completion:^(BOOL finished) {
            [super popViewControllerAnimated:NO];
            self.view.x = 0;
            [self.screenShotArray removeLastObject];
            [self.backgroundView setupShotImage:self.screenShotArray.lastObject];
        }];
        
        return nil;
    }
    else{
        [self.screenShotArray removeLastObject];
        [self.backgroundView setupShotImage:self.screenShotArray.lastObject];
        return [super popViewControllerAnimated:animated];
    }
}


#pragma mark --- panGestureHandle
- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture
{
    if (self.viewControllers.count == 1) //如果当前是第一个 那就不能pop返回
    {
        return;
    }
    
    CGPoint distanceInView = [panGesture translationInView:self.view]; //拖动了多少
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self.backgroundView setupLeft:kLeftX];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged){
        
        if (distanceInView.x >= 10) {           //大于10才算返回
            self.view.x = distanceInView.x - 10;
            [self.backgroundView setupLeft:distanceInView.x*0.3 + kLeftX];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded){
        if (distanceInView.x > distanceToPop) {
            [UIView animateWithDuration:popAnimationDuration animations:^{
                self.view.x = self.view.width;
                [self.backgroundView setupLeft:0];
            } completion:^(BOOL finished) {
                [self.screenShotArray removeLastObject];
                [self.backgroundView setupShotImage:self.screenShotArray.lastObject];
                [super popViewControllerAnimated:NO];
                self.view.x = 0;
            }];
        }
        else{
            [UIView animateWithDuration:popAnimationDuration animations:^{
                self.view.x = 0;
                [self.backgroundView setupLeft:kLeftX];
            }];
        }
    }
}

#pragma mark --- Method
- (UIImage *)capture {
    UIView * captureView = self.view;
    if (self.tabBarController.view) {
        captureView = self.tabBarController.view;
    }
    
    CGSize size = captureView.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGRect rec = CGRectMake(0, 0, captureView.width, captureView.height);
    
    [captureView drawViewHierarchyInRect:rec afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)backClicked
{
    [self popViewControllerAnimated:YES];
}
// 哪些页面支持自动转屏 （这个不写yes 下面的方法不好使）
- (BOOL)shouldAutorotate{
    
    return YES;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - 手势冲突解决
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (self.childViewControllers.count == 1 ) {
            return NO;
        }
        
        if (self.interactivePopGestureRecognizer &&
            [[self.interactivePopGestureRecognizer.view gestureRecognizers] containsObject:gestureRecognizer]) {
            
            CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            
            if (tPoint.x >= 0) {
                CGFloat y = fabs(tPoint.y);
                CGFloat x = fabs(tPoint.x);
                CGFloat af = 30.0f/180.0f * M_PI;
                CGFloat tf = tanf(af);
                if ((y/x) <= tf) {
                    return YES;
                }
                return NO;
                
            }else{
                return NO;
            }
        }
    }
    
    return YES;
}
#pragma mark --- getter
- (NSMutableArray *)screenShotArray
{
    if (! _screenShotsArray) {
        _screenShotsArray = [NSMutableArray array];
    }
    return _screenShotsArray;
}
- (ScreenShotView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[ScreenShotView alloc]initWithFrame:self.view.bounds];
    }
    return _backgroundView;
}


@end


