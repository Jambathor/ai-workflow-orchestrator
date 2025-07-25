# PRD Phase Interactive Prompt

## Version: 1.0.0
## Last Updated: 2024-07-25
## Status: New - Testing Interactive Approach

## Prompt

```
Please follow @PRD_PHASE_INTERACTIVE_INSTRUCTIONS.md to complete the PRD PHASE.

IMPORTANT: This is an INTERACTIVE process. You must:
1. Present options and wait for my choices
2. Complete one section at a time
3. Ask for my approval before proceeding
4. Revise based on my feedback

Use the validated blueprint from @phases/blueprint/blueprint-summary.md as your input.

Start by presenting feature options for me to prioritize for the MVP.
```

## Usage Notes
- Used after running prd-phase.sh script
- Requires completed blueprint phase artifacts
- INTERACTIVE - AI must wait for human input
- Output: 6 PRD documents based on human choices

## Key Interaction Points
1. Feature selection (human chooses 5 from 10)
2. Section approvals (after each requirements section)
3. API design choice (REST vs GraphQL vs Hybrid)
4. User flow validation
5. Technical constraints discussion
6. Final approval before completion

## Expected Behavior
- AI presents options, not solutions
- Human makes all key decisions
- AI implements based on choices
- Regular checkpoints for feedback

## Changelog
- v1.0.0 (2024-07-25): Initial interactive version based on human-in-the-loop feedback