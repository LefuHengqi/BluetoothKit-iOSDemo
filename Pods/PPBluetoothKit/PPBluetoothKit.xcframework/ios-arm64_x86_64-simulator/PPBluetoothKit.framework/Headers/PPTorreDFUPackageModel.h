//
//  PPTorreDFUPackageModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTorreDFUPackageModel : NSObject

@property (nonatomic, copy) NSString *mcuPath;
@property (nonatomic, copy) NSString *mcuVersion;
@property (nonatomic, copy) NSString *blePath;
@property (nonatomic, copy) NSString *bleVersion;
@property (nonatomic, copy) NSString *resPath;
@property (nonatomic, copy) NSString *resVersion;

@end

NS_ASSUME_NONNULL_END
