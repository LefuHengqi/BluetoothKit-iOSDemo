//
//  XM_FoodDetailModel.swift
//  XMProject
//
//  Created by lefu on 2025/6/5
//  


import Foundation


class XM_FoodDetailModel: NSObject {

    /// 食物id，前端展示，获取详情使用
    var foodId: String? = ""
    /// 食物名称
    var foodName: String? = ""
    /// 品牌名称
    var brandName: String? = ""
    /// 份量
    var servingQty: Int? = 0
    /// 份量单位
    var servingUnit: String? = ""
    /// 份量重量
    var servingWeightGrams: Float? = 0
    /// 卡路里
    var lfCalories: Float? = 0
    /// 总脂肪
    var lfTotalFat: Float? = 0
    /// 饱和脂肪
    var lfSaturatedFat: Float? = 0
    /// 胆固醇
    var lfCholesterol: Float? = 0
    /// 钠含量
    var lfSodium: Float? = 0
    /// 总碳水化合物
    var lfTotalCarbohydrate: Float? = 0
    /// 膳食纤维
    var lfDietaryFiber: Float? = 0
    /// 糖含量
    var lfSugars: Float? = 0
    /// 蛋白质含量
    var lfProtein: Float? = 0
    /// 钾含量
    var lfPotassium: Float? = 0
    /// 磷含量
    var lfP: Float? = 0
    /// 条形码
    var upc: String? = ""
    /// 纬度
    var lat: Float? = 0
    /// 经度
    var lng: Float? = 0
    /// 餐饮类型
    var mealType: Int? = 0
    /// 子菜谱
    var subRecipeId: Int? = 0
    /// 砖块代码
    var brickCode: String? = ""
    /// 缩略图
    var thumb: String? = ""
    /// 高分辨率图像
    var highres: String? = ""
    /// 成分说明
    var nfIngredientStatement: String? = ""
    /// 地区
    var locales: String? = ""
    /// 是否生食0=否，1=是
    var isRawFood: Int? = 0
    /// 是否收藏0=否，1=是
    var isCollect: Int? = 0
    
    
    
    var calciumMg:Float? = 0          // 钙
    var vitaminAG:Float? = 0          // 维生素A
    var vitaminB1G:Float? = 0        // 维生素B1 
    var vitaminB2G:Float? = 0         // 维生素B2 
    var vitaminB6G:Float? = 0        // 维生素B6 
    var vitaminB12G:Float? = 0        // 维生素B12 
    var vitaminCG:Float? = 0          // 维生素C 
    var vitaminDG:Float? = 0          // 维生素D 
    var vitaminEG:Float? = 0          // 维生素E 
    var niacinMg:Float? = 0           // 烟酸 
    var phosphorusMg:Float? = 0       // 磷 
    var potassiumMg:Float? = 0        // 钾 
    var magnesiumMg:Float? = 0        // 镁 
    var ironMg:Float? = 0             // 铁 
    var zincMg:Float? = 0             // 锌 
    var seleniumMg:Float? = 0         // 硒 
    var copperMg:Float? = 0           // 铜 
    var manganeseMg:Float? = 0        // 锰
    
    var carotene:Float? = 0           // 胡萝卜素
    
    var water:Float? = 0           // 水分
    
    
    /// 反式脂肪
    var pCusTransFat: Float? = 0
    
    /// 食物头像编号
    var imageIndex = 0

    
    func XM_TransformPPFoodInfo(foodNo:Int)->PPKorreFoodInfo {
        
        let XM_WG:Float = self.servingWeightGrams ?? 0
        
        let XM_Food = PPKorreFoodInfo()
        XM_Food.foodNo = foodNo
        XM_Food.foodRemoteId = self.foodId ?? ""
        XM_Food.foodWeight = CGFloat(XM_WG)
        XM_Food.foodName = self.foodName ?? ""
        
        XM_Food.calories = CGFloat(self.lfCalories ?? 0) // 卡路里
        XM_Food.protein = CGFloat(self.lfProtein ?? 0) // 蛋白质
        XM_Food.totalFat = CGFloat(self.lfTotalFat ?? 0) // 总脂肪
        XM_Food.saturatedFat = CGFloat(self.lfSaturatedFat ?? 0) // 饱和脂肪
        XM_Food.transFat = CGFloat(self.pCusTransFat ?? 0) // 反式脂肪
        XM_Food.totalCarbohydrates = CGFloat(self.lfTotalCarbohydrate ?? 0)  // 总碳水化合物
        XM_Food.dietaryFiber = CGFloat(self.lfDietaryFiber ?? 0)  // 膳食纤维
        XM_Food.sugars = CGFloat(self.lfSugars ?? 0)  // 糖
        XM_Food.cholesterol = CGFloat(self.lfCholesterol ?? 0)  // 胆固醇
        XM_Food.sodium = CGFloat(self.lfSodium ?? 0)  // 钠

        XM_Food.calciumMg = CGFloat(self.calciumMg ?? 0) // 钙 (mg)
        XM_Food.vitaminAG = CGFloat(self.vitaminAG ?? 0) // 维生素A (g)
        XM_Food.vitaminB1G = CGFloat(self.vitaminB1G ?? 0) // 维生素B1 (g)
        XM_Food.vitaminB2G = CGFloat(self.vitaminB2G ?? 0) // 维生素B2 (g)
        XM_Food.vitaminB6G = CGFloat(self.vitaminB6G ?? 0)  // 维生素B6 (g)
        XM_Food.vitaminB12G = CGFloat(self.vitaminB12G ?? 0) // 维生素B12 (g)
        XM_Food.vitaminCG = CGFloat(self.vitaminCG ?? 0) // 维生素C (g)
        XM_Food.vitaminDG = CGFloat(self.vitaminDG ?? 0) // 维生素D (g)
        XM_Food.vitaminEG = CGFloat(self.vitaminEG ?? 0) // 维生素E (g)
        XM_Food.niacinMg = CGFloat(self.niacinMg ?? 0) // 烟酸 (mg)
        XM_Food.phosphorusMg = CGFloat(self.phosphorusMg ?? 0) // 磷 (mg)
        XM_Food.potassiumMg = CGFloat(self.potassiumMg ?? 0)  // 钾 (mg)
        XM_Food.magnesiumMg = CGFloat(self.magnesiumMg ?? 0) // 镁 (mg)
        XM_Food.ironMg = CGFloat(self.ironMg ?? 0)  // 铁 (mg)
        XM_Food.zincMg = CGFloat(self.zincMg ?? 0)  // 锌 (mg)
        XM_Food.seleniumMg = CGFloat(self.seleniumMg ?? 0) // 硒 (mg)
        XM_Food.copperMg = CGFloat(self.copperMg ?? 0)  // 铜 (mg)
        XM_Food.manganeseMg = CGFloat(self.manganeseMg ?? 0) // 锰 (mg)
        XM_Food.imageIndex = self.imageIndex
        
        return XM_Food
    }
    
}
