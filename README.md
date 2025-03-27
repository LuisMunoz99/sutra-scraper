# 📄 SUTRA Scraper & LLM (in process) 

This repository contains a modular R script to scrape **descriptive metadata** about legislative measures from Puerto Rico’s *Sistema Único de Trámite Legislativo (SUTRA)*.

## What does this scraper do?

- Filters measures by legislative term (`cuatrienio`, e.g., 2021)
- Extracts:
  - Measure title
  - Legislative term (cuatrienio)
  - Filing date
  - Unique identifier (custom `medida_uid`)
- Saves the output:
  - As individual `.csv` files per measure
  - As a full `.rds` object with all data (including NULLs)
  - As a combined flat `.csv` for analysis

## Project structure


