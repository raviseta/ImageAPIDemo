//
//  ImageCollectionViewCell.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak private var photoView: PhotoView!
    
    // MARK: - Properties
    
    
    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.prepareForReuse()
    }
    
    func setup(image: PhotoMeta) {
        
        photoView.configure(with: image)
    }
}
