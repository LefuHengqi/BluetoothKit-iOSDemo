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

# 计算库使用 - calcute - CalcuteInfoViewController

## 1.1 测量身体数据相关约定

### 1.1.1 称重测脂注意事项

- 秤支持测脂
- 光脚上称，并接触对应的电极片
- 称重接口返回体重(kg)和阻抗信息
- 人体参数身高、年龄输入正确

### 1.1.2 体脂计算

#### 基础参数约定

| 类别 | 输入范围 | 单位 |    
|:----|:--------|:--:|    
| 身高 | 100-220 | cm |    
| 年龄 | 10-99 | 岁 |    
| 性别 | 0/1 | 女/男 |    
| 体重 | 10-200 | kg |

- 需要身高、年龄、性别和对应的阻抗，调用对应的计算库去获得
- 8电极所涉及的体脂数据项需要8电极的秤才可使用

## 1.2 体脂计算所需参数说明

根据蓝牙协议解析出的体重、阻抗，加上用户数据的身高、年龄、性别，计算出体脂率等多项体脂参数信息。

### 1.2.1 PPBluetoothScaleBaseModel

| 参数 | 注释| 说明 |  
| :--------  | :-----  | :----:  |  
| weight | 体重 | 实际体重*100取整|  
| impedance|四电极算法阻抗 |四电极算法字段|     
| isHeartRating| 是否正在测量心率 |心率测量状态|  
| unit| 秤端的当前单位 |实时单位|  
| heartRate| 心率 |秤端支持心率生效|  
| isPlus| 是否是正数 |食物秤生效|  
| memberId| 成员Id |秤端支持用户时生效|  
| z100KhzLeftArmEnCode| 100KHz左手阻抗加密值 |八电极字段|  
| z100KhzLeftLegEnCode| 100KHz左腳阻抗加密值 |八电极字段|  
| z100KhzRightArmEnCode| 100KHz右手阻抗加密值 |八电极字段|  
| z100KhzRightLegEnCode| 100KHz右腳阻抗加密值 |八电极字段|  
| z100KhzTrunkEnCode| 100KHz軀幹阻抗加密值 |八电极字段|  
| z20KhzLeftArmEnCode| 20KHz左手阻抗加密值 |八电极字段|  
| z20KhzLeftLegEnCode| 20KHz左腳阻抗加密值 |八电极字段|  
| z20KhzRightArmEnCode|20KHz右手阻抗加密值 |八电极字段|  
| z20KhzRightLegEnCode| 20KHz右腳阻抗加密值 |八电极字段|  
| z20KhzTrunkEnCode| 20KHz軀幹阻抗加密值 |八电极字段|

### 1.2.2 计算类型说明  PPBluetoothDefine - deviceCalcuteType

| PPDeviceCalcuteType   | 注释| 使用范围 |  
| :--------  | :-----  | :----:  |  
| PPDeviceCalcuteTypeInScale | 秤端计算 | 秤端计算的秤|  
| PPDeviceCalcuteTypeDirect| 直流 | 四电极直流体脂秤|  
| PPDeviceCalcuteTypeAlternate| 四电极交流 | 四电极体脂秤|  
| PPDeviceCalcuteTypeAlternate8| 8电极交流算法 | 八电极体脂秤|  
| PPDeviceCalcuteTypeNormal| 默认计算方式 | 4电极交流 |  
| PPDeviceCalcuteTypeNeedNot| 不需要计算 | 食物秤或人体秤|  
| PPDeviceCalcuteTypeAlternate8_0| 8电极算法 |八电极体脂秤|

### 1.2.3 用户基础信息说明 PPBluetoothDeviceSettingModel

| 参数 | 注释| 说明 |  
| :--------  | :-----  | :----:  |  
| height| 身高|所有体脂秤|  
| age| 年龄 |所有体脂秤|  
| gender| 性别 |所有体脂秤|

## 1.3 八电极交流体脂计算 - 8AC - CalcuelateResultViewController - calcuteType8AC

**八电极计算体脂示例:**

```
// 计算结果类：PPBodyFatModel


let fatModel  = PPBodyFatModel(userModel: userModel,
                                                 deviceMac: "",
                                                 weight: CGFloat(self.myUserModel.weight),
                                       heartRate: 0, deviceCalcuteType: .alternate8,
                                                 z20KhzLeftArmEnCode: self.myUserModel.z20KhzLeftArmEnCode,
                                                 z20KhzRightArmEnCode: self.myUserModel.z20KhzRightArmEnCode,
                                                 z20KhzLeftLegEnCode: self.myUserModel.z20KhzLeftLegEnCode,
                                                 z20KhzRightLegEnCode: self.myUserModel.z20KhzRightLegEnCode,
                                                 z20KhzTrunkEnCode: self.myUserModel.z20KhzTrunkEnCode,
                                                 z100KhzLeftArmEnCode: self.myUserModel.z100KhzLeftArmEnCode,
                                                 z100KhzRightArmEnCode: self.myUserModel.z100KhzRightArmEnCode,
                                                 z100KhzLeftLegEnCode: self.myUserModel.z100KhzLeftLegEnCode,
                                                 z100KhzRightLegEnCode: self.myUserModel.z100KhzRightLegEnCode,
                                                 z100KhzTrunkEnCode: self.myUserModel.z100KhzTrunkEnCode)

// fatModel 为计算所得结果
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.4 四电极直流体脂计算 - 4DC - CalcuelateResultViewController - calcuteType4DC

**四电极直流计算体脂示例:**

```
// 计算结果类：PPBodyFatModel

let fatModel = PPBodyFatModel(userModel: userModel,
                                      deviceCalcuteType: PPDeviceCalcuteType.direct,
                                      deviceMac: "c1:c1:c1:c1",
                                      weight: CGFloat(self.myUserModel.weight),
                                      heartRate: 0,
                                      andImpedance: self.myUserModel.impedance)
        
// fatModel 为计算所得结果
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.5 四电极交流体脂计算 - 4AC - CalcuelateResultViewController - calcuteType4AC

**四电极交流计算体脂示例:**

```
// 计算结果类：PPBodyFatModel

var fatModel:PPBodyFatModel!

fatModel =  PPBodyFatModel(userModel: userModel,
                                       deviceCalcuteType: PPDeviceCalcuteType.alternate,
                                       deviceMac: "c1:c1:c1:c1",
                                       weight: CGFloat(self.myUserModel.weight),
                                       heartRate: 0,
                                       andImpedance: self.myUserModel.impedance)
                                       
// fatModel 为计算所得结果
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.6 实体类对象及具体参数说明

### 1.6.1 PPBodyFatModel 体脂计算对象参数说明

四电极对应的24项数据
八电极对应的48项数据

| 参数| 参数类型 | 说明 |数据类型|备注  
|------|--------|--------|--------|--------|  
|ppBodyBaseModel| PPBodyBaseModel |体脂计算的入参|基础入参|包含设备信息、用户基础信息、体重和心率|体脂秤  
|ppSDKVersion| String |计算库版本号|返回参数|  
|ppSex| PPUserGender|性别|返回参数| PPUserGenderFemale女PPUserGenderMale男  
|ppHeightCm|Int |身高|返回参数|cm  
|ppAge|Int |年龄|返回参数|岁  
|errorType|BodyFatErrorType |错误类型|返回参数|PP_ERROR_TYPE_NONE(0),无错误 PP_ERROR_TYPE_AGE(1), 年龄有误 PP_ERROR_TYPE_HEIGHT(2),身高有误 PP_ERROR_TYPE_WEIGHT(3),体重有误 PP_ERROR_TYPE_SEX(4) 性別有误 PP_ERROR_TYPE_PEOPLE_TYPE(5)  以下是阻抗有误 PP_ERROR_TYPE_IMPEDANCE_TWO_LEGS(6)  PP_ERROR_TYPE_IMPEDANCE_TWO_ARMS(7)PP_ERROR_TYPE_IMPEDANCE_LEFT_BODY(8) PP_ERROR_TYPE_IMPEDANCE_RIGHT_ARM(9)PP_ERROR_TYPE_IMPEDANCE_LEFT_ARM(10)  PP_ERROR_TYPE_IMPEDANCE_LEFT_LEG(11)  PP_ERROR_TYPE_IMPEDANCE_RIGHT_LEG(12)  PP_ERROR_TYPE_IMPEDANCE_TRUNK(13)  
|bodyDetailModel|PPBodyDetailModel|数据区间范围和介绍描述|  
|ppWeightKg|Float |体重|24&48|kg  
|ppBMI|Float|Body Mass Index|24&48|  
|ppFat|Float |脂肪率|24&48|%  
|ppBodyfatKg|Float |脂肪量|24&48|kg  
|ppMusclePercentage|Float |肌肉率|24&48|%  
|ppMuscleKg|Float |肌肉量|24&48|kg  
|ppBodySkeletal|Float |骨骼肌率|24&48|%  
|ppBodySkeletalKg|Float |骨骼肌量|24&48|kg  
|ppWaterPercentage|Float |水分率|24&48|%  
|ppWaterKg|Float |水分量|24&48|kg  
|ppProteinPercentage|Float |蛋白质率|24&48|%  
|ppProteinKg|Float |蛋白质量|24&48|kg  
|ppLoseFatWeightKg|Float |去脂体重|24&48|kg  
|ppBodyFatSubCutPercentage|Float |皮下脂肪率|24&48|%  
|ppBodyFatSubCutKg|Float |皮下脂肪量|24&48|kg  
|ppHeartRate|Int |心率|24&48|bmp该值与秤有关，且大于0为有效  
|ppBMR|Int |基础代谢|24&48|  
|ppVisceralFat|Int |内脏脂肪等级|24&48|  
|ppBoneKg|Float |骨量|24&48|kg  
|ppBodyMuscleControl|Float |肌肉控制量|24&48|kg  
|ppFatControlKg|Float |脂肪控制量|24&48|kg  
|ppBodyStandardWeightKg|Float |标准体重|24&48|kg  
|ppIdealWeightKg|Float |理想体重|24&48|kg  
|ppControlWeightKg|Float |控制体重|24&48|kg  
|ppBodyType|PPBodyDetailType |身体类型|24&48|PPBodyDetailType有单独说明  
|ppFatGrade|PPBodyFatGrade|肥胖等级|24&48|PPBodyGradeFatThin(0), //!< 偏瘦 PPBodyGradeFatStandard(1),//!< 标准 PPBodyGradeFatOverwight(2), //!< 超重 PPBodyGradeFatOne(3),//!< 肥胖1级 PPBodyGradeFatTwo(4),//!< 肥胖2级 PPBodyGradeFatThree(5);//!< 肥胖3级  
|ppBodyHealth|PPBodyHealthAssessment |健康评估|24&48|PPBodyAssessment1(0), //!< 健康存在隐患PPBodyAssessment2(1), //!< 亚健康 PPBodyAssessment3(2), //!< 一般 PPBodyAssessment4(3), //!< 良好  PPBodyAssessment5(4); //!< 非常好  
|ppBodyAge|Int|身体年龄|24&48|岁  
|ppBodyScore|Int |身体得分|24&48|分  
|ppCellMassKg|Float |身体细胞量|48|kg  
|ppDCI|Int |建议卡路里摄入量|48|Kcal/day  
|ppMineralKg|Float |无机盐量|48|kg  
|ppObesity|Float |肥胖度|48|%  
|ppWaterECWKg|Float |细胞外水量|48|kg  
|ppWaterICWKg|Float |细胞内水量|48|kg  
|ppBodyFatKgLeftArm|Float |左手脂肪量|48|kg  
|ppBodyFatKgLeftLeg|Float |左脚脂肪量|48|kg  
|ppBodyFatKgRightArm|Float |右手脂肪量|48|kg  
|ppBodyFatKgRightLeg|Float |右脚脂肪量|48|kg  
|ppBodyFatKgTrunk|Float |躯干脂肪量|48|kg  
|ppBodyFatRateLeftArm|Float |左手脂肪率|48|%  
|ppBodyFatRateLeftLeg|Float |左脚脂肪率|48|%  
|ppBodyFatRateRightArm|Float |右手脂肪率|48|%  
|ppBodyFatRateRightLeg|Float |右脚脂肪率|48|%  
|ppBodyFatRateTrunk|Float |躯干脂肪率|48|%  
|ppMuscleKgLeftArm|Float |左手肌肉量|48|kg  
|ppMuscleKgLeftLeg|Float |左脚肌肉量|48|kg  
|ppMuscleKgRightArm|Float |右手肌肉量|48|kg  
|ppMuscleKgRightLeg|Float |右脚肌肉量|48|kg  
|ppMuscleKgTrunk|Float |躯干肌肉量|48|kg

注意：在使用时拿到对象，请调用对应的get方法来获取对应的值

### 1.6.2 身体类型-PPBodyDetailType

| 参数| 说明| type |  
|------|--------|--------|  
|PPBodyTypeThin|偏瘦型|0|  
|PPBodyTypeThinMuscle|偏瘦肌肉型|1|  
|PPBodyTypeMuscular|肌肉发达型|2|  
|PPBodyTypeLackofexercise|缺乏运动型|3|  
|PPBodyTypeStandard|标准型|4|  
|PPBodyTypeStandardMuscle|标准肌肉型|5|  
|PPBodyTypeObesFat|浮肿肥胖型|6|  
|PPBodyTypeFatMuscle|偏胖肌肉型|7|  
|PPBodyTypeMuscleFat|肌肉型偏胖|8|

### 1.6.3 设备对象-PPBluetoothAdvDeviceModel

| 属性名 | 类型 | 描述 |备注|  
| ------ | ---- | ---- | ---- |  
| deviceMac | String | 设备mac|设备唯一标识|  
| deviceName | String | 设备蓝牙名称 |设备名称标识|  
| devicePower | Int | 电量 |-1标识不支持 >0为有效值|  
| rssi | Int | 蓝牙信号强度 |
| deviceType | PPDeviceType | 设备类型 |PPDeviceTypeUnknow, //未知  PPDeviceTypeCF,//体脂秤  PPDeviceTypeCE, //体重秤  PPDeviceTypeCB,// 婴儿秤  PPDeviceTypeCA; // 厨房秤 |  
| deviceProtocolType | PPDeviceProtocolType | 协议模式 |  PPDeviceProtocolTypeUnknow(0),//未知 PPDeviceProtocolTypeV2(1),//使用V2.x蓝牙协议      PPDeviceProtocolTypeV3(2),//使用V3.x蓝牙协议  PPDeviceProtocolTypeTorre(3),//Torre协议     PPDeviceProtocolTypeV4(4);//V4.0协议 |  
| deviceCalcuteType | PPDeviceCalcuteType | 计算方式 |PPDeviceCalcuteTypeUnknow(0),//未知   PPDeviceCalcuteTypeInScale(1), //秤端计算   PPDeviceCalcuteTypeDirect(2), //直流4DC   PPDeviceCalcuteTypeAlternate(3),//交流4AC  br> PPDeviceCalcuteTypeAlternate8(4),// 8电极交流算法   PPDeviceCalcuteTypeNormal(5), //默认默认体脂率采用原始值-4AC   PPDeviceCalcuteTypeNeedNot(6),//不需要计算   PPDeviceCalcuteTypeAlternate8_0(7);//8电极算法，bhProduct =0 |  
| deviceAccuracyType | PPDeviceAccuracyType | 精度 |PPDeviceAccuracyTypeUnknow(0), //未知精度   PPDeviceAccuracyTypePoint01(1), //精度0.1   PPDeviceAccuracyTypePoint005(2),//精度0.05   PPDeviceAccuracyTypePointG(3), // 1G精度  PPDeviceAccuracyTypePoint01G(4), // 0.1G精度   PPDeviceAccuracyTypePoint001(5); //0.01KG精度|  
| devicePowerType | PPDevicePowerType | 供电模式 |PPDevicePowerTypeUnknow(0),//未知 PPDevicePowerTypeBattery(1),//电池供电  PPDevicePowerTypeSolar(2),//太阳能供电  PPDevicePowerTypeCharge(3); //充电款 |  
| deviceConnectType | PPDeviceConnectType | 设备连接类型 |PPDeviceConnectTypeUnknow(0),  PPDeviceConnectTypeBroadcast(1), //广播  PPDeviceConnectTypeDirect(2),//直连  PPDeviceConnectTypeBroadcastOrDirect(3); //广播或直连 |  
| deviceFuncType | PPDeviceFuncType | 功能类型 | PPDeviceFuncTypeWeight //称重   PPDeviceFuncTypeFat //测脂   PPDeviceFuncTypeHeartRate //心律   PPDeviceFuncTypeHistory //历史   PPDeviceFuncTypeSafe //孕妇   PPDeviceFuncTypeBMDJ //闭目单脚   PPDeviceFuncTypeBaby //抱婴模式   PPDeviceFuncTypeWifi //wifi配网  PPDeviceFuncTypeTime //时钟   PPDeviceFuncTypeKeyVoice //按键音量 |

### 1.6.4 设备单位-PPDeviceUnit

| 枚举类型 | type | 单位 |
|------|--------|--------| 
|PPUnitKG| 0 | KG |  
|PPUnitLB| 1 | LB |  
|PPUnitSTLB| 2 | ST_LB |  
|PPUnitJin| 3 | 斤 |  
|PPUnitG| 4 | g |  
|PPUnitLBOZ| 5 | lb:oz |  
|PPUnitOZ| 6 | oz |  
|PPUnitMLWater| 7 | ml（水） |  
|PPUnitMLMilk| 8 | ml（牛奶） |  
|PPUnitFLOZWater| 9 | fl_oz（水） |  
|PPUnitFLOZMilk| 10 | fl_oz（牛奶） |  
|PPUnitST| 11 | ST |

<br/>
<br/>

[上一页: 5.厨房秤接入](KitchenScaleIntegrate.md)



