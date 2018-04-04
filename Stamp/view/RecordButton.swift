//
//  RecordButton.swift
//

import UIKit

final class RecordButton: UIButton {
    override func draw(_ rect: CGRect) {
        imageView?.clipsToBounds = false
        imageView?.layer.cornerRadius = 10
        imageView?.layer.shadowColor = UIColor.black.cgColor
        imageView?.layer.shadowOffset = .zero
        imageView?.layer.shadowOpacity = 0.3
        imageView?.layer.shadowRadius = 4

        super.draw(rect)
    }
}
