using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.Lang;


class BasicWatchFaceApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
        System.println("Debug: App initialized");
    }

    function getInitialView() {
        System.println("Debug: Creating initial view");
        return [new BasicWatchFaceView()];
    }
}

class BasicWatchFaceView extends WatchUi.WatchFace {
    var customTimeFont;
    var customFieldFont;

    function initialize() {
        WatchFace.initialize();
        System.println("Debug: Watch face view initialized");
        
        // Load the custom font
        customTimeFont = WatchUi.loadResource(Rez.Fonts.CustomTimeFont);
        customFieldFont = WatchUi.loadResource(Rez.Fonts.CustomFieldFont);
        System.println("Debug: Custom time font loaded");
    }

    function onUpdate(dc) {
        // Clear and basic setup
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Get the data
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (hours >= 12) {
 
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        if (hours == 0) {
            hours = 12;
        }

        var timeString = Lang.format("$1$:$2$:$3$", [
        hours.format("%02d"),
        clockTime.min.format("%02d"),
        clockTime.sec.format("%02d")  // Added seconds
        ]);
        
        var info = ActivityMonitor.getInfo();
        var steps = info.steps;
        
        var heartRate = ActivityMonitor.getHeartRateHistory(1, true).next();
        var hrString = (heartRate != null && heartRate.heartRate != null) ? 
            heartRate.heartRate.toString() + " bpm" : "-- bpm";

        // Calculate center positions
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        
        dc.setColor(0x55FF55, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            centerY - 150,
            customFieldFont,  // Try system font
            steps + " steps",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            centerY - 50,
            customTimeFont,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Try different number font for heart rate
        dc.setColor(0x55FF55, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            centerY + 140,
            customFieldFont,  // Try number font
            hrString,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }
}