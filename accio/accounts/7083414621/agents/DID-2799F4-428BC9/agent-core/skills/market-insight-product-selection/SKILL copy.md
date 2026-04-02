---
name: market-insight-product-selection
description: |
  A comprehensive reference for helping users to make data-driven product selection decisions.
  **When to use**:
    - User is asking about trends, popularity, or what's selling well in any market
    - User wants market analysis, market research, or competitive landscape insights
    - User is researching consumer preferences, demand patterns, or market dynamics
    - User needs help deciding what products to sell, source, or invest in
    - User is exploring product opportunities, winning products, or profitable niches
workflow: |
  Complete this in four steps:
    1. Data Analysis & Selection Recommendation (multi-source data → conclusion + logic + evidence)
    2. Product/Supplier Search (optional, ≥4 cards per dimension)
    3. Supplier Investigation & Inquiry (optional)
    4. Summary & Action Guide (actionable next steps)
enabled: true
---
# Market Insight & Product Selection

A comprehensive workflow for helping users make data-driven product selection decisions through multi-source market analysis.

## How to Use

Read this guide FIRST before any web search or data analysis when the user needs product selection insights.

## Dependencies

- `info_search` for market data
- `product_search`/`supplier_search` for product/supplier data
- `web_fetch` tool for deep diving into URLs
- `matplotlib`/`seaborn` for chart generation

---

## Steps

### Step 1: Data Analysis & Selection Recommendation (Mandatory)

**Purpose**: Conduct deep, multi-source data analysis with cross-validation. Generate actionable selection recommendations with clear conclusion, analysis logic, and data evidence.

#### Data Collection

**Maximize data source calls** (≥3 sources):

- **Web search**: General market intelligence, news, and social phenomena
- **Sales platforms**: Amazon, Alibaba, Shopee, Shein
- **Trend data**: Google Trends, Amazon search trends
- **Social media**: YouTube, Reddit

**Deep dive with `web_fetch` tool**: When search results return promising URLs, use the `web_fetch` tool to extract detailed information from web pages (e.g., full article content, detailed product specs, in-depth reviews)

#### Deep Search Protocol

**Core flow**: Search → Extract entities → Search DEEPER → Check saturation → Continue until complete

⚠️ Deep search is **NOT limited to 2-3 rounds**. Continue until saturation signals detected.

##### Iterative Search Rounds

**Round 1 - Broad (3-6 queries)**: Break topic into dimensions (market size, consumer preferences, competition, technology, community feedback).

**Round 2 - Deep (2-4 queries)**: From R1 findings, drill into specific brands, technologies, pain points, suppliers.

**Round 3+ - Until saturation**: New entities → explore | Unknowns → fill | Claims → verify | Contradictions → resolve

##### Extract & Map (Entity Extraction)

After each `web_fetch`, extract entities and relationships to identify next investigation points.

**Entity extraction prompt template**:

```
Extract from this content:
1. Key entities: products, brands, companies, technologies, suppliers
2. Relationships: [Product] uses [Component] supplied by [Vendor]
3. Next investigation: what should be explored based on these findings
```

**Example**: Found "Xiaomi Band 9 uses Goodix PPG sensor" → Next searches: "Goodix sensor specs", "Goodix competitors", "PPG sensor supply chain"

##### Contrarian Search & Source Quality

**Contrarian search**: When finding positive claims, search for opposing views to avoid echo chamber.

- Growth forecast → search "risks / challenges / bearish outlook"
- Product advantage → search "drawbacks / complaints / competitor strengths"

**Source quality** (prioritize high-quality sources for `web_fetch`):

| Source Type                           | Priority   |
| ------------------------------------- | ---------- |
| Industry reports / financial analysis | ⭐⭐⭐⭐⭐ |
| Official announcements / Tech media   | ⭐⭐⭐⭐   |
| Community (Reddit/YouTube)            | ⭐⭐⭐     |
| SEO content / press releases          | ⭐         |

##### Stop Conditions (Saturation Detection)

**✅ STOP when ANY condition met**:

- **Saturation**: No new entities/data for 2 consecutive rounds
- **Closure**: All initial unknowns filled and verified
- **Verification complete**: Key claims verified by 2+ sources

**❌ DO NOT stop when**: Important entities unexplored | Single-source claims | Unresolved contradictions

##### Minimum Requirements

| Metric            | Minimum                      |
| ----------------- | ---------------------------- |
| info_search calls | 5+                           |
| web_fetch calls   | 8+                           |
| Rounds            | 2+ (until saturation)        |
| Source types      | 3+ (industry/news/community) |

**Comprehensive analysis: expect 15-30+ searches, 20-40+ web_fetch.**

#### Analysis Requirements

**Cross-source validation**: Connect insights from multiple sources to form structured judgments

- Example: "Google Trends shows 2x search growth + Amazon data shows $60-80 trail shoes have high ratings but limited supply + Alibaba shows only X suppliers = blue ocean opportunity with 40% margin potential"
- Example: "Search volume rising + Alibaba B2B has only X qualified suppliers = true blue ocean"

**Trend trajectory judgment**:

- State whether trend is emerging/explosive/mature/declining
- Identify if it's short-term hype or sustainable demand
- Note seasonality factors and 6-12 month outlook

**Trigger event analysis**: Identify sudden growth drivers (e.g., viral YouTube video, celebrity endorsement, KOL review, social media trend)

**Product categorization** (aggregate by sales/growth/reviews): The classification criteria are shown in the table below

| Category                 | Criteria                                 | Recommendation                           |
| ------------------------ | ---------------------------------------- | ---------------------------------------- |
| **Safe bets**      | High sales + low complaints              | Direct sourcing/imitation recommended    |
| **High-potential** | High social buzz + low e-commerce supply | R&D opportunity                          |
| **Red ocean**      | High sales + high complaints             | Requires differentiation, cautious entry |
| **False trends**   | Short-term spikes (holiday/event-driven) | Avoid long-term investment               |

**Hit product feature extraction**:

- Analyze common traits of top-selling products
- Price band distribution and gaps (identify blank price zones)
- Must-have features vs. nice-to-have features
- Most complained features

**User pain point mining**: Extract insights from reviews using NLP analysis when data volume is sufficient

**Competitive landscape analysis**:

- Market concentration (top players' market share)
- Brand vs. white-label ratio
- Entry barriers and differentiation opportunities
- Pricing strategy patterns across competitors

**Supply chain feasibility assessment**:

- Identify "easy-entry variants" based on supplier availability
- MOQ and pricing structure analysis
- Supplier concentration and risk assessment
- Margin potential calculation (e.g., "B2B cost structure suggests 40% gross margin for white-label")

**Social & cultural trends**:

- Lifestyle shifts affecting demand
- Sustainability/ethical consumption preferences
- Regional/cultural preference variations
- Macro trends influencing category evolution

**Demand restatement**: Include 1-2 sentences restating your understanding of buyer needs

#### Output Requirements

**Text conclusions**: Include reasoning chains that connect data to insights.

**Visual evidence** (include whenever possible to enhance user understanding):

- **Images from search results**: When tool results return images with reference IDs, display 3-6 representative images that best illustrate the analysis (e.g., trending styles, product examples, market snapshots)
- **Trend visualization**: Show how trending styles/colors apply to products
  - Example: "Q4 best-seller is multi-function contouring stick" → show product images
  - Example: "Next season's trending color is lemon yellow" → show color palette + application across product categories
- **Code-generated charts** (prioritize consolidation and significance):
  - **Consolidate**: Draw related curves/metrics on a SINGLE chart for comparison (e.g., multiple trend lines on one plot)
  - **Simplicity**: Do NOT generate charts for simple information; use tables or text instead
  - **Types**: Trend charts (multi-line sales/search growth), Price distribution (histogram/box plot), Category comparison (multi-variable radar/bar), Word cloud (review keywords)
  - Use `matplotlib`, `seaborn`, or `wordcloud` to create professional visualizations
- **Hot-selling product display**:
  - Hot-selling products returned by `info_search` (with `hot_selling_product=True`) have Reference IDs
  - You **MUST** display top hot-selling products using product card widgets
  - Display at least 3-5 top-performing hot-selling products to help users quickly identify market opportunities

**Comparison Table with Decision Notes** (MANDATORY when ≥3 candidates):

| Product/Category | Category       | Key Metrics                    | Decision Note                                                  |
| ---------------- | -------------- | ------------------------------ | -------------------------------------------------------------- |
| Smart Pet Feeder | High-potential | Social buzz rising, supply low | High-potential: precision feeding tech, note FDA certification |
| Pet Water Bottle | Safe bets      | High sales, low complaints     | Traffic-driver: EU regulation demand, note material shortage   |
| Auto Litter Box  | Red ocean      | High sales, high complaints    | Caution: needs differentiation, limit initial MOQ              |

- **Category**: Classify each product using the 4 types (Safe bets/High-potential/Red ocean/False trends)
- **Decision Note**: `[positioning] + [evidence] + [risk/action]`

**Value explanation**: Use tangible examples to help users understand product value (e.g., "This multi-function beauty tool replaces 3 separate devices, saving counter space and $50")

**Case studies** (when available):

- Provide "industry gold standard" examples as benchmarks
- Real marketing/viral phenomena (social media trends, KOL reviews, successful brand strategies)
- Actionable "story lines" or content directions users can reference and adapt

**Source citations**:

- Link to original web pages and data sources
- Reference to source sales data tables with key metrics

**Selection Recommendation** (provide structured recommendations with three components):

- **Conclusion**: Specific products/categories grouped by strategy (Safe Bets, High-Potential, etc.)
- **Analysis Logic**: Framework used (e.g., "Blue Ocean Model") + key indicators (supply gap, social buzz, search trend, complaint ratio)
- **Data Evidence**: Verifiable sources (TikTok views, Amazon listings, Google Trends index, Alibaba supplier count)

---

### Step 2: Product/Supplier Search (Optional)

- **Input**: Selection recommendations from Step 1
- **Action**: Search products/suppliers using `product_search`/`supplier_search`
- **Output Requirements**:
  - ≥4 product cards OR ≥4 supplier cards per strategy dimension
  - **MUST display clickable cards** (not just text)
  - Comparison table for cross-evaluation

### Step 3: Supplier Investigation & Inquiry (Optional)

- **Input**: User requests suppliers or inquiry
- **Action**: Assess suppliers, draft inquiry emails
- **Output**: Supplier recommendations + draft inquiry

### Step 4: Summary & Action Guide (Mandatory)

- **Input**: All analysis completed
- **Action**: Synthesize findings into actionable recommendations
- **Output**: Executive summary table, opportunities/risks, specific next steps

---

## Output Format

### Analysis Output Structure

```
1. Demand Understanding
  - Restate user needs (1-2 sentences)

2. Market Analysis & Selection Recommendation (Step 1)
  - Text conclusions with reasoning chains
  - Visual evidence (images, charts, hot-selling product cards)
  - Comparison Table with Decision Notes (categorization + decision note per product)
  - Selection recommendation (conclusion + analysis logic + data evidence)

3. Product/Supplier Cards (Step 2, if applicable)
  - Structured by recommendation dimension
  - ≥4 clickable cards per strategy dimension
  - Comparison table for cross-evaluation

4. Supplier Options (Step 3, if applicable)

5. Summary & Action Guide (Step 4)
  - Opportunities & risks table
  - Specific next steps
  - Data limitations

6. Next Task Suggestions (if applicable)
```

### Chart Design

**When to generate charts**: Only when you have sufficient data (≥5 data points or ≥3 categories) that warrants visualization.

**⚠️ CRITICAL: If you need to generate ANY chart, you MUST read the chart design guide FIRST**:

- **File path**: `./chart-design-guide.md` (relative to this SKILL.md)
- **Why**: Charts generated WITHOUT reading this guide will have poor styling, wrong chart types, and deprecated API usage
- **Contains**: Tool selection (Seaborn vs Matplotlib), code patterns, styling, chart type selection, Seaborn v0.12+ API updates

---

## Example

**User**: "What products should I sell for Q4 2025?"

**Flow**: Demand restatement → Multi-source search (Google Trends, Amazon, Alibaba) → Analysis (trend: heated apparel +150%, categorization, price gaps $30-50) → Comparison table with Decision Notes → Visualizations → Action guide ("Trial 500 units heated jackets $35-45, target GRS-certified suppliers")

---

## Checklist

✅ **Must Include**:

- [ ] Demand restatement (1-2 sentences)
- [ ] Multi-source data (≥3 sources) with cross-validation
- [ ] Trend trajectory judgment (stage, sustainability, timeline)
- [ ] Visual aids (search images, charts, tables)
- [ ] Comparison Table with Decision Notes (4-10 products, including product categorization and decision note per row)
- [ ] Hot-selling product cards (MUST display if available)
- [ ] Selection recommendation (conclusion + analysis logic + data evidence)
- [ ] Source citations

✅ **Deep Search Protocol (required for analytical queries)**:

- [ ] Multi-round iteration: R1 broad → R2 deep → R3+ until saturation
- [ ] Entity extraction after each web_fetch
- [ ] Contrarian search for key claims
- [ ] Source quality weighting
- [ ] Cross-verification (2+ sources for key claims)
- [ ] Saturation check before stopping

❌ **Avoid**:

- Data listing without insights
- Single-source analysis
- Conclusions without reasoning
- Generic advice
- Missing trend predictions
- Ignoring hot-selling products with Reference IDs
- Flat card listings without horizontal comparison
- Vague Decision Notes ("has potential", "worth trying", "looks promising")
- Stopping after 1-2 rounds (analytical queries need 3+)
- Single-source claims without verification
- No entity extraction from web_fetch
- Echo chamber (only searching supportive evidence)
- Ignoring source quality differences
