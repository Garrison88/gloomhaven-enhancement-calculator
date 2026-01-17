# Info Dialog & Strings Audit Plan

This document outlines the audit of info dialogs and strings to ensure enhancement rule descriptions are accurate for each game edition.

## Files Under Review

- `lib/data/strings.dart` - Contains all rule description text
- `lib/ui/dialogs/info_dialog.dart` - Displays the rule descriptions

---

## Audit Checklist

### 1. Lost Action Modifier (`lostNonPersistentInfoTitle` / `_lostNonPersistentContent`)

**Current Content:**
> "If the action has a Lost icon, but no Persistent icon, halve the base cost."

**Issue:** This description is for Frosthaven only. GH2E has a different rule.

| Edition | Rule |
|---------|------|
| GH | N/A (not available) |
| GH2E | "If the action has a Lost icon **and is not a summon action**, halve the cost" |
| FH | "If the action has a Lost icon, **but no Persistent icon**, halve the cost" |

**Proposed Fix:** Make this content edition-aware, similar to how `_plusOneCharacterContent` works.

---

### 2. Persistent Modifier (`persistentInfoTitle` / `_persistentContent`)

**Current Content:**
> "If the action has a Persistent icon, whether or not there is a Lost icon, triple the base cost. This **does not** apply to summon stat enhancements."

**Status:** ✅ Correct for FH. Only shown in FH mode (UI handles this).

**Verification Needed:** Confirm UI only shows this toggle in FH mode.

---

### 3. Multiple Targets (`multipleTargetsInfoTitle` / `_multipleTargetsContent`)

**Current Content:** Already edition-aware.

**Status:** ✅ Appears correct.

**Verification Needed:**
- GH: "always apply to TARGET+1, never to Hex"
- GH2E/FH: "never apply to TARGET+1, Elements, or Hex"

---

### 4. Card Level Fee (`cardLevelInfoTitle` / `_cardLevelContent`)

**Current Content:**
> "25g is added to the cost of an enhancement for each card level beyond 1 or x."

**Status:** ✅ Same across all editions.

**Missing Info:** No mention of Party Boon (GH/GH2E) or Enhancer Lvl 3 (FH) discounts.

**Proposed Fix:** Add edition-specific discount info.

---

### 5. Previous Enhancements Fee (`previousEnhancementsInfoTitle` / `_previousEnhancementsContent`)

**Current Content:**
> "75g is added to the cost of an enhancement for each previous enhancement on the **same action.**..."

**Status:** ✅ Base rule is correct.

**Missing Info:** No mention of:
- Enhancer Lvl 4 discount (FH only): -25g per previous enhancement
- Temporary Enhancement discount: -20g if at least one previous enhancement

**Proposed Fix:** Add edition-specific discount info.

---

### 6. Summon Enhancements (`_plusOneSummonContent`)

**Current Content:** Already edition-aware for persistent modifier.

**Issue:** Missing info about lost modifier exclusion in GH2E.

| Edition | Lost Discount on Summon Stats |
|---------|-------------------------------|
| GH | N/A |
| GH2E | **Excluded** (summons are always excluded) |
| FH | Allowed (if action is lost but not persistent) |

**Proposed Fix:** Add GH2E-specific note about summon exclusion from lost discount.

---

### 7. Hail's Discount (NEW - not in strings.dart)

**Current Status:** Info is hardcoded in `enhancement_calculator_page.dart` line 143-144.

**Proposed Fix:** Move to `strings.dart` for consistency, or verify current inline description is accurate.

---

### 8. General Info (`_generalInfoContent`)

**Current Content:** Already edition-aware.

**Status:** ✅ Appears correct.

---

### 9. Temporary Enhancement (`_temporaryEnhancementContent`)

**Current Content:** Describes the 20% discount and -20g for previous enhancements.

**Status:** ✅ Available for ALL editions (corrected).

**Action Required:** Replace current text with user-provided content.

---

## Implementation Steps (Updated Based on Feedback)

### Step 1: Update Lost Action Content ✅ APPROVED
- [ ] Convert `_lostNonPersistentContent` to a method that takes `GameEdition`
- [ ] GH2E: "If the action has a Lost icon and is not a summon action, halve the cost"
- [ ] FH: "If the action has a Lost icon, but no Persistent icon, halve the cost"
- [ ] Update `lostNonPersistentInfoBody` to pass edition parameter

### Step 2: Update Multiple Targets Terminology ✅ APPROVED
- [ ] Change "Hex" to "area-of-effect hex" in the multiple targets content

### Step 3: Update Card Level Content ✅ APPROVED (with conditions)
- [ ] Convert `_cardLevelContent` to a method that takes edition + discount flags
- [ ] Add Party Boon info for GH/GH2E **only if Party Boon is enabled** (spoiler protection)
- [ ] Add Enhancer Lvl 3 info for FH **only if Enhancer Lvl 3 is enabled** (spoiler protection)

### Step 4: Update Previous Enhancements Content ✅ APPROVED (with conditions)
- [ ] Convert `_previousEnhancementsContent` to a method that takes edition + discount flags
- [ ] Add Enhancer Lvl 4 info **only if Enhancer Lvl 4 is enabled** (spoiler protection)
- [ ] Add Temporary Enhancement discount info **always** (not a spoiler)

### Step 5: Update Summon Content for GH2E ✅ APPROVED
- [ ] Add note that summon stat enhancements **never** get lost discount in GH2E

### Step 6: Move Hail's Discount to strings.dart ✅ APPROVED
- [ ] Move hardcoded text from `enhancement_calculator_page.dart` to `strings.dart`

### Step 7: Update Temporary Enhancement Content ✅ APPROVED
- [ ] Replace current text with user-provided content:
  "With this variant, enhancement stickers are removed when a character retires. This can be facilitated by affixing the stickers to card sleeves, instead of directly to the ability cards, or by applying reusable stickers (which are sold separately). Temporary enhancements have a reduced cost: First, calculate the normal enhancement cost, including any discounts. Next, if the action has at least one previous enhancement, reduce the cost by 20 gold. Finally, reduce the cost by 20 percent (rounded up)."

### Step 8: Review UI Call Sites
- [ ] Verify `enhancement_calculator_page.dart` passes correct edition/flags to all info dialogs
- [ ] Ensure info dialogs that need edition are receiving it

---

## Execution Order

1. Step 1: Lost Action Content (high priority - currently incorrect)
2. Step 5: Summon Content (high priority - missing info)
3. Step 7: Temporary Enhancement Content (quick fix)
4. Step 2: Multiple Targets Terminology (quick fix)
5. Step 3: Card Level Content (medium)
6. Step 4: Previous Enhancements Content (medium)
7. Step 6: Hail's Discount (low - cleanup)
8. Step 8: UI Call Sites Review (verification)
