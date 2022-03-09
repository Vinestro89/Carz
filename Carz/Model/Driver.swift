//
//  Driver.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import Foundation

struct Driver: Hashable {
    let id: Int
    let team: Team
    let firstName: String
    let lastName: String
    let number: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Driver, rhs: Driver) -> Bool {
      lhs.id == rhs.id
    }
}
