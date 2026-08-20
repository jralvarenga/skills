#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/.." && pwd)"
agents_skills_dir="$repo_dir/.agents/skills"
design_skills_dir="$repo_dir/skills/design"

frontend_design_source="$agents_skills_dir/frontend-design"
frontend_design_destination="$design_skills_dir/frontend-design"

ui_ux_pro_max_source="$agents_skills_dir/ui-ux-pro-max"
ui_ux_pro_max_destination="$design_skills_dir/ui-ux-pro-max"

validate_skill() {
  local skill_name="$1"
  local source="$2"

  if [ ! -f "$source/SKILL.md" ]; then
    echo "Cannot update $skill_name: $source/SKILL.md was not found" >&2
    exit 1
  fi
}

copy_skill() {
  local skill_name="$1"
  local source="$2"
  local destination="$3"

  mkdir -p "$destination"
  rsync -a --delete "$source/" "$destination/"
  echo "Copied $skill_name"
  echo "  From: $source"
  echo "  To:   $destination"
}

if ! command -v rsync >/dev/null 2>&1; then
  echo "Cannot update design skills: rsync is required" >&2
  exit 1
fi

validate_skill "frontend-design" "$frontend_design_source"
validate_skill "ui-ux-pro-max" "$ui_ux_pro_max_source"

echo "--- frontend-design ---"
copy_skill "frontend-design" "$frontend_design_source" "$frontend_design_destination"

echo
echo "--- ui-ux-pro-max ---"
copy_skill "ui-ux-pro-max" "$ui_ux_pro_max_source" "$ui_ux_pro_max_destination"
