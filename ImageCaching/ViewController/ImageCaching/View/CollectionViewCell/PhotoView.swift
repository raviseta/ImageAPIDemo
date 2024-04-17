//
//  PhotoView.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import UIKit

class PhotoView: UIView {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak private var imageView: UIImageView!
    
    // MARK: - Properties
    
    private var currentPhotoID: String?
    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }
    
    // MARK: - Prepare For Reuse
    
    func prepareForReuse() {
        currentPhotoID = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }
    
    // MARK: - ConfigureImage
    
    func configure(with photo: PhotoMeta, showsUsername: Bool = true) {
        imageView.backgroundColor = photo.color
        currentPhotoID = photo.identifier
        downloadImage(with: photo)
    }
}

// MARK: - Extension_DownloadImage

extension PhotoView {
    
    private func downloadImage(with photo: PhotoMeta) {
        guard let regularUrl = URL(string: photo.urls.regular) else { return }
        
        let url = sizedImageURL(from: regularUrl)
        
        let downloadPhotoID = photo.identifier
        
        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            
            guard let strongSelf = self, strongSelf.currentPhotoID == downloadPhotoID else { return }
            
            DispatchQueue.main.async {
                
                if isCached {
                    strongSelf.imageView.image = image
                } else {
                    UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        strongSelf.imageView.image = image
                    }, completion: nil)
                }
            }
        })
    }
    
    private func sizedImageURL(from url: URL) -> URL {
        layoutIfNeeded()
        if #available(iOS 16.0, *) {
            return url.appending(queryItems: [
                URLQueryItem(name: "w", value: "\(frame.width)"),
                URLQueryItem(name: "dpr", value: "\(Int(screenScale))")
            ])
        } else {
            return url
        }
    }
}
