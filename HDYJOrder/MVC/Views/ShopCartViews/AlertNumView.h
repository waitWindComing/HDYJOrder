//
//  AlertNumView.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/22.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertNumView : UIView
@property(nonatomic,strong) UITextField *numField;
@property(nonatomic,copy) void(^alertBlock)(NSString *num);

- (void)showAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated;

@end
