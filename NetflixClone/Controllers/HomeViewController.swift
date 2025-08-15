//
//  HomeViewController.swift
//  NetflixClone
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var homeFeedType: [HomeFeedType] = []
    private var headerView: HeroHeaderUIView?
    private var randomTrendingMovie: Title?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        setupTableView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        tableView.tableHeaderView = headerView
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
    }
    
    private func fetchData() {
        homeFeedType = [
            HomeFeedType.trendingMovies,
            HomeFeedType.trendingTv,
            HomeFeedType.popular,
            HomeFeedType.upcoming,
            HomeFeedType.topRated
        ]
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                DispatchQueue.main.async {
                    self?.headerView?.configure(with: TitleViewModel(
                        titleName: selectedTitle?.original_title ?? "",
                        posterURL: selectedTitle?.poster_path ?? ""
                    ))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeFeedType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        let feedType = homeFeedType[indexPath.section]
        
        switch feedType {
        case .trendingMovies:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case .trendingTv:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case .popular:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case .upcoming:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case .topRated:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeFeedType[section].rawValue
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}