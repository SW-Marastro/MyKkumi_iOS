//
//  ImageCache.swift
//  MyKkumi
//
//  Created by 최재혁 on 10/22/24.
//

//생각한 로직
// cacheImage시 url, diskCache인지 전달 -> 이미지 이미 있는 경우에는 기존 이미지 전달 -> 없는 경우 cache후 이미지 전달

import Foundation
import Kingfisher

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let memoryCache : ImageCache
    private let diskCache : ImageCache
    
    
    private init() {
        memoryCache = ImageCache.default
        diskCache = ImageCache(name: "MyKKumiDiskCache")
    }
    
    func cacheImage(from url: URL, toMemoryCache: Bool = true, toDiskCache: Bool = true, completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        let cacheKey = url.absoluteString // 키를 지정하지 않으면 URL 자체를 키로 사용

        // Kingfisher를 사용하여 이미지를 다운로드
//        let resource = ImageResource(downloadURL: url, cacheKey: cacheKey)
//        KingfisherManager.shared.retrieveImage(with: resource) { result in
//            switch result {
//            case .success(let value):
//                // 다운로드 성공 후 선택적으로 메모리와 디스크 캐시에 저장
//                if toMemoryCache {
//                    self.memoryCache.store(value.image, forKey: cacheKey, to: .memory)
//                }
//                if toDiskCache {
//                    self.diskCache.store(value.image, forKey: cacheKey, to: .disk)
//                }
//                completion?(.success(value))
//            case .failure(let error):
//                // 다운로드 실패 시 에러 처리
//                completion?(.failure(error))
//            }
//        }
    }
}
