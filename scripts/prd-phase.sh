#!/bin/bash

# AI Workflow Orchestrator - PRD Phase (Interactive)
# Human-in-the-loop Product Requirements Document creation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 AI Workflow Orchestrator - PRD Phase (Interactive)${NC}"
echo -e "${BLUE}Human-guided requirements specification${NC}"
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

# Check if blueprint phase is complete
blueprint_status=$(grep -A2 '"blueprint"' project.json | grep -o '"status": "[^"]*' | cut -d'"' -f4)
if [[ "$blueprint_status" != "completed" ]]; then
    echo -e "${RED}❌ Blueprint phase must be completed before starting PRD phase.${NC}"
    echo -e "${YELLOW}Current blueprint phase status: $blueprint_status${NC}"
    exit 1
fi

# Check for blueprint artifacts
echo -e "${BLUE}🔍 Checking blueprint phase artifacts...${NC}"
if [[ ! -f "phases/blueprint/blueprint-summary.md" ]]; then
    echo -e "${RED}❌ blueprint-summary.md not found. Please complete blueprint phase first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found blueprint artifacts${NC}"

# Interactive introduction
echo ""
echo -e "${PURPLE}🤝 Interactive PRD Creation${NC}"
echo -e "${CYAN}This phase will guide you through creating detailed requirements${NC}"
echo -e "${CYAN}with regular checkpoints for your input and approval.${NC}"
echo ""
echo -e "${YELLOW}How it works:${NC}"
echo "  1. AI will present options for you to choose from"
echo "  2. You'll review and approve each major section"
echo "  3. You can request revisions at any checkpoint"
echo "  4. Nothing proceeds without your approval"
echo ""
echo -e "${GREEN}Ready to begin? (y/n)${NC}"
read -r ready_to_begin

if [[ $ready_to_begin != "y" && $ready_to_begin != "Y" ]]; then
    echo -e "${YELLOW}PRD phase postponed. Run this script when ready.${NC}"
    exit 0
fi

# Update phase status
echo -e "${BLUE}🔄 Starting PRD phase...${NC}"
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update PRD phase status
python3 -c "
import json
with open('project.json', 'r') as f:
    data = json.load(f)
data['current_phase'] = 'prd'
data['phases']['prd']['status'] = 'in_progress'
data['phases']['prd']['started'] = '$current_time'
with open('project.json', 'w') as f:
    json.dump(data, f, indent=2)
"

echo -e "${GREEN}✅ PRD phase started${NC}"

# Create PRD phase directory if it doesn't exist
mkdir -p phases/prd

# Create interactive PRD instructions
echo -e "${BLUE}📄 Creating interactive PRD instructions...${NC}"
cat > PRD_PHASE_INTERACTIVE_INSTRUCTIONS.md << 'EOF'
# PRD Phase - Interactive Workflow

## 🤝 This is an INTERACTIVE phase

You will work together with the human to create the PRD. Follow these rules:

1. **Present Options** - Don't just create, ask what to prioritize
2. **Work in Sections** - Complete one section, get approval, then continue
3. **Checkpoint Regularly** - After each major decision or section
4. **Revise on Request** - If human says "revise", offer alternatives

## 📋 Interactive PRD Workflow

### Step 1: Feature Prioritization Session

STOP and interact with the human:
```
Based on the blueprint, I've identified these potential features for the MVP:

1. [Feature 1] - [Brief description]
2. [Feature 2] - [Brief description]
...
10. [Feature 10] - [Brief description]

Which 5 features should we prioritize for the MVP?
Please respond with the numbers (e.g., "1, 3, 5, 7, 9")
```

Wait for human response before proceeding.

### Step 2: Requirements Development Process

For EACH selected feature:

1. **Draft Initial Requirements**
   - Create requirements for ONE feature
   - Include acceptance criteria
   - Show to human

2. **Checkpoint**
   ```
   I've drafted requirements for [Feature Name].
   
   Please review and choose:
   - 'approve' - Move to next feature
   - 'revise' - I'll modify based on your feedback
   - 'expand' - I'll add more detail
   - 'simplify' - I'll make it less complex
   ```

3. **Iterate Based on Feedback**
   - Make requested changes
   - Present revised version
   - Wait for approval

### Step 3: API Specification Review

1. **Present API Design Options**
   ```
   For the API design, we have these options:
   
   A) RESTful API with resource-based endpoints
   B) GraphQL API with flexible queries
   C) Hybrid approach (REST + GraphQL)
   
   Which approach aligns best with your vision?
   ```

2. **Develop Chosen Approach**
   - Create API specs for selected approach
   - Show examples
   - Get approval

### Step 4: User Flow Validation

1. **Present User Flows**
   ```
   Here are the key user flows I've identified:
   
   1. [Flow 1 - e.g., Sign up → Connect GitHub → Customize → Publish]
   2. [Flow 2 - e.g., View Analytics → Export Data]
   
   Should I add any additional flows?
   Are these matching your vision?
   ```

2. **Detail Approved Flows**
   - Expand on each flow
   - Include decision points
   - Validate with human

### Step 5: Technical Constraints Discussion

```
Let's discuss technical constraints:

1. Performance targets?
   - Page load time: < 2s? < 3s?
   - API response time: < 200ms? < 500ms?

2. Browser support?
   - Modern browsers only?
   - Include IE11?

3. Mobile requirements?
   - Responsive web only?
   - PWA features?
   - Native app later?

Please share your preferences.
```

### Step 6: Document Assembly

After gathering all inputs:

1. **Create Draft Sections**
   - Feature specifications
   - API documentation
   - User flows
   - Technical requirements
   - Non-functional requirements

2. **Review Checkpoint**
   ```
   I've assembled the PRD draft. Would you like to:
   
   1. Review section by section
   2. See the complete document
   3. Focus on specific areas
   
   What's your preference?
   ```

### Step 7: Final Approval

```
The PRD is complete. Before we finalize:

1. Any features to add/remove?
2. Any requirements to adjust?
3. Any concerns about scope?

Type 'finalize' when ready to complete the phase.
```

## 📁 Deliverables

Create these in `phases/prd/`:
1. `feature-specifications.md` - Detailed feature requirements
2. `api-specification.md` - API design and endpoints
3. `user-flows.md` - Detailed user journeys
4. `data-models.md` - Database schema and models
5. `non-functional-requirements.md` - Performance, security, etc.
6. `prd-summary.md` - Executive summary

## 🛑 Important: Wait for Human

- NEVER proceed without confirmation
- ALWAYS offer choices, not just solutions
- STOP after each major section
- ASK for preferences and priorities
EOF

# Create decision log file
echo -e "${BLUE}📝 Creating decision log...${NC}"
cat > phases/prd/decision-log.md << EOF
# PRD Phase Decision Log

## Date: $(date -u +"%Y-%m-%d")
## Project: $project_name

### Decisions Made:
_This file will track all decisions made during the interactive PRD phase_

### Format:
- **Decision Point**: [What was decided]
- **Options Presented**: [What choices were given]
- **Choice Made**: [What was selected]
- **Rationale**: [Why this choice]
- **Timestamp**: [When decided]

---

EOF

# Git operations
echo -e "${BLUE}📝 Creating git checkpoint...${NC}"
git add -A
git commit -m "PRD phase started with interactive workflow for $project_name

- Blueprint phase completed
- Interactive PRD workflow initialized
- Human-in-the-loop process established
- Decision tracking enabled

🤖 Generated with AI Workflow Orchestrator" || true

# Final instructions
echo ""
echo -e "${GREEN}🎉 Interactive PRD Phase Ready!${NC}"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    Next Steps                              ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}1. In Claude Code, use this command:${NC}"
echo -e "${GREEN}   @PRD_PHASE_INTERACTIVE_INSTRUCTIONS.md${NC}"
echo ""
echo -e "${YELLOW}2. The AI will:${NC}"
echo "   • Present feature options for you to choose"
echo "   • Wait for your input at each checkpoint"
echo "   • Create requirements based on your selections"
echo "   • Ask for approval before proceeding"
echo ""
echo -e "${YELLOW}3. You control the process by:${NC}"
echo "   • Selecting which features to include"
echo "   • Reviewing and approving each section"
echo "   • Requesting revisions when needed"
echo "   • Deciding when to move forward"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}📌 Remember: This is YOUR process. The AI is here to help,${NC}"
echo -e "${CYAN}   not to make decisions for you.${NC}"
echo ""
echo -e "${GREEN}Good luck with your interactive PRD creation!${NC}"