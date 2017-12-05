//
//  LAContextManager.m
//  TouchID和FaceID调用
//
//  Created by yongda on 2017/12/5.
//  Copyright © 2017年 TangyuanLiu. All rights reserved.
//

#import "LAContextManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@implementation LAContextManager

+ (void)callLAContextManagerWithController:(UIViewController *)currentVC
                                   success:(LAContext_Success)success
                                   failure:(LAContext_Failure)failure {
    
    if (![currentVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    NSString *message = IS_IPHONE_X ? @"面容 ID 短时间内失败多次，需要验证手机密码" : @"请把你的手指放到Home键上";// 当deviceType为LAPolicyDeviceOwnerAuthentication的时候，iPhone X会需要前面这段描述
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;//单纯指纹或FaceID,LAPolicyDeviceOwnerAuthentication会有密码验证
    LAContext *laContext = [[LAContext alloc] init];
    laContext.localizedFallbackTitle = @""; // 隐藏左边的按钮(默认是忘记密码的按钮)
    NSError *error = nil;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];
    
    if (isSupport) {
        
        [laContext evaluatePolicy:(deviceType) localizedReason:message reply:^(BOOL s, NSError * _Nullable error) {
            
            if (s) {
                success();
            }else {
                failure(error, LAContextErrorAuthorFailure);
            }
        }];
    }else {

        failure(error, LAContextErrorAuthorNotAccess);
    }
}


@end
