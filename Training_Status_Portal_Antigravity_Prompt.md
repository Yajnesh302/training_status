# Project Build Prompt — Employee Training Status Portal

## Context / Tech Stack (mandatory constraints — do not substitute alternatives)
- Build an **ASP.NET Web Forms** application (same architecture style as my earlier "Attendance" project).
- **Target Framework: .NET Framework 4.5** — project files must set `targetFramework="4.5"` in web.config.
- Must open and build in **Visual Studio 2015** with no dependency on newer tooling, SDKs, or .NET Core/5+/6+/.NET Standard packages. Do not use NuGet packages that require a newer VS version or newer .NET Framework than 4.5.
- **Must run fully offline.** I will develop on my PC (which has internet) and then copy the entire project folder to my office PC, which has **no internet access at all**. So:
  - Any NuGet package used must be **restored/downloaded during development** so that the `packages` folder (or equivalent) is physically present inside the project folder before I copy it.
  - Do not rely on CDNs for CSS/JS (no Bootstrap/jQuery/DataTables from CDN links) — download and reference all JS/CSS libraries **locally** from the project's own `Scripts`/`Content` folders.
  - No calls to any external web service, license server, or telemetry endpoint at runtime.
- **Database: Oracle 11g.** Use `System.Data.OracleClient` or `Oracle.DataAccess` (ODP.NET, 32-bit/unmanaged as appropriate for Oracle 11g compatibility with VS2015) — confirm which ODP.NET version is compatible with .NET 4.5 + Oracle 11g and use that. Avoid Entity Framework unless it's EF6 and proven compatible offline; plain ADO.NET with parameterized queries is preferred for simplicity and reliability.
- **Two separate Oracle connections/schemas are required:**
  - `HRIMS` schema — for training data (`hrims.bkup_hr_emp_training_21jul2026`, `hrims.hr_course_category`, `hrims.hr_training_status`).
  - `HRDATA` schema — for employee name lookup (`hrdata.empdetails`).
  - Store both connection strings separately in `web.config` (`<connectionStrings>`), clearly named (e.g., `HRIMS_DB`, `HRDATA_DB`).
- **Login must use Active Directory authentication** (Windows domain), not a custom username/password table. I will separately provide reference files showing:
  - How the login screen should look (UI reference).
  - How AD authentication was implemented previously (code reference — likely using `System.DirectoryServices` / `PrincipalContext` to validate domain credentials).
  - Antigravity should study these reference files carefully and replicate the same AD login pattern and login page look-and-feel before writing any new login code.

---

## Database Details

### Working table (temporary — will later become the live table)
`hrims.bkup_hr_emp_training_21jul2026`

Columns:
| Column | Notes |
|---|---|
| pcno | Employee personnel code — used to look up employee name from `hrdata.empdetails` |
| ctrtraining | |
| coursetype | Has NULL values — must be filterable, including a "Blank/NULL" option in the filter |
| coursename | 4000+ distinct values — needs an efficient searchable dropdown, not a plain `<select>` |
| organizer | |
| venue | |
| startdate | Date filter (range: start date to end date) |
| enddate | Date filter (range: start date to end date) |
| noofdays | |
| fee | |
| feesource | |
| predrdo | |
| dopartref | |
| course_category | Numeric code, lookup via `hrims.hr_course_category` |
| city | |
| sys_entry_date | |
| training_status | Numeric code, lookup via `hrims.hr_training_status`. Values: 1=Nominated, 2=Done in OG, 3=Done in RG, 4=Ongoing, 5=Completed. **All historical rows currently have training_status = 5. From today onward, any newly inserted row will default to training_status = 1.** |

### Lookup tables
- `hrims.hr_course_category` — maps course_category numeric code → description.
- `hrims.hr_training_status` — maps training_status numeric code → description (1–5 as above).

### Employee name lookup (separate schema)
```sql
SELECT NAME FROM hrdata.empdetails WHERE PCNO = :PCNO AND ROWNUM <= 1
```
Use this (parameterized, bind variable) to resolve employee name for each pcno shown in the results grid. Do not concatenate pcno into the SQL string — use bind parameters everywhere in the app to prevent SQL injection.

---

## Functional Requirements

### 1. Login Page
- Windows/Active Directory login only (no local user table).
- Match the look and behavior of the reference login screen I will provide.
- On successful AD authentication, any authenticated domain user is allowed into the portal (no group/role restriction for now — keep this simple, but structure the code so a role check could be added later without a rewrite).
- Show a clear error message on failed AD login (wrong credentials / AD server unreachable) — do not let the app crash if AD is briefly unreachable.

### 2. Main Filter Page
A filter panel with the following fields, all combinable (AND logic) and all optional (if left blank, that field is not filtered):

| Filter field | Control type | Behavior |
|---|---|---|
| Course Type (`coursetype`) | Searchable dropdown | Populated with **distinct** values from the table; must include an explicit "(Blank)" option to select rows where coursetype IS NULL. Type-to-search/filter within the dropdown. |
| Course Category (`course_category`) | Searchable dropdown | Populated by joining/looking up `hrims.hr_course_category`, showing the description text (not the raw number), but filtering by the underlying code. Type-to-search. |
| Course Name (`coursename`) | Searchable dropdown / autocomplete | Must handle 4000+ distinct entries efficiently — use an autocomplete-style control (server-side filtering as the user types, not a giant client-side dropdown of 4000 items loaded at once) so the page stays fast. |
| Start Date | Date picker | Filters rows where `startdate >= selected date` |
| End Date | Date picker | Filters rows where `enddate <= selected date` |

- A "Search / Apply Filter" button triggers the query. Do not auto-query on every keystroke for the main grid (only the dropdown/autocomplete searches should be live).
- Include a "Clear Filters" button to reset all fields and the grid.

### 3. Results Grid
For each employee/training record matching the filters, display:
- Employee **Name** (resolved via the `hrdata.empdetails` lookup by pcno)
- **PCNO**
- Course Name
- Course Type
- Course Category (description, not code)
- Start Date / End Date
- **Training Status** — shown as its description (e.g., "Completed"), not the raw number
- A dropdown next to (or inline within) each row's Training Status, pre-selected to the current status, allowing the user to change it to any of the 5 status values (Nominated, Done in OG, Done in RG, Ongoing, Completed).
- A per-row "Update"/"Save" action (or a single "Save All Changes" button — Antigravity, pick the more usable pattern for a grid, but confirm with per-row save as the default since it's simpler to implement reliably in Web Forms) that updates `training_status` in `hrims.bkup_hr_emp_training_21jul2026` for that row via a parameterized UPDATE statement keyed on the row's unique identifier (use ROWID or the most reliable unique key available in the table — flag to me if the table has no clear primary key so we can decide together).
- This page is **only for viewing/filtering records and changing training_status**. All other columns are read-only/display-only — no add, no edit, no delete of other fields, per current scope.
- Support pagination or virtual scrolling in the grid since result sets could be large.

### 4. No Audit Trail (for now)
- Do not build a status-change history/audit table for this version. Just update `training_status` directly. (Note: keep the update logic isolated in one place so an audit log could be added later easily, but don't build it now.)

### 5. Table Cutover Plan (backup table → main/live table)
`hrims.bkup_hr_emp_training_21jul2026` is currently a temporary backup copy standing in for the real production table while this project is being built. Once the project is complete and verified, we need to switch the app to point at the actual live table instead.
- **Do not hardcode the table name throughout the codebase.** Centralize the table name (e.g., as a single constant, or better, a `web.config` `<appSettings>` key like `TrainingTableName`) so that switching from the backup table to the live table is a **one-line configuration change**, not a code search-and-replace across multiple files.
- Same principle for the two lookup tables if their names might also change later — keep them configurable too, or at least centralized in one constants file.
- Document this clearly (a short README section) explaining exactly which config value(s) to change at cutover time, and confirm there's nothing else that needs touching.

---

## Non-Functional / Delivery Requirements
- Clean, simple, responsive-enough UI consistent with the earlier Attendance project's look and feel (I will share reference screenshots/files).
- All SQL must use bind/parameterized queries — no string concatenation of user input into SQL.
- Handle Oracle connection failures gracefully with a user-friendly error message (both HRIMS and HRDATA connections).
- Since this runs fully offline on the office PC: provide a short setup README covering (a) which ODP.NET / Oracle client components must be installed on the office PC, (b) how to update the two connection strings, (c) the one config change needed for the table cutover, (d) confirmation that no NuGet restore or internet access is needed at runtime because all packages are already inside the project folder.
- Please ask me clarifying questions before/while building if anything about the AD login pattern, the table's unique key for updates, or the UI reference files is unclear once I share them — don't guess silently on those specific points.

---

## Reference Materials (to be provided separately, before/alongside this prompt)
1. Screenshot(s) or markup of the existing login screen design.
2. Existing code/reference showing how AD login was implemented in the prior (Attendance) project.
3. (Optional) Screenshot of the prior Attendance project's grid/filter UI style, to match visual consistency.

Please review those reference files first, then build the login page and AD authentication to match, before proceeding to the filter page and grid.
