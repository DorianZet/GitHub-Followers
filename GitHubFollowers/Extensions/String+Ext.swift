//
//  String+Ext.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import Foundation

extension String { // THIS EXTENSION WILL BE UNUSED IN THIS PROJECT AS OF THE 2ND CLIP FROM 'CLEAN-UP AND OPTIMIZATION CHAPTER'. The reason it becomes unused is that in NetworkManager, we have an option to decode the date straight from the object by using:                 decoder.dateDecodingStrategy = .iso8601 //
    // Hence, we don't need to convert the 'User.createdAt' from String to date with this extension. We just need to mark the 'createdAt' property as 'Date' instead of 'String' and then just decode it with strategy .iso8601.
    
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
