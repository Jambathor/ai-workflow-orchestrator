#!/bin/bash

# AI Workflow Orchestrator - Concept Phase
# AI-guided concept exploration and validation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧠 AI Workflow Orchestrator - Concept Phase${NC}"
echo -e "${BLUE}AI-guided concept exploration and validation${NC}"
echo ""

# Check if we're in a project directory
if [[ ! -f "project.json" ]]; then
    echo -e "${RED}❌ Not in a project directory. Please run from your project root.${NC}"
    exit 1
fi

# Load project configuration
project_name=$(grep -o '"name": "[^"]*' project.json | cut -d'"' -f4)
complexity=$(grep -o '"complexity": "[^"]*' project.json | cut -d'"' -f4)
topology=$(grep -o '"topology": "[^"]*' project.json | cut -d'"' -f4)
max_agents=$(grep -o '"max_agents": [0-9]*' project.json | cut -d':' -f2 | tr -d ' ')

echo -e "${BLUE}📊 Project Configuration${NC}"
echo "  Project: $project_name"
echo "  Complexity: $complexity"
echo "  Topology: $topology"
echo "  Max Agents: $max_agents"
echo ""

# Check if concept prompt exists
if [[ ! -f "concept-prompt.md" ]]; then
    echo -e "${RED}❌ concept-prompt.md not found. Please create it with your initial idea.${NC}"
    exit 1
fi

# Update phase status
echo -e "${BLUE}🔄 Updating phase status...${NC}"
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
sed -i "s/\"status\": \"ready\"/\"status\": \"in_progress\"/" project.json
sed -i "s/\"started\": null/\"started\": \"$current_time\"/" project.json

# Create concept phase branch
echo -e "${BLUE}🌿 Creating concept phase branch...${NC}"
git checkout -b "concept/v1.0.0-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || git checkout "concept/v1.0.0-$(date +%Y%m%d-%H%M%S)"

# Copy concept template
echo -e "${BLUE}📄 Setting up concept template...${NC}"
cp phases/concept/concept-template.md artifacts/concept-analysis.md

# Initialize Claude Flow swarm
echo -e "${BLUE}🐝 Initializing Claude Flow swarm...${NC}"
cat > claude-flow-init.md << 'EOF'
# Claude Flow Swarm Initialization for Concept Phase

## Initialize Swarm
```bash
# Set up the swarm for concept exploration
mcp__ruv-swarm__swarm_init --topology {{ topology }} --maxAgents {{ max_agents }} --strategy adaptive

# Spawn specialized agents for concept exploration
mcp__ruv-swarm__agent_spawn --type researcher --name "Market Research Agent"
mcp__ruv-swarm__agent_spawn --type analyst --name "Feasibility Analyst"
mcp__ruv-swarm__agent_spawn --type strategist --name "Business Strategist"
mcp__ruv-swarm__agent_spawn --type coordinator --name "Concept Coordinator"

# Store initial concept in memory
mcp__ruv-swarm__memory_usage --action store --key "concept/initial" --value "$(cat concept-prompt.md)"
```

## Orchestrate Concept Exploration
```bash
# Start the concept exploration task
mcp__ruv-swarm__task_orchestrate --task "Concept Exploration and Validation" --strategy parallel --priority high

# Monitor progress
mcp__ruv-swarm__swarm_monitor --duration 30 --interval 5
```

## Agent Coordination Tasks
Each agent will contribute to the concept development:
- **Market Research Agent**: Competitive analysis and market sizing
- **Feasibility Analyst**: Technical and business feasibility assessment
- **Business Strategist**: Value proposition and business model
- **Concept Coordinator**: Overall coordination and decision synthesis
EOF

# Replace template variables
sed -i "s/{{ topology }}/$topology/g" claude-flow-init.md
sed -i "s/{{ max_agents }}/$max_agents/g" claude-flow-init.md

# Create AI-guided concept exploration prompt
echo -e "${BLUE}🤖 Creating AI-guided exploration prompt...${NC}"
cat > ai-concept-guide.md << 'EOF'
# AI-Guided Concept Exploration

## Your Mission
You are the Concept Coordinator in a multi-agent swarm exploring and validating a new project concept. Your goal is to transform the initial idea into a comprehensive, validated concept ready for blueprint development.

## Initial Concept
```
EOF

cat concept-prompt.md >> ai-concept-guide.md

cat >> ai-concept-guide.md << 'EOF'
```

## Multi-Agent Exploration Process

### Phase 1: Parallel Analysis
Run the following agents in parallel to explore different aspects:

1. **Market Research Agent** - Analyze:
   - Competitive landscape and similar solutions
   - Market size and growth potential
   - Target user segments and personas
   - Industry trends and opportunities

2. **Feasibility Analyst** - Assess:
   - Technical feasibility and complexity
   - Resource requirements and constraints
   - Risk factors and mitigation strategies
   - Development timeline estimates

3. **Business Strategist** - Develop:
   - Value proposition and unique selling points
   - Business model and revenue streams
   - Go-to-market strategy
   - Success metrics and KPIs

### Phase 2: Synthesis and Validation
Coordinate the findings from all agents to create:
- Comprehensive stakeholder analysis
- Validated problem-solution fit
- Clear success criteria and metrics
- Risk-adjusted feasibility assessment

### Phase 3: Concept Refinement
Based on the analysis, refine the concept to ensure:
- Clear and compelling value proposition
- Realistic scope and timeline
- Identified key assumptions for validation
- Strong foundation for blueprint phase

## Expected Outputs
1. **Concept Document** - Complete concept-analysis.md
2. **Stakeholder Analysis** - Detailed stakeholder mapping
3. **Feasibility Assessment** - Technical and business feasibility
4. **Success Metrics** - Measurable success criteria
5. **Risk Analysis** - Key risks and mitigation strategies

## Quality Gates
Before proceeding to blueprint phase, ensure:
- [ ] Problem statement is clear and validated
- [ ] Target users are identified and accessible
- [ ] Value proposition is compelling and differentiated
- [ ] Technical approach is feasible with available resources
- [ ] Business case is sound with realistic projections
- [ ] Key assumptions are identified and testable

## Next Steps
1. Initialize the Claude Flow swarm (see claude-flow-init.md)
2. Run the parallel analysis with specialized agents
3. Synthesize findings into the concept document
4. Validate with stakeholders and technical experts
5. Refine based on feedback and prepare for blueprint phase

---
Remember: The goal is not perfection but a solid foundation for the next phase. Focus on identifying and validating the core assumptions that will drive the entire project.
EOF

# Create concept validation checklist
echo -e "${BLUE}✅ Creating validation checklist...${NC}"
cat > concept-validation.md << 'EOF'
# Concept Validation Checklist

## Core Validation Criteria
- [ ] **Problem Clarity**: Is the problem well-defined and significant?
- [ ] **Solution Fit**: Does the proposed solution address the problem effectively?
- [ ] **Market Validation**: Is there evidence of market demand?
- [ ] **Technical Feasibility**: Can this be built with available resources?
- [ ] **Business Viability**: Is there a sustainable business model?

## Stakeholder Validation
- [ ] **Primary Users**: Have you talked to potential users?
- [ ] **Technical Team**: Can the technical team build this?
- [ ] **Business Stakeholders**: Do business stakeholders support this?
- [ ] **Domain Experts**: Have domain experts validated the approach?

## Risk Assessment
- [ ] **Technical Risks**: Are technical risks identified and manageable?
- [ ] **Market Risks**: Are market risks understood and mitigated?
- [ ] **Resource Risks**: Are resource requirements realistic?
- [ ] **Timeline Risks**: Is the timeline achievable?

## Success Metrics
- [ ] **User Metrics**: How will you measure user adoption and satisfaction?
- [ ] **Business Metrics**: How will you measure business success?
- [ ] **Technical Metrics**: How will you measure technical success?
- [ ] **Quality Metrics**: How will you measure quality and reliability?

## Readiness for Blueprint Phase
- [ ] **Concept Document**: Complete and validated concept analysis
- [ ] **Stakeholder Buy-in**: Key stakeholders support the concept
- [ ] **Resource Commitment**: Resources are allocated and available
- [ ] **Technical Direction**: General technical approach is agreed upon
- [ ] **Success Criteria**: Clear success metrics are defined

## Validation Methods
- [ ] **User Interviews**: Conducted interviews with potential users
- [ ] **Market Research**: Analyzed competitive landscape and market size
- [ ] **Technical Spike**: Validated core technical assumptions
- [ ] **Business Case**: Developed and validated business case
- [ ] **Prototype/MVP**: Created minimal prototype or proof of concept (optional)

---
Complete this checklist before proceeding to the blueprint phase.
EOF

# Create AI conversation log
echo -e "${BLUE}💬 Creating AI conversation log...${NC}"
cat > ai-conversations.md << 'EOF'
# AI Conversation Log - Concept Phase

## Session Information
- **Date**: $(date)
- **Phase**: Concept Exploration
- **Agents**: Market Research, Feasibility Analysis, Business Strategy, Coordination

## Conversation History
[This file will be updated with AI conversations during the concept exploration process]

### Initial Concept Exploration
Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

**User Input**: 
```
EOF

cat concept-prompt.md >> ai-conversations.md

echo '```

**AI Response**: [To be filled during exploration]

---
Add all AI conversations below this line with timestamps and agent identification.
' >> ai-conversations.md

# Create decision log
echo -e "${BLUE}📋 Creating decision log...${NC}"
cat > decisions/concept-decisions.md << 'EOF'
# Concept Phase Decision Log

## Major Decisions

### Decision 1: [Title]
- **Date**: [Date]
- **Context**: [Background and situation]
- **Options Considered**: [List of options]
- **Decision**: [What was decided]
- **Rationale**: [Why this decision was made]
- **Impact**: [Expected impact]
- **Reversibility**: [Can this decision be changed later?]

### Decision 2: [Title]
- **Date**: [Date]
- **Context**: [Background and situation]
- **Options Considered**: [List of options]
- **Decision**: [What was decided]
- **Rationale**: [Why this decision was made]
- **Impact**: [Expected impact]
- **Reversibility**: [Can this decision be changed later?]

## Minor Decisions
- [Date] - [Decision]: [Brief description]
- [Date] - [Decision]: [Brief description]
- [Date] - [Decision]: [Brief description]

## Assumptions Made
- [Assumption 1]: [Description and validation plan]
- [Assumption 2]: [Description and validation plan]
- [Assumption 3]: [Description and validation plan]

## Open Questions
- [Question 1]: [Description and plan to resolve]
- [Question 2]: [Description and plan to resolve]
- [Question 3]: [Description and plan to resolve]

---
Update this log throughout the concept phase to maintain a clear record of all decisions and their rationale.
EOF

# Commit initial concept setup
echo -e "${BLUE}💾 Committing concept phase setup...${NC}"
git add .
git commit -m "Initialize concept phase exploration

- Set up concept analysis template
- Created AI-guided exploration framework
- Initialized Claude Flow swarm configuration
- Created validation checklist and decision log
- Ready for AI-assisted concept development

Phase: Concept Exploration
Status: In Progress
Agents: Market Research, Feasibility Analysis, Business Strategy, Coordination

🤖 Generated with AI Workflow Orchestrator"

# Usage instructions
echo ""
echo -e "${GREEN}🎉 Concept phase initialized!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Review ai-concept-guide.md for detailed exploration process"
echo "2. Use Claude Code with the following approach:"
echo ""
echo -e "${YELLOW}   Option A: Full AI-Guided Exploration${NC}"
echo "   - Open Claude Code in this project directory"
echo "   - Load ai-concept-guide.md and follow the multi-agent process"
echo "   - Use the Claude Flow swarm commands from claude-flow-init.md"
echo ""
echo -e "${YELLOW}   Option B: Manual Exploration${NC}"
echo "   - Fill out artifacts/concept-analysis.md section by section"
echo "   - Use the template prompts to guide your thinking"
echo "   - Complete the concept-validation.md checklist"
echo ""
echo -e "${BLUE}📁 Key Files:${NC}"
echo "   ai-concept-guide.md - AI-guided exploration process"
echo "   artifacts/concept-analysis.md - Main concept document"
echo "   concept-validation.md - Validation checklist"
echo "   claude-flow-init.md - Swarm initialization commands"
echo "   ai-conversations.md - AI conversation log"
echo "   decisions/concept-decisions.md - Decision tracking"
echo ""
echo -e "${BLUE}🔄 Status Commands:${NC}"
echo "   ../ai-workflow-orchestrator/scripts/status.sh - Check project status"
echo "   ../ai-workflow-orchestrator/scripts/validate-concept.sh - Validate concept completion"
echo ""
echo -e "${YELLOW}💡 Pro Tip: Use Claude Code's multi-agent capabilities for best results${NC}"
echo -e "${YELLOW}   The research shows 45-60% productivity improvements with this approach${NC}"
echo ""
echo -e "${GREEN}✨ Ready for AI-guided concept exploration!${NC}"