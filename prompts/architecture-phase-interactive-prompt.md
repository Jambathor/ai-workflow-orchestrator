# Architecture Phase Interactive Prompt

## Version: 1.0.0
## Last Updated: 2024-07-27
## Status: New - Interactive Technical Architecture Design

## Prompt

```
Please follow @ARCHITECTURE_PHASE_INTERACTIVE_INSTRUCTIONS.md to complete the ARCHITECTURE PHASE.

IMPORTANT: This is an INTERACTIVE process. You must:
1. Present technology options with clear trade-offs
2. Wait for my decision on each component
3. Document rationale for every choice
4. Complete one section at a time
5. Update architecture-decisions.md after EACH decision

Use the completed PRD from @phases/prd/prd-summary.md as your requirements baseline.

Key constraints from PRD to remember:
- $0/month budget using free tiers
- Open source technologies preferred  
- Security and customization are top priorities
- <2s page load performance target
- Single admin user (no multi-user auth needed)

Start by summarizing your understanding of the project requirements.
```

## Usage Notes
- Used after running architecture-phase.sh script
- Requires completed PRD phase artifacts
- INTERACTIVE - AI must wait for human decisions
- Output: 9 architecture documents with full rationale

## Key Interaction Points
1. Requirements confirmation
2. Frontend framework selection
3. Backend technology choice
4. Database selection
5. Hosting platform decision
6. Security approach approval
7. Performance strategy validation
8. Final architecture review

## Expected Behavior
- AI presents 2-3 options for each decision
- Pros and cons clearly explained
- Human makes all technology choices
- Every decision logged with rationale
- Regular checkpoints for feedback

## Architecture Decision Record (ADR) Format
```
### ADR-XXX: [Decision Title]
- **Status**: Accepted
- **Context**: [What prompted this decision]
- **Decision**: [What was decided]
- **Alternatives**: [What else was considered]
- **Consequences**: [What happens as a result]
- **Timestamp**: [When decided]
```

## Changelog
- v1.0.0 (2024-07-27): Initial interactive version based on PRD phase success