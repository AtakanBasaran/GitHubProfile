//
//  String+Ext.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 26.07.2024.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "tr")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        
        guard let date = self.convertToDate() else {return "N/A"}
        
        return date.convertToMonthYearFormat()
    }
}
