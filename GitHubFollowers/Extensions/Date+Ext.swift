//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 01/12/2020.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy" // returns e.g. "Jan 2020" or "Mar 1998".
       
        return dateFormatter.string(from: self)
    }
}
