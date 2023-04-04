//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/04/03.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    var movieName: String = ""
    var movieCode: String = ""
    private lazy var dataManager = MovieDescManager(movieApiType: .movie(movieCode), movieImageApiType: .movieImage(movieName))
    
    // MARK: - UI Properties
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    
        return scrollView
    }()
    
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private let descStackView = DescStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchImage()
        fetchData()
    }
    
    private func fetchData() {
        dataManager.boxofficeInfo.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                let infoUIModel = MovieInfoUIModel(data: data.movieInfoResult.movieInfo)
                DispatchQueue.main.async {
                    self?.descStackView.updateTextLabel(infoUIModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchImage() {
        dataManager.fetchMoviePosterImage { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                    self?.posterImageView.sizeToFit()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


// MARK: - UI
extension MovieDetailViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = movieName
        
        view.addSubview(scrollView)
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(descStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            posterImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            descStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            descStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            descStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            descStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}
