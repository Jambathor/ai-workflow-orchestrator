# Changelog - AI Workflow Orchestrator

All notable changes to the AI Workflow Orchestrator framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Blueprint phase script (`scripts/blueprint-phase.sh`) for standardized phase transitions
- Phase-specific instruction templates (CONCEPT_PHASE_INSTRUCTIONS.md, BLUEPRINT_PHASE_INSTRUCTIONS.md)
- Learnings documentation from real-world testing (`learnings/` directory)
- CHANGELOG.md for tracking framework evolution
- Versioned prompts directory for Claude Code prompts
- ROADMAP.md with development priorities
- Phase workflow guide acknowledging current limitations
- Human-in-the-loop requirements to roadmap

### Changed
- Improved phase boundary enforcement with explicit DO/DO NOT instructions
- Enhanced project.json structure to track phase artifacts
- Updated status script to better reflect actual progress

### Fixed
- Phase bleeding issue where AI would skip ahead to implementation
- Project status tracking showing 0% despite completed phases
- Git branch initialization errors in start-workflow.sh

### Learned
- Phase-specific instruction files are essential for preventing scope creep
- AI agents need explicit constraints to respect phase boundaries
- Clear deliverable checklists keep projects focused
- Phase validation scripts improve workflow adherence

## [1.0.0] - 2024-07-25

### Initial Release
- 6-phase structured development methodology
- Research-backed templates for each phase
- Multi-agent coordination patterns with Claude Flow
- Interactive setup and status scripts
- Comprehensive getting started guide
- Based on 100+ research sources showing 45-60% productivity improvements

### Phase Structure
1. **Concept Phase** - Idea exploration and validation
2. **Blueprint Phase** - High-level solution design
3. **PRD Phase** - Detailed requirements specification
4. **Architecture Phase** - Technical design and planning
5. **Testing Phase** - Quality assurance strategy
6. **Implementation Phase** - AI-assisted development

### Known Issues
- Only concept-phase.sh script included
- Phase boundaries not strongly enforced
- Setup script has input handling issues
- No automated phase transition scripts