// UIImageView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Разширение для UIImageView для скачивание изображения в него
extension UIImageView {
    func downloadImageInto(from: URL, vkApiService: VKAPIService) {
        image = nil
        vkApiService.downloadImageFrom(urlString: from) { [weak self] downloadedImage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
    }
}
