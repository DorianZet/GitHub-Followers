//
//  String+Ext.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? { // we make the date optional, as it can return nil in case the date format is not the one we describe below.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // taken from nsdateformatter.com.
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // same as above.
        dateFormatter.timeZone = .current
        
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" } // if the date is not converted successfully, return just a "N/A" string.
        return date.convertToMonthYearFormat()
    }
    
}
