#!/bin/bash

# AI Workflow Orchestrator - Project Status
# Check current project status and progress

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 AI Workflow Orchestrator - Project Status${NC}"
echo ""

# Check if we're in a project directory
if [[ ! -f "project.json" ]]; then
    echo -e "${RED}❌ Not in a project directory. Please run from your project root.${NC}"
    exit 1
fi

# Load project configuration
project_name=$(grep -o '"name": "[^"]*' project.json | cut -d'"' -f4)
project_version=$(grep -o '"version": "[^"]*' project.json | cut -d'"' -f4)
created_date=$(grep -o '"created": "[^"]*' project.json | cut -d'"' -f4)
current_phase=$(grep -o '"current_phase": "[^"]*' project.json | cut -d'"' -f4)
complexity=$(grep -o '"complexity": "[^"]*' project.json | cut -d'"' -f4 2>/dev/null || echo "not specified")

# Display project information
echo -e "${BLUE}📋 Project Information${NC}"
echo "  Name: $project_name"
echo "  Version: $project_version"
echo "  Created: $created_date"
echo "  Complexity: $complexity"
echo "  Current Phase: $current_phase"
echo ""

# Function to get phase status
get_phase_status() {
    local phase=$1
    local status=$(grep -A 10 "\"$phase\":" project.json | grep -o '"status": "[^"]*' | cut -d'"' -f4)
    echo "$status"
}

# Function to get phase dates
get_phase_dates() {
    local phase=$1
    local started=$(grep -A 10 "\"$phase\":" project.json | grep -o '"started": "[^"]*' | cut -d'"' -f4)
    local completed=$(grep -A 10 "\"$phase\":" project.json | grep -o '"completed": "[^"]*' | cut -d'"' -f4)
    
    if [[ "$started" == "null" ]]; then
        started="Not started"
    fi
    if [[ "$completed" == "null" ]]; then
        completed="Not completed"
    fi
    
    echo "$started|$completed"
}

# Function to display phase status
display_phase_status() {
    local phase=$1
    local display_name=$2
    local status=$(get_phase_status "$phase")
    local dates=$(get_phase_dates "$phase")
    local started=$(echo "$dates" | cut -d'|' -f1)
    local completed=$(echo "$dates" | cut -d'|' -f2)
    
    case $status in
        "pending")
            echo -e "  ⭕ $display_name: ${YELLOW}Pending${NC}"
            ;;
        "ready")
            echo -e "  🟡 $display_name: ${YELLOW}Ready${NC}"
            ;;
        "in_progress")
            echo -e "  🔄 $display_name: ${BLUE}In Progress${NC} (started: $started)"
            ;;
        "completed")
            echo -e "  ✅ $display_name: ${GREEN}Completed${NC} (finished: $completed)"
            ;;
        *)
            echo -e "  ❓ $display_name: ${RED}Unknown Status${NC}"
            ;;
    esac
}

# Display phase status
echo -e "${BLUE}🔄 Phase Status${NC}"
display_phase_status "concept" "Concept Exploration"
display_phase_status "blueprint" "Blueprint Development"
display_phase_status "prd" "Product Requirements"
display_phase_status "architecture" "Technical Architecture"
display_phase_status "testing" "Test Strategy"
display_phase_status "implementation" "Implementation"
echo ""

# Calculate progress
phases=("concept" "blueprint" "prd" "architecture" "testing" "implementation")
total_phases=${#phases[@]}
completed_phases=0
in_progress_phases=0

for phase in "${phases[@]}"; do
    status=$(get_phase_status "$phase")
    if [[ "$status" == "completed" ]]; then
        ((completed_phases++))
    elif [[ "$status" == "in_progress" ]]; then
        ((in_progress_phases++))
    fi
done

progress_percentage=$((completed_phases * 100 / total_phases))

echo -e "${BLUE}📈 Progress Summary${NC}"
echo "  Total Phases: $total_phases"
echo "  Completed: $completed_phases ($progress_percentage%)"
echo "  In Progress: $in_progress_phases"
echo "  Remaining: $((total_phases - completed_phases - in_progress_phases))"
echo ""

# Display progress bar
echo -e "${BLUE}Progress Bar:${NC}"
progress_bar=""
for ((i=1; i<=total_phases; i++)); do
    if [[ $i -le $completed_phases ]]; then
        progress_bar+="█"
    elif [[ $i -le $((completed_phases + in_progress_phases)) ]]; then
        progress_bar+="▓"
    else
        progress_bar+="░"
    fi
done
echo "  $progress_bar $progress_percentage%"
echo ""

# Check for artifacts
echo -e "${BLUE}📁 Artifacts${NC}"
artifact_count=0
if [[ -d "artifacts" ]]; then
    for file in artifacts/*.md; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "unknown")
            if [[ $size -gt 100 ]]; then
                echo -e "  ✅ $filename (${size} bytes)"
            else
                echo -e "  ⚠️  $filename (${size} bytes - minimal content)"
            fi
            ((artifact_count++))
        fi
    done
fi

if [[ $artifact_count -eq 0 ]]; then
    echo -e "  ${YELLOW}No artifacts found${NC}"
fi
echo ""

# Check for decisions
echo -e "${BLUE}📋 Decisions${NC}"
decision_count=0
if [[ -d "decisions" ]]; then
    for file in decisions/*.md; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            echo -e "  📄 $filename"
            ((decision_count++))
        fi
    done
fi

if [[ $decision_count -eq 0 ]]; then
    echo -e "  ${YELLOW}No decisions recorded${NC}"
fi
echo ""

# Check git status
echo -e "${BLUE}📝 Git Status${NC}"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    current_branch=$(git branch --show-current)
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    last_commit=$(git log -1 --pretty=format:"%h - %s (%cr)" 2>/dev/null || echo "No commits")
    
    echo "  Current Branch: $current_branch"
    echo "  Total Commits: $commit_count"
    echo "  Last Commit: $last_commit"
    
    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null; then
        echo -e "  ${YELLOW}⚠️  Uncommitted changes detected${NC}"
    fi
    
    # Check for untracked files
    if [[ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]]; then
        echo -e "  ${YELLOW}⚠️  Untracked files detected${NC}"
    fi
else
    echo -e "  ${RED}❌ Not a git repository${NC}"
fi
echo ""

# Check for Claude Flow swarm status
echo -e "${BLUE}🐝 Claude Flow Status${NC}"
if command -v claude >/dev/null 2>&1; then
    if claude mcp list 2>/dev/null | grep -q "claude-flow"; then
        echo -e "  ✅ Claude Flow MCP configured"
        
        # Check if swarm is active (this would need to be implemented)
        echo -e "  ℹ️  Use Claude Code to check active swarm status"
    else
        echo -e "  ${YELLOW}⚠️  Claude Flow MCP not configured${NC}"
    fi
else
    echo -e "  ${RED}❌ Claude Code not found${NC}"
fi
echo ""

# Next steps based on current phase
echo -e "${BLUE}🎯 Next Steps${NC}"
case $current_phase in
    "concept")
        concept_status=$(get_phase_status "concept")
        if [[ "$concept_status" == "ready" ]]; then
            echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/concept-phase.sh${NC}"
            echo -e "  2. Fill out your initial concept in concept-prompt.md"
            echo -e "  3. Use Claude Code to explore your concept with AI agents"
        elif [[ "$concept_status" == "in_progress" ]]; then
            echo -e "  1. Complete the concept analysis in artifacts/concept-analysis.md"
            echo -e "  2. Fill out the concept validation checklist"
            echo -e "  3. Review and commit your concept decisions"
        fi
        ;;
    "blueprint")
        echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/blueprint-phase.sh${NC}"
        echo -e "  2. Design your system architecture"
        echo -e "  3. Map user journeys and select technology stack"
        ;;
    "prd")
        echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/prd-phase.sh${NC}"
        echo -e "  2. Define detailed requirements and user stories"
        echo -e "  3. Design API specifications and data models"
        ;;
    "architecture")
        echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/architecture-phase.sh${NC}"
        echo -e "  2. Create detailed technical architecture"
        echo -e "  3. Plan security and performance strategies"
        ;;
    "testing")
        echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/testing-phase.sh${NC}"
        echo -e "  2. Develop comprehensive test strategy"
        echo -e "  3. Plan automation and quality assurance"
        ;;
    "implementation")
        echo -e "  1. Run: ${GREEN}../ai-workflow-orchestrator/scripts/implementation-phase.sh${NC}"
        echo -e "  2. Use Claude Flow for AI-assisted development"
        echo -e "  3. Follow the implementation plan with parallel agents"
        ;;
esac
echo ""

# Success metrics
echo -e "${BLUE}📊 Success Metrics${NC}"
target_reduction=$(grep -o '"development_time_reduction": [0-9.]*' project.json | cut -d':' -f2 | tr -d ' ')
target_productivity=$(grep -o '"target_productivity_gain": [0-9.]*' project.json | cut -d':' -f2 | tr -d ' ')
quality_threshold=$(grep -o '"quality_threshold": [0-9.]*' project.json | cut -d':' -f2 | tr -d ' ')

echo "  Target Time Reduction: ${target_reduction}% (45-60% typical)"
echo "  Target Productivity Gain: ${target_productivity}% (research-backed)"
echo "  Quality Threshold: ${quality_threshold}% (85% recommended)"
echo ""

# Available commands
echo -e "${BLUE}🛠️  Available Commands${NC}"
echo -e "  Status: ${GREEN}../ai-workflow-orchestrator/scripts/status.sh${NC}"
echo -e "  Help: ${GREEN}../ai-workflow-orchestrator/scripts/help.sh${NC}"
echo -e "  Validate: ${GREEN}../ai-workflow-orchestrator/scripts/validate-phase.sh${NC}"
echo -e "  Export: ${GREEN}../ai-workflow-orchestrator/scripts/export-artifacts.sh${NC}"
echo ""

# Final summary
if [[ $progress_percentage -eq 100 ]]; then
    echo -e "${GREEN}🎉 Project Complete! All phases finished.${NC}"
elif [[ $progress_percentage -ge 80 ]]; then
    echo -e "${GREEN}🚀 Project Nearly Complete! Final phase in progress.${NC}"
elif [[ $progress_percentage -ge 50 ]]; then
    echo -e "${BLUE}⚡ Project Making Good Progress! Halfway there.${NC}"
else
    echo -e "${YELLOW}📝 Project Getting Started! Focus on current phase.${NC}"
fi

echo -e "${BLUE}💡 Remember: The research shows 45-60% productivity improvements with this approach!${NC}"