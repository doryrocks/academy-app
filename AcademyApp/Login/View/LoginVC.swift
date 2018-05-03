import Foundation
import UIKit
import LocalAuthentication
import Hero

class LoginVC: UIViewController {
    private lazy var button: UIButton = makeButton()
    private let viewModel = InputVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func loadView() {
        super.loadView()
        self.hero.isEnabled = true
        self.view.hero.id = "bg"
        self.view.backgroundColor = .white
        view.addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 2 * 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    

    private func makeButton() -> UIButton {
        let v = UIButton()
        v.hero.id = "button"
        v.hero.modifiers = [.rotate()]
        v.setTitle("Přihlásit", for: .normal)
        v.backgroundColor = UIColor(named: "academy")
        v.layer.cornerRadius = 6
        v.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .highlighted)
        
        v.addTarget(self, action: #selector(LoginVC.press), for: .touchUpInside)
        return v
    }
    
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
            let vc = InputVC()
            vc.hero.isEnabled = true
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.hero.navigationAnimationType = .pageIn(direction: HeroDefaultAnimationType.Direction.down)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    @objc private func press() {
        if UserDefaults.standard.value(forKey: "username") != nil {
            let myContext = LAContext()
            let myLocalizedReasonString = "Login to Academy with TouchID/FaceID"
            
            var authError: NSError?
            if #available(iOS 8.0, macOS 10.12.1, *) {
                if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                        if success {
                            DispatchQueue.main.sync {
                                let vc = UIViewController()
                                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                                indicator.startAnimating()
                                vc.view.addSubview(indicator)
                                indicator.translatesAutoresizingMaskIntoConstraints = false
                                indicator.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                                indicator.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                            
                            self.viewModel.login(email: (UserDefaults.standard.value(forKey: "username") as? String)!, password: (UserDefaults.standard.value(forKey: "password") as? String)!) { [weak self] participant in
                                if participant == nil {
                                    self?.navigationController?.popViewController(animated: false)
                                } else {
                                    let businessCardVC = BusinessCardVC(for: participant!.id)
                                    self?.navigationController?.popViewController(animated: false)
                                    self?.navigationController?.pushViewController(businessCardVC, animated: false)
                                }
                            }
                        } else {
                            DispatchQueue.main.sync {
                                self.notifyUser("FaceID/TouchID login failed", err: "Please try again later")
                            }
                        }
                    }
                } else {
                    notifyUser("FaceID/TouchID login failed", err: "Not possible to use local authentication")
                }
            } else {
                notifyUser("FaceID/TouchID login failed", err: "iOS 8.O or higher is required")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
            let vc = InputVC()
            vc.hero.isEnabled = true
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.hero.navigationAnimationType = .pageIn(direction: HeroDefaultAnimationType.Direction.right)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


    }







