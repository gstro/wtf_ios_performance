slidenumbers: true
autoscale: true
build-lists: true
<!-- globals above this line -->

# [fit] WTF

---

# [fit] WTF
# [fit] Is So Slow In My App?

## Greg Stromire
## PDX CocoaHeads - May 9, 2018

^Thanks everyone for coming

^Thank you to Ryan and Dexcom

---

# About Me

Software Engineer @ **Tozny**
  - Cryptography and Privacy Company
  - I'm _often_ developing for iOS

^Data Privacy and Protection using applied Cryptography

^Products for password-less authentication and end-to-end encrypted database

^Mainly client SDKs, but more services work lately

PDX CocoaHeads Member Since **January 2014**

^May have been coming to meetings prior to 2014, just start of Meetup membership

^I remember discussing the introduction of ARC

[.build-lists: false]

---

# Who has used:

- `XCTest`?
- `measure`?
- Benchmarks?
- _Time Profiler:tm:_?

---

# Agenda

1. What this talk is _not_ :x:
2. Notes about "Performance" :pencil:
3. Example Application :iphone:
4. _Time Profiler:tm:_ :clock3:
5. `XCTest`ing for Performance :white_check_mark:
6. Address Issue and Confirm :100:
7. `Check` for Regressions :sparkles:

---

# What this talk is _Not_

---

# What this talk is _Not_

"Performance" as it relates to:
  - Network
  - Memory
  - Battery
  - Etc.

Exhaustive List of Possible Performance Issues

A Magic Bullet

^Performance is a WIDE-RANGING issue

^So what IS this talk about?

[.build-lists: false]

---

# When we say
# [fit] Performance
# we often mean
# [fit] Responsiveness

---

> We've found that if it takes too much longer than a hundred milliseconds, your user starts to feel it.
-- WWDC 2015 Session 230

^So your goal for any responsiveness scenario should be 100 milliseconds.

^Consider the oldest hardware you intend to support.

---

Consider a copy of your `Release` Scheme with wrappers around UX[^1]:

```swift
@IBAction func buttonPressed() {
#if PERFORMANCE
    let before = CFAbsoluteTimeGetCurrent()
#endif
    intensiveOperation() // long running task
#if PERFORMANCE
    let after  = CFAbsoluteTimeGetCurrent()
    print("\"Real\" time of operation: \(after - before)")
#endif
}
```

[^1]: WWDC 2015 Session 230

---

# Various Performance Tips[^2]

- Use a `reuseIdentifier` Where Appropriate
- Set Views as Opaque When Possible
- Don’t Block the Main Thread
- Size Images to Image Views
- Use Sprite Sheets
- Avoid Date Formatters Where Possible

^Maybe one of these could fix the issue in my example app?

[^2]: [25 iOS App Performance Tips - raywenderlich.com](https://www.raywenderlich.com/31166/25-ios-app-performance-tips-tricks)

---

That said...

# [fit] 👺 Beware
# [fit] Premature Optimization

---

# [fit] 👺
# Premature Optimization
- Don't guess, profile!
- Be systematic!

^ One change at a time -- process of elimination

---

# Example App

---

# Example App

Secret message application.
Encrypts :lock: and decrypts :key: user-supplied text.

- Simplified version of a real problem I encountered
- Anyone heard of `libsodium`[^3]?

^start app

[.build-lists: false]

[^3]: [libsodium](https://download.libsodium.org/doc/)

---

# [fit] WTF

---

# WTF Is So Slow In My App?

1. Am I using a slow algorithm?
2. Is this library implementation slow?
3. Are the instance creations expensive?
4. Is this a result of moving around the `String` (i.e. Value type)?
5. Something else?

^crypto libraries: ciphers, modes, padding...

^Too many

^Collect data like a scientist

---

# Time Profiler:tm:

^full demo, through `Data.init` fix

^identify base64url bottleneck

^let's do this the "right" way

---

# Time Profiler:tm:

Can be in-app or in-tests

Allows inspection and drill-down

Heaviest stack trace on the right panel

Hold down `option` and click disclosure triangle

Click to go to calling code

Did we identify any issues?

^What we don't want to do: just dive in and try things out. (At least not yet.)

^How do we know if we've improved? Can we quantify that "experience?"

---

# `XCTest`ing for Performance

^Example code: `measure`, `measureMetrics`, `startMeasuring`, `stopMeasuring`

^Class and instance setup

---

# `XCTest`ing for Performance

- `measure`, `measureMetrics`, `startMeasuring`, `stopMeasuring`
- Baseline and STDDEV
  - Baselines are _per device_
  - Can commit baselines to project repo

^full demo through improved baselines

---

# Addressing the Issue
- [Base64URL](http://lmgtfy.com/?q=base64url+swift) :snail:
- [Swift-Sodium](https://github.com/jedisct1/swift-sodium/blob/040915692a9cfdea4039d4b0e30e88d94e4b8362/Sodium/Utils.swift#L97) :racehorse:
- Fix issue and Run Tests :white_check_mark:
- Compare Baselines :100:

^Show Graphs?

^(IF TIME?) Set new baselines

^(IF TIME?) Show failure on old encoding _performance_?

---

# Checking for Regressions

- Encoding random data -- does this new implementation match?
- I should test with a diverse set of cases to raise my confidence.
- But how?
- Enter `SwiftCheck`

---

# `SwiftCheck`

- Based on `QuickCheck` from Haskell

^Anyone familiar with either?

- Generates 100 widely variable test cases

^Much better than a person can -- known edge cases per type

- Also **shrinks** the failing cases!

- General use testing tool -- I’m using it here for regressions

- Setup: `Arbitrary`, `forAll`, etc.

[.build-lists: false]

---

# `SwiftCheck`ing for Regressions

---

# Lessons From Our Performance Journey

1. Profile Early, Profile Often, and Let that Inform Optimizations
2. `XCTest` for Performance: `measure` and Baselines
3. Drill Deep with TimeProfiler:tm:
4. Fix the Issue and Update Baselines
5. Check for Regressions with `SwiftCheck`

[.build-lists: false]

---

# [fit] Thanks!
# Questions?
