#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/.." && pwd)"
skills_dir="$repo_dir/skills"
install_home="${AGENT_SKILLS_HOME:-$HOME}"
target_dirs=("$install_home/.agents/skills" "$install_home/.claude/skills")

if [ ! -d "$skills_dir" ]; then
  echo "Skills directory not found: $skills_dir" >&2
  exit 1
fi

for target_dir in "${target_dirs[@]}"; do
  mkdir -p "$target_dir"

  # Remove stale links created by this repository after skills are renamed or removed.
  for target in "$target_dir"/*; do
    if [ -L "$target" ] && [ ! -e "$target" ]; then
      current_target="$(readlink "$target")"
      case "$current_target" in
        "$skills_dir/"*)
          rm -- "$target"
          echo "Removed stale link $target"
          ;;
      esac
    fi
  done

  while IFS= read -r skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    target="$target_dir/$skill_name"

    if [ -L "$target" ]; then
      current_target="$(readlink "$target")"

      if [ "$current_target" != "$skill_dir" ]; then
        echo "Cannot link $skill_name: $target points to another skill" >&2
        exit 1
      fi

      ln -sfn "$skill_dir" "$target"
    elif [ -e "$target" ]; then
      echo "Cannot link $skill_name: $target already exists and is not a symlink" >&2
      exit 1
    else
      ln -s "$skill_dir" "$target"
    fi

    echo "Linked $target"
  done < <(find "$skills_dir" -type f -name SKILL.md -print | sort)
done
