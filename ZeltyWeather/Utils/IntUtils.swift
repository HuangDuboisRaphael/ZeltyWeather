//
//  IntUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

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
    
    func convertUnixToReadableTime(for city: String, timeZoneIdentifier: String) -> String {
        /// Convert the Unix timestamp to current hour.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(self))
        let readableTime = dateFormatter.string(from: sunriseDate)

        return readableTime
    }
    
    func convertUnixToReadableTimeWithCompletion(for city: String, timeZoneIdentifier: String, completion: @escaping (String) -> Void) {
        /// Convert the Unix timestamp to current hour.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(self))
        let readableTime = dateFormatter.string(from: sunriseDate)
        completion(readableTime)
    }
}
