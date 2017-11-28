//
//  AddressModel.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/20.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(nonatomic,copy) NSString *address_id;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *is_default;
@end
