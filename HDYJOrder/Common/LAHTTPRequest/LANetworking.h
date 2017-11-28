//
//  LANetworking.h
//  TiFenBaoDian
//
//  Created by libertyAir on 16/6/14.
//  Copyright © 2016年 libertyAir. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseURL     @"https://api.fc62.com"

#define kAuth           [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/index/auth"]     //授权
#define kLogin          [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/login"]     //登录
#define kLogincode      [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/logincode"] //动态码登录
#define kGetaddress     [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/getaddress"]//单个收货地址
#define kSendlogin      [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/sendlogin"] //发送动态码
#define kSendpwd        [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/sendpwd"]   //发送验证码
#define kChangepwd      [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/changepwd"] //修改密码
#define kEditpassword   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/editpassword"]  //忘记密码
#define kAddressList     [NSString stringWithFormat:@"%@%@",kBaseURL,@"//app/user/addresslist"]       //收货地址列表get
#define kAddress        [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/address"]       //添加收货地址
#define kDeladdress     [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/deladdress"]    //删除收货地址
#define kAdd            [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/orders/add"]         //订单生成
#define kLists          [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/orders/lists"]       //历史订单get
#define kInfo           [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/orders/info"]        //订单详情get
#define kCancel         [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/orders/cancel"]      //取消订单get
#define kGoodLists      [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/goods/lists"]        //商品列表get
#define kGoodsedition   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/goodsedition"]  //商品列表用户版本
#define kCartList   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/goods/catlist"]  //获取购物车列表
#define kAddCart   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/goods/addcat"]  //购物车添加
#define kDelCat   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/goods/delcat"]  //购物车删除
#define kEditDefalut   [NSString stringWithFormat:@"%@%@",kBaseURL,@"/app/user/editisdefalut"]  //设置默认地址
@interface LANetworking : NSObject

+ (void)requestUrl:(NSString *)url_string
            params:(NSMutableDictionary *)params
       showLoading:(BOOL)show
        controller:(UIViewController *)vc
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure;
+ (void)requestSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure url:(NSString *)url_string params:(NSDictionary *)params controller:(UIViewController *)vc;
@end

