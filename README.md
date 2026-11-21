# EquityLab

## Purpose

I built EquityLab to track my finances with a focus on equity, rather than the cash flows most finance apps emphasize. The idea is to keep a precise record of all assets and liabilities and see what actually remains after subtracting what I owe from what I own. Taking snapshots over time makes it possible to observe how that net worth develops.

## Features

### Track Loans

Track money you borrow and lend, including the people or institutions involved. Record transactions and repayments, review their history, and see how much of each loan has been repaid.

<p>
  <img src="Documentation/loanLedger.png" alt="Loan and receivable overview with repayment progress" width="280">
  <img src="Documentation/loanDetail.png" alt="Loan details and transaction history" width="280">
</p>

### Define Snapshot Structure

Define the assets and liabilities you want to track and organize them into pools such as bank accounts, investments, or personal loans. Edit the structure as your financial situation changes.

<img src="Documentation/snapshotStructure.png" alt="Assets and liabilities organized into snapshot pools" width="280">

### Take Snapshots

Capture your financial position on a chosen date by entering the value of each asset and liability. Browse previous snapshots and revisit the values behind your equity at each point in time.

<p>
  <img src="Documentation/snapshotLedger.png" alt="Snapshot history with dates and equity totals" width="280">
  <img src="Documentation/snapshotDetail.png" alt="Snapshot form with asset and liability values" width="280">
</p>

### Visualize Snapshots

Follow your equity over time and select a snapshot to explore its details. Review changes and distributions across asset and liability pools, or see the balance of assets, liabilities, and equity.

<p>
  <img src="Documentation/dashboardAssets.png" alt="Equity history and changes across asset pools" width="280">
  <img src="Documentation/dashboardLiabilities.png" alt="Equity history and changes across liability pools" width="280">
  <img src="Documentation/dashboardBalance.png" alt="Snapshot balance showing assets, liabilities, and equity" width="280">
</p>

## Local Setup

The app was built before Liquid Glass, and I haven't had time to update the UI for it. Run it in an **iOS 18 simulator** to see the interface as originally designed.

### App

Required installations:

- Xcode with iOS 18 simulator support
- An iOS 18 simulator runtime, installed through Xcode's Settings

From the repository root, open the project:

```sh
open EquityLab.xcodeproj
```

Let Xcode resolve the Swift Package dependencies, select the **EquityLab** scheme and an **iPhone simulator running iOS 18**, then press **⌘R** to build and run the app.
