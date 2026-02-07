//
//  DefaultPhotoLibraryPermissionManager.swift
//  Chac
//
//  Created by 이원빈 on 1/19/26.
//

import Photos
import UIKit

final class DefaultPhotoLibraryPermissionManager: NSObject,
                                                  ObservableObject,
                                                  PhotoLibraryPermissionManager {
    
    @Published var permissionStatus: PHAuthorizationStatus = .notDetermined
    
    var hasPermission: Bool {
        permissionStatus == .authorized || permissionStatus == .limited
    }
    
    var isDenied: Bool {
        permissionStatus == .denied
    }
    
    override init() {
        super.init()
        checkPermissionStatus()
    }
    
    func checkPermissionStatus() {
        permissionStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.permissionStatus = status
            }
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func openPhotosApp() {
        if let url = URL(string: "photos-redirect://") {
            UIApplication.shared.open(url)
        }
    }
}
