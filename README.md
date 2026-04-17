# 🏥 Medical Test Management System

A shell-based system for managing patient medical test records, enabling efficient storage, retrieval, and analysis through a command-line interface.

## ✨ Features

- Add, update, delete, and search medical test records  
- Search by **patient ID, test type, date, and status**  
- Detect **abnormal test results** based on predefined ranges  
- Calculate **average values** for different medical tests  
- Includes **input validation** and error handling for reliable usage  

## 🗂️ Project Structure

```
medical-test-management/
├── MedicalTest.sh        # Main program
├── medicalRecord.txt     # Patient records database
├── medicaltest.txt       # Test definitions and normal ranges
├── Average.sh            # Average calculations
├── update.sh             # Update records
├── delete.sh             # Delete records
├── save.sh               # Validation and saving
└── docs/
    └── report.pdf        # Project documentation
```

## 🚀 Getting Started

### Prerequisites

```bash
sudo apt install bc
```

> Requires Linux/Unix environment with Bash

### Run

```bash
chmod +x MedicalTest.sh
./MedicalTest.sh
```

## ⚙️ How It Works

The system stores medical test records in text files and performs operations using shell scripts.

- Ensures **data validation** for correct input formats  
- Supports full **CRUD operations**  
- Provides basic **data analysis** (abnormal detection & averages)  

## 🛠️ Tech Stack

- **Bash (Shell Scripting)**  
- **Linux/Unix**  
- **Text file storage**  

## 👥 Done by:

- Marah Hamarsheh  
- Lana Daramna  
