//
//  PPECGDataModel.h
//  PPBluetoothKit
//
//  Created by lefu on 2026/10/12
//  


#import <Foundation/Foundation.h>



@interface PPECGDataModel : NSObject
/// lead状态， 0：lead off ，1：lead on
@property (nonatomic, assign) NSInteger leadStatus;
/// wear状态， 0：wear off  ，1：wear on
@property (nonatomic, assign) NSInteger wearStatus;
/// ECG原始数据
@property (nonatomic, strong) NSArray<NSNumber *> *originDatas;

@end


