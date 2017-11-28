//
//  AddressPickerVIew.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerVIew : UIView
@property(nonatomic,copy) void(^sureBlock)(NSString *str1,NSString *str2,NSString *str3);
@property(nonatomic,copy) void(^closeBlock)(void);
@end
