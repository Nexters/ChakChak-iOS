//
//  PhotoLibraryPermissionManager.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

protocol PhotoLibraryPermissionManager {
    var hasPermission: Bool { get }
    var isDenied: Bool { get }
    func checkPermissionStatus()
    func requestPhotoLibraryPermission()
    func openSettings()
    func openPhotosApp()
}
