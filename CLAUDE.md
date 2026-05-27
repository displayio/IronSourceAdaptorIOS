# CLAUDE.md

Guidance for working in this repository.

## What this repo is

A **DIO (display.io / Brandio) custom adapter for IronSource LevelPlay mediation**, iOS, Objective-C.
Remote: `displayio/IronSourceAdaptorIOS`.

> **The adapter is the product.** The Xcode app target is only a manual test harness for it.

### `DDIOAdapterIronSource/` — the actual deliverable

The custom network adapter that bridges IronSource LevelPlay to the DIO SDK. This is what
ships and what changes here matter. It implements IronSource's custom-adapter protocols
(`ISBaseNetworkAdapter`, `ISBaseBanner`, `ISBaseInterstitial`) and drives `DIOSDK` placements
underneath.

- `ISDIOCustomAdapter.{h,m}` — network adapter registration / init.
- `ISDIOCustomInterstitial.{h,m}` — interstitial: loads a `DIOInterstitialPlacement` ad and
  maps DIO ad events to the IronSource `ISInterstitialAdDelegate`.
- `ISDIOCustomBanner.{h,m}` — banner/MREC/infeed: loads a DIO inline placement and returns its
  view via `ISBannerAdDelegate`.

### `IronSource_iOS/` — test app only

A demo app used to manually verify the adapter (load/show interstitial, MREC banner,
interscroller, infeed). **Not a shipped artifact.** Treat changes here as test scaffolding.
Real LevelPlay ad unit IDs live as constants in `ViewController.h` / `ViewController.m`
(`kAdUnit*`); `kAdUnitNative` / `kAdUnitRewarded` are reserved for future use.

## Dependencies & build

- CocoaPods. `Pods/` is **gitignored** — run `pod install` after cloning. `Podfile` / `Podfile.lock`
  are committed.
  - `DIOSDK` 4.7.1, `IronSourceSDK` 9.4.1.0 (pulls FBAudienceNetwork + IronSourceAdQualitySDK).
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
- Test IDs in the app: IronSource appKey `1df03dc05`, DIO appId `7729`.
- **Commit rules: follow [`COMMIT.md`](./COMMIT.md).** Conventional Commits; **do not add a
  Co-Authored-By trailer and do not mention Claude in commit messages.**
