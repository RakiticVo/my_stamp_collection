import json
import subprocess
import re
import os
import sys

PUBSPEC_PATH = "pubspec.yaml"

def run_cmd(cmd):
    result = subprocess.run(cmd, capture_output=True, text=True, shell=True)
    if result.returncode != 0:
        print(f"Error running command: {cmd}")
        print(result.stderr)
        return None
    return result.stdout

def get_outdated_data():
    output = run_cmd("flutter pub outdated --json")
    if not output:
        return None
    try:
        data = json.loads(output)
        return data.get('packages', [])
    except json.JSONDecodeError:
        print("Failed to parse JSON output from flutter pub outdated")
        return None

def update_pubspec(packages_to_update):
    if not os.path.exists(PUBSPEC_PATH):
        print(f"File not found: {PUBSPEC_PATH}")
        return
    
    with open(PUBSPEC_PATH, 'r', encoding='utf-8') as f:
        content = f.read()

    updates_made = 0
    for package, new_version in packages_to_update.items():
        # Look for package: ^version or package: version
        pattern = rf'({package}:\s*)[\^]?[\d\.]+[^\s\n]*'
        # Check if version should be ^new_version
        replacement = rf'\1^{new_version}'
        
        new_content, count = re.subn(pattern, replacement, content)
        if count > 0:
            content = new_content
            updates_made += count
            print(f"Updated {package} to ^{new_version}")

    if updates_made > 0:
        with open(PUBSPEC_PATH, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully updated {updates_made} packages in {PUBSPEC_PATH}")
        return True
    else:
        print("No updates applied to pubspec.yaml")
        return False

def main():
    print("Fetching outdated packages...")
    packages = get_outdated_data()
    if not packages:
        return

    packages_to_update = {}
    for pkg in packages:
        kind = pkg.get('kind', '')
        if kind in ['direct', 'dev']:
            name = pkg.get('package')
            current = pkg.get('current', {}).get('version')
            resolvable = pkg.get('resolvable', {}).get('version')
            if resolvable and current != resolvable:
                packages_to_update[name] = resolvable

    if not packages_to_update:
        print("All direct/dev dependencies are already at their latest resolvable versions.")
        return

    print(f"Found {len(packages_to_update)} packages to update.")
    if update_pubspec(packages_to_update):
        print("Running flutter pub get...")
        run_cmd("flutter pub get")
        print("Update complete.")

if __name__ == "__main__":
    main()
