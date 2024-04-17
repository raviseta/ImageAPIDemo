//
//  PhotoMeta.swift
//  ImageCaching
//
//  Created by Ravi Seta on 15/04/24.
//

import UIKit

public struct PhotoMeta: Codable {

    public enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
        case small_s3
    }
    
    public struct LinkKind: Codable {
        let linksSelf, html, download, downloadLocation: String

        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case html, download
            case downloadLocation = "download_location"
        }
    }
    
    public struct Urls: Codable {
        let raw, full, regular, small: String
        let thumb, smallS3: String

        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
    }

    public let identifier: String
    public let height: Int
    public let width: Int
    public let color: UIColor?
    public let exif: PhotoExif?
    public let user: PhotoUser
    public let urls: Urls
    public let links: LinkKind
    public let likesCount: Int
    public let downloadsCount: Int?
    public let viewsCount: Int?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case color
        case exif
        case user
        case urls
        case links
        case likesCount = "likes"
        case downloadsCount = "downloads"
        case viewsCount = "views"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)

        if let hexString = try? container.decode(String.self, forKey: .color) {
            color = UIColor(hexString: hexString)
        } else {
            color = nil
        }

        exif = try? container.decode(PhotoExif.self, forKey: .exif)
        user = try container.decode(PhotoUser.self, forKey: .user)
        urls = try container.decode(Urls.self, forKey: .urls)
        links = try container.decode(LinkKind.self, forKey: .links)
        likesCount = try container.decode(Int.self, forKey: .likesCount)
        downloadsCount = try? container.decode(Int.self, forKey: .downloadsCount)
        viewsCount = try? container.decode(Int.self, forKey: .viewsCount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try? container.encode(color?.hexString, forKey: .color)
        try? container.encode(exif, forKey: .exif)
        try container.encode(user, forKey: .user)
        try container.encode(likesCount, forKey: .likesCount)
        try? container.encode(downloadsCount, forKey: .downloadsCount)
        try? container.encode(viewsCount, forKey: .viewsCount)
    }
}


