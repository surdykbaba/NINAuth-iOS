//
//  DateExtension.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 22/02/2025.
//

import Foundation

struct DateFormat {
    static let UniversalDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    static let Dateformat = "dd MMMM yyyy"
    static let yrMonthDayFormat = "yyyy-MM-dd"
    static let dateFormat = "dd MMM yyyy"
}

extension Date {
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
}

