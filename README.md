# Main Cursor Rules Repository

This repository serves as a centralized location for storing and managing Cursor rules (`.mdc` files) and their documentation (`.md` files). The structure mirrors the `.cursor/rules` hierarchy to make it easy for users to copy rules directly into their Cursor projects.

## Repository Structure

Each rule type folder follows the same structure:
```
type/
├── rule-name/
│   ├── rule-name.mdc    # The actual rule file
│   └── README.md        # Documentation for the rule
```

## Naming Conventions

### Rule Files
- Use kebab-case for rule names (e.g., `auto-format.mdc`)
- Rule files should be named descriptively of their function
- Each rule should be in its own folder matching the rule name

### Documentation
- Each rule folder must contain a `README.md`
- Documentation should include:
  - Rule purpose and functionality
  - Usage instructions
  - Examples
  - Any dependencies or prerequisites

## File Types
- `.mdc` - Cursor rule files
- `.md` - Documentation files
- `.gitignore` - Git ignore configuration

## Contributing

When adding new rules:

1. Create a new folder for your rule:
   ```bash
   mkdir rules/type/your-rule-name
   ```

2. Add your files:
   - Create `your-rule-name.mdc` with the rule content
   - Create `README.md` with documentation

3. Follow the naming conventions:
   - Use kebab-case for all file and folder names
   - Keep names descriptive and concise

4. Ensure your rule follows the `.cursor/rules` hierarchy structure for easy integration

## Integration

To use these rules in your Cursor project:
1. Copy the desired rule folder to your project's `.cursor/rules/` directory
2. The rule will be automatically loaded by Cursor
3. Follow the rule's README.md for specific configuration instructions
