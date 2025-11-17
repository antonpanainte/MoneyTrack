//
//  Extensions.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import Foundation
import SwiftUI
import AVFoundation


extension Color {
    static let Background = Color("Background")
    static let Icon = Color("Icon")
    static let Text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    // "2025-08-31T22:00:00+00:00"
    static let isoWithColonTZ: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX" // handles +00:00
        return f
    }()
}

extension String {
    //transform a string date into a Date object
    func dateParsed() -> Date {
        let s = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let d = DateFormatter.isoWithColonTZ.date(from: s) { return d }
        // if the string is a unix timestamp
        if let interval = TimeInterval(s) {
            return Date(timeIntervalSince1970: interval)
        }
        return Date()
    }
}


extension Date {
    //Cut the unused info of a date, and make into string (UI purposes)
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
    
    //get the day of a Date, used for calculations
    func getDay() -> Int {
        let day = self.formatted(.dateTime.day())
        return Int(day)!
    }
    
    func getYear() -> Int {
        let year = self.formatted(.dateTime.year())
        return Int(year)!
    }
    
    //this function returns the last day of the month in as a date
    func getLastDay() -> Date {
        let cal = Calendar.current
        
        let year = Int(self.formatted(.dateTime.year())) //get the int value of the year
        let month = self.getMonthInt() //get the int value of the month
        
        var comps = DateComponents(calendar: cal, year: year , month: month)
        comps.setValue(month + 1, for: .month)
        comps.setValue(0, for: .day)  //force the calendar to be set to the last day of previous month
        let date = cal.date(from: comps)! 
        return date
    }

    //this function returns a number, which represents the last day of a month,
    //it is used later to calculate the dayly expenses
    func lastDay() -> Int {
        let cal = Calendar.current
        
        let year = Int(self.formatted(.dateTime.year())) //get the int value of the year
        let month = self.getMonthInt() //get the int value of the month
        
        var comps = DateComponents(calendar: cal, year: year , month: month)
        comps.setValue(month + 1, for: .month)
        comps.setValue(0, for: .day)  //force the calendar to be set to the last day of previous month
        let date = cal.date(from: comps)! //extract the date from "comps" calendar in Date format
        return cal.component(.day, from: date) //return only the "day" component
    }
    
    //this is a helper function fot lastDay(), which simply returns the month's numeration
    func getMonthInt() -> Int {
        let month = self.formatted(.dateTime.month())
        switch month {
        case "Jan": return 1
        case "Feb": return 2
        case "Mar": return 3
        case "Apr": return 4
        case "May": return 5
        case "Jun": return 6
        case "Jul": return 7
        case "Aug": return 8
        case "Sep": return 9
        case "Oct": return 10
        case "Nov": return 11
        case "Dec": return 12
        default: return 0
        }
    }
    
}

func playSound(named name: String, withExtension ext: String, player audioPlayer: inout AVAudioPlayer?) {
        //  Find the URL for your audio file in the app's bundle
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Could not find the file: \(name).\(ext)")
            return
        }

        do {
            //  Initialize the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            
            //  Play the sound
            audioPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }




