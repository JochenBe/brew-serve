//
//  main.swift
//  brew-serve
//
//  Created by Jochen Bernard on 22/03/2022.
//

import ArgumentParser
import Dispatch

struct BrewServe: ParsableCommand {
    @Argument(help: "The service to run.")
    var service: String
    
    func setSignalEventHandler(signal s: Int32, handler: @escaping () -> Void) -> DispatchSourceSignal {
        let source = DispatchSource.makeSignalSource(signal: s)
        source.setEventHandler(handler: handler)
        
        signal(s, SIG_IGN)
        
        return source
    }
    
    func stop() {
        print("")
        BrewServices.stop(service)
        Self.exit()
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
        
        let terminationStatus = BrewServices.run(service)
        
        guard terminationStatus == 0 else {
            Self.exit()
        }
        
        dispatchMain()
    }
}

BrewServe.main()
