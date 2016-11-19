# ~~Jarvis~~ Navi
A virtual assistant for MacOS.

I was looking for an excuse to learn MacOS development one day and since Apple took too long porting Siri to the Mac, I made my own. Siri is out now so this is mostly obsolete, but it was still fun to build and interact with it.

## Highlights
- Wake up alarms
- Control Spotify
- Open frequently used webpages
- Facetime/text contacts


## Always listening, never annoying
Using Apple's NSSpeechRecognizer, Navi listens for certain key commands. Once you add the first 20+ commands, it can pick up a lot of false positives and do things you aren't expecting. So after being idle for 60 seconds, Navi simply goes to sleep and ignores all commands until you give it a wake-up command, "Hey Navi." 

## Smart Controllers 
Controllers are what drive Navi. New functionality can be easily added by just dropping in a new controller. Each controller is able to tell Navi what commands to listen to, then Navi simply hands the task off to the controller.

Future goal: A controller would be able to store context specific data and "learn" new commands as it grows.

