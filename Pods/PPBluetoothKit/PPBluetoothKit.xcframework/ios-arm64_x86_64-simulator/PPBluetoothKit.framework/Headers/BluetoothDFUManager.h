//
//  DfuTest.h
//  Pods
//
//  Created by lefu on 2025/9/26
//  


#import <CoreBluetooth/CoreBluetooth.h>

// 服务UUID
static NSString *const kServiceUUID = @"f000ffc0-0451-4000-b000-000000000000";
// 特征UUID
static NSString *const kImgIdentifyCharacteristicUUID = @"f000ffc1-0451-4000-b000-000000000000";
static NSString *const kImgBlockCharacteristicUUID = @"f000ffc2-0451-4000-b000-000000000000";

// 通知名称
static NSString *const kDFUProgressNotification = @"DFUProgressNotification";
static NSString *const kDFUStatusNotification = @"DFUStatusNotification";

typedef NS_ENUM(NSInteger, DFUState) {
    DFUStateIdle,
    DFUStateSearching,
    DFUStateConnecting,
    DFUStateDiscoveringServices,
    DFUStateDiscoveringCharacteristics,
    DFUStateEnablingNotifications,
    DFUStateQueryingVersion,
    DFUStateComparingVersion,
    DFUStateStartingUpgrade,
    DFUStateSendingData,
    DFUStateCompleted,
    DFUStateError
};

@interface BluetoothDFUManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *targetPeripheral;
@property (nonatomic, strong) CBCharacteristic *imgIdentifyCharacteristic;
@property (nonatomic, strong) CBCharacteristic *imgBlockCharacteristic;

@property (nonatomic, assign) DFUState currentState;
@property (nonatomic, strong) NSData *firmwareData;
@property (nonatomic, assign) NSInteger currentBlock;
@property (nonatomic, assign) NSInteger totalBlocks;
@property (nonatomic, strong) NSDate *lastSendTime;

// GCD定时器
@property (nonatomic, strong) dispatch_source_t sendTimer;

// 版本信息
@property (nonatomic, assign) uint16_t firmwareVersion;
@property (nonatomic, assign) uint16_t protocolVersion;
@property (nonatomic, assign) uint32_t firmwareSize;
@property (nonatomic, assign) uint32_t upgradeFlag;

+ (instancetype)sharedManager;
- (void)startDFUProcess;
- (void)cancelDFUProcess;

@end
