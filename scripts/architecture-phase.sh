#!/bin/bash

# AI Workflow Orchestrator - Architecture Phase (Interactive)
# Human-in-the-loop Technical Architecture design

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏗️  AI Workflow Orchestrator - Architecture Phase (Interactive)${NC}"
echo -e "${BLUE}Human-guided technical architecture design${NC}"
echo ""

# Check if we're in a project directory
if [[ ! -f "project.json" ]]; then
    echo -e "${RED}❌ Not in a project directory. Please run from your project root.${NC}"
    exit 1
fi

# Load project configuration
project_name=$(grep -o '"name": "[^"]*' project.json | cut -d'"' -f4)
complexity=$(grep -o '"complexity": "[^"]*' project.json | cut -d'"' -f4 || echo "medium")
current_phase=$(grep -o '"current_phase": "[^"]*' project.json | cut -d'"' -f4)

echo -e "${BLUE}📊 Project Configuration${NC}"
echo "  Project: $project_name"
echo "  Complexity: $complexity"
echo "  Current Phase: $current_phase"
echo ""

# Check if PRD phase is complete
prd_status=$(grep -A2 '"prd"' project.json | grep -o '"status": "[^"]*' | cut -d'"' -f4)
if [[ "$prd_status" != "completed" ]]; then
    echo -e "${RED}❌ PRD phase must be completed before starting Architecture phase.${NC}"
    echo -e "${YELLOW}Current PRD phase status: $prd_status${NC}"
    exit 1
fi

# Check for PRD artifacts
echo -e "${BLUE}🔍 Checking PRD phase artifacts...${NC}"
required_files=("prd-summary.md" "feature-specifications.md" "api-specification.yaml" "data-models.md")
missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f "phases/prd/$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo -e "${RED}❌ Missing PRD artifacts:${NC}"
    for file in "${missing_files[@]}"; do
        echo "   - $file"
    done
    echo -e "${YELLOW}Please complete the PRD phase first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found all PRD artifacts${NC}"

# Interactive introduction
echo ""
echo -e "${PURPLE}🤝 Interactive Architecture Design${NC}"
echo -e "${CYAN}This phase will guide you through technical architecture decisions${NC}"
echo -e "${CYAN}with regular checkpoints for your input and approval.${NC}"
echo ""
echo -e "${YELLOW}What we'll cover:${NC}"
echo "  1. Technology stack selection"
echo "  2. System architecture design"
echo "  3. Database schema refinement"
echo "  4. Security architecture"
echo "  5. Deployment architecture"
echo "  6. Performance optimization strategy"
echo ""
echo -e "${YELLOW}How it works:${NC}"
echo "  1. AI will present technical options based on your PRD"
echo "  2. You'll make key architectural decisions"
echo "  3. Each decision can be revised before moving on"
echo "  4. Nothing is finalized without your approval"
echo ""
echo -e "${GREEN}Ready to begin? (y/n)${NC}"
read -r ready_to_begin

if [[ $ready_to_begin != "y" && $ready_to_begin != "Y" ]]; then
    echo -e "${YELLOW}Architecture phase postponed. Run this script when ready.${NC}"
    exit 0
fi

# Update phase status
echo -e "${BLUE}🔄 Starting Architecture phase...${NC}"
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update Architecture phase status
python3 -c "
import json
with open('project.json', 'r') as f:
    data = json.load(f)
data['current_phase'] = 'architecture'
data['phases']['architecture']['status'] = 'in_progress'
data['phases']['architecture']['started'] = '$current_time'
with open('project.json', 'w') as f:
    json.dump(data, f, indent=2)
"

echo -e "${GREEN}✅ Architecture phase started${NC}"

# Create Architecture phase directory if it doesn't exist
mkdir -p phases/architecture

# Create interactive Architecture instructions
echo -e "${BLUE}📄 Creating interactive Architecture instructions...${NC}"
cat > ARCHITECTURE_PHASE_INTERACTIVE_INSTRUCTIONS.md << 'EOF'
# Architecture Phase - Interactive Workflow

## 🤝 This is an INTERACTIVE phase

You will work together with the human to design the technical architecture. Follow these rules:

1. **Present Options** - Don't just choose technologies, present alternatives
2. **Explain Trade-offs** - Help human understand pros/cons
3. **Work in Sections** - Complete one architectural area, get approval, then continue
4. **Checkpoint Regularly** - After each major decision
5. **Document Rationale** - Record WHY each choice was made

## 📋 Interactive Architecture Workflow

### Step 1: Review PRD Context

Start by summarizing what you understand from the PRD:
```
Based on the PRD, I understand we're building:
- [Core purpose in 1-2 sentences]
- Key requirements: [List 3-5 most important]
- Constraints: [Budget, performance, etc.]

Is this understanding correct?
```

Wait for human confirmation before proceeding.

### Step 2: Technology Stack Selection

#### Frontend Framework
```
For the frontend, considering your requirements, here are the options:

A) Next.js 14 with App Router
   ✅ Pros: Full-stack, great DX, built-in optimizations
   ❌ Cons: Larger bundle, more complex

B) Vite + React
   ✅ Pros: Fast builds, lighter weight, simple
   ❌ Cons: Need separate backend, less built-in features

C) Astro
   ✅ Pros: Ultra-fast static sites, great for portfolios
   ❌ Cons: Less dynamic capabilities

Given your focus on [reference PRD priorities], which would you prefer?
```

#### Backend Technology
```
For the backend/API layer:

A) Next.js API Routes (if using Next.js)
   ✅ Pros: Unified codebase, easy deployment
   ❌ Cons: Less separation of concerns

B) Express.js
   ✅ Pros: Flexible, huge ecosystem, simple
   ❌ Cons: More boilerplate needed

C) Fastify
   ✅ Pros: High performance, good DX
   ❌ Cons: Smaller ecosystem

Which aligns with your preferences?
```

Continue this pattern for:
- Database selection
- Authentication approach
- Hosting platform
- CDN strategy

### Step 3: System Architecture Design

Based on technology choices, present architecture:
```
Here's the proposed system architecture:

[ASCII diagram or description]

Key components:
1. [Component 1] - handles [responsibility]
2. [Component 2] - handles [responsibility]

Does this architecture meet your needs?
Would you like to modify any aspects?
```

### Step 4: Database Schema Refinement

```
Based on the PRD data models, here's the refined schema:

[Show key tables/collections]

I'm proposing these optimizations:
1. [Optimization 1] because [reason]
2. [Optimization 2] because [reason]

Do these changes make sense for your use case?
```

### Step 5: Security Architecture

```
For security, I recommend:

Authentication:
- [Approach] because [reason]

Authorization:
- [Approach] because [reason]

Data Protection:
- [Measures] because [reason]

Are there specific security concerns we should address?
```

### Step 6: Deployment Architecture

```
For deployment, considering your $0/month target:

Option A: Vercel + Supabase
- Hosting: Vercel free tier (100GB bandwidth)
- Database: Supabase free tier (500MB)
- Pros: Zero cost, great DX
- Cons: Bandwidth limits

Option B: Railway + Cloudflare
- Hosting: Railway free tier
- CDN: Cloudflare free
- Pros: More flexibility
- Cons: More setup

Which approach do you prefer?
```

### Step 7: Performance Strategy

```
To meet your performance targets (<2s load):

1. Static Generation for [pages]
2. Edge caching for [assets]
3. Image optimization via [approach]
4. Code splitting strategy

Should we prioritize any specific optimizations?
```

### Step 8: Architecture Decision Log

After EACH decision:
```
📝 DECISION LOGGED:
- Area: [Frontend/Backend/Database/etc]
- Choice: [What was selected]
- Rationale: [Why this choice]
- Trade-offs accepted: [What we're giving up]
```

### Step 9: Final Review

```
Here's our complete architecture:

FRONTEND:
- Framework: [choice]
- Styling: [choice]
- State: [choice]

BACKEND:
- Runtime: [choice]
- Framework: [choice]
- API: [choice]

DATABASE:
- Primary: [choice]
- Caching: [choice]

INFRASTRUCTURE:
- Hosting: [choice]
- CDN: [choice]
- Monitoring: [choice]

Shall we proceed with this architecture? 
Any final adjustments needed?
```

## 📁 Deliverables

Create these in `phases/architecture/`:
1. `architecture-overview.md` - High-level system design
2. `technology-stack.md` - Detailed tech choices with rationale
3. `database-design.md` - Refined schema with optimizations
4. `api-design.md` - Detailed API architecture
5. `security-architecture.md` - Security measures and implementation
6. `deployment-architecture.md` - Infrastructure and deployment design
7. `performance-strategy.md` - Optimization approach
8. `architecture-decisions.md` - ADR (Architecture Decision Records)
9. `architecture-summary.md` - Executive summary

## 🛑 Important: Wait for Human

- NEVER proceed without confirmation
- ALWAYS explain technical trade-offs
- OFFER alternatives, don't prescribe solutions
- DOCUMENT all decisions with rationale
- KEEP referring back to PRD requirements

## 📝 Decision Logging is MANDATORY

After EVERY architectural decision, update `architecture-decisions.md`:
- What was decided
- What alternatives were considered
- Why this choice was made
- What trade-offs were accepted
- Impact on other architectural areas
EOF

# Create decision log file
echo -e "${BLUE}📝 Creating architecture decision log...${NC}"
cat > phases/architecture/architecture-decisions.md << EOF
# Architecture Phase Decision Log

## Date: $(date -u +"%Y-%m-%d")
## Project: $project_name

### Decision Record Format:
Each decision should follow the ADR (Architecture Decision Record) format:
- **ID**: ADR-001
- **Title**: [Decision Title]
- **Status**: Proposed/Accepted/Deprecated
- **Context**: [What prompted this decision]
- **Decision**: [What was decided]
- **Alternatives**: [What else was considered]
- **Consequences**: [What happens as a result]
- **Timestamp**: [When decided]

---

### ADR-001: [Pending First Decision]
- **Status**: Pending
- **Context**: Starting architecture phase
- **Decision**: TBD
- **Alternatives**: TBD
- **Consequences**: TBD
- **Timestamp**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

EOF

# Git operations
echo -e "${BLUE}📝 Creating git checkpoint...${NC}"
git add -A
git commit -m "Architecture phase started with interactive workflow for $project_name

- PRD phase completed
- Interactive architecture workflow initialized
- Human-in-the-loop technical decisions
- ADR (Architecture Decision Records) enabled

🤖 Generated with AI Workflow Orchestrator" || true

# Final instructions
echo ""
echo -e "${GREEN}🎉 Interactive Architecture Phase Ready!${NC}"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    Next Steps                              ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}1. In Claude Code, use this command:${NC}"
echo -e "${GREEN}   @ARCHITECTURE_PHASE_INTERACTIVE_INSTRUCTIONS.md${NC}"
echo ""
echo -e "${YELLOW}2. The AI will:${NC}"
echo "   • Review your PRD to understand requirements"
echo "   • Present technology options with trade-offs"
echo "   • Wait for your decisions on each component"
echo "   • Document all choices with rationale"
echo ""
echo -e "${YELLOW}3. You'll make decisions on:${NC}"
echo "   • Frontend and backend frameworks"
echo "   • Database technology"
echo "   • Hosting and deployment approach"
echo "   • Security implementation"
echo "   • Performance optimizations"
echo ""
echo -e "${YELLOW}4. Key Architecture Constraints:${NC}"
echo "   • \$0/month using free tiers (from PRD)"
echo "   • Open source technologies preferred"
echo "   • Security and customization focus"
echo "   • <2s page load target"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}📌 Remember: This is YOUR architecture. The AI presents${NC}"
echo -e "${CYAN}   options and explains trade-offs, but you make the calls.${NC}"
echo ""
echo -e "${GREEN}Good luck with your architecture design!${NC}"