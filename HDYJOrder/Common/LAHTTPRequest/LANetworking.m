//
//  LANetworking.m
//  TiFenBaoDian
//
//  Created by libertyAir on 16/6/14.
//  Copyright © 2016年 libertyAir. All rights reserved.
//

#import "LANetworking.h"
#import <AFNetworking.h>

@implementation LANetworking

/** 封装afn*/
+ (void)requestUrl:(NSString *)url_string
            params:(NSMutableDictionary *)params
       showLoading:(BOOL)show
        controller:(UIViewController *)vc
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    
    NSLog(@"+++++%@---%@--", url_string, params);
    if (show) {

    }
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //获取token
    GET_TOKEN(NO, ^(NSString *token) {
        params[@"token"] = token;
        [manager POST:url_string parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //公共操作
            
            //回调
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([code isEqualToString:@"2"]) {
                //token过期
                GET_TOKEN(YES, ^(NSString *token) {
                    //重新请求
                    [LANetworking requestUrl:url_string
                                      params:params
                                 showLoading:show
                                  controller:vc
                                     success:success
                                     failure:failure];
                });
            }else if([code isEqualToString:@"1"]){
                //请求失败
                [[UIApplication sharedApplication].keyWindow makeToast:dic[@"message"]];
            }
            success(dic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"网络错误"];
            //清除token
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"hdyj_token"];
            //公共操作
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:@"是否重新连接?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [LANetworking requestUrl:url_string
                                  params:params
                             showLoading:show
                              controller:vc
                                 success:success
                                 failure:failure];
                //[LANetworking requestSuccess:success failure:failure url:url_string params:params controller:vc];
            }]];
            [vc presentViewController:alertController animated:YES completion:nil];
            //回调
            failure(error);
        }];
    });
    
    
}
+ (void)requestSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure url:(NSString *)url_string params:(NSDictionary *)params controller:(UIViewController *)vc
{
    
    NSLog(@"+++++%@---%@--", url_string, params);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:url_string parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //公共操作
        
        //回调
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //公共操作
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:@"是否重新连接?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [LANetworking requestSuccess:success failure:failure url:url_string params:params controller:vc];
        }]];
        [vc presentViewController:alertController animated:YES completion:nil];
        //回调
        failure(error);
    }];
    
}
@end
