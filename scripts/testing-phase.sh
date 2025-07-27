#!/bin/bash

# AI Workflow Orchestrator - Testing Phase
# Automated test strategy generation based on architecture

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 AI Workflow Orchestrator - Testing Phase${NC}"
echo -e "${BLUE}Automated test strategy generation${NC}"
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

# Check if architecture phase is complete
architecture_status=$(grep -A2 '"architecture"' project.json | grep -o '"status": "[^"]*' | cut -d'"' -f4)
if [[ "$architecture_status" != "completed" ]]; then
    echo -e "${RED}❌ Architecture phase must be completed before starting Testing phase.${NC}"
    echo -e "${YELLOW}Current architecture phase status: $architecture_status${NC}"
    exit 1
fi

# Check for architecture artifacts
echo -e "${BLUE}🔍 Checking architecture phase artifacts...${NC}"
required_files=("architecture-summary.md" "technology-stack.md" "api-design.md" "security-architecture.md")
missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f "phases/architecture/$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo -e "${RED}❌ Missing architecture artifacts:${NC}"
    for file in "${missing_files[@]}"; do
        echo "   - $file"
    done
    echo -e "${YELLOW}Please complete the architecture phase first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found all architecture artifacts${NC}"

# Testing approach
echo ""
echo -e "${PURPLE}🎯 Testing Strategy Approach${NC}"
echo -e "${CYAN}This phase will generate a comprehensive test strategy based on:${NC}"
echo "  • Your technology choices from architecture phase"
echo "  • Security requirements from PRD"
echo "  • Performance targets (<2s load time)"
echo "  • Zero-cost testing tools focus"
echo ""

echo -e "${YELLOW}The AI will create:${NC}"
echo "  1. Test strategy overview"
echo "  2. Unit testing approach"
echo "  3. Integration testing plan"
echo "  4. E2E testing strategy"
echo "  5. Performance testing methodology"
echo "  6. Security testing checklist"
echo "  7. Test automation setup"
echo "  8. CI/CD test pipeline"
echo ""

echo -e "${GREEN}Continue with automated test strategy generation? (y/n)${NC}"
read -r ready_to_begin

if [[ $ready_to_begin != "y" && $ready_to_begin != "Y" ]]; then
    echo -e "${YELLOW}Testing phase postponed. Run this script when ready.${NC}"
    exit 0
fi

# Update phase status
echo -e "${BLUE}🔄 Starting Testing phase...${NC}"
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update Testing phase status
python3 -c "
import json
with open('project.json', 'r') as f:
    data = json.load(f)
data['current_phase'] = 'testing'
data['phases']['testing']['status'] = 'in_progress'
data['phases']['testing']['started'] = '$current_time'
with open('project.json', 'w') as f:
    json.dump(data, f, indent=2)
"

echo -e "${GREEN}✅ Testing phase started${NC}"

# Create Testing phase directory if it doesn't exist
mkdir -p phases/testing

# Create testing phase instructions
echo -e "${BLUE}📄 Creating testing phase instructions...${NC}"
cat > TESTING_PHASE_INSTRUCTIONS.md << 'EOF'
# Testing Phase - Automated Strategy Generation

## 🎯 Phase Overview

Generate a comprehensive testing strategy based on the architecture decisions and PRD requirements. Focus on practical, zero-cost testing approaches.

## 📋 Testing Strategy Components

### 1. Review Architecture Context

Read and analyze:
- `phases/architecture/technology-stack.md` - Understand the tech stack
- `phases/architecture/security-architecture.md` - Security testing needs
- `phases/prd/performance-strategy.md` - Performance targets
- `phases/prd/feature-specifications.md` - What needs testing

### 2. Generate Test Strategy Documents

Create the following in `phases/testing/`:

#### A. `testing-strategy.md`
- Overall testing philosophy
- Test pyramid approach (Unit > Integration > E2E)
- Coverage targets (aim for 80%+ for critical paths)
- Testing tools selection (Jest, Vitest, Playwright, etc.)
- Manual vs automated testing decisions

#### B. `unit-testing.md`
- Component testing approach for React
- API route testing strategy
- Utility function testing
- Mock strategies for external services
- Example test cases for core features

#### C. `integration-testing.md`
- API integration tests
- Database integration tests
- Authentication flow testing
- GitHub API integration testing
- Example test scenarios

#### D. `e2e-testing.md`
- Critical user journeys to test
- Admin workflow testing
- Public portfolio testing
- Cross-browser testing strategy
- Mobile testing approach

#### E. `performance-testing.md`
- Core Web Vitals testing
- Load testing approach
- API performance benchmarks
- Database query performance
- Lighthouse CI integration

#### F. `security-testing.md`
- OWASP Top 10 checklist
- Authentication testing
- Input validation testing
- XSS prevention verification
- SQL injection testing
- Rate limiting verification

#### G. `test-automation.md`
- CI/CD pipeline setup (GitHub Actions)
- Pre-commit hooks
- Automated test runs
- Test reporting
- Coverage tracking

#### H. `testing-checklist.md`
- Pre-deployment checklist
- Release testing procedures
- Regression testing approach
- Bug tracking process

### 3. Tool Selection (Zero-Cost Focus)

Recommend free/open-source tools:
- **Unit Testing**: Vitest (faster than Jest)
- **Integration**: Supertest
- **E2E**: Playwright (better than Cypress for free tier)
- **Performance**: Lighthouse CI
- **Security**: OWASP ZAP (free scanner)
- **Monitoring**: Sentry free tier

### 4. Testing Standards

Define:
- Naming conventions for test files
- Test structure patterns
- Assertion best practices
- When to use mocks vs real services
- Test data management

### 5. Critical Test Scenarios

Based on PRD, ensure coverage for:
1. Admin authentication flow
2. GitHub repository import
3. Project CRUD operations
4. Analytics data collection
5. Public portfolio rendering
6. Contact form submission
7. Performance under load

## 🚨 Important Reminders

### Update project.json When Complete
```python
import json
from datetime import datetime

with open('project.json', 'r+') as f:
    data = json.load(f)
    data['phases']['testing']['status'] = 'completed'
    data['phases']['testing']['completed'] = datetime.utcnow().isoformat() + 'Z'
    data['phases']['testing']['artifacts'] = [
        # List all .md files created
    ]
    f.seek(0)
    json.dump(data, f, indent=2)
    f.truncate()
```

### Or remind user to run:
```bash
~/projects/experiments/claude-flow-workflow/v2/ai-workflow-orchestrator/scripts/complete-phase.py testing
```

## 📁 Deliverables Summary

All files in `phases/testing/`:
1. `testing-strategy.md` - Overall approach
2. `unit-testing.md` - Component testing
3. `integration-testing.md` - API/DB testing  
4. `e2e-testing.md` - User journey testing
5. `performance-testing.md` - Speed/optimization
6. `security-testing.md` - Security verification
7. `test-automation.md` - CI/CD setup
8. `testing-checklist.md` - Quality gates

Total: 8 comprehensive testing documents
EOF

# Git operations
echo -e "${BLUE}📝 Creating git checkpoint...${NC}"
git add -A
git commit -m "Testing phase started for $project_name

- Architecture phase completed
- Automated testing strategy generation
- Focus on zero-cost testing tools
- Comprehensive test coverage planning

🤖 Generated with AI Workflow Orchestrator" || true

# Final instructions
echo ""
echo -e "${GREEN}🎉 Testing Phase Ready!${NC}"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    Next Steps                              ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}1. In Claude Code, use this command:${NC}"
echo -e "${GREEN}   @TESTING_PHASE_INSTRUCTIONS.md${NC}"
echo ""
echo -e "${YELLOW}2. The AI will:${NC}"
echo "   • Analyze your architecture and PRD"
echo "   • Generate comprehensive test strategies"
echo "   • Select appropriate testing tools"
echo "   • Create 8 testing documents"
echo ""
echo -e "${YELLOW}3. Key Testing Constraints:${NC}"
echo "   • Zero-cost tools only"
echo "   • 80%+ coverage for critical paths"
echo "   • Performance testing for <2s target"
echo "   • Security testing based on OWASP"
echo ""
echo -e "${YELLOW}4. When Complete:${NC}"
echo -e "${CYAN}   Run: ${GREEN}complete-phase.py testing${NC}"
echo -e "${CYAN}   From your project directory${NC}"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}📌 This phase is automated based on your previous decisions.${NC}"
echo -e "${CYAN}   The AI will generate appropriate test strategies.${NC}"
echo ""
echo -e "${GREEN}Good luck with your testing strategy!${NC}"