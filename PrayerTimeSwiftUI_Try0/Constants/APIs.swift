//
//  APIs.swift
//  PrayerTimeSwiftUI_Try0
//
//  Created by Uslu, Teyhan on 13.04.2024.
//

import Foundation

enum ServiceApi {
    
    private var baseURL: String { return "https://vakit.vercel.app" }
    
    case country
    case cityOrRegion(country: String)
    case district(country: String, city: String)
    case times(country: String, city: String, district: String, date: String)
    case timesWithLocation(latitude: Double, longitude: Double)
    
    private var fullPath: String {
        var endPoint: String {
            switch self {
            case .country:
                return "/api/countries"
            case .cityOrRegion(let country):
                return "/api/regions?country=\(country)"
            case .district(let country, let city):
                return "/api/cities?country=\(country)&region=\(city)"
            case .times(let country, let city, let district, let date):
                return "/api/timesFromPlace?country=\(country)&region=\(district)&city=\(city)&date=\(date)&days=1&timezoneOffset=180&calculationMethod=Turkey"
            case .timesWithLocation(latitude: let latitude, longitude: let longitude):
                return "/api/place?lat=\(latitude)&lng=\(longitude)"
            }
        }
        return baseURL + endPoint
    }
    
    func url() throws -> URL {
        guard let url = URL(string: fullPath) else {
            preconditionFailure("The url used in \(self) is not valid")
        }
        return url
    }
}


