# Concept Phase Prompt

## Version: 1.0.0
## Last Updated: 2024-07-25
## Status: Validated ✅

## Prompt

```
Please follow @CONCEPT_PHASE_INSTRUCTIONS.md to complete the CONCEPT PHASE ONLY.

Following the concept-template.md in the phases/concept/ folder:
1. Initialize a concept exploration swarm
2. Use AI agents to explore and validate the idea
3. Conduct market research
4. Analyze feasibility
5. Map stakeholders
6. Define success criteria
7. Create a refined concept document

Do NOT move to implementation or other phases yet. Focus only on concept exploration and validation.
```

## Usage Notes
- Used after running concept-phase.sh script
- Requires CONCEPT_PHASE_INSTRUCTIONS.md to be present
- Input: @concept-prompt.md with initial idea
- Output: 6 concept phase documents

## Changelog
- v1.0.0 (2024-07-25): Initial validated version that successfully prevented scope creep