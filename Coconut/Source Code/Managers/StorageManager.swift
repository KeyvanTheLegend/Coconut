//
//  StorageManager.swift
//  Coconut
//
//  Created by sh on 8/28/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
}

extension StorageManager {
    
    public func uploadProfilePicture(with image : UIImage , fileName : String , completion : @escaping (Result<String,StorageManagerError>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(.NOT_VALID_IMAGE))
            return
        }
        storage.child("image/\(fileName)").putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(.UNABLE_TO_UPLOAD_IMAGE))
                return
            }
            self.storage.child("image/\(fileName)").downloadURL { url, error in
                guard error == nil else{
                    completion(.failure(.UNABLE_TO_FETCH_IMAGE_URL))
                    return
                }
                guard let downloadUrl = url?.absoluteString else {return}
                completion(.success(downloadUrl))
            }
        }
    }
}

enum StorageManagerError : Error {
    case NOT_VALID_IMAGE
    case UNABLE_TO_UPLOAD_IMAGE
    case UNABLE_TO_FETCH_IMAGE_URL
    
}

