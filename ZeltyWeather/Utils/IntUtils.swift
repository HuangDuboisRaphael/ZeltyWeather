//
//  IntUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import CoreLocation

extension Int {
    func convertDateToReadableTime(for city: String) -> String {
        /// Convert the Unix timestamp to  current date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")

        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let readableDate = dateFormatter.string(from: date)
        
        return readableDate
    }
    
    func convertUnixToReadableTime(for city: String) -> String {
        /// Convert the Unix timestamp to current hour.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: getTimeZoneIdentifierForGivenCity(city: city))
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(self))
        let readableTime = dateFormatter.string(from: sunriseDate)

        return readableTime
    }
    
    func convertUnixToReadableTimeWithCompletion(for city: String, completion: @escaping (String) -> Void) {
        /// Convert the Unix timestamp to current hour.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: getTimeZoneIdentifierForGivenCity(city: city))
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(self))
        let readableTime = dateFormatter.string(from: sunriseDate)
        completion(readableTime)
    }
    
    private func getTimeZoneIdentifierForGivenCity(city: String) -> String {
        /// Use sempahore to wait closure completion before returning value.
        var timeZone = ""
        let semaphore = DispatchSemaphore(value: 0)
        determineTimeZoneIdentifier(for: city) { timeZoneIdentifier in
            timeZone = timeZoneIdentifier
            semaphore.signal()
        }
        semaphore.wait()
        
        return timeZone
    }
    
    func determineTimeZoneIdentifier(for city: String, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        /// Use  geocoder to get the geographic infomation of the given city
        geocoder.geocodeAddressString(city) { placemarks, _ in
            guard let placemark = placemarks?.first, let timeZone = placemark.timeZone?.identifier else {
                completion("Europe/Paris")
                return
            }
            completion(timeZone)
        }
    }
}
