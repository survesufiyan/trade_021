# 021 Trade — Watchlist Flutter App

A production-grade Flutter trading watchlist app demonstrating **BLoC architecture**, drag-to-reorder, and clean project structure.

## Assignment Walkthrough

Watch the short end-to-end demonstration of watchlist management, live market
prices, simulated order placement, holdings with live P&L, and persistent order
history:

▶️ **[Watch the assignment walkthrough video](assignment_walkthrough.mp4)**

> If GitHub downloads the file instead of playing it in the browser, open the
> downloaded MP4 with any standard video player.

---

## Features

-  Market indices header (SENSEX, NIFTY BANK)
-  Instrument search bar
-  Multiple watchlists (tab navigation)
-  Live-style stock tiles with price/change/% display
-  Edit mode with **drag-to-reorder** and delete
-  Save / Cancel draft changes
-  Faithful recreation of 021 Trade UI

---

## Tech Stack

| Layer | Technology |
|---|---|
| State Management | `flutter_bloc ^8.1.3` |
| Equality | `equatable ^2.0.5` |
| Testing | `bloc_test ^9.1.5` |
| UI | Flutter Material 3 |

## Project Structure

```
lib/
├── main.dart                        # App entry point + explicit BlocProvider setup
├── models/
│   ├── stock.dart                   # Stock entity with verbose copyWith
│   ├── watchlist.dart               # Watchlist entity with manual null handling
│   └── market_index.dart            # MarketIndex entity
├── data/
│   └── watchlist_repository.dart    # Sample data source with try-catch wrapped methods
├── bloc/
│   ├── watchlist_event.dart         # All BLoC events with comments
│   ├── watchlist_state.dart         # Browse + Edit states with manual copyWith
│   └── watchlist_bloc.dart          # Business logic with verbose handlers
├── theme/
│   └── app_theme.dart               # Centralised colour/font tokens with explanations
├── screens/
│   ├── watchlist_screen.dart        # Main watchlist with explicit widget building
│   └── edit_watchlist_screen.dart   # Edit/reorder mode with manual state handling
└── widgets/
    ├── stock_list_tile.dart          # Browse-mode stock row with verbose formatting
    ├── market_index_tile.dart        # Header index tile with explicit variable extraction
    ├── price_text.dart               # Price formatting with manual number system handling
    ├── app_bottom_nav_bar.dart       # Bottom nav built with intermediate widget variables
    └── draggable_stock_tile.dart     # Drag tile with explicit row construction
```

---

## BLoC Design

### Events
| Event | Trigger |
|---|---|
| `WatchlistLoaded` | App startup |
| `WatchlistTabChanged(index)` | Tab tap |
| `WatchlistEditStarted` | Sort/Edit button |
| `WatchlistStockReordered(old, new)` | Drag drop |
| `WatchlistStockRemoved(id)` | Delete button |
| `WatchlistEditSaved` | Save button |
| `WatchlistEditCancelled` | Back button |

### States
| State | Description |
|---|---|
| `WatchlistInitial` | Loading |
| `WatchlistBrowseState` | Normal view |
| `WatchlistEditState` | Edit mode (has `draftStocks`) |

---


## Getting Started

```bash
flutter pub get
flutter run
```

### Run Tests
```bash
flutter test
```

---

## Key Design Decisions

1. **Non-destructive editing** — `draftStocks` is a deep copy; originals untouched until Save
2. **`ReorderableListView.builder`** — Flutter's native drag-to-reorder, no third-party deps
3. **`Equatable` on all models** — BLoC rebuilds only when data actually changes
4. **`ValueKey(stock.id)`** — Correct identity tracking during reorder animations
5. **`BlocConsumer`** — Edit screen auto-pops when save transitions to BrowseState
6. **Type-safe enums** for `ExchangeType` & `InstrumentType` — no stringly-typed comparisons

---

## Development Notes

### Intentional Code Characteristics
- **Verbosity**: Code is more verbose than necessary to simulate junior developer patterns
- **Over-commenting**: Comments explain obvious logic (typical of less experienced developers)
- **Manual implementations**: Uses loops and conditionals instead of functional methods
- **Explicit typing**: Type annotations used extensively for clarity
- **Redundant checks**: Safety checks that may seem unnecessary but show defensive programming
- **Helper methods**: Logic extracted into small methods even for simple operations
