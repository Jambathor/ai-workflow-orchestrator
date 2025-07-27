# Testing Phase Prompt

## Version: 1.0.0
## Last Updated: 2024-07-27
## Status: New - Automated Testing Strategy

## Prompt

```
Please follow @TESTING_PHASE_INSTRUCTIONS.md to complete the TESTING PHASE.

This is an AUTOMATED phase. You should:
1. Analyze the architecture and PRD documents
2. Generate comprehensive test strategies
3. Create all 8 testing documents
4. Focus on zero-cost testing tools

Use these key documents as input:
- @phases/architecture/technology-stack.md
- @phases/architecture/security-architecture.md  
- @phases/prd/feature-specifications.md
- @phases/prd/performance-strategy.md

Remember the constraints:
- $0/month budget (use free/open-source tools)
- Single admin user (affects auth testing)
- <2s page load target (performance testing focus)
- High security requirements (OWASP compliance)

Create practical, implementable test strategies that match the chosen tech stack.

IMPORTANT: When complete, remind the user to run:
complete-phase.py testing
```

## Usage Notes
- Used after running testing-phase.sh script
- Requires completed architecture phase artifacts
- AUTOMATED - Less interactive than PRD/Architecture phases
- Output: 8 testing strategy documents

## Expected Documents
1. `testing-strategy.md` - Overall approach and philosophy
2. `unit-testing.md` - Component and function testing
3. `integration-testing.md` - API and database testing
4. `e2e-testing.md` - User journey testing
5. `performance-testing.md` - Speed and optimization testing
6. `security-testing.md` - Vulnerability testing
7. `test-automation.md` - CI/CD pipeline setup
8. `testing-checklist.md` - Quality gates and procedures

## Testing Tools (Free Tier)
- Unit: Vitest (faster than Jest)
- Integration: Supertest
- E2E: Playwright
- Performance: Lighthouse CI
- Security: OWASP ZAP
- Coverage: Native Vitest coverage

## Changelog
- v1.0.0 (2024-07-27): Initial automated version for testing phase