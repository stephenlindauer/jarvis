//
//  JSpotifyController.swift
//  Jarvis
//
//  Created by Frank on 5/21/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JSpotifyController: JCommandController {

    override func getCommands() -> [String] {
        return ["play spotify", "pause spotify"]
    }

    override func performCommand(command: String) {
        switch command {
        case "play spotify":
            play()
        case "pause spotify":
            pause()
        default:
            print ("No spotify implementation")
        }
    }
    
    private func play() {
        let task = NSTask.init()
        task.launchPath = "/usr/local/bin/spotify"
        task.arguments = ["play"]
        task.launch()
        task.waitUntilExit()
    }
    
    private func pause() {
        let task = NSTask.init()
        task.launchPath = "/usr/local/bin/spotify"
        task.arguments = ["pause"]
        task.launch()
        task.waitUntilExit()
    }
}
