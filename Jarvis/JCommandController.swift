//
//  JCommandController.swift
//  Jarvis
//
//  Created by Frank on 5/21/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JCommandController: NSObject {
    
    // Override these functions
    func setup() {}
    func getCommands() -> [String] { return [] }
    func performCommand(command: String) {}
    
    func respondsToCommand(command: String) -> Bool {
        return getCommands().contains(command)
    }
    
    
    
}
