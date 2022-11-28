// UIImageView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Разширение для UIIMageView для скачивание изображения в него
extension UIImageView {
    func downloadImageInto(from: URL) {
        image = nil
        let vkApiService = VKAPIService()
        vkApiService.downloadImageFrom(urlString: from) { downloadedImage in
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
    }
}
