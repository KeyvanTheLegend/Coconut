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
    
    public func uploadProfilePicture(with imageData : Data , fileName : String , completion : @escaping (Result<String,Error>) -> Void) {
        storage.child("image/\(fileName)").putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            self.storage.child("image/\(fileName)").downloadURL { url, error in
                guard error == nil else{
                    return
                }
                guard let downloadUrl = url?.absoluteString else {return}
                completion(.success(downloadUrl))
            }
        }
    }
}
