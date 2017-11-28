//
//  PickerAddressView.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/21.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerAddressView : UIView
@property(nonatomic,copy) void(^selectBlock)(NSString *aid);
@property(nonatomic,strong) NSArray *dataArray;
@end
