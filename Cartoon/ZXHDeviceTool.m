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
#import "NSString+Common.h"

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


+ (NSString *)randomIDFA{
    NSString *orginStr = @"asjdoiwncjksdhcpowenclncjwhecowncowecnwlhcbil whgeciuowncowcnowencwoecnwinclsniowjnwoecnowneci mnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinweco eoh weiohdoi wefoiefhoiwhefoi hwefoihoiwencnowiencoinwco cno wncoiwncowneconweohweohowncohweiugiuweuo wioruioerjbfdkjegriegfhjkdbvk 2jeoifg wicvwdohqpweihpbevoieqwnvkrqnhreihoiwbnvoqwiehfiougqeuvjbnwoichoqwubvib";
    int index = arc4random()%(orginStr.length - 6);
    int length = arc4random()%(orginStr.length - 2 - index);
    if (length == 0) {
        length = 1;
    }
    NSRange range = NSMakeRange(index, length);
    NSString *str = [orginStr substringWithRange:range];
    NSString *md5Str = [[str md5] uppercaseString];

    NSRange range1 = NSMakeRange(0, 8);
    NSRange range2 = NSMakeRange(8, 4);
    NSRange range3 = NSMakeRange(12, 4);
    NSRange range4 = NSMakeRange(16, 4);
    NSRange range5 = NSMakeRange(20, 12);
    
    NSString *str1 = [md5Str substringWithRange:range1];
    NSString *str2 = [md5Str substringWithRange:range2];
    NSString *str3 = [md5Str substringWithRange:range3];
    NSString *str4 = [md5Str substringWithRange:range4];
    NSString *str5 = [md5Str substringWithRange:range5];
    //EFCAA621-B3F7-49C1-BF5E-ADC0019BF7A1
    NSString *res = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",str1,str2,str3,str4,str5];
    NSLog(@"%@",res);
    return res;
}

+ (NSString *)randomUDID{
    NSString *orginStr = @"euowioruioerjbfdkjeownecimnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinwecoeohweiohdegfhjkdbvk2jeoifgwicvwdohqpwownecimnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinwecoeohweiohdoiwefoiefhoiwhefoiwefoihoiwencnowiencoinwcocnowncoiwncowneconeihpbevoieqwnvkrqnhreihoiwbnvoqwiehfiougqeuvjbnwoichoqwubvibasjdoiwncjksdhcpowenclncjwhecowncowecnwlhcbilwhgeciuowncowcnowencwoecnwinclsniowjnwoecnownecimnwdcnwioeciwenconwclkwnclnwkloiwefoiefownecimnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinwecoeohweiohdoiwefoiefhoiwhefoiwefoihoiwencnowiencoinwcocnowncoiwncowneconhoiwhefoiwefoihoiwencnowiencoinwcocnowncoiwncownecongriegfhjkdbvk2jeoifgwicvwdohqpwownecimnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinwecoeohweiohdoiwefoiefhoiwhefoiwefoihoiwencnowiencoinwcocnowncoiwncowneconeihpbevoieqwnvkrqnhreihoiwbnvoqwiehfiougqeuvjbnwoichoqwubvibasjdoiwncjksdhcpowenclncjwhecowncowecnwlhcbilwhgeciuowncowcnowencwoecnwinclsniowjnwoecnownecimnwdcnwioeciwenconwclkwnclnwklecnlk wncljwheoinwecoeohweiohdoiwefoiefhoiwhefoiwefoihoiwencnowiencoinwcocnowncoiwncowneconweohweohowncohweiugiuw";
    int index = arc4random()%(orginStr.length - 8);
    int length = arc4random()%(orginStr.length - 4 - index);
    if (length == 0) {
        length = 1;
    }
    NSRange range = NSMakeRange(index, length);
    NSString *str = [orginStr substringWithRange:range];
    NSString *md5Str = [str md5] ;
    
    int index2 = arc4random()%(orginStr.length - 10);
    int length2 = arc4random()%(orginStr.length - 3 - index2);
    if (length2 == 0) {
        length2 = 1;
    }
    NSRange range2 = NSMakeRange(index2, length2);
    NSString *str2 = [orginStr substringWithRange:range2];
    NSString *md5Str2 = [str2 md5];
    
    NSString *res = [NSString stringWithFormat:@"%@%@",md5Str,[md5Str2 substringToIndex:8]];

    return res;
}

+ (NSString *)randomIP{
    int add1 = arc4random()%200 + 17;
    int add2 = arc4random()%100 + 12;
    int add3 = arc4random()%220 + 13;
    int add4 = arc4random()%150 + 14;
    
    NSString *res = [NSString stringWithFormat:@"%d.%d.%d.%d",add1,add2,add3,add4];
    NSLog(@"%@",res);
    
    return res;
}

+ (NSString *)randomDeviceType{
    NSArray *array = @[
        @"iPhone7,1",@"iPhone7,2",
        @"iPhone8,1",@"iPhone8,2",@"iPhone8,4",
        @"iPhone9,1",@"iPhone9,2",@"iPhone9,3",@"iPhone9,4",
        @"iPhone10,1",@"iPhone10,2",@"iPhone10,3",@"iPhone10,4",@"iPhone10,5",@"iPhone10,6",
        @"iPhone11,2",@"iPhone11,4",@"iPhone11,6",@"iPhone11,8",
        @"iPhone12,1",@"iPhone12,3",@"iPhone12,5"
    ];
    return array[arc4random()%array.count];
}

+ (NSString *)randomOS{
    NSArray *array = @[
        @"12.0",@"12.0.1",@"12.1",@"12.1.1",@"12.1.2",@"12.1.3",@"12.1.4",@"12.2",@"12.3",@"12.3.1",@"12.4",
        @"13.1",@"13.1.1",@"13.1.2",@"13.2",@"13.2.1",@"13.2.3",@"13.3.1",@"13.4",
    ];
    return array[arc4random()%array.count];
}

@end
