//
//  PPAdvancedConfig.h
//  PPBluetoothKit
//
//  Created by lefu on 2025/9/19
//  


#import <Foundation/Foundation.h>


@interface PPAdvancedConfig : NSObject
@property (nonatomic, assign) NSInteger typeCanvasHeight;
@property (nonatomic, assign) NSInteger typeCanvasWidth;
@property (nonatomic, assign) NSInteger typeLen; // 字模协议长度
@property (nonatomic, assign) NSInteger selectUserOrder; // 测量完成选择用户顺序：1-先选择用户再下称，2-先提示下称再选择用户；不填为先选择用户再下称

+ (PPAdvancedConfig *)modelFromDict:(NSDictionary *)dict;

@end


