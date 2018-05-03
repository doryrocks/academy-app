import UIKit

class BusinessCardVC: UIViewController {
    private let cardView = BusinessCardView()
    private let viewModel = BusinessCardVM()

    init(for id: Int) {
        super.init(nibName: nil, bundle: nil)
        viewModel.loadParticipant(id: id) { [weak self] participant in
            self?.cardView.content = participant!
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        
    }

    
    override func loadView() {
        super.loadView()
        view.addSubview(cardView)
        cardView.frame = view.bounds
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .white
        
    }
}

