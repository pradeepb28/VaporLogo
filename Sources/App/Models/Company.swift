//
//  Company.swift
//  App
//
//  Created by pradeep burugu on 2/23/19.
//

import Vapor

struct Company {
    let name: String
    let domain: String
    let logo: String
}

extension Company: Content {}
extension Company: Codable {}
