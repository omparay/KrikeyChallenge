//
//  iTunesSearch.swift
//  Library
//
//  Created by Oliver Paray on 6/24/19.
//  Copyright © 2019 Oliver Paray. All rights reserved.
//

import Foundation

public class iTunesSearch {

    public static let searchURL = "https://itunes.apple.com/search"

    enum SearchKeys: String{
        case term,country,media,limit,explicit
    }

    enum CountryKeys: String{
        case US,UM,JP,AU,CA,CN,DE,GB,IL,IT,KR,ZA,ES,FR
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

    static func performSearch(withTerm: String,
                              andCountry: String = iTunesSearch.CountryKeys.US.rawValue,
                              andMedia: String? = nil,
                              andLimit: Int? = nil,
                              isExplicit: Bool? = nil,
                              handler: ExecutionBlock) {
        var searchParams = [iTunesSearch.SearchKeys.term:withTerm,
                            iTunesSearch.SearchKeys.country:andCountry]
        if let media = andMedia {
            searchParams[iTunesSearch.SearchKeys.media] = media
        }
        if let limit = andLimit{
            searchParams[iTunesSearch.SearchKeys.limit] = "\(limit)"
        }
        if let explicit = isExplicit{
            searchParams[iTunesSearch.SearchKeys.explicit] = (explicit) ? "Yes" : "No"
        }
        let params = String(queryStringFromDictionary: searchParams)
        let urlString = iTunesSearch.searchURL + params
        HttpClient.sharedInstance.execute(serviceUrl: urlString, webMethod: .Get, executionHandler: handler)
    }
}
