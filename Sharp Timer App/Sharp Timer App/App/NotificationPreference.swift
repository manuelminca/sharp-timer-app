//
//  NotificationPreference.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation

enum NotificationAuthorizationStatus {
    case unknown
    case granted
    case denied
}

struct NotificationPreference {
    var authorizationStatus: NotificationAuthorizationStatus = .unknown
    var lastRequestDate: Date?
    var needsFallbackBanner: Bool = false
    var lastFailureReason: String?
    
    init() {}
}
