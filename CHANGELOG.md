# Changelog

Display.io custom adapter for Unity LevelPlay (ironSource), iOS.

## 4.8.1

### Added
- Rewarded video. The reward is granted once, after the ad has been watched to the end and before the ad closes; closing early grants nothing.
- Rewarded slots only accept video and audio creatives. Any other creative is reported to LevelPlay as no fill, so users never sit through an ad that cannot reward them.

### Changed
- Built against DIOSDK 4.8.1 and IronSourceSDK (LevelPlay) 9.6.1.0.
- The adapter reports its own version to LevelPlay instead of the DIOSDK version.
- A banner placement now has to match the requested ad size (320x50 banner vs 300x250 infeed / medium rectangle); a mismatch fails the load instead of rendering the wrong size.

### Fixed
- Interstitial: LevelPlay received "ad closed" as soon as the video finished, while the ad was still on screen, so the app could resume behind it. "Closed" is now sent only when the user closes the ad.
- Interstitial: a show failure before the ad was displayed was never reported.
- Banner and infeed: the impression reached LevelPlay before the load, so apps saw "displayed" before "loaded".
- A banner destroyed while it was still loading was delivered anyway and counted an impression.
- Destroying a displayed banner reported a spurious "screen dismissed" event.
- Several banner or interstitial instances shared one ad object and could close or replace each other's ads.
