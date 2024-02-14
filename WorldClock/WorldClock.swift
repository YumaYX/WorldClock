//
//  WorldClock.swift
//  WorldClock
//
//  Created by Yuma SATO on 2024/01/07.
//

import Foundation

class WorldClock {
    let timeZone: TimeZone
    var timeFormatter: DateFormatter

    init(timeZone: TimeZone) {
        self.timeZone = timeZone
        self.timeFormatter = DateFormatter()
        self.timeFormatter.timeZone = timeZone
        self.timeFormatter.dateFormat = "HH:mm"
    }

    func getCurrentTime() -> String {
        let currentDate = Date()
        return timeFormatter.string(from: currentDate)
    }
}
