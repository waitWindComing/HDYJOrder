//
//  NewAddressController.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/18.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "BaseViewController.h"

@interface NewAddressController : BaseViewController
@property(nonatomic,copy) NSString *aid;
@property(nonatomic,strong) NSArray *goodsArray;
@property(nonatomic,copy) void(^paymentSucceedBlock)(void);
@end
