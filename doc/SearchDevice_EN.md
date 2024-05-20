[English Docs](../README_EN.md)  |  [中文文档](../README.md)
Related documents
[Lefu Open Platform](https://uniquehealth.lefuenergy.com/unique-open-web/#/document)  |    [PPBluetoothKit Android SDK](https://lefuhengqi.apifox.cn/doc-3330813)  |    [PPBluetoothKit WeChat mini program plug-in](https://uniquehealth.lefuenergy.com/unique-open-web/#/document?url=https://lefuhengqi.apifox.cn/doc-2625745)

[iOS sample program address](https://gitee.com/shenzhen-lfscale/bluetooth-kit-iosdemo.git)

# Quick Links
- [1.Overview](../README_EN.md)
- [2.Integration method](Integration_EN.md)
- [3.Device scanning](SearchDevice_EN.md)
- [4.Integrated body scale](BodyScaleIntegrate_EN.md)
- [5.Integrated kitchen scale](KitchenScaleIntegrate_EN.md)
- [6.Calculation library usage](Calculate_EN.md)

# Device scanning - SearchDeviceViewController

## 1.1 Device classification definition-PPDevicePeripheralType

Note: You can run Demo program and scan the device to obtain the `PeripheralType` of the device; the "initialization method" and "supported functions" of devices with different `PeripheralType` are different.

| Classification enumeration | Usage example class | Connection method | Device type | Protocol type |
|------|--------|--------|--------|-----|
| PPDevicePeripheralTypePeripheralApple | DeviceAppleViewController | Connection | Body Scale | 2.x |
| PPDevicePeripheralTypePeripheralBanana | DeviceBananaViewController | Broadcast | Body Scale | 2.x |
| PPDevicePeripheralTypePeripheralCoconut | DeviceCoconutViewController | Connection | Body Scale | 3.x |
| PPDevicePeripheralTypePeripheralDurian | DeviceDurianViewController | Connections for device-side computing | Body Scale | 2.x |
| PPDevicePeripheralTypePeripheralTorre | DeviceTorreViewController | Connection | Body Scale | Torre |
| PPDevicePeripheralTypePeripheralIce | DeviceIceViewController | Connection | Body Scale | 4.x |
| PPDevicePeripheralTypePeripheralJambul | DeviceJambulViewController | Broadcast | Body Scale | 3.x |
| PPDevicePeripheralTypePeripheralEgg | DeviceEggViewController | Connections | Kitchen Scales | 2.x |
| PPDevicePeripheralTypePeripheralFish | DeviceFishViewController | Connections | Kitchen Scales | 3.x |
| PPDevicePeripheralTypePeripheralGrapes | DeviceGrapesViewController | Broadcast | Kitchen Scale | 2.x |
| PPDevicePeripheralTypePeripheralHamburger | DeviceHamburgerViewController | Broadcast | Kitchen Scale | 3.x |

## 1.2 Scan surrounding supported devices-SearchDeviceViewController

`PPBluetoothConnectManager` is the core class for device scanning and connection. It mainly implements the following functions:

- Bluetooth status monitoring
- Scan for supported Bluetooth devices in the surrounding area
- Connect to designated Bluetooth devices
- Disconnect the specified device
- Stop scanning



For specific usage, please refer to the `SearchDeviceViewController` class in this Demo

```

@interface PPBluetoothConnectManager : NSObject
// Bluetooth status proxy
@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

// Search for device agents
@property (nonatomic, weak) id<PPBluetoothSurroundDeviceDelegate> surroundDeviceDelegate;

// Connect device agent
@property (nonatomic, weak) id<PPBluetoothConnectDelegate> connectDelegate;

// Search for peripheral supported devices

- (void)searchSurroundDevice;

// Connect to the specified device

- (void)connectPeripheral:(CBPeripheral *)peripheral withDevice:(PPBluetoothAdvDeviceModel *)device;

// Stop searching for Bluetooth devices

- (void)stopSearch;

// Disconnect the specified Bluetooth device

- (void)disconnect:(CBPeripheral *)peripheral;

@end
```

### 1.2.1 Create PPBluetoothConnectManager instance

```
// Create a PPBluetoothConnectManager instance and set the proxy
let scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()
self.scaleManager.updateStateDelegate = self;
self.scaleManager.surroundDeviceDelegate = self;
```

### 1.2.2 Implement Bluetooth status and search device agent methods

```
extension SearchDeviceViewController:PPBluetoothUpdateStateDelegate,PPBluetoothSurroundDeviceDelegate{

    // Bluetooth status
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            // Search for peripheral support devices
            self.scaleManager.searchSurroundDevice()
        }
    }
    
    // Search for supported devices
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
    
    }
}
```

### 1.2.3 PPBluetoothUpdateStateDelegate and PPBluetoothSurroundDeviceDelegate proxy method description

```
@protocol PPBluetoothUpdateStateDelegate <NSObject>

// Bluetooth status
- (void)centralManagerDidUpdateState:(PPBluetoothState)state;

@end


@protocol PPBluetoothSurroundDeviceDelegate <NSObject>

// Search for supported devices
- (void)centralManagerDidFoundSurroundDevice:(PPBluetoothAdvDeviceModel *)device andPeripheral:(CBPeripheral *)peripheral;

@end
```

### 1.2.4 Bluetooth status description-PPBluetoothState

| Category enumeration | Description | Remarks |
|------|--------|--------|
| PPBluetoothStateUnknown | Unknown state |
| PPBluetoothStateResetting | Reset |
| PPBluetoothStateUnsupported | Not supported |
| PPBluetoothStateUnauthorized | Permission not authorized |
| PPBluetoothStatePoweredOff| Bluetooth is turned off|
| PPBluetoothStatePoweredOn | Bluetooth is on |

### 1.2.5 Connect to the specified Bluetooth device

```
// Connect the Bluetooth device and set the corresponding proxy
self.scaleManager.connect(peripheral, withDevice: device)
self.scaleManager.connectDelegate = self
```

### 1.2.6 Device connection status proxy implementation-PPBluetoothConnectDelegate

```
extension DeviceIceViewController:PPBluetoothConnectDelegate{
    
    // The device is connected
    func centralManagerDidConnect() {

    }
    
    // Device disconnects
    func centralManagerDidDisconnect() {

    }
    
    // Device connection failed
    func centralManagerDidFail(toConnect error: Error!) {
        
    }

}
```

### 1.2.7 Search for peripheral supported devices

```
//  Search for peripheral supported devices. Please check whether Bluetooth is "on" before calling.
self.scaleManager.searchSurroundDevice()
```

### 1.2.8 Stop scanning

```
self.scaleManager.stopSearch()
```

### 1.2.9 Disconnect the specified device

```
self.scaleManager.disconnect(peripheral)
```

<br/>
<br/>

[Previous page: 2.Integration method](Integration_EN.md)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[Next page: 4.Integrated body scale](BodyScaleIntegrate_EN.md)



