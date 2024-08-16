//
//  UIPaddingLabel.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/14.
//

import UIKit

open class UIPaddingLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

extension UILabel {
    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        if let label = self as? UIPaddingLabel {
            label.textInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }

    func setCornerRadius(_ radius: CGFloat) {
        if let label = self as? UIPaddingLabel {
            label.cornerRadius = radius
        }
    }
}
