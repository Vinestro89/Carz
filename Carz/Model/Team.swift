//
//  Team.swift
//  Carz
//
//  Created by Vincent DELMAESTRO on 09/03/2022.
//

import Foundation

struct Team: Hashable {
    let id: Int
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
      lhs.id == rhs.id
    }
}
