#!/usr/bin/env python3
"""
list_skills_by_agent.py
Print a table of skill → agent mapping by reading agents/*/AGENT.md frontmatter.
Also reports any skills in scientific-skills/ not mapped to any agent (orphans).

Usage:
    python scripts/list_skills_by_agent.py
    python scripts/list_skills_by_agent.py --orphans-only
"""

import argparse
import re
import sys
from pathlib import Path
from collections import defaultdict

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML not installed. Run: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

REPO_ROOT = Path(__file__).parent.parent
AGENTS_DIR = REPO_ROOT / "agents"
SKILLS_DIR = REPO_ROOT / "scientific-skills"


def extract_frontmatter(content: str) -> dict:
    match = re.match(r"^---\s*\n(.*?)\n---\s*\n", content, re.DOTALL)
    if match:
        data = yaml.safe_load(match.group(1))
        return data if isinstance(data, dict) else {}
    return {}


def load_agent_mappings() -> dict[str, list[str]]:
    """Returns {skill_name: [agent_names]} mapping."""
    skill_to_agents: dict[str, list[str]] = defaultdict(list)

    if not AGENTS_DIR.exists():
        print(f"WARNING: agents/ directory not found at {AGENTS_DIR}", file=sys.stderr)
        return skill_to_agents

    for agent_dir in sorted(AGENTS_DIR.iterdir()):
        if not agent_dir.is_dir():
            continue
        agent_md = agent_dir / "AGENT.md"
        if not agent_md.exists():
            continue

        data = extract_frontmatter(agent_md.read_text(encoding="utf-8"))
        agent_name = data.get("name", agent_dir.name)

        for skill in data.get("primary-skills", []):
            skill_to_agents[str(skill)].append(f"{agent_name} (primary)")
        for skill in data.get("secondary-skills", []):
            skill_to_agents[str(skill)].append(f"{agent_name} (secondary)")

    return skill_to_agents


def get_all_skills() -> list[str]:
    if not SKILLS_DIR.exists():
        return []
    return sorted(p.name for p in SKILLS_DIR.iterdir() if p.is_dir())


def main() -> None:
    parser = argparse.ArgumentParser(description="Show skill-to-agent mapping.")
    parser.add_argument("--orphans-only", action="store_true", help="Only show unmapped skills")
    args = parser.parse_args()

    skill_to_agents = load_agent_mappings()
    all_skills = get_all_skills()

    if not all_skills:
        print("No skills found in scientific-skills/")
        sys.exit(0)

    orphans = [s for s in all_skills if s not in skill_to_agents]
    mapped = [s for s in all_skills if s in skill_to_agents]

    if not args.orphans_only:
        # Print full mapping table
        col_w = max(len(s) for s in all_skills) + 2
        header = f"{'Skill':<{col_w}}  Agents"
        print(header)
        print("-" * (col_w + 40))
        for skill in all_skills:
            agents_str = ", ".join(skill_to_agents.get(skill, ["(unmapped)"]))
            print(f"{skill:<{col_w}}  {agents_str}")

        print(f"\nTotal: {len(all_skills)} skills, {len(mapped)} mapped, {len(orphans)} orphans")

    if orphans:
        print(f"\nOrphaned skills (not mapped to any agent):")
        for s in orphans:
            print(f"  - {s}")
    elif not args.orphans_only:
        print("\nAll skills are mapped to at least one agent.")


if __name__ == "__main__":
    main()
