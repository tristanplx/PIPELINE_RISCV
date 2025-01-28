# PIPELINE_RISCV

[English <img src="https://cdn-icons-png.flaticon.com/16/197/197374.png" width="16"/>](#english-version)  
[Français <img src="https://cdn-icons-png.flaticon.com/16/197/197560.png" width="16"/>](#version-fran%C3%A7aise)

# RISC-V Pipeline Project

<a name="english-version"></a>

## English Version

### Project Overview

This project implements a **pipelined RISC-V processor** based on the RV32I architecture. It is developed in **SystemVerilog** as part of a course on processor architecture. The main objectives are to understand pipelining, manage data and control dependencies, and integrate instruction and data caches.

### Key Features

- **Pipeline Design**: Implements a 5-stage pipeline (Fetch, Decode, Execute, Memory, Write-Back).
- **Hazard Management**: Resolves data and control dependencies using software (NOP insertion) and hardware (stall signals).
- **Cache Implementation**: Adds single-way and two-way associative instruction caches for performance improvement.

**Note**: Only the cache implementation files are provided in this repository. The single-cycle processor code was supplied as part of the course, and I do not wish to redistribute or claim ownership of this work.

**Additional Note**: A significant part of the work involved creating a detailed report in LaTeX. The report is written in french.
### File Structure

- `src/` - Source code for all modules (e.g., datapath, control path, caches).
- `sim/` - Simulation scripts and testbenches.
- `firmware/` - Assembly and machine code programs for testing.

<a name="version-fran%C3%A7aise"></a>

## Version Française

### Aperçu du Projet

Ce projet implémente un **processeur RISC-V pipeline** basé sur l'architecture RV32I. Développé en **SystemVerilog**, il s'inscrit dans le cadre d'un cours sur l'architecture des processeurs. Les objectifs principaux sont de comprendre le pipeline, de gérer les dépendances de données et de contrôle, et d'intégrer des caches d'instructions et de données.

### Fonctionnalités Principales

- **Conception Pipeline** : Implémente un pipeline en 5 étapes (Fetch, Decode, Execute, Memory, Write-Back).
- **Gestion des Hazards** : Résout les dépendances de données et de contrôle via des solutions logicielles (NOP) et matérielles (stall signals).
- **Caches** : Ajoute des caches d'instruction à voie unique et associatif à deux voies pour améliorer les performances.

**Remarque** : Seuls les fichiers relatifs à l'implémentation des caches sont fournis dans ce dépôt. Le code du processeur monocycle a été fourni dans le cadre du cours, et je ne souhaite pas le redistribuer ou en revendiquer la propriété.

**Note Supplémentaire** : Une grande partie du travail a consisté à rédiger un rapport détaillé en LaTeX. Ce rapport, initialement rédigé en français, est inclus dans ce projet. Pour des raisons de temps, l'intégralité du rapport a été traduite en anglais à l'aide de ChatGPT.

### Structure des Fichiers

- `src/` - Code source pour tous les modules (datapath, control path, caches).
- `sim/` - Scripts de simulation et testbenches.
- `firmware/` - Programmes en assembleur et machine pour les tests.
