// UIImageView+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

extension UIImageView {
    func downloadImageInto(from: URL) {
        image = nil
        let task = URLSession.shared.dataTask(with: from) { data, _, error in

            if error != nil {
                print("ERROR \(String(describing: error))")
            }

            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
