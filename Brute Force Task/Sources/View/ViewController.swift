//
//  ViewController.swift
//  Brute Force Task
//
//  Created by Радик Ахметзянов on 11.10.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "password"
        textField.textAlignment = .center
        textField.layer.cornerRadius = 20
        textField.setRightIcon()
        textField.setLeftIcon(UIImage(named: "") ?? UIImage())
        textField.text = ""
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Угадать пароль?"
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create password", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(passwordButtonPressed), for: .touchUpInside)

        return button
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Press me!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        return button
    }()
    
    static var activityIndicator = UIActivityIndicatorView(style: .medium)

    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .systemCyan
            } else {
                self.view.backgroundColor = .systemYellow
            }
        }
    }
    
    @objc private func buttonPressed() {
        isBlack.toggle()
    }
    
    @objc private func passwordButtonPressed() {
        textField.isSecureTextEntry = true
        label.text = "Сейчас угадаю..."
        self.randomPassword()
        ViewController.activityIndicator.startAnimating()
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.bruteForce(passwordToUnlock: self.textField.text ?? "")
            ViewController.activityIndicator.stopAnimating()
            self.passwordButton.setTitle("Попробуй еще", for: .normal)
            self.textField.isSecureTextEntry = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupHierarchy()
        setupLayout()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(passwordButton)
        view.addSubview(button)
    }
    
    private func setupLayout() {
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(label.snp.top).offset(-30)
            make.height.equalTo(40)
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).inset(50)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-50)

        }
        
        passwordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(label.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).inset(50)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(passwordButton.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).inset(50)
        }
    }
    
    func randomPassword() {
        let passwordCharacters = Array("".digits + "".lowercase + "".uppercase + "".punctuation)
        let lenght = 3
        let randomPassword = String((0..<lenght).map{ _ in passwordCharacters[Int(arc4random_uniform(UInt32(passwordCharacters.count)))]})
        textField.text = randomPassword
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            // Your stuff here
        }
        label.text = password
        print(password)
    }
}


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

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
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
