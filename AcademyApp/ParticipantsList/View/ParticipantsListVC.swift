import UIKit
import DGElasticPullToRefresh
import Hero

// MARK: - ViewController

class ParticipantsListVC: UIViewController {
    let viewModel: ViewModel
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    lazy var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Účastníci akademie"
        titleLabel.textColor = .white
        self.navigationItem.titleView = titleLabel
        self.view.backgroundColor = .white
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
        loadingIndicator.startAnimating()
    }
    
    override func loadView() {
        super.loadView()
        if viewModel.loaded == false {
            self.view.addSubview(self.loadingIndicator)
            self.setupIndicator()
            
        } else {
            loadingIndicator.stopAnimating()
            view.addSubview(tableView)
            tableView.frame = view.bounds
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableView.register(ParticipantCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundView = loadingIndicator
            tableView.separatorColor = UIColor(named: "academy")

            let loadingCircle = DGElasticPullToRefreshLoadingViewCircle()
            loadingCircle.tintColor = UIColor.white
            tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self?.tableView.reloadData()
                    self?.tableView.dg_stopLoading()
                })
                }, loadingView: loadingCircle)
            tableView.dg_setPullToRefreshFillColor(UIColor(named: "academy")!)
            tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.didUpdateModel = { [weak self] model in
            self?.tableView.reloadData()
            self?.loadView()
        }
        viewModel.loadData(with: RemoteDataProvider())
        
    }
    
    func setupIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    deinit {
        tableView.dg_removePullToRefresh()
    }
}

// MARK: Delegate & datarousce

extension ParticipantsListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.modelForSection(section).header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.modelForSection(section).footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.modelForRow(inSection: indexPath.section, atIdx: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ParticipantCell
        
        switch model {
        case let .participant(person):
            cell.textLabel?.text = person.name
            cell.imageView?.kf.setImage(with: URL(string: person.imageUrl), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, _, _, url) in
                cell.setNeedsLayout()
            })
            cell.detailTextLabel?.attributedText = person.scores.sorted(by: { lhs, rhs in
                lhs.value > rhs.value
            })[0..<min(4, person.scores.count)]
                .filter {
                    $0.value > 0
                }
                .reduce(NSMutableAttributedString()) { accum, current in
                    accum.append(NSAttributedString(string: current.emoji, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 24)]))
                    accum.append(NSAttributedString(string: " \(current.value)   ", attributes: [
                        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),
                        NSAttributedStringKey.baselineOffset: 2,
                        NSAttributedStringKey.foregroundColor: UIColor.gray
                        ]))
                    return accum
            }
        }
        return cell
    }
}

extension ParticipantsListVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.modelForRow(inSection: indexPath.section, atIdx: indexPath.row)
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        let vc = UIViewController()
        vc.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        navigationController?.pushViewController(vc, animated: false)
        loadingIndicator.startAnimating()
        
        
        switch model {
        case .participant(let person):
            let dataProvider = RemoteDataProvider()
            dataProvider.loadParticipant(id: person.id) { [weak self] participant in
                loadingIndicator.stopAnimating()
                let businessCardVC = BusinessCardVC(for: person.id)
                let transition = self?.makeTransition()
                self?.navigationController?.popViewController(animated: false)
                self?.navigationController?.view.layer.add(transition!, forKey: nil)
                self?.navigationController?.pushViewController(businessCardVC, animated: false)
                let titleLabel = UILabel(frame: CGRect())
                titleLabel.textColor = .white
                titleLabel.text = (person.name)
                businessCardVC.navigationItem.titleView = titleLabel
                businessCardVC.navigationItem.backBarButtonItem?.title = "Účastníci akademie"
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
}


