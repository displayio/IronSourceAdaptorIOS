# Handoff — Display.io LevelPlay adapter, iOS 4.8.1

Status as of 2026-10-13. This repo and `~/Desktop/iOSWork/iOSMediationAdapters` are **committed,
not released**. Android
counterpart: `~/Desktop/AndroidWork/IronSourceAndroid/HANDOFF.md`.

## Context

- Display.io is a **custom network** in Unity LevelPlay (formerly ironSource), network key
  `15bfd7489`. LevelPlay instantiates the `ISDIOCustom*` classes by name.
- Config keys entered by the publisher in LevelPlay: `dio_app_id` (app level),
  `dio_placement_id` (instance level). Rate-based (waterfall) only — custom networks cannot bid.
- Consent: not set by the adapter. DIOSDK reads the IAB keys written by the publisher's CMP.
- Ad expiry: not handled by the adapter (out of scope).

## What was done

### Adapter (`DDIOAdapterIronSource/`)
- DIOSDK 4.7.1 → **4.8.1**, IronSourceSDK 9.4.1.0 → **9.6.1.0**. The Podfile now pins iOS 15 and
  raises every pod target to 15.0 (Xcode 27 rejects the 10.0/12.0 targets of the IronSource pods).
- New **rewarded video** (`ISDIOCustomRewardedVideo`).
- Bug fixes and behaviour changes — see [`CHANGELOG.md`](./CHANGELOG.md) (4.8.1). The most visible
  one: interstitial `closed` used to reach the app as soon as the video ended, while the ad was
  still on screen.
- Adapter version `4.8.1` (`kDIOAdapterVersion`).
- [`CLAUDE.md`](./CLAUDE.md) updated.

### Publishing repo (`~/Desktop/iOSWork/iOSMediationAdapters`)
- `IronSource/` synced with `DDIOAdapterIronSource/` (identical, rewarded included).
- `IronSource-DIO-Adapter.podspec` → `4.8.1`, `DIOSDK >= 4.8.1`. README requirement line updated.
- `pod lib lint --quick` passes; the SPM product `IronSource-DIO-Adapter` builds. The SPM
  `DIOSDK` requirement is now `from: "4.8.1"` for all adapters.

### Test app (`IronSource_iOS/`, internal only)
- Rows: Interstitial / Show, Banner (now 320x50) / Show, Interscroller, Infeed / **Show (new)**,
  **Rewarded / Show (new)**. Banner and infeed work the same way: the format button loads, Show
  displays.
- Global **Use Feed** switch under the logos (on by default): on — Show opens banner / infeed in a
  feed, interscroller always opens in a feed; off — interscroller still in a feed, Show places
  banner / infeed between the last button row and the version labels. Ads never cover controls.

### LevelPlay dashboard (test account)
- The old app `1df03dc05` is rejected by LevelPlay init ("Invalid Application", code 2140) and is
  renamed **"DIO App iOS (old)"**.
- New app **"DIO App iOS v2"**, app key **`2899db815`**, used by the test app. DisplayIO instances
  (`dio_app_id` = `7729`):

| Ad unit | Ad unit ID | DIO placement |
|---|---|---|
| Interstitial | `3y98oeuomvtgj1bw` | 5197 (interstitial video) |
| Rewarded | `qfg6631ek1iqdnxg` | 5197 (interstitial video) |
| Banner (320x50) | `1eyeni5hr976t06u` | 15770 (banner video) |
| Infeed (300x250) | `fg0sfdrx050iih6q` | 5134 (infeed video) |
| IS — interscroller | `xu0a4x9dm9fa4ey2` | 7022 (interscroller video) |

### Verified so far
- Through LevelPlay on the iPhone 17 Pro simulator: all five formats load and show; interstitial
  `closed` arrives only after the real close; rewarded grants the reward once, before `closed`;
  banner/infeed report `loaded` before `displayed`; a banner placement in a 300x250 slot fails.
- Use Feed on/off layouts checked programmatically: 0 overlaps between the inline ad and any
  control or label.
- Physical iPhone 17 Pro: test app installed, manual pass in progress.

## What is left

### 1. QA (to be handed over)
Use the test app with app key `2899db815` on a physical device. For each format check:

| Area | Expected |
|---|---|
| Interstitial | loads, shows, `closed` only after the user closes it (not when the video ends) |
| Rewarded | `rewarded` exactly once, after the video ends, before `closed`; closing early → no reward |
| Banner 320x50 | loads, displays, click opens the landing page |
| Infeed 300x250 | loads, displays, click opens the landing page |
| Interscroller | displays inside the feed, scroll effect works |
| Use Feed on/off | banner/infeed switch between feed and inline; nothing covers the buttons |
| Small screens | on an iPhone SE-size screen the inline infeed (300x250) may not fit — check |
| Dashboards | impressions and clicks in LevelPlay vs the Display.io dashboard (after ≥ 1 day of traffic) |

Known LevelPlay limitation: custom adapters are not listed in the Integration Test Suite, so
"adapter version visible in the test suite" cannot be met.

### 2. Release (when instructed)
- `iOSMediationAdapters` is prepared for 4.8.1 together with all other adapters (podspecs, SPM
  `DIOSDK` from 4.8.1, iOS 15.0; lint and SPM build pass). Remaining: tag `4.8.1`,
  `pod trunk push IronSource-DIO-Adapter.podspec`; SPM picks the release up from the tag.

### 3. Publisher documentation (`~/Desktop/Docs/wp-documentation`)
Section `docs/ios-adapters.html#ironsource` is outdated:
- **Screenshots to replace** (all from 2024-03-26, old ironSource UI; LevelPlay is now Unity LevelPlay):
  1. `Screenshot-2024-03-26-at-11.35.34` — Networks → Add custom network
  2. `Screenshot-2024-03-26-at-11.37.52` — entering network key `15bfd7489`
  3. `Screenshot-2024-03-26-at-12.08.41` — DisplayIO app/instance settings (`dio_app_id`, `dio_placement_id`, rate)
  4. `Screenshot-2024-03-26-at-11.41.17` — Management → Mediation (waterfall)
- In the new screenshots replace every real identifier with placeholders —
  `YOUR_APP_ID`, `YOUR_PLACEMENT_ID`, `YOUR_APP_KEY`, `YOUR_AD_UNIT_ID`. The network key
  `15bfd7489` stays — publishers need it.
- Text updates: `pod 'IronSource-DIO-Adapter', '4.7.1'` → `4.8.1`; LevelPlay naming instead of
  ironSource; supported formats table (interstitial, rewarded, banner 320x50, infeed / medium
  rectangle 300x250, interscroller); a rewarded instance must point to an interstitial placement
  serving video or audio; consent comes from the publisher's CMP.
- Docs are not deployed by us.

### 4. Open items
- Decide whether to remove the extra custom network "display.io inc" (`15c135dd5`) that is also
  saved in the LevelPlay account. The "(old)" apps stay as they are.
