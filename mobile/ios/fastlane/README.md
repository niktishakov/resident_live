# iOS App Distribution Guide

This guide explains how to distribute the iOS app using both TestFlight and Ad Hoc methods.

## Prerequisites

1. Xcode Command Line Tools
   ```bash
   xcode-select --install
   ```

2. Fastlane Installation
   - Follow [Installing Fastlane](https://docs.fastlane.tools/#installing-fastlane) instructions
   - Make sure all gems are installed:
     ```bash
     cd ios
     bundle install
     ```

3. For Ad Hoc Distribution:
   - Project manager's iPhone UDID registered in Apple Developer account
   - UDID included in an ad hoc provisioning profile
   - Required certificates installed on your Mac

## Available Distribution Methods

### 1. TestFlight Distribution

Deploy a new build to TestFlight for testing:

```bash
cd mobile/ios
bundle exec fastlane beta
```

This will:
- Increment the build number
- Build the app
- Upload to TestFlight
- Notify testers (if configured)

### 2. Ad Hoc Distribution

Generate an ad hoc IPA for direct installation:

```bash
cd mobile/ios
bundle exec fastlane adhoc
```

The IPA will be generated at `./build/ResidentLive_AdHoc.ipa`

#### Installing the Ad Hoc IPA

There are several methods to install the ad hoc IPA:

1. **Apple Configurator 2**
   - Install [Apple Configurator 2](https://apps.apple.com/us/app/apple-configurator-2/id1037126344)
   - Connect iPhone to Mac
   - Drag and drop IPA file onto Apple Configurator 2
   - Follow installation prompts

2. **Diawi**
   - Upload IPA to [Diawi](https://www.diawi.com/)
   - Share generated link with project manager
   - Install directly from link on iPhone

3. **TestFlight Alternative**
   - Use TestFlight instead of ad hoc for easier distribution
   - Run `bundle exec fastlane beta`
   - Invite project manager as internal tester

## Device Registration Guide

To register a new test device:

1. Connect iPhone to Mac
2. Open Xcode
3. Go to Window > Devices and Simulators
4. Copy the device Identifier (UDID)
5. Visit [Apple Developer Portal](https://developer.apple.com/account/resources/devices/list)
6. Add device with UDID
7. Regenerate ad hoc provisioning profile to include the device

## Troubleshooting

If you encounter issues:

1. **Ad Hoc Installation Fails**
   - Verify device UDID is correctly registered
   - Check provisioning profile includes the device
   - Ensure bundle identifier matches provisioning profile
   - Verify signing certificate is valid and installed

2. **Build Errors**
   - Clean build folder: `flutter clean`
   - Reinstall pods: `pod install`
   - Update fastlane: `bundle update fastlane`

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools)
- [TestFlight Guide](https://developer.apple.com/testflight/)
- [Ad Hoc Distribution Guide](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing/distributing-your-app-using-ad-hoc-provisioning)

---
*Note: This README combines automated fastlane documentation with manual instructions for comprehensive app distribution guidance.*
