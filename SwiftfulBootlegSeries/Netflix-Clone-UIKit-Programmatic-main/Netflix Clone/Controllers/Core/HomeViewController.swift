//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Aarish Khanna on 11/01/23.
//

import UIKit

enum Sections: Int{
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    
    let sectionTitles: [String] = ["Trending Movies","Trending Tv", "Popular" , "Upcoming Movies", "Top Rated" ]
    
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    //    navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
//        APICaller.shared.getMovie(with: "Harry Potter"){
//            result in
//
//        }
      //  fetchData()
    }
    
    private func configureHeroHeaderView(){
        
        APICaller.shared.getTrendingMovies{
           [weak self] result in
            switch result{
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar(){
        
        // to left align nav bar item with image view
        
//            let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
//            containerView.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
//            let imageSearch = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
//            imageSearch.image = UIImage(named: "Image 1")
//            containerView.addSubview(imageSearch)
//            let searchBarButtonItem = UIBarButtonItem(customView: containerView)
//            searchBarButtonItem.width = 30
//            navigationItem.leftBarButtonItem = searchBarButtonItem
        
        //to left align nav bar item with custom image by resizing it with an resizeto extension
        
        
          let image =  UIImage(named: "Image 1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal).resizeTo(size: CGSize(width: 30, height: 30))
        
//        image = image?.withRenderingMode(.alwaysOriginal)
        
          navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
//        navigationItem.leftBarButtonItem?.width = 20
        
        
//        let imageSearch = UIImage(named: "Image 1")
//        let searchBarButtonItem = UIBarButtonItem(image: imageSearch, style: .plain, target: nil, action: nil)
//        searchBarButtonItem.width = 5
//        navigationItem.leftBarButtonItem = searchBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done
                            , target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
//    private func fetchData(){
       
//        APICaller.shared.getTrendingMovies{
//            results in
//
//            switch results{
//            case .success(let movies):
//                print(movies)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getTredingTvs{
//            results in
//            print(results)
//        }
        
//        APICaller.shared.getUpcomingMovies{
//            _ in
//        }
        
//        APICaller.shared.getPopular{
//            _ in
//            
//        }
        
//        APICaller.shared.getTopRated{
//            _ in
//        }
        
  //  }
    

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello World"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            
            return UITableViewCell()
        }
        
        cell.delegate = self
        switch indexPath.section{
            
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies{
                result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTredingTvs{
                result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular{
                result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies{
                result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated{
                result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
            
            
        default:
            return UITableViewCell()
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
        
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .white
       // header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.text = header.textLabel?.text?.capitalized
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        //print(offset)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}


extension HomeViewController: CollectionViewTableViewCellDeleagte {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            [weak self] in
            let vc = TitlePreviewViewController()
       //     vc.delegate = self
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
}
