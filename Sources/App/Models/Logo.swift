//
//  Logo.swift
//  App
//
//  Created by pradeep burugu on 2/23/19.
//

import Vapor

final class Logo {
    var name: String
    let url: String
    
    init(name: String) {
        self.name = name
        self.url = "https://logo.clearbit.com/" + name
    }
}

extension Logo: Content {}
