//
//  LogMessage.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import Foundation

struct LogMessage: Identifiable {
    var id = UUID()
    var primaryInfo: String
    var secondaryInfo: String
}
