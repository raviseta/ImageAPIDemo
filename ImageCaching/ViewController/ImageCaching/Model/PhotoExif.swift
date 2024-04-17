//
//  PhotoExif.swift
//  ImageCaching
//
//  Created by Ravi Seta on 16/04/24.
//

import Foundation

public struct PhotoExif: Codable {

    public let aperture: String
    public let exposureTime: String
    public let focalLength: String
    public let iso: String
    public let make: String
    public let model: String

    private enum CodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }

}
