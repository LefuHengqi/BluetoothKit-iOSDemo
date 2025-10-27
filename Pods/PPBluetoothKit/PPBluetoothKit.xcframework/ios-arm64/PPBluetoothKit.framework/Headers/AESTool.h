//
//  AESTool.h
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/2
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface AESTool:NSObject

+ (NSData *)cipherOperationWithContentData:(NSData *)contentData keyData:(NSData *)keyData operation:(CCOperation)operation;
+ (NSString *)aesEncryptString:(NSString *)content key:(NSString *)key;

+ (NSString *)aesDecryptString:(NSString *)content key:(NSString *)key;

+ (NSData *)aesEncryptData:(NSData *)contentData keyData:(NSData *)keyData;
+ (NSData *)aesDecryptData:(NSData *)contentData keyData:(NSData *)keyData;


+ (NSData *)encryptData:(NSString *)dataText keyData:(NSData *)keyData ivString:(NSString *)ivString;

+ (NSData *)decryptData:(NSData *)encryptedData keyData:(NSData *)keyData ivString:(NSString *)ivString;

@end

