//
//  BrewServices.swift
//  brew-serve
//
//  Created by Jochen Bernard on 23/03/2022.
//

import Shell

final class BrewServices {
    @discardableResult
    private static func execute(_ args: String...) -> Int32 {
        return Shell.execute(["brew", "services"] + args) { string in
            print(string, terminator: "")
        }
    }
    
    static func run(_ service: String) -> Int32 {
        execute("run", service)
    }
    
    static func stop(_ service: String) {
        execute("stop", service)
    }
}
