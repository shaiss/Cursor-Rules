# PR Gaming Detection Guide

## 🎯 **Executive Summary**

This guide provides a systematic approach to detect **PR gaming** - where developers artificially inflate their contribution metrics by splitting work across multiple PRs, duplicating commits, or creating overlapping changes to exploit point-based development tooling.

## 🚨 **What Is PR Gaming?**

PR gaming occurs when developers manipulate the PR system to increase their apparent productivity:

1. **Commit Duplication**: Same commits appearing in multiple PRs
2. **Artificial PR Splitting**: Breaking one logical feature into multiple PRs unnecessarily
3. **File Overlap Gaming**: Multiple PRs modifying the same files without coordination
4. **Rapid Fire PRs**: Submitting multiple PRs within short timeframes to inflate metrics

## 🔍 **Detection Methodology**

### **Primary Tools**

1. **`simple_pr_analyzer.sh`** - Automated detection script
2. **Manual git analysis** - Deep dive verification
3. **GitHub MCP cross-reference** - External validation

### **Key Indicators**

| Risk Level | Indicators |
|------------|------------|
| 🔴 **CRITICAL** | Duplicate commits across PRs, >80% file overlap |
| 🟡 **WARNING** | Multiple PRs <1 hour apart, 50-80% file overlap |
| 🟢 **NORMAL** | Sequential PRs with logical boundaries, <20% overlap |

## 📊 **Using the PR Analyzer**

### **Basic Usage**
```bash
./simple_pr_analyzer.sh <start_pr> <end_pr>

# Examples:
./simple_pr_analyzer.sh 229 231  # Analyze PRs 229-231
./simple_pr_analyzer.sh 244 250  # Analyze PRs 244-250
```

### **Interpreting Results**

#### **Risk Score Calculation**
- **Duplicate commits**: +70 points
- **File overlap**: +50 points  
- **Rapid submissions**: +25 points per incident
- **Total**: 0-100+ scale

#### **Risk Levels**
```
🔴 80-100+: HIGH RISK
   Action: Immediate investigation required
   
🟡 50-79:   MEDIUM RISK  
   Action: Review process with team lead
   
🟠 25-49:   LOW-MEDIUM RISK
   Action: Monitor future patterns
   
🟢 0-24:    LOW RISK
   Action: Normal development patterns
```

## 🚨 **Real Example Analysis**

### **Case Study: PRs 229-231**

**Results from our analyzer:**
```
File overlap detected:
- finowl-backend/cmd/app/api.go (PRs 229, 231)
- finowl-backend/cmd/app/handlers_generic_discovery.go (PRs 229, 230)
- finowl-backend/cmd/app/queries_test.go (PRs 229, 230)
- finowl-backend/cmd/app/queries.go (PRs 229, 230)

Timing:
- PR #229: 2025-05-29 20:49:36
- PR #230: 2025-05-29 23:39:31 (2h 50m later)
- PR #231: 2025-05-30 03:28:03 (3h 49m later)

Risk Score: 100/100 - HIGH RISK
```

**Analysis:**
- ✅ **No duplicate commits** (good sign)
- 🔴 **Significant file overlap** (concerning)
- 🔴 **Rapid submission pattern** (suspicious)

**Conclusion:** Likely artificial PR splitting - one feature split across 3 PRs

## 🔧 **Manual Verification Commands**

### **Deep Dive Analysis**
```bash
# 1. Check actual commit overlap
git log --grep="Merge pull request #229" --oneline -1
git log --grep="Merge pull request #230" --oneline -1

# 2. Compare file changes between PRs  
git diff --name-only <base>..<pr229_head>
git diff --name-only <base>..<pr230_head>

# 3. Check timing patterns
git log --grep="Merge pull request" --pretty=format:"%ad %s" --date=format:"%m/%d %H:%M" -10

# 4. Verify commit authenticity
git show --stat <commit_hash>
```

### **Cross-Reference with GitHub**
```bash
# Using GitHub CLI (if available)
gh pr list --state merged --limit 20 --json number,title,additions,deletions

# Using GitHub MCP server
# Check: mcp_github_get_pull_request for each PR
# Verify: Line counts and file changes match git analysis
```

## 📋 **Management Action Framework**

### **HIGH RISK (80+ Score)**

**Immediate Actions:**
1. **Meet with developer** within 24 hours
2. **Review all recent PRs** from same author
3. **Implement stricter review process**
4. **Document findings** for performance review

**Questions to Ask:**
- Why were these changes split across multiple PRs?
- What was the business justification for the separation?
- Were these coordinated as part of a larger feature?

### **MEDIUM RISK (50-79 Score)**

**Follow-up Actions:**
1. **Schedule team discussion** about PR practices
2. **Review tooling incentives** that may encourage gaming
3. **Establish clearer PR guidelines**
4. **Monitor future submissions** closely

### **Process Improvements**

**Preventive Measures:**
1. **PR Size Guidelines**: Max 500-1000 lines without justification
2. **Review Requirements**: Mandatory review for PRs >200 lines
3. **Timing Rules**: Minimum 2-hour gap between substantial PRs
4. **Overlap Detection**: Weekly automated scans

## ⚖️ **Ethical Considerations**

### **Dos and Don'ts**

✅ **DO:**
- Focus on patterns, not individuals
- Verify findings thoroughly
- Consider legitimate explanations
- Protect team morale during investigation

❌ **DON'T:**
- Make accusations without evidence
- Punish intensive legitimate work periods
- Create hostile work environment
- Rely solely on automated tools

### **Fair Assessment**

Remember: **Bad process ≠ Malicious intent**

Some legitimate reasons for overlapping PRs:
- Emergency hotfixes
- Iterative feature development  
- Coordinated team efforts
- Rapid prototyping phases

## 🚀 **Implementation Plan**

### **Week 1: Setup**
1. Deploy detection scripts
2. Train team leads on usage
3. Establish baseline metrics

### **Week 2-4: Monitoring**
1. Run weekly scans on recent PRs
2. Document patterns and trends
3. Identify problem areas

### **Month 2+: Process Improvement**
1. Implement preventive measures
2. Adjust tooling incentives
3. Regular team education

## 📈 **Success Metrics**

**Positive Indicators:**
- Reduced file overlap between PRs
- More logical PR boundaries
- Improved commit message quality
- Balanced contribution metrics

**Warning Signs:**
- Sudden changes in PR patterns after detection
- Gaming shifting to other metrics (commits, issues)
- Team resistance to transparency

## 🔧 **Tool Maintenance**

### **Regular Updates**
- Test scripts on new git versions
- Adjust risk scoring based on findings
- Add new detection patterns as needed

### **Calibration**
- Review false positives/negatives monthly
- Adjust thresholds based on team size and velocity
- Update detection logic for new gaming patterns

---

## 📞 **Emergency Response**

If you detect **HIGH RISK** gaming patterns:

1. **Document everything** - Save analyzer output
2. **Verify manually** - Don't rely solely on automation  
3. **Act quickly** - Address within 24-48 hours
4. **Be fair** - Consider all explanations
5. **Focus on process** - Fix systems, not just individuals

**Remember:** The goal is improving development practices, not punishing the team. 