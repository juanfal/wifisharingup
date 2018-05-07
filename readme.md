# Definitive workaround to wifi-sharing constant breaking down in MacosX

I have found a system that finally **works** and when, less frequently wifi sharing breaks, it manages to recover it automatically in a minute.

The solution is a `~/Library/LaunchAgents/com.me.wifisharingup.plist` daemon with the next contents:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>com.me.wifisharingup</string>

      <key>ProgramArguments</key>
      <array>
        <string>/Users/me/bin/wifisharingup.sh</string>
      </array>
      <key>Nice</key>
      <integer>1</integer>

      <key>StartInterval</key>
      <integer>60</integer>

      <key>RunAtLoad</key>
      <true/>

      <key>StandardErrorPath</key>
      <string>/Users/me/Library/Logs/wifisharingup.err</string>

      <key>StandardOutPath</key>
      <string>/Users/me/Library/Logs/wifisharingup.out</string>
    </dict>
    </plist>


You can see, each minute it runs the simple script that follows.  Be careful making the previous plist be owned by the root and launch it with:

    sudo chown root com.me.wifisharingup.plist
    sudo launchctl load /Users/me/Library/LaunchAgents/com.me.wifisharingup.plist

The script it launches each minute (don't forget to make it executable) is:

    #!/bin/sh

    if [[ ! `ipconfig getifaddr en1` ]]; then
        /usr/sbin/networksetup -setairportpower en1 off
        /usr/sbin/networksetup -setairportpower en1 on
        echo `date` >> "/Users/me/Library/Logs/wifisharingup.err"
    else
        touch "/Users/me/Library/Logs/wifisharingup.out"
    fi

I think the simple periodically (each minute) call to `ipconfig getifaddr en1` refreshes something in what is the wifi sharing daemon.  Whatever it is, any moment the wifi sharing fails, it looses the self assigned IP address, and then, `ipconfig getifaddr en1` fails, so my script totally resets wifi, making it rebuild its previous status and recovering the wifi-sharing.

It has been working for days so far inside a MacMini without keyboard, mouse or monitor, but only plugged into the Ethernet and giving my wifi gadgets access to the world.
