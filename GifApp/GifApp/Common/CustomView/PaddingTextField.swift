//
//  PaddingTextField.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/21.
//

import UIKit

@IBDesignable
final class PaddingTextField: UITextField {

    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: frame.height))
            leftView = paddingView
            leftViewMode = ViewMode.always
        }
    }
}
