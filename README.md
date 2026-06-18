# DP-700 — Real-world Microsoft Fabric Demos

This repository contains production-style, metadata-driven data pipeline demos built on **Microsoft Fabric** (Data Factory, Lakehouse, SQL Database). Each demo follows a config-driven approach where a central **Control DB** drives all ingestion logic — no hard-coded source or target details in the pipelines.

---

## Repository Structure

```
Real-world Demos/
└── Real-world Demos/
    ├── MatadataDriven_xlsx_csv_json_Demo/      # Demo 1 – Multi-format file ingestion
    └── Fabric_Metadata_Driven_Medallion_Framework/  # Demo 2 – Medallion architecture
```

---

## Demo 1 — Metadata-Driven XLSX / CSV / JSON Ingestion

### Overview

A fully metadata-driven pipeline that ingests **CSV** and **Excel (XLSX)** files from OneLake into Lakehouse tables. All source/target configuration lives in a SQL **Control DB** — adding a new file type or source requires only a database insert, not a pipeline change.

### Architecture

```
PL_MAIN
  │
  ├─ Lookup → config.PipelineDetails JOIN config.BusinessSourceDetails
  │           (filtered by Spec_Code parameter)
  │
  └─ ForEach (each row returned)
        └─ ExecutePipeline → PL_CHILD_MAIN
                              │
                              ├─ Switch on SourceType
                              │     ├─ "CSV"   → Copy CSV  → Lakehouse Table
                              │     └─ "Excel" → Copy XLSX → Lakehouse Table
                              └─ (extensible for JSON, Parquet, etc.)
```

**PL_MAIN** accepts a `Spec_Code` parameter (e.g. `BO2`, `BO3`) and looks up all files registered for that business object. It then loops through each row and delegates the actual copy to **PL_CHILD_MAIN**, passing source type, file name, metadata config, row range, and location details.

---

### Control DB

The Control DB is a **Microsoft Fabric SQL Database** containing three tables under the `config` schema. Scripts are in `MatadataDriven_xlsx_csv_json_Demo/DB/`.

#### `config.PipelineDetails`

Stores one row per source file / data asset.

| Column | Type | Description |
|---|---|---|
| `Id` | INT IDENTITY | Primary key (auto-increment) |
| `Spec_Code` | NVARCHAR(100) | Business Object code (e.g. `BO2`, `BO3`) — links to `BusinessSourceDetails` |
| `Description` | NVARCHAR(255) | Human-readable description of the dataset |
| `Source_Type` | NVARCHAR(50) | File format: `CSV`, `Excel`, `JSON`, etc. |
| `Data_Source` | NVARCHAR(50) | File name (e.g. `file1.csv`, `File1.xlsx`) |
| `Load_Type` | NVARCHAR(50) | `Full Load` or `Delta Load` |
| `Metadata_Config` | NVARCHAR(MAX) | JSON blob with format-specific settings (delimiter, encoding, header row, compression, etc.) |
| `Additional_Configurations` | NVARCHAR(255) | Optional extra config |
| `Target_Type` | NVARCHAR(50) | Destination type (e.g. `Table`) |
| `Target_Name` | NVARCHAR(100) | Destination Lakehouse table name |
| `Sheet_Name` | NVARCHAR(100) | Excel sheet name (Excel only, NULL for CSV) |
| `Row_Range` | NVARCHAR(50) | Excel cell range (e.g. `A1:D6`) (Excel only, NULL for CSV) |
| `Where_Condition` | NVARCHAR(MAX) | Optional SQL filter for delta loads |
| `Created_At` | DATETIME | Auto-set on insert |
| `Updated_At` | DATETIME | Auto-set on insert |

**Example `Metadata_Config` for CSV:**
```json
{
  "ColumnDelimiter": ",",
  "RowDelimiter": "\n",
  "Encoding": "UTF-8",
  "FirstRowAsHeader": true,
  "EscapeCharacter": "\\",
  "QuoteCharacter": "\"",
  "NullValue": "NULL",
  "CompressionType": "None",
  "FileExtension": ".csv",
  "SearchStart": "0",
  "TableActionOption": "None"
}
```

**Example `Metadata_Config` for Excel:**
```json
{
  "CompressionType": "None",
  "ColumnDelimiter": ",",
  "RowDelimiter": "\r\n",
  "Encoding": "UTF-8",
  "EscapeCharacter": "¬",
  "QuoteCharacter": "\"",
  "FirstRowAsHeader": true,
  "NullValue": "",
  "FileExtension": ".xlsx",
  "SearchStart": "0",
  "TableActionOption": "None"
}
```

---

#### `config.BusinessSourceDetails`

Stores location details for each Business Object (source folder in OneLake and target folder/schema).

| Column | Type | Description |
|---|---|---|
| `Id` | INT IDENTITY | Primary key |
| `Spec_Code` | NVARCHAR(255) | Business Object code — joins to `PipelineDetails.Spec_Code` |
| `Source_Location_Type` | NVARCHAR(255) | Source storage type (e.g. `OneLake`, `ADLS`) |
| `Source_Location_Details` | NVARCHAR(255) | Source folder/container path |
| `Target_Location_Type` | NVARCHAR(255) | Target storage type |
| `Target_Location_Details` | NVARCHAR(255) | Target folder/schema path |
| `Spec_Code_ID` | INT | Numeric ID cross-reference for the Spec_Code |

---

#### `config.DeltaLoadTable`

Tracks watermark values for incremental (delta) loads.

| Column | Type | Description |
|---|---|---|
| `Id` | INT | Primary key (matches pipeline row ID) |
| `Modified_Date` | DATETIME | Last time this row was updated |
| `Min_Load_Date` | DATETIME | Lower bound of the last load window |
| `Max_Load_Date` | DATETIME | Upper bound of the last load window |
| `Page_Number` | INT | Page tracking for paginated API sources |
| `Last_Loaded_Id` | INT | Last successfully loaded record ID |

---

### Sample Data (Demo 1)

Located in `MatadataDriven_xlsx_csv_json_Demo/SampleFiles/`:

| File | Format | Delimiter | Registered As |
|---|---|---|---|
| `file1.csv` | CSV | `,` (comma) | BO2 / Table1 |
| `file2.csv` | CSV | `;` (semicolon) | BO2 / Table2 |
| `File1.xlsx` | Excel | Sheet1, range `A1:D6` | BO3 / Table3 |
| `File2.xlsx` | Excel | Sheet1, range `B3:D8` | BO3 / Table4 |

Both CSV files share the same schema (`Id, Name, Amount, Date`) but use different delimiters — demonstrating that each file can carry its own `Metadata_Config`.

---

### Setup Steps (Demo 1)

1. **Create the Control DB** — run `DB/1_ControlDB.sql` in your Fabric SQL Database to create the `config` schema and all three tables.
2. **Seed pipeline config** — run `DB/2_PipelineDetails.sql` to insert the four sample file registrations (BO2 CSV files, BO3 Excel files).
3. **Seed source details** — run `DB/3_BusinessSourceDetails_Data.sql` to insert the OneLake location details for BO2 and BO3.
4. **Upload sample files** — upload the files from `SampleFiles/` into the appropriate OneLake folders (`BO2/` and `BO3/`).
5. **Import pipelines** — import `DataPipeline/PL_MAIN.json` and `DataPipeline/PL_CHILD_MAIN.json` into your Fabric workspace.
6. **Update the linked service** — in `PL_MAIN`, update the `ControlDB` connection to point to your Fabric SQL Database workspace and artifact IDs.
7. **Run PL_MAIN** — trigger with `Spec_Code = BO2` or `Spec_Code = BO3` to ingest the respective files.

To add a new file, simply insert a row into `config.PipelineDetails` (and `config.BusinessSourceDetails` if it's a new Business Object) — no pipeline changes needed.

---

## Demo 2 — Fabric Metadata-Driven Medallion Framework

### Overview

An enterprise-grade **Medallion Architecture** (Bronze → Silver → Gold) framework for Microsoft Fabric, presented at **PASS Summit 2026**. It extends the metadata-driven approach to support multiple source types across a full lakehouse lifecycle.

### Source Types Covered

| Business Object | Source Type | Files |
|---|---|---|
| BO1 | Flat files (CSV) | `Orders.csv`, `customers.csv` |
| BO2 | Flat files (CSV) | `file1.csv`, `file2.csv` |
| BO3 | Excel files | `File1.xlsx`, `File2.xlsx` |
| BO4 | SQL Database | `supplier_adjustments.xlsx` + `database.sql` (RetailERP schema) |
| BO5 | REST API (OData) | Northwind OData endpoints (`Products`, `Categories`) |

### RetailERP SQL Source (BO4)

The `database.sql.txt` defines a sample on-premises SQL source with these tables:

- **`Customers`** — CustomerID, Name, Segment, Country, City, SignupDate, IsActive
- **`Stores`** — StoreID, StoreName, Region, ManagerName, OpenDate
- **`CustomerSegments`** — SegmentID, SegmentName, DiscountRate
- **`CustomerSegmentMapping`** — CustomerID ↔ SegmentID assignments

### REST API Source (BO5)

OData endpoints from the public Northwind service:

```
https://services.odata.org/V4/Northwind/Northwind.svc/Products
https://services.odata.org/V4/Northwind/Northwind.svc/Categories
https://services.odata.org/V4/Northwind/Northwind.svc/Products?$top=10
https://services.odata.org/V4/Northwind/Northwind.svc/Products?$expand=Category
```

### Resources

| File | Description |
|---|---|
| `PASS Summit 2026 _Fabric_Foundry.pptx` | Main conference presentation |
| `PASS Summit 2026 _Fabric_Foundry_PreDay.pptx` | Pre-day deep-dive session |
| `Step 1 - Configure the On-Premises Data Gateway.docx` | Gateway setup guide for SQL sources |
| `POC.zip` | Full proof-of-concept Fabric workspace export |

---

## Prerequisites

- Microsoft Fabric workspace (Fabric capacity or trial)
- Fabric SQL Database (for the Control DB)
- Fabric Lakehouse (Bronze layer target)
- On-Premises Data Gateway (required for BO4 SQL source in Demo 2)
- Data Factory pipelines imported into the workspace

---

## Key Design Principles

- **Zero pipeline changes to add sources** — all configuration lives in the Control DB
- **Format-agnostic** — CSV, Excel, JSON, SQL, and REST API handled by the same pipeline skeleton
- **Metadata_Config JSON** — each row carries its own format settings, so files with different delimiters or encodings coexist in the same Business Object
- **Delta load ready** — `config.DeltaLoadTable` tracks watermarks for incremental ingestion
- **Medallion-ready** — the framework naturally extends to Bronze → Silver → Gold promotion via additional pipeline stages
