//
//  CarouselView.swift
//  CustomComponentsApp
//
//  Created by Станислав Дейнекин on 31.10.2025.
//

import UIKit

final class CarouselView: UICollectionView {

    var inset: CGFloat = 0 {
        didSet {
            updateLayoutInsets()
        }
    }

    var itemSpacing: CGFloat = 8.0 {
        didSet {
            updateItemSpacing()
        }
    }

    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = scrollDirection
        }
    }

    convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
        self.inset = inset
        self.decelerationRate = .normal
        updateLayoutInsets()
        updateItemSpacing()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCellScaling()
    }

    // MARK: - Private Methods
    private func updateLayoutInsets() {
        (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    private func updateItemSpacing() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = itemSpacing
        }
    }

    private func updateCellScaling() {
        guard let visibleCells = visibleCells as? [CarouselCell] else { return }

        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)

        // Находим первую полностью видимую ячейку слева
        var leftMostVisibleCell: CarouselCell?
        var minFullyVisibleX = CGFloat.greatestFiniteMagnitude

        for cell in visibleCells {
            let cellFrame = cell.frame
            // Проверяем, полностью ли она видна
            let isFullyVisible = cellFrame.minX >= visibleRect.minX && cellFrame.maxX <= visibleRect.maxX

            if isFullyVisible && cellFrame.minX < minFullyVisibleX {
                minFullyVisibleX = cellFrame.minX
                leftMostVisibleCell = cell
            }
        }

        // Если она не полностью видна то находим следующую
        if leftMostVisibleCell == nil {
            leftMostVisibleCell = visibleCells.min(by: { $0.frame.minX < $1.frame.minX })
        }

        // Для плавного масштабирования
        for cell in visibleCells {
            let cellFrame = cell.frame
            let cellCenterX = cellFrame.midX
            // Смещаем центр влево
            let visibleCenterX = visibleRect.minX + bounds.width * 0.2

            let distance = abs(cellCenterX - visibleCenterX)
            let maxDistance = bounds.width * 0.6

            let scale = max(1.0 - (distance / maxDistance) * 0.2, 0.85)
            let alpha = max(1.0 - (distance / maxDistance) * 0.3, 0.7)

            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                cell.updateScaleAndAlpha(scale: scale, alpha: alpha)
            })
        }
    }

    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        super.scrollToItem(at: indexPath, at: .left, animated: animated)
    }

    // MARK: - UIScrollViewDelegate методы для плавного скролла
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Вычисляем индекс для скролла
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidth = bounds.width * 0.35 + itemSpacing
        let targetX = targetContentOffset.pointee.x
        let proposedIndex = round(targetX / cellWidth)

        // Изменим позицию чтобы ячейка была полностью видна слева
        targetContentOffset.pointee.x = proposedIndex * cellWidth
    }
}
