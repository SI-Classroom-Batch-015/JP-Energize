//
//  HomeViewPicker.swift
//  JP Energize
//
//  Created by Phillip Wilke on 19.09.24.
//

import Foundation


enum HomePicker: String, Identifiable, CaseIterable {
    case week, month, year
    
    var id: Self { self }
}
