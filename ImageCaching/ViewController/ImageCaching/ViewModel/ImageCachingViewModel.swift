//
//  ImageCachingViewModel.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import Foundation

class ImageCachingViewModel {
    
    let apiManager: APIManager
    private(set) var images: [PhotoMeta] = []
    
    private var isCallRunning: Bool = false
    private var allowLoadMore: Bool = true
    
    private var request: PhotoRequest = .default
    
    var allowToFetchNextPage: Bool {
        return (!isCallRunning && allowLoadMore)
    }
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchImages() async -> PhotoResponse {
        
        print("Page :: \(self.request.page) || PerPage :: \(self.request.per_page)")
        
        guard !isCallRunning, allowLoadMore else { return .failure(PhotoError.finishedPaging) }
        
        do {
            self.isCallRunning = true
            
            let photos: [PhotoMeta] = try await self.apiManager.requestUsingQuery(endPoint: .fetchPhotos, parameter: self.request)
            self.images.append(contentsOf: photos)
            
            self.isCallRunning = false
            self.allowLoadMore = photos.count >= request.per_page
            
            if self.allowLoadMore {
                self.request.page += 1
            }
            
            return .success(photos.count)
            
        } catch {
            isCallRunning = false
            allowLoadMore = false
            
            return .failure(error)
        }
    }
    
}
