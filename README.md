# Power BI Multi-Dashboard Portfolio

Welcome to the Power BI Analytics Portfolio. This repository contains two distinct Power BI dashboard projects designed to deliver business intelligence and data-driven insights.

---

## 🛠️ Repository Architecture & File Mechanics

This repository hosts two primary Power BI templates/reports. Due to the underlying structure of Power BI (`.pbix` / `.pbit`) files, the project files map to the following structural components:

```text
├── README.md
├── Dashboard_1/
│   ├── [Content_Types].xml        # Content stream types mapping
│   ├── DataModel                  # Data engine model definitions
│   ├── Metadata                   # Report metadata and schema
│   └── Report/
│       ├── Layout                 # Canvas layout, visual structures & positions
│       └── StaticResources/       # Embedded visual assets (PNGs, logos, icons)
└── Dashboard_2/
    ├── [Content_Types].xml
    ├── DataModel
    ├── Metadata
    └── Report/
        ├── Layout
        └── StaticResources/

```

---

## 📊 Dashboard 1: Sales & Revenue Overview

### Overview

This dashboard focuses on commercial performance, tracking total sales metrics, volume growth, and key transaction statistics across time periods and operational segments.

### Key Features

* **Key Performance Indicators (KPIs):** Instant visibility into total orders, overall revenue, and average transaction size.
* **Trend Analysis:** Period-over-period tracking to evaluate growth trajectories.
* **Interactive Visuals:** Built-in dynamic filters for fast drill-downs across categories and regions.

### Data Model & Measures

* **Average Order Value (AOV):** Calculated dynamically via DAX to assess average customer spend per transaction.
* **Total Order Count:** Distinct aggregations of order identifiers across selected timeframes.

---

## 📈 Dashboard 2: Executive Performance & Operational Insights

### Overview

Designed for executive decision-makers, this report aggregates cross-functional metrics to monitor high-level organizational trends, operational efficiency, and target attainment.

### Key Features

* **Executive Summary:** Top-level metrics summarizing business health and operational output.
* **Comparative Metrics:** Side-by-side performance evaluation against historical benchmarks.
* **Custom Asset Integration:** Standardized visual layouts for seamless stakeholder presentations.

---

## 🚀 Getting Started

### Prerequisites

* **Power BI Desktop** (Latest version recommended)
* Access to source data drivers (if refreshing datasets locally)

### Installation & Usage

1. Clone or download this repository:
```bash
git clone https://github.com/your-username/your-repo-name.git

```


2. Navigate to the desired dashboard folder.
3. Open the corresponding `.pbix` file using **Power BI Desktop**.
4. To update data connections, navigate to `Home > Transform Data > Data source settings` and update paths to your local or cloud data sources.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.
