//
//  PPImpedanceFailModel.h
//  PPBluetoothKit
//
//  Created by lefu on 2025/12/15
//  


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PPImpedanceFrequency) {
    PPImpedanceFrequency5 = 1,
    PPImpedanceFrequency10 = 2,
    PPImpedanceFrequency20 = 3,
    PPImpedanceFrequency25 = 4,
    PPImpedanceFrequency50 = 5,
    PPImpedanceFrequency100 = 6,
    PPImpedanceFrequency200 = 7,
    PPImpedanceFrequency250 = 8,
};

//BIA_ERROR_RANGER    = 0x04, //!< 量測失敗-數據異常，通常超过范围异常阻抗值造成，也可能为线材和连接异常(10~1600Ω,建议单臂阻抗<800Ω)
//BIA_ERROR_REPEAT    = 0x05, //!< 量測失敗-重複異常,通常为测量时姿势改变等
//BIA_ERROR_ELECTR1   = 0x06, //!< 量測失敗-电极接线错误，通常为左右反接等
//BIA_ERROR_ELECTR2   = 0x07, //!< 量測失敗-电极接线错误,其他情况等
typedef NS_ENUM(NSInteger, PPImpedanceError) {
    PPImpedanceErrorRange = 4,
    PPImpedanceErrorRepeat = 5,
    PPImpedanceErrorElectr1 = 6,
    PPImpedanceErrorElectr2 = 7
};


@interface PPImpedanceFailModel : NSObject
/// 频率
@property (nonatomic, assign) PPImpedanceFrequency frequency;
/// 阻抗测量结果的状态
@property (nonatomic, assign) PPImpedanceError errorType;
/// 电极线接线异常状态错误码 （16进制，如：01、0F），非 00 时有错误
@property (nonatomic, copy) NSString *exceptionCode;


@end


