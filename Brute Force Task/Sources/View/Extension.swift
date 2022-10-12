//
//  Extension.swift
//  Brute Force Task
//
//  Created by Радик Ахметзянов on 12.10.2022.
//

import Foundation
import UIKit

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 20, y: 6, width: 20, height: 18))
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }

    func setRightIcon() {
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 20))
        iconContainerView.addSubview(ViewController.activityIndicator)
        rightView = iconContainerView
        rightViewMode = .always
    }
}
