//
//  BrewServices.swift
//  brew-serve
//
//  Created by Jochen Bernard on 23/03/2022.
//

import Foundation

final class BrewServices {
    private static func execute(_ args: String...) {
        let process = Process()
        let outputPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.launchPath = "/usr/bin/env"
        process.arguments = ["brew", "services"] + args
        process.launch()
        
        let handle = outputPipe.fileHandleForReading
        handle.waitForDataInBackgroundAndNotify()
        
        let observer = NotificationCenter.default.addObserver(
            forName: .NSFileHandleDataAvailable,
            object: handle,
            queue: nil
        ) { _ in
            guard let string = String(data: handle.availableData, encoding: .utf8) else { return }
            print(string, terminator: "")
        }
        
        process.waitUntilExit()
        
        NotificationCenter.default.removeObserver(observer)
    }
    
    static func run(_ service: String) {
        execute("run", service)
    }
    
    static func stop(_ service: String) {
        execute("stop", service)
    }
}
