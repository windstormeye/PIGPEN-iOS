//
//  TXIM.h
//  PIGPEN
//
//  Created by PJHubs on 2019/3/26.
//  Copyright © 2019 PJHubs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXIM : NSObject
+ (void)config;

+ (void)userLogin:(NSString *)uid
              sig:(NSString *)sig
         complate:(void (^)(void))complate
          failure:(void (^)(int code, NSString *err))failure;

+ (void)userLogout:(void (^)(void))complate
           faliure:(void(^)(int code, NSString *err))faliure;
@end

NS_ASSUME_NONNULL_END
