//
//  BodyDetailViewController.swift
//  PPBluetoothKitDemo
//
//
//

import UIKit
import PPCalculateKit

class BodyDetailViewController: UIViewController {

    var detailModel: PPBodyDetailModel?
    var errorType:PPBodyfatErrorType = .ERROR_TYPE_NONE

    private var bodyDataArray = [PPBodyDetailInfoModel]()

    private let itemSpacing: CGFloat = 12
    private let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
    private var bodyDataJson:[String: Any] = [:]

    private lazy var collectionView: UICollectionView = {
        let layout = BodyDetailFlowLayout()
        layout.minimumLineSpacing = self.itemSpacing
        layout.minimumInteritemSpacing = self.itemSpacing
        layout.sectionInset = self.sectionInset
        layout.heightDelegate = self

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BodyDetailItemCell.self, forCellWithReuseIdentifier: BodyDetailItemCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Localization.string("Measurement_results")
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)

        self.setupUI()
        self.loadData()
    }

    private func setupUI() {
        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    private func loadData() {

        guard let data = self.detailModel?.data else { return }

        if Localization.language == .chinese {
            
            self.bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_zh.json")
        } else {
            
            self.bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
        }

        // Get all body indicator arrays(detailModel.data). 获取所有身体指标数组(detailModel.data)
        self.bodyDataArray = data["lefuBodyData"] as? [PPBodyDetailInfoModel] ?? []
        self.bodyDataArray.removeAll { info in
            return (info.bodyParamKey == "ppHeartRate" && info.currentValue < 1) || info.bodyParamKey == "ppFootLen"
        }
        
        
        self.collectionView.reloadData()
    }
}

extension BodyDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, BodyDetailFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bodyDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyDetailItemCell.reuseIdentifier, for: indexPath) as! BodyDetailItemCell
        self.configure(cell: cell, with: self.bodyDataArray[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.showDetailAlert(for: self.bodyDataArray[indexPath.item])
    }

    
    private func configure(cell: BodyDetailItemCell, with data: PPBodyDetailInfoModel) {

        let name = bodyDataJson[data.bodyParamNameString] ?? ""
        let standardTitle = bodyDataJson[data.standardTitle] ?? ""
        
        let value = self.formattedValue(for: data)
        
        cell.configure(name: "\(name)", value: "\(value)", standard: "\(standardTitle)")
        
//        print("name:\(name) currentValue:\(value) range:\(data.standardArray)  standardTitle:\(standardTitle) standSuggestion:\(bodyDataJson[data.standSuggestion] ?? "") standeValuation:\(bodyDataJson[data.standeValuation] ?? "")")
    }

    private func formattedValue(for data: PPBodyDetailInfoModel) -> String {
        if data.bodyParamKey == "ppWeightKg" {
            return String(format: "%.2f %@", Float(data.currentValue), data.unit)
        }
        return String(format: "%.1f %@", Float(data.currentValue), data.unit)
    }

    private func formattedRange(for data: PPBodyDetailInfoModel) -> String {
        return "\(data.standardArray)"
    }

    private func showDetailAlert(for data: PPBodyDetailInfoModel) {
        let name = self.bodyDataJson[data.bodyParamNameString] as? String ?? ""
        let standardTitle = self.bodyDataJson[data.standardTitle] as? String ?? ""
        let suggestion = self.bodyDataJson[data.standSuggestion] as? String ?? ""
        let evaluation = self.bodyDataJson[data.standeValuation] as? String ?? ""

        let alert = BodyDetailAlertViewController(title: name.isEmpty ? "Details" : name, items: [
            (title: "name", value: name),
            (title: "currentValue", value: "\(data.currentValue)"),
            (title: "range", value: self.formattedRange(for: data)),
            (title: "standardTitle", value: standardTitle),
            (title: "standSuggestion", value: suggestion),
            (title: "standeValuation", value: evaluation),
        ])
        self.present(alert, animated: false)
    }

    func flowLayout(_ layout: BodyDetailFlowLayout, heightForItemAt indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        let data = self.bodyDataArray[indexPath.item]
        let name = self.bodyDataJson[data.bodyParamNameString] as? String ?? ""
        return BodyDetailItemCell.height(forName: name, itemWidth: itemWidth)
    }
}
