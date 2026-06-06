import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.FitContributor;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.Time;

// Route type constants
enum {
    TYPE_LEAD = 0,
    TYPE_TR = 1,
    TYPE_AUTO = 2
}

class ClimbTaggerField extends WatchUi.SimpleDataField {

    hidden var _routeType as Number = TYPE_LEAD;
    hidden var _routeTypeField as FitContributor.Field;
    hidden var _lapCount as Number = 0;

    // Labels matching the enum
    hidden var _labels as Array<String> = ["LEAD", "TR", "AUTO"];

    function initialize() {
        SimpleDataField.initialize();
        label = "Route";

        // FIT field: records route type (0=Lead, 1=TR, 2=Auto) per lap
        _routeTypeField = createField(
            "route_type",
            0,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_LAP, :units => "type"}
        );
        _routeTypeField.setData(_routeType);
    }

    // Called every second during the activity — return display value
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        return _labels[_routeType];
    }

    // Lap button pressed — cycle route type and record to FIT
    function onTimerLap() as Void {
        _lapCount++;
        // Record current type for the lap that just ended
        _routeTypeField.setData(_routeType);
        // Cycle to next type
        _routeType = (_routeType + 1) % 3;
        _routeTypeField.setData(_routeType);
    }

    // Record final state on stop
    function onTimerStop() as Void {
        _routeTypeField.setData(_routeType);
    }

    // Reset on new activity
    function onTimerReset() as Void {
        _routeType = TYPE_LEAD;
        _lapCount = 0;
        _routeTypeField.setData(_routeType);
    }
}
