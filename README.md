# Climb Tagger — Connect IQ Data Field

A Connect IQ data field for Garmin Instinct 2 that lets you tag routes as **Lead**, **TR**, or **Auto-belay** during indoor climbing sessions. The route type is recorded as a custom FIT field so it exports with your activity data.

## How it works

- Add it as a data field to your Indoor Climbing activity screen
- Shows the current route type: **LEAD**, **TR**, or **AUTO**
- Press the **lap button** to cycle to the next type
- Writes a `route_type` custom FIT field per lap (0=Lead, 1=TR, 2=Auto) that exports with the activity
- Defaults to LEAD on activity start

## Build & Install

```shell
# Build (requires Connect IQ SDK)
monkeyc -f ~/jottenlips/climb-tagger/monkey.jungle \
  -o ~/jottenlips/climb-tagger/climb-tagger.prg \
  -y ~/watchface/developer_key.der \
  -d instinct2
```

To sideload it, connect your Instinct 2 and drop `climb-tagger.prg` into `GARMIN/APPS/`. Or use the Connect IQ VS Code extension to deploy.

## Caveats to test on the watch

- The climbing activity auto-detects routes and creates its own laps. You'll want to test whether the manual lap button conflicts with auto-lap, or if they coexist. If there's interference, we might need to switch to recording per-session instead of per-lap.
- The icon is 60x60 instead of 62x62 — it'll scale fine but you can swap it later.

## What's next

Once you start getting tagged FIT data, we can parse the `route_type` field in the [garminclimb](https://github.com/jottenlips/garminclimb) chart generator to split speed/send-rate/grade charts by Lead vs TR vs Auto-belay.

## Why

Garmin's climbing activity tracks routes, grades, sends, and falls automatically via `splitSummaries`, but doesn't distinguish between lead, top-rope, and auto-belay. This matters because:

- Auto-belay routes are shorter (~5-8m) and inflate speed/send-rate metrics
- Lead performance on tall routes (10m+) is what translates to outdoor climbing
- Splitting the data by route type gives a more accurate picture of progression
