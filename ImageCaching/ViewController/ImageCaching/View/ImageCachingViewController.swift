//
//  ImageCachingViewController.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import UIKit

class ImageCachingViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    
    private var viewModel: ImageCachingViewModel!
    
    
    // MARK: - UIViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - SetupView
    
    private func setupView() {
        
        self.viewModel = ImageCachingViewModel(apiManager: APIManager())
        self.fetchImages()
        
        self.collectionView.register(UINib(nibName: "FooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
    }
    
}

// MARK: - Extensions

// MARK: - UICollectionView DataSource | Delegate

extension ImageCachingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard viewModel.allowToFetchNextPage, (viewModel.images.count - 2 == indexPath.item) else { return }
        self.fetchImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let image = self.viewModel.images[indexPath.item]
        cell.setup(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! FooterView
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionView UICollectionViewDelegateFlowLayout

extension ImageCachingViewController: UICollectionViewDelegateFlowLayout {
    
    // SetupSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize: CGSize = collectionView.frame.size
        let width: CGFloat = ((collectionViewSize.width - 2) / 2)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard viewModel.allowToFetchNextPage else { return .zero }
        return CGSize(width: collectionView.frame.width, height: 52)
    }
}

// MARK: - API CALL

extension ImageCachingViewController {
    
    private func fetchImages() {
        
        Task {
            
            let response = await self.viewModel.fetchImages()
            
            DispatchQueue.main.async {
                switch response {
                case .success(let fetchedPhotoCount):
                    self.reloadCollectionView(loadedItemCount: fetchedPhotoCount)
                case .failure(let error):
                    let alert = UIAlertController(title: "Message", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func reloadCollectionView(loadedItemCount: Int) {
        
        guard loadedItemCount > 0, self.viewModel.images.count > 0 else { return }
        
        let startIndex = self.viewModel.images.count - loadedItemCount
        let endIndex = startIndex + loadedItemCount
        var newIndexPaths = [IndexPath]()
        for index in startIndex..<endIndex {
            newIndexPaths.append(IndexPath(item: index, section: 0))
        }

        DispatchQueue.main.async { [unowned self] in

            let hasWindow = self.collectionView.window != nil
            let collectionViewItemCount = self.collectionView.numberOfItems(inSection: 0)
            if hasWindow && collectionViewItemCount < self.viewModel.images.count {
                self.collectionView.insertItems(at: newIndexPaths)
            } else {
                self.collectionView.reloadData()
            }
        }
    }
}

