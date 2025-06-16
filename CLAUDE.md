# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the openwashdata organization's website repository - a Quarto-based website (openwashdata.org) focused on water, sanitation, and hygiene (WASH) data and research community.

## Website Architecture

- **Project type**: Quarto website (`_quarto.yml`)
- **Deployment**: Netlify with `@quarto/netlify-plugin-quarto`
- **Content structure**: `.qmd` files organized in `pages/` subdirectories
- **Styling**: Custom SCSS in `style/` directory with Atkinson Hyperlegible font
- **Theme**: Litera theme with custom modifications

### Key Configuration Files

- **`_quarto.yml`** - Main project configuration with website structure, navbar, sidebar, and theme settings
- **`netlify.toml`** - Deployment configuration for Netlify
- **`package.json`** - Node dependencies (currently only Quarto Netlify plugin)
- **`styles.css`** - Additional CSS overrides
- **`style/theme.scss`** - Custom SCSS theme variables and rules

## Content Organization

### Pages Structure
- **`about/`** - Team member profiles with individual `index.qmd` files
- **`pages/academy/`** - Educational content and graduate profiles
- **`pages/blog/`** - Blog posts with automatic listing functionality
- **`pages/events/`** - Event pages and documentation
- **`pages/gallery/`** - Data gallery, presentations, proposals, and reports
- **`pages/get-started/`** - Getting started documentation
- **`pages/partners/`** - Partner organization pages

### Data Integration Patterns
Many pages integrate with R and external data sources:
- Google Sheets integration via `googlesheets4` package
- R data processing scripts in subdirectory `data/` folders
- CSV export functionality for reproducibility
- R utility functions in `R/df_to_yaml.R` for YAML conversion

## Development Commands

### Basic Quarto Workflow
```bash
# Preview during development (auto-reload)
quarto preview

# Render entire website
quarto render

# Render specific page
quarto render pages/blog/index.qmd
```

### Content Management
```bash
# Create new blog post
mkdir -p pages/blog/posts/YYYY-MM-DD-post-title/
# Add index.qmd and any assets to the new directory

# The blog listing automatically discovers posts via:
# contents: "posts/*/index.qmd" in pages/blog/index.qmd
```

## R Integration

### Data Processing
R is used extensively for dynamic content generation:
- Pages with R chunks use `execute: echo: false` and `warning: false`
- Google Sheets data is fetched and cached as CSV files
- Custom R functions in `R/` directory for data transformations

### Common R Patterns
```r
# Typical data workflow in .qmd files
data <- googlesheets4::read_sheet("sheet_id")
data |> readr::write_csv("data_data/filename.csv")
data <- readr::read_csv("data_data/filename.csv")
```

## Freeze System

Quarto's freeze system (`execute: freeze: auto`) caches computational results in `_freeze/` directory to improve build performance. This is especially important for pages with R code that fetches external data.

## Extensions

The site uses several Quarto extensions:
- **FontAwesome** (`quarto-ext/fontawesome`) - Icon support
- **QR Code** (`jmbuhr/qrcode`) - QR code generation
- Various RevealJS plugins for presentation slides

## Content Conventions

### Blog Posts
- Located in `pages/blog/posts/YYYY-MM-DD-title/index.qmd`
- Use `_metadata.yml` for common settings
- Support for thumbnails, categories, and automatic feed generation

### Data Pages
- Often integrate with R for dynamic content
- Include downloadable CSV exports
- Use responsive tables with `{.column-page}` for wide content

### Presentations
- RevealJS-based slides in `pages/gallery/slides/`
- Support for interactive features, chalkboard, confetti, etc.
- PDF exports available alongside web versions

## Session Standards

**Prompt History**: All user prompts and interactions must be logged in `prompt-history.md` at the repository root level. Each session should be separated by date and include timestamps for each prompt. This ensures full traceability of all work performed in the repository
.

## Project Management with GitHub CLI

- Create branches from `dev` never from `main`
- List issues: `gh issue list`
- View issue details: `gh issue view 80` (e.g., for issue #80 "Rename geographies parameter")
- Create branch for issue: `gh issue develop 80`
- Checkout branch: `git checkout 80-rename-geographies-parameter-to-entities`
- Create pull request: `gh pr create --title "Rename geographies parameter to entities" --body "Implements #80"`
- List pull requests: `gh pr list`
- View pull request: `gh pr view PR_NUMBER`
