[English Docs](../README_EN.md)  |  [中文文档](../README.md)
相关文档
[乐福开放平台](https://uniquehealth.lefuenergy.com/unique-open-web/#/document)  |    [PPBluetoothKit Android SDK](https://lefuhengqi.apifox.cn/doc-3330813)  |    [PPBluetoothKit 微信小程序插件](https://uniquehealth.lefuenergy.com/unique-open-web/#/document?url=https://lefuhengqi.apifox.cn/doc-2625745)

[iOS示例程序地址](https://gitee.com/shenzhen-lfscale/bluetooth-kit-iosdemo.git)

# 快速链接
- [1.概述](../README.md)
- [2.集成方式](Integration.md)
- [3.设备扫描](SearchDevice.md)
- [4.人体秤接入](BodyScaleIntegrate.md)
- [5.厨房秤接入](KitchenScaleIntegrate.md)
- [6.计算库使用](Calculate.md)

# 设备扫描 -SearchDeviceViewController

## 1.1 设备分类定义- PPDevicePeripheralType

注：可以通过运行Demo程序，扫描设备，获得设备的`PeripheralType`；不同`PeripheralType`的设备"初始化方式"和“支持的功能”有区别。

扫描设备会返回`PPBluetoothAdvDeviceModel`对象，通过`PeripheralType`属性获取设备分类，根据`PeripheralType`区分自己的设备，设备分类及对应示例如下：

| 分类枚举 | 使用示例类 | 连接方式 | 设备类型 | 协议类型 |  
|------|--------|--------|--------|-----|  
| PPDevicePeripheralTypePeripheralApple | DeviceAppleViewController | 连接 | 人体秤 | 2.x | 
| PPDevicePeripheralTypePeripheralBanana | DeviceBananaViewController | 广播 | 人体秤 | 2.x |
| PPDevicePeripheralTypePeripheralCoconut | DeviceCoconutViewController | 连接 | 人体秤 | 3.x |
| PPDevicePeripheralTypePeripheralDurian | DeviceDurianViewController | 设备端计算的连接 | 人体秤 | 2.x |   
| PPDevicePeripheralTypePeripheralTorre | DeviceTorreViewController | 连接 | 人体秤 | Torre |  
| PPDevicePeripheralTypePeripheralIce | DeviceIceViewController | 连接 | 人体秤 | 4.x |  
| PPDevicePeripheralTypePeripheralJambul | DeviceJambulViewController | 广播 | 人体秤 | 3.x |
| PPDevicePeripheralTypePeripheralEgg | DeviceEggViewController | 连接 | 厨房秤 | 2.x |  
| PPDevicePeripheralTypePeripheralFish | DeviceFishViewController | 连接 | 厨房秤 | 3.x |  
| PPDevicePeripheralTypePeripheralGrapes | DeviceGrapesViewController | 广播 | 厨房秤 | 2.x |  
| PPDevicePeripheralTypePeripheralHamburger | DeviceHamburgerViewController | 广播 | 厨房秤 | 3.x |

## 1.2 扫描周围支持的设备-SearchDeviceViewController

`PPBluetoothConnectManager`是设备扫描和连接的核心类，主要实现以下功能：

- 蓝牙状态监听
- 扫描周边所支持的蓝牙设备
- 连接指定的蓝牙设备
- 断开指定设备的连接
- 停止扫描

具体使用方式，可以参考本Demo中`SearchDeviceViewController`类

```
@interface PPBluetoothConnectManager : NSObject
// 蓝牙状态代理
@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

// 搜索设备代理
@property (nonatomic, weak) id<PPBluetoothSurroundDeviceDelegate> surroundDeviceDelegate;

// 连接设备代理
@property (nonatomic, weak) id<PPBluetoothConnectDelegate> connectDelegate;

// 搜索周边所支持的设备
- (void)searchSurroundDevice;

// 连接指定的设备
- (void)connectPeripheral:(CBPeripheral *)peripheral withDevice:(PPBluetoothAdvDeviceModel *)device;

// 停止搜索蓝牙设备
- (void)stopSearch;

// 断开连接指定的蓝牙设备
- (void)disconnect:(CBPeripheral *)peripheral;

@end
```

### 1.2.1 创建PPBluetoothConnectManager实例

```
// 创建PPBluetoothConnectManager实例，并设置代理
let scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()
self.scaleManager.updateStateDelegate = self;
self.scaleManager.surroundDeviceDelegate = self;
```

### 1.2.2 实现蓝牙状态和搜索设备代理方法

```
extension SearchDeviceViewController:PPBluetoothUpdateStateDelegate,PPBluetoothSurroundDeviceDelegate{

    //蓝牙状态
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            //搜索周边支持设备
            self.scaleManager.searchSurroundDevice()
        }
    }
    
    //搜索到所支持的设备
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
    
    }
}
```

### 1.2.3 PPBluetoothUpdateStateDelegate和PPBluetoothSurroundDeviceDelegate代理方法说明

```
@protocol PPBluetoothUpdateStateDelegate <NSObject>

// 蓝牙状态
- (void)centralManagerDidUpdateState:(PPBluetoothState)state;

@end


@protocol PPBluetoothSurroundDeviceDelegate <NSObject>

// 搜索到所支持的设备
- (void)centralManagerDidFoundSurroundDevice:(PPBluetoothAdvDeviceModel *)device andPeripheral:(CBPeripheral *)peripheral;

@end
```

### 1.2.4 蓝牙状态说明-PPBluetoothState

| 分类枚举 | 说明 | 备注 |  
|------|--------|--------|  
| PPBluetoothStateUnknown | 未知状态 |
| PPBluetoothStateResetting | 复位 |   
| PPBluetoothStateUnsupported | 不支持|
| PPBluetoothStateUnauthorized | 权限未授权| 
| PPBluetoothStatePoweredOff| 蓝牙已关闭 |
| PPBluetoothStatePoweredOn | 蓝牙已打开 |

### 1.2.5 连接指定蓝牙设备

```
//连接蓝牙设备，并设置对应代理，注：只有“连接方式”的设备才需要建立连接，“广播方式”设备不需要建立连接
self.scaleManager.connect(peripheral, withDevice: device)
self.scaleManager.connectDelegate = self
```

### 1.2.6 设备连接状态代理实现-PPBluetoothConnectDelegate

```
extension DeviceIceViewController:PPBluetoothConnectDelegate{
    
    // 设备已连接
    func centralManagerDidConnect() {

    }
    
    // 设备断开连接
    func centralManagerDidDisconnect() {

    }
    
    // 设备连接失败
    func centralManagerDidFail(toConnect error: Error!) {
        
    }

}
```

### 1.2.7搜索周边支持的设备

```
// 搜索周边支持的设备，调用前请判断蓝牙是否为“打开”状态
self.scaleManager.searchSurroundDevice()
```

### 1.2.8 停止扫描

```
self.scaleManager.stopSearch()
```

### 1.2.9 断开指定设备的连接

```
self.scaleManager.disconnect(peripheral)
```

<br/>
<br/>

[上一页: 2.集成方式](Integration.md)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[下一页: 4.人体秤接入](BodyScaleIntegrate.md)




