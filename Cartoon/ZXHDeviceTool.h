//
//  ZXHDeviceTool.h
//  Cartoon
//
//  Created by zxh on 2019/10/23.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZXHDeviceTool : NSObject

+ (BOOL)isJailBreak;

/**
 *  获取当前设备的通讯运营商名称
 */
+ (NSString *)getDeviceCarrierName;

/**
 *  获取当前设备的网络通讯名称值
 */
+ (NSString *)getDeviceNetworkName;

/**
 *  获取当前设备的型号名称
 */
+ (NSString *)getDeviceModel;

/**
 *  获取当前设备的操作系统名称
 */
+ (NSString *)getDeviceOSName;

/**
 *  获取当前设备的操作系统版本号
 */
+ (NSString *)getDeviceOSVersion;

/**
 *  获取当前设备的唯一编号UUID
 */
+ (NSString *)getDeviceUUID;

/**
 *  获取当前设备的IDFA
 */
+ (NSString *)getDeviceIDFA;

@end


