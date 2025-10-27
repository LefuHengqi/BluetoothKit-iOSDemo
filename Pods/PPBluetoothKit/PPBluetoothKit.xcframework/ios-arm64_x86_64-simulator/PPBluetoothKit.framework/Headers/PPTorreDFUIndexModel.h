//
//  PPTorreDFUIndexModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTorreDFUIndexModel : NSObject

@property (nonatomic, assign) NSInteger packetSize;
@property (nonatomic, assign) NSInteger mtu;

@property (nonatomic, assign) NSInteger packetIndex;
@property (nonatomic, assign) NSInteger packetOffset;
@property (nonatomic, assign) NSInteger chunkIndex;
@property (nonatomic, assign) NSInteger chunkOffset;

@end

NS_ASSUME_NONNULL_END
