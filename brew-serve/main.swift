//
//  main.swift
//  brew-serve
//
//  Created by Jochen Bernard on 22/03/2022.
//

import ArgumentParser
import Dispatch
import Foundation

struct Serve: ParsableCommand {
    @Argument
    var service: String
    
    func stop() {
        print("")
        BrewServices.stop(service)
        Serve.exit()
    }
    
    func setSignalEventHandler(signal s: Int32, handler: @escaping () -> Void) -> DispatchSourceSignal {
        let source = DispatchSource.makeSignalSource(signal: s)
        source.setEventHandler(handler: handler)
        
        signal(s, SIG_IGN)
        
        return source
    }
    
    func run() {
        let sighupSource = setSignalEventHandler(signal: SIGHUP, handler: stop)
        sighupSource.resume()
        
        let sigintSource = setSignalEventHandler(signal: SIGINT, handler: stop)
        sigintSource.resume()
        
        let sigkillSource = setSignalEventHandler(signal: SIGKILL, handler: stop)
        sigkillSource.resume()
        
        let sigtermSource = setSignalEventHandler(signal: SIGTERM, handler: stop)
        sigtermSource.resume()
        
        BrewServices.run(service)
        
        dispatchMain()
    }
}

Serve.main()
