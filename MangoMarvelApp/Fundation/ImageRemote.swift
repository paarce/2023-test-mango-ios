//
//  ImageRemote.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

final class ImageRemote: NSObject {

    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }).resume()
    }
}
