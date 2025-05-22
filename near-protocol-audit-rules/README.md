# NEAR Protocol Auditing Rule-Set

This rule-set provides a comprehensive framework for auditing NEAR Protocol smart contracts and integrations. The rules work together to ensure thorough, consistent, and effective security reviews.

## Overview

The NPR-auditing rule-set consists of several rules that guide different aspects of the auditing process:

1. **NEAR Protocol Audit** (`near-protocol-audit.mdc`)
   - Core auditing principles and methodology
   - Security best practices
   - Common vulnerability patterns
   - Audit scope definition

2. **NEAR Audit Search Patterns** (`near-audit-search-patterns.mdc`)
   - Common security patterns to search for
   - Vulnerability detection techniques
   - Code analysis strategies
   - Pattern matching guidelines

3. **NEAR Audit Scoring** (`near-audit-scoring.mdc`)
   - Risk assessment methodology
   - Severity classification
   - Impact evaluation
   - Scoring guidelines

4. **NEAR Integration Verification** (`near-integration-verification.mdc`)
   - Integration security checks
   - Cross-contract interaction analysis
   - External dependency review
   - Integration testing guidelines

5. **NEAR Audit Verification Checklist** (`near-audit-verification-checklist.mdc`)
   - Comprehensive audit checklist
   - Verification procedures
   - Quality assurance steps
   - Final review guidelines

6. **Blockchain Files** (`blockchain-files.mdc`)
   - Blockchain-specific file analysis
   - Storage pattern review
   - State management verification
   - File security guidelines

## Usage

To use this rule-set:

1. Copy the entire `.cursor/rules` directory to your project
2. The rules will automatically guide your auditing process
3. Each rule focuses on a specific aspect of the audit
4. Rules work together to ensure comprehensive coverage

## Best Practices

1. **Start with Protocol Audit**
   - Begin with the core audit principles
   - Use the protocol audit rule to establish scope
   - Define audit objectives

2. **Follow Search Patterns**
   - Use the search patterns for systematic review
   - Apply pattern matching consistently
   - Document findings thoroughly

3. **Score Findings**
   - Use the scoring system for risk assessment
   - Maintain consistent severity classification
   - Document impact clearly

4. **Verify Integrations**
   - Review all integration points
   - Check cross-contract interactions
   - Verify external dependencies

5. **Complete Checklist**
   - Follow the verification checklist
   - Ensure all items are addressed
   - Document verification steps

## Dependencies

- Cursor IDE
- NEAR Protocol knowledge
- Security auditing experience
- Code analysis tools

## Examples

The rules in this set work together to create audits that:
- Follow systematic review processes
- Maintain consistent security standards
- Provide clear risk assessments
- Document findings thoroughly
- Ensure comprehensive coverage 