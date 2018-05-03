import UIKit

 class InputVC: UIViewController, UITextFieldDelegate{
    private lazy var inputTextField: UITextField = makeInput()
    private lazy var passwordTextField: UITextField = makePassInput()
    private lazy var button: UIButton = makeButton()
    private var viewModel = InputVM()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .white
        inputTextField.becomeFirstResponder()
    }

    override func loadView() {
        super.loadView()
        self.hero.isEnabled = true
        self.view.hero.id = "bg"
        view.addSubview(inputTextField)
        view.addSubview(passwordTextField)
        view.addSubview(button)
        setupConstraints()
    }
    
    func login() {
        if inputTextField.text == nil || passwordTextField.text == nil {
            self.navigationController?.popViewController(animated: false)
        } else {
            let vc = UIViewController()
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            vc.view.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
            navigationController?.pushViewController(vc, animated: false)
            
            viewModel.login(email: inputTextField.text!, password: passwordTextField.text!) { [weak self] participant in
                if participant == nil {
                    self?.navigationController?.popViewController(animated: false)
                    self?.inputTextField.isEnabled = true
                    self?.passwordTextField.isEnabled = true
                    self?.button.isEnabled = true
                } else {
                    let businessCardVC = BusinessCardVC(for: (participant?.id)!)
                    UserDefaults.standard.set(self?.inputTextField.text, forKey: "username")
                    UserDefaults.standard.set(self?.passwordTextField.text, forKey: "password")
                    let transition = self?.makeTransition()
                    self?.navigationController?.view.layer.add(transition!, forKey: nil)
                    self?.navigationController?.popViewController(animated: false)
                    self?.navigationController?.pushViewController(businessCardVC, animated: true)
                }
            }
        }
    }
    
    func makeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        return transition
    }

    private func setupConstraints() {
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor).isActive = true
        inputTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 2 * 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func makeInput() -> UITextField {
        let v = UITextField()
        v.placeholder = "Vlož přihlašovací jméno"
        v.textAlignment = .center
        v.tintColor = UIColor(named: "academy")
        v.borderStyle = .roundedRect
        v.keyboardType = .asciiCapable
        v.returnKeyType = .next
        v.delegate = self
        return v
    }
    private func makePassInput() -> UITextField {
        let v = UITextField()
        v.placeholder = "Heslo"
        v.textAlignment = .center
        v.tintColor = UIColor(named: "academy")
        v.borderStyle = .roundedRect
        v.keyboardType = .asciiCapable
        v.returnKeyType = .go
        v.isSecureTextEntry = true
        v.delegate = self
        return v
    }

    private func makeButton() -> UIButton {
        let v = UIButton()
        self.hero.isEnabled = true
        v.hero.id = "button"
        v.setTitle("Přihlásit", for: .normal)
        v.backgroundColor = UIColor(named: "academy")
        v.layer.cornerRadius = 6
        v.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .highlighted)
        v.addTarget(self, action: #selector(InputVC.press), for: .touchUpInside)
        return v
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputTextField {
            inputTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            inputTextField.isEnabled = false
            passwordTextField.isEnabled = false
            button.isEnabled = false

            press()
        }
        return true
    }

    @objc private func press() {
        inputTextField.isEnabled = false
        passwordTextField.isEnabled = false
        button.isEnabled = false
        login()


}

}
