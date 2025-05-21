# Main Cursor Rules Repository

This repository serves as a centralized location for storing and managing Cursor rules (`.mdc` files) and their documentation (`.md` files). The structure mirrors the `.cursor/rules` hierarchy to make it easy for users to copy rules directly into their Cursor projects.

## Repository Structure

Each rule-set folder follows the same structure:
```
rule-set-name/
├── *.mdc    # The rule files (written in plain English)
└── README.md        # Documentation for the rule-set
```

## Naming Conventions

### Rule-Set Folders
- Use kebab-case for rule-set names (e.g., `workshop-writer`)
- Folder names should be descriptive of the rule-set's purpose
- Each rule-set should be in its own folder

### Documentation
- Each rule-set folder must contain a `README.md`
- Documentation should include:
  - Rule-set purpose and functionality
  - Usage instructions
  - Examples
  - Any dependencies or prerequisites

## File Types
- `.mdc` - Cursor rule files (written in plain English)
- `.md` - Documentation files
- `.gitignore` - Git ignore configuration

## Contributing

When adding new rule-sets:

1. Create a new folder for your rule-set:
   ```bash
   mkdir your-rule-set-name
   ```

2. Add your files:
   - Add your `.mdc` rule files (written in plain English)
   - Create `README.md` with documentation for the rule-set

3. Follow the naming conventions:
   - Use kebab-case for folder names
   - Keep names descriptive and concise

4. Ensure your rule-set follows the `.cursor/rules` hierarchy structure for easy integration

## Integration

To use these rules in your Cursor project:
1. Copy the desired rule-set folder to your project's `.cursor/rules/` directory
2. The rules will be automatically loaded by Cursor
3. Follow the rule-set's README.md for specific configuration instructions
