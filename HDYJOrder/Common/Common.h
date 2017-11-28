//
//  Common.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/15.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface Common : NSObject

NSString *GET_TOKEN(BOOL repeat,void(^complete)(NSString *token));//获取token
BOOL SAVE_USERMSG(UserModel *user);//储存用户信息
UserModel *GET_USERMSG(void);//获取用户信息
void *UPDATA_CARTCOUNT(NSString *count);//修改用户购物车商品数量
//HUD
void *ShowHUDWtihText(NSString *text);
void *HidenHUD(void);
@end

//用户信息
@interface UserModel : NSObject <NSCoding>
@property(nonatomic,copy) NSString *username;//用户名
@property(nonatomic,copy) NSString *pwd;//密码
@property(nonatomic,copy) NSString *user_id;//用户id
@property(nonatomic,copy) NSString *mobile;//手机号
@property(nonatomic,copy) NSString *avatar;//头像
@property(nonatomic,copy) NSString *level;//用户折扣
@property(nonatomic,copy) NSString *banner;//banner图
@property(nonatomic,copy) NSString *carcount;//购物车商品种类数
@end
