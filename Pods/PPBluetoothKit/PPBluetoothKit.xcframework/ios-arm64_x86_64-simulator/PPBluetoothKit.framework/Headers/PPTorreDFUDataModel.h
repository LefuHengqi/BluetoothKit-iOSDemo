//
//  PPTorreDFUDataModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTorreDFUDataModel : NSObject

@property (nonatomic, strong) NSData *mcuData;
@property (nonatomic, strong) NSData *bleData;
@property (nonatomic, strong) NSData *resData;


@property (nonatomic, strong) NSMutableArray *mcuDataCMDSlice;
@property (nonatomic, strong) NSMutableArray *bleDataCMDSlice;
@property (nonatomic, strong) NSMutableArray *resDataCMDSlice;

@end

NS_ASSUME_NONNULL_END
