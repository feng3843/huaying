//
//  ZXHDeviceTool.m
//  Cartoon
//
//  Created by zxh on 2019/10/23.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "ZXHDeviceTool.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/AdSupport.h>

@implementation ZXHDeviceTool

+ (BOOL)isJailBreak{

  __block BOOL jailBreak = NO;

    NSArray *array = @[@"/Applications/Cydia.app",@"/private/var/lib/apt",@"/usr/lib/system/libsystem_kernel.dylib",@"Library/MobileSubstrate/MobileSubstrate.dylib",@"/etc/apt"];

    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        BOOL fileExist =  [[NSFileManager defaultManager] fileExistsAtPath:obj];

        if ([obj isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]) {

            jailBreak |= !fileExist;

        }else{

            jailBreak |= fileExist;

        }

    }];

   return jailBreak;

}



/*获取当前设备的通讯运营商名称*/
+ (NSString *)getDeviceCarrierName
{
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return [carrier carrierName];
}

/*获取当前设备的网络通讯名称值*/
+ (NSString *)getDeviceNetworkName
{
    /*
        CTRadioAccessTechnologyGPRS             //介于2G和3G之间(2.5G)
        CTRadioAccessTechnologyEdge             //GPRS到第三代移动通信的过渡(2.75G)
        CTRadioAccessTechnologyWCDMA
        CTRadioAccessTechnologyHSDPA            //亦称为3.5G(3?G)
        CTRadioAccessTechnologyHSUPA            //3G到4G的过度技术
        CTRadioAccessTechnologyCDMA1x           //3G
        CTRadioAccessTechnologyCDMAEVDORev0     //3G标准
        CTRadioAccessTechnologyCDMAEVDORevA
        CTRadioAccessTechnologyCDMAEVDORevB
        CTRadioAccessTechnologyeHRPD            //电信一种3G到4G的演进技术(3.75G)
        CTRadioAccessTechnologyLTE              //接近4G
     */
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    return [info currentRadioAccessTechnology];
}

/*获取当前设备的型号名称*/
+ (NSString *)getDeviceModel
{
    NSString *platform = nil;
    struct utsname systemInfo;
    uname(&systemInfo);
    platform = [NSString stringWithCString:systemInfo.machine
                                  encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@",platform];
}

/*获取当前设备的操作系统名称*/
+ (NSString *)getDeviceOSName
{
    return @"ios";
}

/*获取当前设备的操作系统版本号*/
+ (NSString *)getDeviceOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/*获取当前设备的唯一编号*/
+ (NSString *)getDeviceUUID
{
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return IDFV;
}

/*获取当前设备的IDFA*/
+ (NSString *)getDeviceIDFA
{
     NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    return IDFA;
}

@end
