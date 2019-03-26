//
//  TXIM.m
//  PIGPEN
//
//  Created by PJHubs on 2019/3/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

#import "TXIM.h"
#import <ImSDK/ImSDK.h>

@implementation TXIM
+ (void)config {
    //初始化 SDK 基本配置
    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
    sdkConfig.sdkAppId = 1400197107;
    sdkConfig.accountType = @"36862";
    sdkConfig.disableLogPrint = YES;
    [[TIMManager sharedInstance] initSdk:sdkConfig];
}

+ (void)userLogin:(NSString *)uid
              sig:(NSString *)sig
         complate:(void (^)(void))complate
          failure:(void (^)(int code, NSString *err))failure {
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    login_param.identifier = uid;
    login_param.userSig = sig;
    login_param.appidAt3rd = @"1400197107";
    [[TIMManager sharedInstance] login: login_param succ:^(){
        complate();
    } fail:^(int code, NSString * err) {
        failure(code, err);
    }];
}
@end
