# Phase Workflow Guide - How to Actually Use This Framework

## The Problem We're Solving

You're right to feel frustrated. The current workflow has issues:
- Prompts get lost in Claude Code conversations
- Too much manual work between phases
- Unclear what to do at each step
- Not leveraging the framework's full potential

## The Ideal Workflow (What We're Building Towards)

### For Each Phase:

1. **Run Phase Script**
   ```bash
   ~/path/to/orchestrator/scripts/[phase]-phase.sh
   ```

2. **Use Versioned Prompt**
   ```
   Claude Code: Please execute @prompts/[phase]-phase-prompt.md
   ```

3. **Phase Deliverables Created**
   - All documents in `phases/[phase]/`
   - Artifacts tracked in project.json
   - Git commit created

4. **Validate & Proceed**
   ```bash
   ~/path/to/orchestrator/scripts/validate-[phase].sh
   # If valid, proceed to next phase
   ```

## Current Workflow (What Works Now)

### 1. Starting a Project
```bash
cd ~/projects/experiments
~/path/to/orchestrator/scripts/start-workflow.sh
# Enter: project name, complexity, domain
```

### 2. Concept Phase
```bash
cd [project-directory]
# Edit concept-prompt.md with your idea
~/path/to/orchestrator/scripts/concept-phase.sh

# In Claude Code:
# Use @prompts/concept-phase-prompt.md content
```

### 3. Blueprint Phase
```bash
~/path/to/orchestrator/scripts/blueprint-phase.sh

# In Claude Code:
# Use @prompts/blueprint-phase-prompt.md content
```

### 4. Subsequent Phases
Currently manual - this is a gap we're fixing.

## What's Missing (And How We'll Fix It)

### 1. Automated Prompt Management
**Current**: Copy prompts manually
**Future**: `claude-code @execute-phase blueprint`

### 2. Phase Validation
**Current**: Hope it's right
**Future**: Automated checklist validation

### 3. Progress Tracking
**Current**: Broken status script
**Future**: Real-time progress dashboard

### 4. Smooth Transitions
**Current**: Manual JSON editing
**Future**: One command to transition phases

## Tips for Using the Framework Now

### 1. Create a Project Checklist
```markdown
- [ ] Run start-workflow.sh
- [ ] Create concept-prompt.md
- [ ] Run concept-phase.sh
- [ ] Copy concept prompt to Claude Code
- [ ] Save all outputs
- [ ] Run blueprint-phase.sh
- [ ] Copy blueprint prompt to Claude Code
- [ ] Continue...
```

### 2. Use Git Branches per Phase
```bash
git checkout -b concept
# Do concept work
git commit -am "Complete concept phase"
git checkout -b blueprint
# Continue...
```

### 3. Track Your Own Metrics
- Time per phase
- Number of iterations
- Quality of outputs
- What worked/didn't work

### 4. Document Everything
- Save Claude Code conversations
- Note prompt modifications
- Track what caused issues
- Share learnings

## The Path Forward

We're building this together. Each project using the framework:
1. Reveals gaps (like you've found)
2. Suggests improvements
3. Validates what works
4. Shapes the roadmap

Your frustrations are valid and valuable - they're shaping v1.1.0.

## Quick Reference Card

```bash
# Start project
./start-workflow.sh

# Begin phase
./scripts/[phase]-phase.sh

# In Claude Code
@prompts/[phase]-phase-prompt.md

# Check status
./scripts/status.sh

# Validate phase (coming soon)
./scripts/validate-[phase].sh

# Next phase
./scripts/[next-phase]-phase.sh
```

---

*This guide acknowledges current limitations while showing the path forward.*