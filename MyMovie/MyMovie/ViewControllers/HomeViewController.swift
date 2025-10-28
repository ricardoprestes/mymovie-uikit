//
//  ViewController.swift
//  MyMovie
//
//  Created by Ricardo Prestes on 13/10/25.
//

import UIKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filmes em Cartaz"
        
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchNowPlaying { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setupCollectionView() {
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        for cell in collectionView.visibleCells {
            guard let cell = cell as? MovieCell else { continue }
            let baseFrame = cell.convert(cell.bounds, to: view)
            let distance = baseFrame.midX - centerX
            
            let scale = max(0.9, 1 - abs(distance / collectionView.bounds.width))
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            cell.applyParallax(in: collectionView)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let width = collectionView.bounds.width - (padding * 2)
        let height = collectionView.bounds.height - (padding * 2)
        return CGSize(width: width, height: height)
    }

}

