#!/bin/bash

# AI Workflow Orchestrator - Start New Project
# Based on research showing 45-60% productivity improvements with AI-guided workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORCHESTRATOR_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$ORCHESTRATOR_DIR/templates"
PROJECTS_DIR="$HOME/ai-workflow-projects"

echo -e "${BLUE}🚀 AI Workflow Orchestrator - Starting New Project${NC}"
echo -e "${BLUE}Based on research showing 45-60% productivity improvements${NC}"
echo ""

# Check if Claude Flow is available
if ! command -v claude &> /dev/null; then
    echo -e "${RED}❌ Claude Code not found. Please install Claude Code first.${NC}"
    exit 1
fi

# Check if Claude Flow MCP is configured
echo -e "${YELLOW}🔍 Checking Claude Flow MCP configuration...${NC}"
if ! claude mcp list | grep -q "claude-flow"; then
    echo -e "${YELLOW}⚠️  Claude Flow MCP not configured. Setting up...${NC}"
    echo "Would you like to configure Claude Flow MCP now? (y/n)"
    read -r configure_mcp
    if [[ $configure_mcp == "y" || $configure_mcp == "Y" ]]; then
        echo -e "${BLUE}🔧 Adding Claude Flow MCP server...${NC}"
        claude mcp add claude-flow npx claude-flow mcp start
        echo -e "${GREEN}✅ Claude Flow MCP configured successfully${NC}"
    else
        echo -e "${YELLOW}⚠️  Continuing without Claude Flow MCP (reduced functionality)${NC}"
    fi
fi

# Project setup
echo -e "${BLUE}📝 Project Setup${NC}"
echo "Enter your project name (e.g., 'my-awesome-app'):"
read -r project_name

if [[ -z "$project_name" ]]; then
    echo -e "${RED}❌ Project name cannot be empty${NC}"
    exit 1
fi

# Sanitize project name
project_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

echo -e "${BLUE}📂 Creating project directory...${NC}"
mkdir -p "$PROJECTS_DIR"
project_dir="$PROJECTS_DIR/$project_name"

if [[ -d "$project_dir" ]]; then
    echo -e "${YELLOW}⚠️  Project directory already exists: $project_dir${NC}"
    echo "Would you like to continue and overwrite? (y/n)"
    read -r overwrite
    if [[ $overwrite != "y" && $overwrite != "Y" ]]; then
        echo -e "${YELLOW}🚫 Operation cancelled${NC}"
        exit 1
    fi
    rm -rf "$project_dir"
fi

mkdir -p "$project_dir"
cd "$project_dir"

echo -e "${GREEN}✅ Project directory created: $project_dir${NC}"

# Initialize git repository
echo -e "${BLUE}🔧 Initializing git repository...${NC}"
git init
git config user.name "AI Workflow Orchestrator"
git config user.email "ai-workflow@example.com"

# Create project structure
echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p {artifacts,phases,decisions,exports,docs}

# Create project configuration
echo -e "${BLUE}⚙️  Creating project configuration...${NC}"
cat > project.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "orchestrator_version": "2.0.0",
  "current_phase": "concept",
  "phases": {
    "concept": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "blueprint": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "prd": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "architecture": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "testing": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "implementation": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    }
  },
  "swarm_config": {
    "topology": "hierarchical",
    "max_agents": 8,
    "strategy": "adaptive"
  },
  "success_metrics": {
    "development_time_reduction": 0.45,
    "target_productivity_gain": 0.60,
    "quality_threshold": 0.85
  }
}
EOF

# Copy phase templates
echo -e "${BLUE}📄 Setting up phase templates...${NC}"
cp -r "$TEMPLATES_DIR"/* phases/

# Create README
echo -e "${BLUE}📚 Creating project README...${NC}"
cat > README.md << EOF
# $project_name

AI-Orchestrated Development Workflow Project

## Overview
This project uses the AI Workflow Orchestrator system based on research showing 45-60% productivity improvements with multi-agent approaches.

## Current Status
- **Phase**: Concept Exploration
- **Status**: Ready to begin
- **Created**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

## Quick Start
\`\`\`bash
# Start concept phase
../ai-workflow-orchestrator/scripts/concept-phase.sh

# Check project status
../ai-workflow-orchestrator/scripts/status.sh
\`\`\`

## Project Structure
- \`phases/\` - Phase templates and artifacts
- \`artifacts/\` - Generated specifications and documents
- \`decisions/\` - Decision logs and rationale
- \`exports/\` - Exported artifacts and reports
- \`docs/\` - Additional documentation

## Workflow Phases
1. **Concept**: Idea exploration and validation
2. **Blueprint**: High-level solution design
3. **PRD**: Detailed requirements specification
4. **Architecture**: Technical design and planning
5. **Testing**: Quality assurance strategy
6. **Implementation**: AI-assisted development

## Success Metrics
Based on research analysis:
- Target development time reduction: 45-60%
- Quality threshold: 85%
- Productivity gain target: 60%

## AI Agent Coordination
This project uses Claude Flow for multi-agent coordination:
- Hierarchical topology with up to 8 agents
- Adaptive strategy based on task complexity
- Persistent memory across phases
- Automated quality gates

## Next Steps
1. Run the concept phase script to begin
2. Follow the AI-guided prompts for idea exploration
3. Review and validate each phase before proceeding
4. Use version control for all decisions and artifacts

---
Generated by AI Workflow Orchestrator v2.0.0
EOF

# Create initial commit
echo -e "${BLUE}💾 Creating initial commit...${NC}"
git add .
git commit -m "Initial project setup with AI Workflow Orchestrator

- Project: $project_name
- Orchestrator version: 2.0.0
- Phase templates configured
- Git repository initialized
- Ready for concept phase

🤖 Generated with AI Workflow Orchestrator"

# Create concept phase branch
git checkout -b "concept/v1.0.0"
git checkout main

# Project selection workflow
echo -e "${BLUE}🎯 Project Workflow Selection${NC}"
echo ""
echo "Select your project complexity:"
echo "1. Simple (1-2 week project, solo developer)"
echo "2. Medium (1-3 month project, small team)"
echo "3. Complex (3+ month project, larger team)"
echo ""
echo "Enter your choice (1-3):"
read -r complexity

case $complexity in
    1)
        complexity_level="simple"
        recommended_agents=3
        recommended_topology="star"
        ;;
    2)
        complexity_level="medium"
        recommended_agents=5
        recommended_topology="hierarchical"
        ;;
    3)
        complexity_level="complex"
        recommended_agents=8
        recommended_topology="mesh"
        ;;
    *)
        echo -e "${YELLOW}⚠️  Invalid choice, defaulting to medium complexity${NC}"
        complexity_level="medium"
        recommended_agents=5
        recommended_topology="hierarchical"
        ;;
esac

# Update project configuration
echo -e "${BLUE}⚙️  Updating project configuration for $complexity_level complexity...${NC}"
cat > project.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "orchestrator_version": "2.0.0",
  "complexity": "$complexity_level",
  "current_phase": "concept",
  "phases": {
    "concept": {
      "status": "ready",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "blueprint": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "prd": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "architecture": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "testing": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    },
    "implementation": {
      "status": "pending",
      "started": null,
      "completed": null,
      "artifacts": []
    }
  },
  "swarm_config": {
    "topology": "$recommended_topology",
    "max_agents": $recommended_agents,
    "strategy": "adaptive"
  },
  "success_metrics": {
    "development_time_reduction": 0.45,
    "target_productivity_gain": 0.60,
    "quality_threshold": 0.85
  }
}
EOF

# Domain selection
echo -e "${BLUE}🏗️  Domain Selection${NC}"
echo ""
echo "Select your project domain:"
echo "1. Web Application (React/Vue/Angular)"
echo "2. API/Backend Service (Node.js/Python/Java)"
echo "3. Mobile App (React Native/Flutter)"
echo "4. Desktop Application (Electron/Tauri)"
echo "5. AI/ML Project (Python/TensorFlow/PyTorch)"
echo "6. DevOps/Infrastructure (Docker/Kubernetes/Terraform)"
echo "7. Data/Analytics (Python/R/SQL)"
echo "8. Other/Mixed"
echo ""
echo "Enter your choice (1-8):"
read -r domain

case $domain in
    1) domain_type="web" ;;
    2) domain_type="api" ;;
    3) domain_type="mobile" ;;
    4) domain_type="desktop" ;;
    5) domain_type="ai-ml" ;;
    6) domain_type="devops" ;;
    7) domain_type="data" ;;
    8) domain_type="other" ;;
    *) domain_type="web" ;;
esac

# Create domain-specific guidance
echo -e "${BLUE}📋 Creating domain-specific guidance...${NC}"
cat > docs/domain-guidance.md << EOF
# Domain-Specific Guidance: $domain_type

## Recommended Technology Stack
[This will be populated based on your domain selection and refined during the blueprint phase]

## Common Patterns
[Domain-specific patterns and best practices]

## Integration Points
[Typical integrations for this domain]

## Performance Considerations
[Domain-specific performance requirements]

## Security Considerations
[Domain-specific security requirements]

## Testing Strategy
[Domain-specific testing approaches]

---
This guidance will be refined by AI agents during the workflow phases.
EOF

# Create initial concept prompt
echo -e "${BLUE}💡 Creating initial concept prompt...${NC}"
cat > concept-prompt.md << EOF
# Your Project Concept

## Initial Idea
Describe your project idea in your own words. Don't worry about structure or completeness - just capture what you want to build and why.

### What problem are you solving?
[Your answer here]

### Who will use this?
[Your answer here]

### What makes this unique or valuable?
[Your answer here]

### Any initial technical thoughts?
[Your answer here]

## Next Steps
1. Fill out the above sections with your initial thoughts
2. Run: \`../ai-workflow-orchestrator/scripts/concept-phase.sh\`
3. Follow the AI-guided exploration process

The AI agents will help you refine and develop this concept into a comprehensive specification.
EOF

# Final setup
echo -e "${BLUE}🔧 Final setup...${NC}"
git add .
git commit -m "Configure project for $complexity_level complexity and $domain_type domain

- Complexity: $complexity_level
- Domain: $domain_type  
- Recommended agents: $recommended_agents
- Recommended topology: $recommended_topology
- Created domain-specific guidance
- Ready for concept phase

🤖 Generated with AI Workflow Orchestrator"

# Success message
echo ""
echo -e "${GREEN}🎉 Project setup complete!${NC}"
echo ""
echo -e "${BLUE}Project Details:${NC}"
echo "  Name: $project_name"
echo "  Location: $project_dir"
echo "  Complexity: $complexity_level"
echo "  Domain: $domain_type"
echo "  Recommended agents: $recommended_agents"
echo "  Topology: $recommended_topology"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. cd $project_dir"
echo "2. Edit concept-prompt.md with your initial idea"
echo "3. Run: ../ai-workflow-orchestrator/scripts/concept-phase.sh"
echo ""
echo -e "${BLUE}Available Commands:${NC}"
echo "  Status: ../ai-workflow-orchestrator/scripts/status.sh"
echo "  Help: ../ai-workflow-orchestrator/scripts/help.sh"
echo ""
echo -e "${YELLOW}💡 Based on research showing 45-60% productivity improvements${NC}"
echo -e "${YELLOW}   with AI-guided multi-agent workflows${NC}"
echo ""
echo -e "${GREEN}✨ Happy building!${NC}"