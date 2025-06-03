#!/bin/bash

# LLM Data Formatter
# Purpose: Format analyzer output for optimal LLM consumption
# Usage: Called by cursor rules after data collection to format for LLM

echo "🤖 LLM DATA FORMATTER - Optimizing data for LLM analysis"
echo ""

# Usage
if [ $# -lt 1 ]; then
    cat << EOF
Usage: $0 <analyzer_output_file> [format_type]

PURPOSE: 
Takes raw analyzer output and formats it for optimal LLM consumption.
Called by cursor rules after script_logged collects data.

FORMAT TYPES:
  quick       - Fast summary for immediate LLM decisions
  detailed    - Comprehensive formatting with all context
  risk-focus  - Risk-focused summary for decision making
  json        - JSON structure for programmatic LLM use

EXAMPLES:
  $0 evidence/script_outputs/simple_pr_analyzer.log quick
  $0 evidence/script_outputs/enhanced_pr_analyzer.log detailed
  $0 evidence/script_outputs/enhanced_pr_analyzer.log risk-focus

INPUT: Raw analyzer output from cursor rules' script_logged execution
OUTPUT: LLM-optimized structured data with analysis guidance

EOF
    exit 1
fi

input_file="$1"
format_type="${2:-detailed}"

if [ ! -f "$input_file" ]; then
    echo "❌ Input file not found: $input_file"
    exit 1
fi

# Extract key data from analyzer output
echo "📊 EXTRACTING DATA FROM ANALYZER OUTPUT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract basic metrics
pr_range=$(grep "Analyzing PR range:" "$input_file" | head -1 | sed 's/.*Analyzing PR range: //' | sed 's/🔍//' | tr -d ' ')
prs_found=$(grep "Found.*PRs" "$input_file" | head -1 | sed 's/.*Found \([0-9]\+\) PRs.*/\1/' || echo "Unknown")
risk_score=$(grep "Risk Score:" "$input_file" | head -1 | sed 's/.*Risk Score: \([0-9]\+\).*/\1/' || echo "0")
risk_level=$(grep -E "(HIGH|MEDIUM|LOW) RISK:" "$input_file" | head -1 | sed 's/.*\(HIGH\|MEDIUM\|LOW\) RISK.*/\1/' || echo "Unknown")

# Extract overlaps
file_overlaps_detected=$(grep -q "FILE OVERLAP" "$input_file" && echo "true" || echo "false")
rapid_submissions_detected=$(grep -q "RAPID:" "$input_file" && echo "true" || echo "false")

# Extract author info if available
unique_authors=$(grep "unique contributors" "$input_file" | sed 's/.*\([0-9]\+\) unique contributors.*/\1/' || echo "Unknown")

echo "📋 Range: PRs $pr_range"
echo "🎯 Purpose: LLM decision making with formatted data"
echo "⏰ Generated: $(date)"
echo ""

case "$format_type" in
    "quick")
        echo "⚡ QUICK LLM DATA SUMMARY"
        echo ""
        
        echo "🎯 IMMEDIATE DECISION DATA:"
        echo "  • Risk Score: $risk_score/100 ($risk_level risk)"
        echo "  • PRs Analyzed: $prs_found"
        echo "  • File Overlaps: $([ "$file_overlaps_detected" = "true" ] && echo "DETECTED" || echo "None")"
        echo "  • Rapid Submissions: $([ "$rapid_submissions_detected" = "true" ] && echo "DETECTED" || echo "None")"
        
        if [ "$file_overlaps_detected" = "true" ]; then
            echo ""
            echo "📁 FILE OVERLAP DETAILS:"
            grep -A 5 "FILE OVERLAP" "$input_file" | grep -E "(File:|PRs:)" | head -10
        fi
        
        if [ "$rapid_submissions_detected" = "true" ]; then
            echo ""
            echo "⚡ RAPID SUBMISSION DETAILS:"
            grep "RAPID:" "$input_file" | head -5
        fi
        
        echo ""
        echo "🤖 LLM INSTRUCTIONS:"
        if [ "$risk_score" -ge 80 ]; then
            echo "  HIGH RISK: Create dual reports (internal + collaborative dev team discussion)"
        elif [ "$risk_score" -ge 50 ]; then
            echo "  MEDIUM RISK: Team discussion recommended with collaborative questions"
        else
            echo "  LOW RISK: Normal process review sufficient"
        fi
        ;;
        
    "detailed")
        echo "🔬 DETAILED LLM DATA PACKAGE"
        echo ""
        
        echo "📊 COMPREHENSIVE ANALYSIS DATA:"
        echo "  • Analysis Scope: PRs $pr_range ($prs_found PRs)"
        echo "  • Risk Assessment: $risk_score/100 ($risk_level)"
        echo "  • Contributors: $unique_authors"
        echo "  • File Overlaps: $file_overlaps_detected"
        echo "  • Rapid Patterns: $rapid_submissions_detected"
        echo ""
        
        echo "🔍 DETAILED FINDINGS:"
        
        # Include file overlap section
        if [ "$file_overlaps_detected" = "true" ]; then
            echo ""
            echo "📁 FILE OVERLAP ANALYSIS:"
            grep -A 20 "File Overlap" "$input_file" | head -25
        fi
        
        # Include timing section
        if [ "$rapid_submissions_detected" = "true" ]; then
            echo ""
            echo "⚡ TIMING PATTERN ANALYSIS:"
            grep -A 10 "Timing Pattern" "$input_file" | head -15
        fi
        
        # Include risk factors
        risk_factors=$(grep "Risk factors:" "$input_file" | sed 's/.*Risk factors: //')
        if [ ! -z "$risk_factors" ]; then
            echo ""
            echo "⚠️  RISK FACTORS IDENTIFIED:"
            echo "  $risk_factors"
        fi
        
        echo ""
        echo "🧠 LLM ANALYSIS FRAMEWORK:"
        echo "1. Review risk metrics and contributing patterns"
        echo "2. Analyze file coordination and timing context"
        echo "3. Consider business requirements and team processes"
        echo "4. Formulate collaborative questions for team discussion"
        echo "5. Generate appropriate report format based on risk level"
        ;;
        
    "risk-focus")
        echo "🎯 RISK-FOCUSED LLM SUMMARY"
        echo ""
        
        echo "🚨 RISK INDICATORS FOR LLM DECISION:"
        echo "  • Overall Risk: $risk_score/100 ($risk_level)"
        
        # Extract and format specific risks
        if [ "$file_overlaps_detected" = "true" ]; then
            overlap_count=$(grep -c "File:" "$input_file" 2>/dev/null || echo "Multiple")
            echo "  • File Overlaps: $overlap_count instances detected"
        else
            echo "  • File Overlaps: None detected"
        fi
        
        if [ "$rapid_submissions_detected" = "true" ]; then
            rapid_count=$(grep -c "RAPID:" "$input_file" 2>/dev/null || echo "Multiple")
            echo "  • Rapid Submissions: $rapid_count instances detected"
        else
            echo "  • Rapid Submissions: None detected"
        fi
        
        echo "  • Contributors: $unique_authors unique author(s)"
        
        echo ""
        echo "🎯 LLM DECISION GUIDANCE:"
        if [ "$risk_score" -ge 80 ]; then
            echo "🔴 HIGH RISK RESPONSE NEEDED:"
            echo "  - Generate internal management report with risk analysis"
            echo "  - Create collaborative dev team discussion document"
            echo "  - Use questions, not accusations in team communication"
            echo "  - Focus on understanding context before conclusions"
        elif [ "$risk_score" -ge 50 ]; then
            echo "🟡 MEDIUM RISK RESPONSE:"
            echo "  - Consider team discussion with collaborative questions"
            echo "  - Focus on process improvement opportunities"
            echo "  - Document findings for workflow enhancement"
            echo "  - Gather context before any conclusions"
        else
            echo "🟢 LOW RISK RESPONSE:"
            echo "  - Standard process monitoring sufficient"
            echo "  - Document efficient development patterns if notable"
            echo "  - No immediate action required"
        fi
        
        echo ""
        echo "📋 KEY EVIDENCE FOR LLM:"
        grep -E "(File:|PRs:|RAPID:)" "$input_file" | head -10
        ;;
        
    "json")
        echo "🔗 JSON STRUCTURE FOR LLM PARSING"
        echo ""
        
        # Build JSON structure
        cat << EOF
{
  "llm_summary": {
    "pr_range": "$pr_range",
    "prs_analyzed": $prs_found,
    "risk_score": $risk_score,
    "risk_level": "$risk_level",
    "unique_authors": "$unique_authors",
    "analysis_timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  },
  "indicators": {
    "file_overlaps_detected": $file_overlaps_detected,
    "rapid_submissions_detected": $rapid_submissions_detected,
    "risk_factors": "$(grep 'Risk factors:' "$input_file" | sed 's/.*Risk factors: //' || echo 'none')"
  },
  "llm_guidance": {
    "recommended_action": "$([ "$risk_score" -ge 80 ] && echo "dual_reports" || [ "$risk_score" -ge 50 ] && echo "team_discussion" || echo "normal_monitoring")",
    "report_tone": "$([ "$risk_score" -ge 50 ] && echo "collaborative_questions" || echo "standard_documentation")",
    "priority": "$([ "$risk_score" -ge 80 ] && echo "high" || [ "$risk_score" -ge 50 ] && echo "medium" || echo "low")"
  },
  "verification_commands": [
    "git log --grep='Merge pull request' --oneline -10",
    "git show --stat <commit_hash>",
    "git diff --name-only <base>..<head>"
  ]
}
EOF
        ;;
        
    *)
        echo "❌ Unknown format type: $format_type"
        echo "Available: quick, detailed, risk-focus, json"
        exit 1
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ LLM formatting complete - Data optimized for analysis"
echo "🎯 LLM: Use the structured data above for informed decision making"
echo ""

# Provide verification commands for LLM to suggest
echo "🔧 VERIFICATION COMMANDS (for LLM to recommend):"
if [ ! -z "$pr_range" ]; then
    start_pr=$(echo "$pr_range" | cut -d'-' -f1)
    end_pr=$(echo "$pr_range" | cut -d'-' -f2)
    echo "git log --grep=\"Merge pull request #$start_pr\" --oneline"
    echo "git log --grep=\"Merge pull request #$end_pr\" --oneline"
fi
echo "git show --stat <commit_hash>  # For specific PR verification"
echo "" 