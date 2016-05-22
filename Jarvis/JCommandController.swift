//
//  JCommandController.swift
//  Jarvis
//
//  Created by Frank on 5/21/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JCommandController: NSObject {
    
    func getCommands() -> [String] {
        return []
    }
    
    func respondsToCommand(command: String) -> Bool {
        return getCommands().contains(command)
    }
    
    func performCommand(command: String) {
        
    }
    
}
