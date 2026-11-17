import UIKit

protocol BodyDetailFlowLayoutDelegate: AnyObject {
    func flowLayout(_ layout: BodyDetailFlowLayout, heightForItemAt indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
}

class BodyDetailFlowLayout: UICollectionViewFlowLayout {

    weak var heightDelegate: BodyDetailFlowLayoutDelegate?

    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    private var cachedContentSize: CGSize = .zero

    override var collectionViewContentSize: CGSize {
        return self.cachedContentSize
    }

    override func prepare() {
        super.prepare()

        self.cachedAttributes.removeAll()

        guard let collectionView = self.collectionView else { return }

        let availableWidth = collectionView.bounds.width - self.sectionInset.left - self.sectionInset.right
        let itemWidth = floor((availableWidth - self.minimumInteritemSpacing) / 2)
        guard itemWidth > 0 else { return }

        var originY = self.sectionInset.top
        var lastRowBottom = self.sectionInset.top

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            var itemIndex = 0
            while itemIndex < itemCount {
                let columnCount = min(2, itemCount - itemIndex)
                var rowAttributes = [UICollectionViewLayoutAttributes]()
                var rowHeight: CGFloat = 0

                for column in 0..<columnCount {
                    let indexPath = IndexPath(item: itemIndex + column, section: section)
                    let height = self.heightDelegate?.flowLayout(self, heightForItemAt: indexPath, itemWidth: itemWidth) ?? 0
                    rowHeight = max(rowHeight, height)
                    rowAttributes.append(UICollectionViewLayoutAttributes(forCellWith: indexPath))
                }

                for (column, attribute) in rowAttributes.enumerated() {
                    attribute.frame = CGRect(
                        x: self.sectionInset.left + CGFloat(column) * (itemWidth + self.minimumInteritemSpacing),
                        y: originY,
                        width: itemWidth,
                        height: rowHeight
                    )
                }

                self.cachedAttributes.append(contentsOf: rowAttributes)
                lastRowBottom = originY + rowHeight
                originY = lastRowBottom + self.minimumLineSpacing
                itemIndex += columnCount
            }
        }

        let contentHeight = self.cachedAttributes.isEmpty
            ? self.sectionInset.top + self.sectionInset.bottom
            : lastRowBottom + self.sectionInset.bottom
        self.cachedContentSize = CGSize(width: collectionView.bounds.width, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cachedAttributes.first { $0.indexPath == indexPath }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { return false }
        return collectionView.bounds.width != newBounds.width
    }
}
