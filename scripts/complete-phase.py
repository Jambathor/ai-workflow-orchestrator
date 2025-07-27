#!/usr/bin/env python3
"""
Helper script to properly complete a phase in the AI Workflow Orchestrator.
Updates project.json with correct status, timestamp, and artifacts.
"""

import json
import sys
import os
from datetime import datetime
from pathlib import Path


def complete_phase(phase_name, project_dir='.'):
    """Mark a phase as completed with proper artifacts"""
    
    project_json_path = Path(project_dir) / 'project.json'
    
    # Check if project.json exists
    if not project_json_path.exists():
        print(f"❌ No project.json found in {project_dir}")
        return False
    
    # Read project.json
    with open(project_json_path, 'r') as f:
        data = json.load(f)
    
    # Check if phase exists
    if phase_name not in data['phases']:
        print(f"❌ Unknown phase: {phase_name}")
        print(f"   Valid phases: {', '.join(data['phases'].keys())}")
        return False
    
    # Check if already completed
    if data['phases'][phase_name]['status'] == 'completed':
        print(f"⚠️  {phase_name} phase is already completed")
        return True
    
    # Find artifacts
    phase_dir = Path(project_dir) / 'phases' / phase_name
    artifacts = []
    
    if phase_dir.exists():
        # Find all markdown files (excluding templates)
        artifacts.extend([
            f.name for f in phase_dir.glob('*.md') 
            if not f.name.endswith('-template.md') and not f.name.endswith('_INSTRUCTIONS.md')
        ])
        # Find all YAML files
        artifacts.extend([f.name for f in phase_dir.glob('*.yaml')])
        # Find all JSON files (excluding package.json)
        artifacts.extend([
            f.name for f in phase_dir.glob('*.json')
            if f.name != 'package.json'
        ])
    
    # Update status
    data['phases'][phase_name]['status'] = 'completed'
    data['phases'][phase_name]['completed'] = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    data['phases'][phase_name]['artifacts'] = sorted(set(artifacts))
    
    # Update current_phase to next phase
    phase_order = ['concept', 'blueprint', 'prd', 'architecture', 'testing', 'implementation']
    current_index = phase_order.index(phase_name)
    if current_index < len(phase_order) - 1:
        data['current_phase'] = phase_order[current_index + 1]
    
    # Save updated project.json
    with open(project_json_path, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"✅ {phase_name} phase marked as completed")
    print(f"   Status: completed")
    print(f"   Completed: {data['phases'][phase_name]['completed']}")
    print(f"   Artifacts: {len(artifacts)} files")
    if artifacts:
        for artifact in sorted(artifacts):
            print(f"     - {artifact}")
    print(f"   Next phase: {data.get('current_phase', 'All phases complete!')}")
    
    return True


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: complete-phase.py <phase_name> [project_dir]")
        print("")
        print("Examples:")
        print("  complete-phase.py prd")
        print("  complete-phase.py architecture /path/to/project")
        print("")
        print("Valid phases: concept, blueprint, prd, architecture, testing, implementation")
        sys.exit(1)
    
    phase_name = sys.argv[1]
    project_dir = sys.argv[2] if len(sys.argv) > 2 else '.'
    
    # Change to project directory
    if project_dir != '.':
        original_dir = os.getcwd()
        try:
            os.chdir(project_dir)
            success = complete_phase(phase_name, '.')
            os.chdir(original_dir)
        except Exception as e:
            print(f"❌ Error: {e}")
            if 'original_dir' in locals():
                os.chdir(original_dir)
            sys.exit(1)
    else:
        success = complete_phase(phase_name)
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()