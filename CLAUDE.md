# CLAUDE.md

Guidance for working in this repository.

## What this repo is

A **DIO (display.io / Brandio) custom adapter for IronSource LevelPlay mediation**, iOS, Objective-C.
Remote: `displayio/IronSourceAdaptorIOS`.

> **The adapter is the product.** The Xcode app target is only a manual test harness for it.

### `DDIOAdapterIronSource/` — the actual deliverable

The custom network adapter that bridges IronSource LevelPlay to the DIO SDK. This is what
ships and what changes here matter. It implements IronSource's custom-adapter protocols
(`ISBaseNetworkAdapter`, `ISBaseBanner`, `ISBaseInterstitial`, `ISBaseRewardedVideo`) and drives
`DIOSDK` placements underneath.

- `ISDIOCustomAdapter.{h,m}` — network adapter registration / init. `adapterVersion` is the
  adapter's own version (`kDIOAdapterVersion`, e.g. `4.8.1`), `networkSDKVersion` is DIOSDK's.
- `ISDIOCustomInterstitial.{h,m}` — interstitial: loads a `DIOInterstitialPlacement` ad and
  maps DIO ad events to the IronSource `ISInterstitialAdDelegate`. `adDidClose` is sent only on
  `DIOAdEventOnClosed`, never on `OnAdCompleted` (completion only sends `adDidEnd`, once).
- `ISDIOCustomRewardedVideo.{h,m}` — rewarded: same flow on an interstitial (or deprecated
  rewarded-video) placement. Accepts only video/audio creatives (anything else is finished and
  reported as no fill); `adRewarded` fires once, on `OnAdCompleted`, before `adDidClose`.
- `ISDIOCustomBanner.{h,m}` — banner/MREC/infeed/interscroller: loads a DIO inline placement and
  returns its view via `ISBannerAdDelegate`. Rejects a placement that does not match the requested
  size (banner placement in a 300x250 slot and vice versa). `adDidOpen` is posted one main-loop
  pass later, because DIOSDK marks the impression synchronously in `didMoveToWindow`, i.e. while
  LevelPlay is still handling `adDidLoadWithView`. `destroyAdWithAdData` cancels a load in flight.

All adapter state lives in instance properties: LevelPlay creates one adapter object per
instance, so file-level globals leak ads between instances.

Config keys read from LevelPlay: `dio_app_id` (app level), `dio_placement_id` (instance level).
LevelPlay custom network key: `15bfd7489`. Consent is not set by the adapter — DIOSDK reads the
IAB keys the publisher's CMP writes.

### `IronSource_iOS/` — test app only

A demo app used to manually verify the adapter (interstitial, rewarded, banner 320x50,
interscroller, infeed). **Not a shipped artifact.** Treat changes here as test scaffolding.
Real LevelPlay ad unit IDs live as constants in `ViewController.m` (`kAdUnit*`); `kAdUnitNative`
is reserved for future use.

Banner and infeed behave the same: the format button loads, its Show button displays. The main
screen has a global **Use Feed** switch under the logos (on by default):
- on — Show opens banner / infeed in `FeedViewController` (ad at row 5); interscroller always
  opens the feed;
- off — interscroller still opens the feed, Show places banner / infeed in an ad slot on the main
  screen between the last button row and the version labels, so they never cover a control.

## Dependencies & build

- CocoaPods. `Pods/` is **gitignored** — run `pod install` after cloning. `Podfile` / `Podfile.lock`
  are committed.
  - `DIOSDK` 4.8.1, `IronSourceSDK` 9.6.1.0 (pulls FBAudienceNetwork + IronSourceAdQualitySDK).
  - The Podfile pins `platform :ios, '15.0'` and raises every pod target to 15.0 in
    `post_install` — Xcode 27 refuses the 10.0/12.0 targets the IronSource pods declare.
- Open / build via the **workspace**, not the project:

```bash
pod install
xcodebuild -workspace IronSource_iOS.xcworkspace -scheme IronSource_iOS \
  -sdk iphonesimulator -configuration Debug \
  -destination 'generic/platform=iOS Simulator' build
```

## Things to know

- **IronSource 8+/9.x is LevelPlay only** — the legacy mediation API (`ISBannerView`,
  `[IronSource loadInterstitial]`, global delegates) was removed. The test app uses the
  LevelPlay `LPM*` classes (`LPMInterstitialAd`, `LPMBannerAdView`, `LPMInitRequest`).
  The adapter side uses the `ISBase*` custom-adapter protocols (unchanged across the bump).
- Test IDs in the app: LevelPlay appKey `2899db815` ("DIO App iOS v2"), DIO appId `7729`.
  The old app `1df03dc05` ("DIO App iOS (old)") is rejected by LevelPlay init with
  "Invalid Application" (2140) — do not switch back to it.
- The publishing copy of the adapter lives in `~/Desktop/iOSWork/iOSMediationAdapters/IronSource`
  (pod `IronSource-DIO-Adapter`); sync `DDIOAdapterIronSource/` there when releasing.
- Release notes: [`CHANGELOG.md`](./CHANGELOG.md).
- **Commit rules: follow [`COMMIT.md`](./COMMIT.md).** Conventional Commits; **do not add a
  Co-Authored-By trailer and do not mention Claude in commit messages.**
