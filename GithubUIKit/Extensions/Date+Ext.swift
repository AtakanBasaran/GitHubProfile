//
//  Date+Ext.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 26.07.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
}
