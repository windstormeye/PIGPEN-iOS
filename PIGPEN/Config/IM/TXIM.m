//
//  TXIM.m
//  PIGPEN
//
//  Created by PJHubs on 2019/3/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

#import "TXIM.h"
#import <TUIKit/TUIKit.h>

@implementation TXIM
+ (void)config {
    //初始化 SDK 基本配置
    NSInteger sdkAppid = 1400197107;
    NSString *accountType = @"36862";
//    TUIKitConfig *config = [TUIKitConfig defaultConfig];//默认TUIKit配置，这个您可以根据自己的需求在 TUIKitConfig 里面自行配置
    [[TUIKit sharedInstance] initKit:sdkAppid accountType:accountType withConfig:[TUIKitConfig defaultConfig]];
}

+ (void)userLogin:(NSString *)uid
              sig:(NSString *)sig
         complate:(void (^)(void))complate
          failure:(void (^)(int code, NSString *err))failure {
    
    
    NSString *identifier = uid;
    NSString *userSig = sig;
    [[TUIKit sharedInstance] loginKit:identifier userSig:userSig succ:^{
        complate();
    } fail:^(int code, NSString *msg) {
        failure(code, msg);
    }];
}

+ (void)userLogout:(void (^)(void))complate
           faliure:(void(^)(int code, NSString *err))faliure {
//    [[TIMManager sharedInstance] logout:^() {
//        complate();
//    } fail:^(int code, NSString * err) {
//        faliure(code, err);
//    }];
}

@end
