//
//  JOpenerController.swift
//  Jarvis
//
//  Created by Frank on 5/25/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JOpenerController: JCommandController {
    
    override func getCommands() -> [String] {
        return ["open trello", "open harvest", "open facebook"]
    }
    
    override func performCommand(command: String) {
        switch command {
        case "open trello":
            open("https://trello.com/b/94tEN5Il/address-book")
        case "open facebook":
            open("https://www.facebook.com")
        case "open harvest":
            open("https://comocoding.harvestapp.com/time")
        default:
            print ("No spotify implementation")
        }
    }
    
    func open(what: String) {
        let task = NSTask.init()
        task.launchPath = "/usr/bin/open"
        task.arguments = [what]
        task.launch()
        task.waitUntilExit()
    }
    
}
