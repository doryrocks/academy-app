
import Foundation
import UIKit
import RAMAnimatedTabBarController

class TabBarVC: RAMAnimatedTabBarController {
    
    var participantsList: ParticipantsListVC = ParticipantsListVC(viewModel: ViewModel())
    var myAccount: LoginVC = LoginVC()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUpTabBarVC()
    }
    
    func setUpTabBarVC() -> Void {

        let participantsItem = RAMAnimatedTabBarItem(title: "Seznam účastníků", image: UIImage(named: "ic-list"), tag: 0)
        participantsItem.iconColor = .gray
        participantsItem.textColor = .gray
        participantsItem.animation = RAMBounceAnimation()
        participantsList.tabBarItem = participantsItem

        let accountItem = RAMAnimatedTabBarItem(title: "Účet", image: UIImage(named: "ic-account"), tag: 1)
        accountItem.iconColor = .gray
        accountItem.textColor = .gray
        accountItem.animation = RAMBounceAnimation()
        myAccount.tabBarItem = accountItem
        
        let participantsListNC = setUpParticipansListsNC()
        let myAccountNC = UINavigationController(rootViewController: myAccount)
        myAccountNC.navigationBar.tintColor = .white

        self.viewControllers = [participantsListNC, myAccountNC]

    }
    
    func setUpParticipansListsNC() -> UINavigationController {
        let nc = UINavigationController(rootViewController: participantsList)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nc.navigationBar.shadowImage = UIImage()
        nc.navigationBar.barTintColor = UIColor(named: "academy")
        nc.navigationBar.tintColor = .white
        return nc
    }

}
