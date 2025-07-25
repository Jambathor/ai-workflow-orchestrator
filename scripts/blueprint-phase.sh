#!/bin/bash

# AI Workflow Orchestrator - Blueprint Phase
# AI-guided high-level solution design

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏗️ AI Workflow Orchestrator - Blueprint Phase${NC}"
echo -e "${BLUE}AI-guided high-level solution design${NC}"
echo ""

# Check if we're in a project directory
if [[ ! -f "project.json" ]]; then
    echo -e "${RED}❌ Not in a project directory. Please run from your project root.${NC}"
    exit 1
fi

# Load project configuration
project_name=$(grep -o '"name": "[^"]*' project.json | cut -d'"' -f4)
complexity=$(grep -o '"complexity": "[^"]*' project.json | cut -d'"' -f4)
current_phase=$(grep -o '"current_phase": "[^"]*' project.json | cut -d'"' -f4)

echo -e "${BLUE}📊 Project Configuration${NC}"
echo "  Project: $project_name"
echo "  Complexity: $complexity"
echo "  Current Phase: $current_phase"
echo ""

# Check if concept phase is complete
concept_status=$(grep -A2 '"concept"' project.json | grep -o '"status": "[^"]*' | cut -d'"' -f4)
if [[ "$concept_status" != "completed" ]]; then
    echo -e "${RED}❌ Concept phase must be completed before starting blueprint phase.${NC}"
    echo -e "${YELLOW}Current concept phase status: $concept_status${NC}"
    exit 1
fi

# Check if already in blueprint phase or beyond
if [[ "$current_phase" != "blueprint" && "$current_phase" != "concept" ]]; then
    echo -e "${YELLOW}⚠️ Project is already in $current_phase phase.${NC}"
    echo "Continue anyway? (y/n)"
    read -r continue_anyway
    if [[ $continue_anyway != "y" && $continue_anyway != "Y" ]]; then
        echo -e "${YELLOW}Blueprint phase cancelled.${NC}"
        exit 0
    fi
fi

# Check for concept artifacts
echo -e "${BLUE}🔍 Checking concept phase artifacts...${NC}"
if [[ ! -f "phases/concept/concept-validated.md" ]]; then
    echo -e "${RED}❌ concept-validated.md not found. Please complete concept phase first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found validated concept${NC}"

# Update phase status
echo -e "${BLUE}🔄 Updating phase status...${NC}"
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update blueprint phase status
python3 -c "
import json
with open('project.json', 'r') as f:
    data = json.load(f)
data['current_phase'] = 'blueprint'
data['phases']['blueprint']['status'] = 'in_progress'
data['phases']['blueprint']['started'] = '$current_time'
with open('project.json', 'w') as f:
    json.dump(data, f, indent=2)
"

echo -e "${GREEN}✅ Blueprint phase started${NC}"

# Create blueprint phase directory if it doesn't exist
mkdir -p phases/blueprint

# Create blueprint instructions if not present
if [[ ! -f "BLUEPRINT_PHASE_INSTRUCTIONS.md" ]]; then
    echo -e "${BLUE}📄 Creating blueprint phase instructions...${NC}"
    cat > BLUEPRINT_PHASE_INSTRUCTIONS.md << 'EOF'
# BLUEPRINT PHASE - AI Workflow Orchestrator

## Phase Overview
The Blueprint Phase creates high-level solution architecture and design.

## Deliverables Required:
1. `system-architecture.md` - High-level system design
2. `user-journeys.md` - User flow diagrams and descriptions
3. `technology-stack.md` - Technology choices and rationale
4. `integration-plan.md` - External service integrations
5. `performance-strategy.md` - Performance and scalability approach
6. `blueprint-summary.md` - Executive summary of blueprint

## Important: Stay at high-level design. No implementation details!
EOF
fi

# Git operations
echo -e "${BLUE}📝 Creating git checkpoint...${NC}"
git add -A
git commit -m "Blueprint phase started for $project_name

- Concept phase completed
- Moving to high-level solution design
- Blueprint phase initialized

🤖 Generated with AI Workflow Orchestrator" || true

# Instructions for user
echo ""
echo -e "${GREEN}🎉 Blueprint Phase Ready!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Review the validated concept in phases/concept/concept-validated.md"
echo "2. In Claude Code, use: @BLUEPRINT_PHASE_INSTRUCTIONS.md"
echo "3. Focus on high-level architecture, not implementation"
echo "4. Create all required blueprint documents"
echo ""
echo -e "${YELLOW}💡 Remember: Blueprint is about WHAT and HOW conceptually, not code!${NC}"
echo ""
echo -e "${BLUE}Required Deliverables:${NC}"
echo "  - System architecture diagram and description"
echo "  - User journey maps"
echo "  - Technology stack selection"
echo "  - Integration approach"
echo "  - Performance strategy"
echo ""
echo -e "${GREEN}Good luck with your blueprint phase!${NC}"