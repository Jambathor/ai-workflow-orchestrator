# Concept Phase - Clarification Questions Template

## Purpose
These questions should be asked at the START of the concept phase to prevent fundamental misunderstandings that cascade through all phases.

## Core Clarification Questions

### 1. Project Ownership Model
**Question**: Is this project:
- [ ] A personal project for your own use
- [ ] A product/service for other users
- [ ] An internal tool for a specific organization
- [ ] An open-source tool for the community

### 2. User Model
**Question**: Who will use this?
- [ ] Just me (single user)
- [ ] Me + invited collaborators
- [ ] Anyone who signs up (public service)
- [ ] Specific user group (describe: ____________)

### 3. Access Control
**Question**: How will people access this?
- [ ] No login needed (public content)
- [ ] Single admin login (just me)
- [ ] User registration and accounts
- [ ] SSO/Enterprise authentication
- [ ] Other: ____________

### 4. Data Ownership
**Question**: Whose data will this handle?
- [ ] Only my own data
- [ ] Data from multiple users (each owns their data)
- [ ] Aggregated public data
- [ ] Company/organization data

### 5. Deployment Model
**Question**: Where will this live?
- [ ] My personal server/hosting
- [ ] Public SaaS deployment
- [ ] On-premise for organizations
- [ ] Distributed (users run their own)

## Example Clarifications

### Personal Portfolio Website
- Project Type: Personal project for my own use
- Users: Public visitors (read-only) + me (admin)
- Access: Public viewing, single admin dashboard
- Data: My own projects and content
- Deployment: My personal hosting

### Multi-tenant SaaS
- Project Type: Product for other users
- Users: Anyone who signs up
- Access: User registration with accounts
- Data: Each user owns their data
- Deployment: Public cloud service

### Open Source Developer Tool
- Project Type: Tool for the community
- Users: Individual developers
- Access: No login (runs locally)
- Data: User's local data only
- Deployment: Users install locally

## Usage Instructions

1. Ask these questions BEFORE writing any concept documents
2. Document answers in `concept-validation.md`
3. Reference these answers in all subsequent phases
4. If unclear, default to asking for clarification
5. Don't assume - explicit is better than implicit

## Red Flags to Watch For

- Using "users" without clarifying who they are
- Assuming multi-tenancy when it's personal use
- Adding authentication when none is needed
- Building features for scale when it's single-user
- Creating user management for personal projects

## Template for Concept Validation

```markdown
# Concept Validation - [Project Name]

## Project Classification
- **Type**: [Personal/Product/Tool/Internal]
- **Primary User**: [Me/Public/Specific Group]
- **Access Model**: [Public/Single Admin/Multi-user]
- **Data Scope**: [Personal/Multi-tenant/Public]
- **Deployment**: [Personal/SaaS/On-premise/Local]

## Confirmed Understanding
[Write 2-3 sentences confirming the project scope]

## What This Is NOT
[Explicitly list what this project is NOT to prevent scope creep]
```

---

*Add this template to the concept phase process to prevent cascading misunderstandings through all phases.*