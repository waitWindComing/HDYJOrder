//
//  Common.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/15.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "Common.h"
#import <objc/runtime.h>

#define kTOKEN_KEY @"hdyj_token"
#define kAPP_ID @"I%CHOW~1"
#define kAPP_SECRET @"qzhxmMzv#hdcv-+KzK!bc4seEF1b2elk"
#define File_Path @"user_Mgs"
@interface Common()

@end
@implementation Common
Common *CreatCommon(void){
    static Common *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[Common alloc]init];
    });
    return myManager;
}
NSString *GET_TOKEN(BOOL repeat,void(^complete)(NSString *token)){
    __block NSString *token;
    if (repeat) {
        token = nil;
    }else{
        token = [[NSUserDefaults standardUserDefaults]objectForKey:kTOKEN_KEY];
    }
    if (!token) {
        NSString *appid = [NSString md5:kAPP_ID];
        NSString *appsecret = [NSString md5:kAPP_SECRET];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"appid"] = appid;
        params[@"appsecret"] = appsecret;
        [LANetworking requestSuccess:^(id responseObject) {
            NSDictionary *dic = responseObject;
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([code isEqualToString:@"1"]) {
                [[UIApplication sharedApplication].keyWindow makeToast:dic[@"message"]];
                return;
            }
            token = dic[@"data"][@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:token
                                                     forKey:kTOKEN_KEY];
            complete(token);
        } failure:^(NSError *error) {
            complete(token);
        } url:kAuth params:params controller:nil];

    }else{
        complete(token);
    }
    return token;
}
BOOL SAVE_USERMSG(UserModel *user){
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:File_Path];
    //归档
    return [NSKeyedArchiver archiveRootObject:user toFile:path];
}

UserModel *GET_USERMSG(void){
    NSString*path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:File_Path];
    //解档
    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return user;
}

void *UPDATA_CARTCOUNT(NSString *count){
    BaseTabbarController *tabbar = [BaseTabbarController shareInstance];
    if (!count || [count isEqualToString:@"0"]) {
        [tabbar.tabBar.items[2] setBadgeValue:nil];
    }else{
       [tabbar.tabBar.items[2] setBadgeValue:count];
    }
    return 0;
}
//HUD
void *ShowHUDWtihText(NSString *text){
    UIView *view = [UIApplication sharedApplication].windows[0];
    MBProgressHUD *hud =  [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.dimBackground = NO;
    hud.labelText = text;
    [hud show:YES];
    //设置关联对象
    objc_setAssociatedObject(CreatCommon(), @"hud_key", hud, OBJC_ASSOCIATION_RETAIN);
    return 0;
}
void *HidenHUD(void){
    MBProgressHUD *hud = objc_getAssociatedObject(CreatCommon(), @"hud_key");
    [hud removeFromSuperview];
    hud = nil;
    return 0;
}
@end

@implementation UserModel
- (void)encodeWithCoder:(NSCoder*)aCoder{
    
    unsigned int count =0;
    
    Ivar *ivars =class_copyIvarList([self class], &count);
    
    for(NSInteger i=0;i<count;i++){
        
        Ivar ivar = ivars[i];
        
        const char *iName =ivar_getName(ivar);
        
        NSString *iStr = [NSString stringWithUTF8String:iName];
        
        id value = [self valueForKey:iStr];
        
        [aCoder encodeObject:value forKey:iStr];
        
    }
        
    free(ivars);
        
}
        
    //解码

- (id)initWithCoder:(NSCoder*)aDecoder{
        
    self= [super init];

    if(self){
        
        unsigned int count =0;
        
        Ivar *ivars =class_copyIvarList([self class], &count);
        
        for(NSInteger i=0; i < count;i++){
            
            Ivar ivar = ivars[i];
            
            const char*key =ivar_getName(ivar);
            
            NSString *iName = [NSString stringWithUTF8String:key];
            
            id value = [aDecoder decodeObjectForKey:iName];
            
            [self setValue:value forKey:iName];
            
            }
        
            free(ivars);
        
            }
    
            return self;
                
}
@end
