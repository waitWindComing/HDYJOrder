//
//  AddressModel.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/20.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"address_id":@"id"};
}
@end
