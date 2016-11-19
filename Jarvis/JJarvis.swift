//
//  JJarvis.swift
//  Jarvis
//
//  Created by Frank on 5/24/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JJarvis: NSObject, NSSpeechRecognizerDelegate {

    static let shared = JJarvis()
    
    var operationQueue: NSOperationQueue!
    var speechRecognizer = NSSpeechRecognizer()
    var isListening = false
    var commands:[String]!
    var lastSpeechCommand : String!
    var lastAttention: NSDate!
    var controllers : [JCommandController] = [JSpotifyController.init(), JAudioController.init(), JLocationController.init(), JWeatherController.init(), JAlarmController.init() ]
    var originalSystemVolume: Float!



    override init() {
        super.init()
        
        operationQueue = NSOperationQueue.init()
        operationQueue.maxConcurrentOperationCount = 1

        
        commands = ["hello computer", "stop listening", "go away", "hey computer", "hey navi", "say again", "list commands", "facetime terra", "text terra"]
        //        commands.appendContentsOf(["alpha", "bravo", "charlie", "delta", "echo", "fox", "golf", "hotel", "india", "juliet", "kilo", "lima", "mike", "november", "ocscar", "papa", "qubec", "romeo", "siera", "tango", "uniform", "victor", "whiskey", "xray", "yankee", "zulu"])
        
        commands.appendContentsOf(["build M4K", "build M 4 K"])
        
        for controller in controllers {
            controller.setup()
            print("setup \(controller.className)")
            commands.appendContentsOf(controller.getCommands())
            print ("added commands")
        }
        
        speechRecognizer?.delegate = self
        speechRecognizer?.commands = commands
        speechRecognizer?.startListening()
        
        lastAttention = NSDate.init()

    }
    
    
    func speechRecognizer(sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        
        print ("Command: \(command)")
        
        if (lastAttention.timeIntervalSinceNow < -60) {
            isListening = false
            print ("<INFO> Navi fell asleep.")
        }
        
        if (command == "hey computer" || command == "hey navi") {
            sayMessage(randomResponse(["Yes?", "How can I help you?", "What's up?"]))
            isListening = true
            lastAttention = NSDate.init()
            return
        }
        
        // if not listening, no further processing
        if (isListening == false) {
            return
        }
        
        lastAttention = NSDate.init()
        
        for controller in controllers {
            if (controller.respondsToCommand(command)) {
                controller.performCommand(command)
            }
        }
        
        switch command {
        
        case "hello computer":
            sayMessage(randomResponse(["Hello.", "What's up?", "Hey.", "Yo."]))
        case "stop listening", "go away":
            isListening = false
            sayMessage("Ok.")
        case "list commands":
            print ("Listing all commands...")
            for cmd in commands {
                print(cmd)
            }
        case "say again":
            sayMessage(lastSpeechCommand)
        case "build M4K", "build M 4 K":
            build("M4K")
        case "facetime terra":
            facetimeTerra()
        case "text terra":
            JOpenerController().open("iMessage://4804897948")
        
            
        default:
            print ("No implementation for command '\(command)'")
        }
    }
    
    private func randomResponse(responses: NSArray) -> String {
        return responses[Int(rand()) % responses.count] as! String
    }
    
    func build(project : String) {
        if (project == "M4K") {
            let task = NSTask.init()
            task.launchPath = "/usr/bin/git"
            task.arguments = ["push", "heroku", "master"]
            task.launch()
            task.waitUntilExit()
        }
    }
    
    
    func facetimeTerra() {
        JOpenerController().open("facetime://4804897948")
    }
    
    func say(text: String) {
        print("Saying... \(text)")
        lastSpeechCommand = text
        
        let task = NSTask.init()
        task.launchPath = "/usr/bin/say"
        task.arguments = [text]
        task.launch()
        task.waitUntilExit()
    }
    
    
    func sayMessage(message: String) {
        operationQueue.addOperation(NSBlockOperation.init(block: {
            self.say(message)
            
        }))
    }
    
    
    
}
