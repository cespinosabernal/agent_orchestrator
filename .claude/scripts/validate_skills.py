#!/usr/bin/env python3
"""
validate_skills.py
Parse all SKILL.md files in scientific-skills/ and verify their YAML frontmatter.
Checks that each skill has required fields: name, description.

Usage:
    python scripts/validate_skills.py              # validate all skills
    python scripts/validate_skills.py --verbose    # show pass for each skill too

Exit code 0 if all pass, 1 if any fail.
"""

import argparse
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML not installed. Run: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

REQUIRED_FIELDS = ["name", "description"]
REPO_ROOT = Path(__file__).parent.parent
SKILLS_DIR = REPO_ROOT / "scientific-skills"


def extract_frontmatter(content: str) -> tuple[str | None, str]:
    """Extract YAML frontmatter between --- delimiters. Returns (yaml_str, rest)."""
    match = re.match(r"^---\s*\n(.*?)\n---\s*\n", content, re.DOTALL)
    if match:
        return match.group(1), content[match.end():]
    return None, content


def validate_skill(skill_dir: Path, verbose: bool) -> bool:
    skill_md = skill_dir / "SKILL.md"
    name = skill_dir.name

    if not skill_md.exists():
        print(f"FAIL [{name}]: SKILL.md not found")
        return False

    content = skill_md.read_text(encoding="utf-8")
    frontmatter_str, _ = extract_frontmatter(content)

    if frontmatter_str is None:
        print(f"FAIL [{name}]: No YAML frontmatter found (missing --- delimiters)")
        return False

    try:
        data = yaml.safe_load(frontmatter_str)
    except yaml.YAMLError as e:
        print(f"FAIL [{name}]: Invalid YAML — {e}")
        return False

    if not isinstance(data, dict):
        print(f"FAIL [{name}]: Frontmatter is not a YAML mapping")
        return False

    missing = [f for f in REQUIRED_FIELDS if not data.get(f)]
    if missing:
        print(f"FAIL [{name}]: Missing required fields: {', '.join(missing)}")
        return False

    if verbose:
        print(f"PASS [{name}]")
    return True


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate SKILL.md frontmatter for all skills.")
    parser.add_argument("--verbose", "-v", action="store_true", help="Print PASS for each skill")
    args = parser.parse_args()

    if not SKILLS_DIR.exists():
        print(f"ERROR: scientific-skills/ directory not found at {SKILLS_DIR}", file=sys.stderr)
        sys.exit(1)

    # Skills are now nested: scientific-skills/<group>/<skill>
    skill_dirs = sorted(p for p in SKILLS_DIR.rglob("*") if p.is_dir() and p.parent != SKILLS_DIR)
    if not skill_dirs:
        print("ERROR: No skill directories found", file=sys.stderr)
        sys.exit(1)

    passed = 0
    failed = 0

    for skill_dir in skill_dirs:
        if validate_skill(skill_dir, args.verbose):
            passed += 1
        else:
            failed += 1

    total = passed + failed
    print(f"\nResult: {passed}/{total} passed, {failed} failed")

    if failed > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
