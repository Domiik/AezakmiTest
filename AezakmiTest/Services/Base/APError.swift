//
//  APError.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import Foundation

enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case internetConnection
}
