//
//  JAudioController.swift
//  Jarvis
//
//  Created by Frank on 5/25/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//



class JAudioController: JCommandController {

    override func getCommands() -> [String] {
        return ["mute volume", "increase volume", "decrease volume"]
    }
    
    override func performCommand(command: String) {
        switch command {
        case "mute volume":
            NSSound.setSystemVolume(0)
        case "increase volume":
            NSSound.setSystemVolume(NSSound.systemVolume() + 0.2)
        case "decrease volume":
            NSSound.setSystemVolume(NSSound.systemVolume() - 0.2)
        default:
            print ("No audio implementation")
        }
    }
    
    
}
