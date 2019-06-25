//
//  iTunesSearch.swift
//  Library
//
//  Created by Oliver Paray on 6/24/19.
//  Copyright © 2019 Oliver Paray. All rights reserved.
//

import Foundation

public class iTunesSearch {

    enum SearchKeys: String{
        case term,country,media,limit,explicit
    }

    enum ResultKeys: String{
        case resultCount,results

        public enum SongKeys: String{
            case
            kind,
            artistName,
            collectionCensoredName,
            trackCensoredName,
            artistViewUrl,
            collectionViewUrl,
            trackViewUrl,
            previewUrl,
            artworkUrl100,
            collectionPrice,
            trackPrice,
            releaseDate,
            collectionExplicitness,
            trackExplicitness,
            country,
            currency,
            primaryGenreName,
            isStreamable
        }

        public enum eBookKeys: String{
            case
            artworkUrl100,
            trackCensoredName,
            trackViewUrl,
            releaseDate,
            currency,
            artistName,
            genres,
            kind,
            price,
            description
        }

        public enum SoftareKeys: String {
            case
            isGameCenterEnabled,
            screenshotUrls,
            ipadScreenshotUrls,
            appletvScreenshotUrls,
            artworkUrl100,
            artistViewUrl,
            kind,
            features,
            advisories,
            averageUserRatingForCurrentVersion,
            trackCensoredName,
            sellerUrl,
            contentAdvisoryRating,
            trackViewUrl,
            sellerName,
            currentVersionReleaseDate,
            releaseDate,
            releaseNotes,
            currency,
            version,
            minimumOsVersion,
            artistName,
            genres,
            price,
            description,
            averageUserRating,
            userRatingCount
        }

        public enum MovieKeys: String{
            case
            kind,
            artistName,
            trackCensoredName,
            trackViewUrl,
            previewUrl,
            artworkUrl100,
            collectionPrice,
            trackPrice,
            trackRentalPrice,
            collectionHdPrice,
            trackHdPrice,
            trackHdRentalPrice,
            releaseDate,
            collectionExplicitness,
            trackExplicitness,
            trackTimeMillis,
            country,
            currency,
            contentAdvisoryRating,
            longDescription
        }
    }

    enum ErrorKeys: String{
        case errorMessage,queryParameters

        public enum QueryParameterKeys: String{
            case output,callback,country,limit,term,lang
        }
    }

    static func performSearch(withTerm: String?,
                              andCountry: String?,
                              andMedia: String?,
                              andLimit: Int?,
                              isExplicit: Bool?,
                              handler: ExecutionBlock) {
        
    }
}
