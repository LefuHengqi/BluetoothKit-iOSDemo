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

# Calculation library usage - calcute - CalcuteInfoViewController

## 1.1 Agreement regarding measurement of body data

### 1.1.1 Precautions for weight and body fat measurement

- the scale supports body fat measurement
- Step on the scale barefoot and make contact with the corresponding electrodes
- The weight interface returns weight (kg) and impedance information
- Ensure that the input for body parameters such as height and age is correct

### 1.1.2 Body fat calculation

#### Basic parameter agreement

| Category | Input range | Unit |    
|:----|:--------|:--:|    
| Height | 100-220 | cm |    
| Age | 10-99 | Years |    
| Gender | 0/1 | Female/Male |    
| Weight | 10-200 | kg |

- Height, age, gender, and corresponding impedance are required. Call the corresponding calculation library to obtain it.
- The body fat data items involved by the 8 electrodes can only be used with a scale that has 8 electrodes.

## 1.2 Description of parameters required for body fat calculation

Based on the weight and impedance parsed from the Bluetooth protocol, along with user data such as height, age, and gender, calculate multiple body fat parameters such as body fat percentage.

### 1.2.1 PPBluetoothScaleBaseModel

| Parameters | Comment| Description |  
| :--------  | :-----  | :----:  |  
| weight | Weight | Actual weight multiplied by 100 and rounded|  
| impedance|Impedance for four-electrode algorithm |Fields for four-electrode algorithm|     |  
| isHeartRating| Whether heart rate is being measured |Heart rate measurement status|  
| unit| Current unit on the scale |Real-time unit|  
| heartRate| Heart rate |Effectiveness of heart rate on the scale|  
| isPlus| Whether it is a positive number |Effectiveness of food scale|  
| memberId| Member ID |Effective when the scale supports users|  
| z100KhzLeftArmEnCode| 100kHz left hand impedance encryption value |Eight-electrode fields|  
| z100KhzLeftLegEnCode| 100kHz left foot impedance encryption value |Eight-electrode fields|  
| z100KhzRightArmEnCode| 100kHz right hand impedance encryption value |Eight-electrode fields|  
| z100KhzRightLegEnCode| 100kHz right foot impedance encryption value |Eight-electrode fields|  
| z100KhzTrunkEnCode| 100kHz trunk impedance encryption value |Eight-electrode fields|  
| z20KhzLeftArmEnCode| 20kHz left hand impedance encryption value |Eight-electrode fields|  
| z20KhzLeftLegEnCode| 20kHz left foot impedance encryption value |Eight-electrode fields|  
| z20KhzRightArmEnCode|20kHz right hand impedance encryption value |Eight-electrode fields|  
| z20KhzRightLegEnCode| 20kHz right foot impedance encryption value |Eight-electrode fields|  
| z20KhzTrunkEnCode| 20kHz trunk impedance encryption value |Eight-electrode fields|

### 1.2.2 Calculation type description PPBluetoothDefine - deviceCalcuteType

| PPDeviceCalcuteType | Comments | Scope of use |
| :-------- | :----- | :----: |
| PPDeviceCalcuteTypeInScale | Scale side calculations | Scale side calculations |
| PPDeviceCalcuteTypeDirect| DC| Four-electrode DC grease scale|
| PPDeviceCalcuteTypeAlternate| Four-electrode AC | Four-electrode body fat scale |
| PPDeviceCalcuteTypeAlternate8| 8-electrode AC algorithm | Eight-electrode body fat scale |
| PPDeviceCalcuteTypeNormal| Default calculation method | 4-electrode AC |
| PPDeviceCalcuteTypeNeedNot| No calculation required | Food scale or body scale |
| PPDeviceCalcuteTypeAlternate8_0| 8-electrode algorithm | Eight-electrode body fat scale |

### 1.2.3 Basic user information description PPBluetoothDeviceSettingModel

| Parameters | Comments | Description |
| :-------- | :----- | :----: |
| height| height|all body fat scales|
| age| age|all body fat scales|
| gender| Gender|All body fat scales|

## 1.3 Eight-electrode AC body fat calculation - 8AC - CalcuelateResultViewController - calcuteType8AC

**Eight-electrode body fat calculation example:**

```
// Calculation result class:  PPBodyFatModel


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

// fatModel is the calculated result
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.4 Four-electrode DC fluid grease calculation - 4DC - CalcuelateResultViewController - calcuteType4DC

**Four-electrode DC body fat calculation example:**

```
// Calculation result class: PPBodyFatModel

let fatModel = PPBodyFatModel(userModel: userModel,
                                      deviceCalcuteType: PPDeviceCalcuteType.direct,
                                      deviceMac: "c1:c1:c1:c1",
                                      weight: CGFloat(self.myUserModel.weight),
                                      heartRate: 0,
                                      andImpedance: self.myUserModel.impedance)
        
// fatModel is the calculated result
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.5 Four-electrode AC body fat calculation - 4AC - CalcuelateResultViewController - calcuteType4AC

**Four-electrode AC body fat calculation example:**

```
// Calculation result class: PPBodyFatModel

var fatModel:PPBodyFatModel!

fatModel =  PPBodyFatModel(userModel: userModel,
                                       deviceCalcuteType: PPDeviceCalcuteType.alternate,
                                       deviceMac: "c1:c1:c1:c1",
                                       weight: CGFloat(self.myUserModel.weight),
                                       heartRate: 0,
                                       andImpedance: self.myUserModel.impedance)
                                       
// fatModel is the calculated result
if (fatModel.errorType == .ERROR_TYPE_NONE) {

	print("\(fatModel.description)")
} else {

	print("errorType:\(fatModel.errorType)")
}
```

## 1.6 Entity class objects and specific parameter descriptions

### 1.6.1 PPBodyFatModel body fat calculation object parameter description

- 24 items of data corresponding to four electrodes
- 48 items of data corresponding to eight electrodes

| Parameters | Parameter type | Description | Data type | Remarks
|------|--------|--------|--------|--------|
|ppBodyBaseModel| PPBodyBaseModel |Input parameters for body fat calculation|Basic input parameters|Contains device information, user basic information, weight and heart rate|Body fat scale
|ppSDKVersion| String |Computation library version number|Return parameters|
|ppSex| PPUserGender|Gender|Return parameters| PPUserGenderFemale female PPUserGenderMale male
|ppHeightCm|Int |Height|Return parameters|cm
|ppAge|Int |Age|Return Parameters|Years
|errorType|BodyFatErrorType |Error type|Return parameters|PP_ERROR_TYPE_NONE(0), no error PP_ERROR_TYPE_AGE(1), age error PP_ERROR_TYPE_HEIGHT(2), height error PP_ERROR_TYPE_WEIGHT(3), weight error PP_ERROR_TYPE_SEX(4) gender error PP_ERROR_TYPE_PEOPLE_TYPE (5) The following impedance is incorrect PP_ERROR_TYPE_IMPEDANCE_TWO_LEGS(6) PP_ERROR_TYPE_IMPEDANCE_TWO_ARMS(7)PP_ERROR_TYPE_IMPEDANCE_LEFT_BODY(8) PP_ERROR_TYPE_IMPEDANCE_RIGHT_ARM(9)PP_ERROR_TYPE_IMPEDANCE_LEFT_ARM(10) PP _ERROR_TYPE_IMPEDANCE_LEFT_LEG(11) PP_ERROR_TYPE_IMPEDANCE_RIGHT_LEG(12) PP_ERROR_TYPE_IMPEDANCE_TRUNK(13) |
|bodyDetailModel|PPBodyDetailModel|Data interval range and introduction description|
|ppWeightKg|Float |Weight|24&48|kg|
|ppBMI|Float|Body Mass Index|24&48|
|ppFat|Float |Fat rate|24&48|% |
|ppBodyfatKg|Float |Fat mass|24&48|kg|
|ppMusclePercentage|Float |Muscle Percentage|24&48|%|
|ppMuscleKg|Float |Muscle mass|24&48|kg |
|ppBodySkeletal|Float |Skeletal muscle rate|24&48|% |
|ppBodySkeletalKg|Float |Skeletal muscle mass|24&48|kg |
|ppWaterPercentage|Float |Moisture percentage|24&48|% |
|ppWaterKg|Float |Moisture content|24&48|kg
|ppProteinPercentage|Float |Protein rate|24&48|%
|ppProteinKg|Float |Protein mass|24&48|kg
|ppLoseFatWeightKg|Float |Lean body mass|24&48|kg
|ppBodyFatSubCutPercentage|Float |Subcutaneous fat rate|24&48|%
|ppBodyFatSubCutKg|Float |Subcutaneous fat mass|24&48|kg
|ppHeartRate|Int |Heart rate|24&48|bmp This value is related to the scale, and is valid if it is greater than 0
|ppBMR|Int |Basal Metabolism|24&48|
|ppVisceralFat|Int |Visceral fat level|24&48|
|ppBoneKg|Float |Bone mass|24&48|kg|
|ppBodyMuscleControl|Float |Muscle control volume|24&48|kg|
|ppFatControlKg|Float |Fat control volume|24&48|kg|
|ppBodyStandardWeightKg|Float |Standard weight|24&48|kg|
|ppIdealWeightKg|Float |Ideal Weight|24&48|kg|
|ppControlWeightKg|Float |Control weight|24&48|kg|
|ppBodyType|PPBodyDetailType |Body type|24&48|PPBodyDetailType has a separate description|
|ppFatGrade|PPBodyFatGrade|Obesity grade|24&48|PPBodyGradeFatThin(0), //!< Thin PPBodyGradeFatStandard(1),//!< Standard PPBodyGradeFatOverwight(2), //!< Overweight PPBodyGradeFatOne(3),//!< Obesity level 1PPBodyGradeFatTwo(4),//!< Obesity level 2PPBodyGradeFatThree(5);//!< Obesity level 3|
|ppBodyHealth|PPBodyHealthAssessment |Health Assessment|24&48|PPBodyAssessment1(0), //!< Hidden health risks PPBodyAssessment2(1), //!< Sub-health PPBodyAssessment3(2), //!< General PPBodyAssessment4(3), // !< GoodPPBodyAssessment5(4); //!< Very good|
|ppBodyAge|Int|Body Age|24&48|Years|
|ppBodyScore|Int |Body Score|24&48|Points|
|ppCellMassKg|Float |Body Cell Mass|48|kg|
|ppDCI|Int |Recommended calorie intake|48|Kcal/day|
|ppMineralKg|Float |Inorganic salt amount|48|kg|
|ppObesity|Float |Obesity|48|%|
|ppWaterECWKg|Float |Extracellular water volume|48|kg|
|ppWaterICWKg|Float |Intracellular water volume|48|kg|
|ppBodyFatKgLeftArm|Float |Left hand fat mass|48|kg|
|ppBodyFatKgLeftLeg|Float |Left foot fat amount|48|kg|
|ppBodyFatKgRightArm|Float |Right hand fat mass|48|kg|
|ppBodyFatKgRightLeg|Float |Fat mass of right foot|48|kg|
|ppBodyFatKgTrunk|Float |Trunk fat mass|48|kg|
|ppBodyFatRateLeftArm|Float |Left hand fat rate|48|%|
|ppBodyFatRateLeftLeg|Float |Left foot fat rate|48|%|
|ppBodyFatRateRightArm|Float |Right hand fat rate|48|%|
|ppBodyFatRateRightLeg|Float |Right foot fat rate|48|%|
|ppBodyFatRateTrunk|Float |Trunk fat rate|48|%|
|ppMuscleKgLeftArm|Float |Left hand muscle mass|48|kg|
|ppMuscleKgLeftLeg|Float |Left foot muscle mass|48|kg|
|ppMuscleKgRightArm|Float |Right hand muscle mass|48|kg|
|ppMuscleKgRightLeg|Float |Right foot muscle mass|48|kg|
|ppMuscleKgTrunk|Float |Trunk muscle mass|48|kg|

Note: When using the object, please call the corresponding get method to obtain the corresponding value.

### 1.6.2 Body type-PPBodyDetailType

| Parameters | Description | type |
|------|--------|--------|
|PPBodyTypeThin|Thin type|0|
|PPBodyTypeThinMuscle|Thin Muscle|1|
|PPBodyTypeMuscular|Muscular|2|
|PPBodyTypeLackofexercise|Lack of exercise|3|
|PPBodyTypeStandard|Standard type|4|
|PPBodyTypeStandardMuscle|Standard muscle type|5|
|PPBodyTypeObesFat|Puffy and obese type|6|
|PPBodyTypeFatMuscle|Fat muscular type|7|
|PPBodyTypeMuscleFat|Muscle type fat|8|

### 1.6.3 Device object-PPBluetoothAdvDeviceModel

|Attribute name|Type|Description|Remarks|
| ------ | ---- | ---- | ---- |
| deviceMac | String | device mac|device unique identifier|
| deviceName | String | Device Bluetooth name | Device name identification |
| devicePower | Int | Power | -1 flag is not supported > 0 is a valid value |
| rssi | Int | Bluetooth signal strength |
| deviceType | PPDeviceType | Device type |PPDeviceTypeUnknow, //Unknown PPDeviceTypeCF, //Body fat scale PPDeviceTypeCE, //Weight scale PPDeviceTypeCB, // Baby scale PPDeviceTypeCA; // Kitchen scale |
| deviceProtocolType | PPDeviceProtocolType | Protocol mode | PPDeviceProtocolTypeUnknow(0),//Unknown PPDeviceProtocolTypeV2(1),//Use V2.x Bluetooth protocol PPDeviceProtocolTypeV3(2),//Use V3.x Bluetooth protocol PPDeviceProtocolTypeTorre(3),//Torre ProtocolPPDeviceProtocolTypeV4(4);//V4.0 protocol|
| deviceCalcuteType | PPDeviceCalcuteType | Calculation method |PPDeviceCalcuteTypeUnknow(0),//Unknown PPDeviceCalcuteTypeInScale(1), //Scale side calculation PPDeviceCalcuteTypeDirect(2), //DC 4DC PPDeviceCalcuteTypeAlternate(3),//AC 4AC br> PPDeviceCalcuteTypeAlternate8(4) ,//8-electrode AC algorithm PPDeviceCalcuteTypeNormal(5), //The default body fat rate adopts the original value -4AC PPDeviceCalcuteTypeNeedNot(6),//No need to calculate PPDeviceCalcuteTypeAlternate8_0(7);//8-electrode algorithm, bhProduct =0 |
| deviceAccuracyType | PPDeviceAccuracyType | Precision|PPDeviceAccuracyTypeUnknow(0), //Unknown precision PPDeviceAccuracyTypePoint01(1), //Precision 0.1 PPDeviceAccuracyTypePoint005(2), //Precision 0.05 PPDeviceAccuracyTypePointG(3), // 1G precision PPDeviceAccuracyTypePoint01G(4), // 0.1G accuracy PPDeviceAccuracyTypePoint001(5); //0.01KG accuracy|
| devicePowerType | PPDevicePowerType | Power supply mode |PPDevicePowerTypeUnknow(0),//Unknown PPDevicePowerTypeBattery(1),//Battery powered PPDevicePowerTypeSolar(2),//Solar powered PPDevicePowerTypeCharge(3); //Charging model|
| deviceConnectType | PPDeviceConnectType | Device connection type | PPDeviceConnectTypeUnknow(0), PPDeviceConnectTypeBroadcast(1), //Broadcast PPDeviceConnectTypeDirect(2), //Direct connection PPDeviceConnectTypeBroadcastOrDirect(3); //Broadcast or direct connection|
| deviceFuncType | PPDeviceFuncType | Function type | PPDeviceFuncTypeWeight //Weighing PPDeviceFuncTypeFat //Fat measurement PPDeviceFuncTypeHeartRate //Heart rhythm PPDeviceFuncTypeHistory //History PPDeviceFuncTypeSafe //Pregnant women PPDeviceFuncTypeBMDJ //Close eyes and one foot PPDeviceFuncTypeBaby //Baby mode PPDeviceFuncTypeWifi //wifi distribution network PPDeviceFuncTypeTime //Clock PPDeviceFuncTypeKeyVoice //Key volume |

### 1.6.4 Device unit-PPDeviceUnit

| enum type | type | unit |
|------|--------|--------| 
|PPUnitKG| 0 | KG |
|PPUnitLB| 1 | LB |
|PPUnitSTLB| 2 | ST_LB |
|PPUnitJin| 3 | Jin|
|PPUnitG| 4 | g |
|PPUnitLBOZ| 5 | lb:oz |
|PPUnitOZ| 6 | oz |
|PPUnitMLWater| 7 | ml (water) |
|PPUnitMLMilk| 8 | ml (milk) |
|PPUnitFLOZWater| 9 | fl_oz (water) |
|PPUnitFLOZMilk| 10 | fl_oz (milk) |
|PPUnitST| 11 | ST |

<br/>
<br/>

[Previous page: 5.Integrated kitchen scale](KitchenScaleIntegrate_EN.md)



