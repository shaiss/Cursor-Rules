#!/bin/bash

# Comprehensive PR Analyzer v1.0
# Purpose: Deep analysis for cursor rules system-gaming-audit.mdc
# Focus: Detailed evidence collection, structured data, multiple formats
# Usage: script_logged comprehensive_pr_analyzer.sh <start_pr> <end_pr> [--format json|csv|standard]

if [ $# -lt 2 ] || [ $# -gt 4 ]; then
    echo "Usage: $0 <start_pr> <end_pr> [--format json|csv|standard]"
    echo "Purpose: Comprehensive PR analysis for cursor system-gaming-audit"
    echo "Focus: Detailed evidence collection and structured data output"
    exit 1
fi

start_pr=$1
end_pr=$2
OUTPUT_FORMAT="standard"

# Parse format option
if [ "$3" = "--format" ] && [ ! -z "$4" ]; then
    OUTPUT_FORMAT="$4"
fi

echo "🔬 COMPREHENSIVE PR ANALYSIS: PRs $start_pr-$end_pr"
echo "📋 Format: $OUTPUT_FORMAT"
echo "🎯 Purpose: Deep analysis for evidence collection and dual reports"
echo ""

# Comprehensive PR discovery and data collection
pr_data=()
pr_count=0

echo "📊 COMPREHENSIVE PR DISCOVERY"
for pr_num in $(seq $start_pr $end_pr); do
    merge_commit=$(git log --grep="Merge pull request #$pr_num" --format="%H" -1 2>/dev/null)
    
    if [ ! -z "$merge_commit" ]; then
        pr_count=$((pr_count + 1))
        
        # Collect comprehensive metadata
        timestamp=$(git log --format="%at" -1 $merge_commit)
        date_str=$(git log --format="%ad" --date=format:"%Y-%m-%d %H:%M:%S" -1 $merge_commit)
        author=$(git log --format="%an <%ae>" -1 $merge_commit)
        subject=$(git log --format="%s" -1 $merge_commit)
        
        # Get parent commits for analysis
        parents=$(git log --format="%P" -1 $merge_commit)
        parent1=$(echo $parents | cut -d' ' -f1)
        parent2=$(echo $parents | cut -d' ' -f2)
        
        # Collect change statistics
        if [ ! -z "$parent2" ]; then
            files_changed=$(git diff --name-only $parent1..$parent2 2>/dev/null | wc -l)
            lines_added=$(git diff --numstat $parent1..$parent2 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
            lines_deleted=$(git diff --numstat $parent1..$parent2 2>/dev/null | awk '{sum+=$2} END {print sum+0}')
            commit_count=$(git rev-list --count $parent1..$parent2 2>/dev/null || echo "0")
        else
            files_changed=0
            lines_added=0
            lines_deleted=0
            commit_count=1
        fi
        
        # Store comprehensive data
        pr_data+=("$pr_num|$merge_commit|$timestamp|$date_str|$author|$files_changed|$lines_added|$lines_deleted|$commit_count|$parent1|$parent2")
        
        echo "  ✅ PR #$pr_num: $files_changed files, +$lines_added/-$lines_deleted lines ($commit_count commits)"
        echo "     📅 $date_str by $author"
    fi
done

if [ $pr_count -eq 0 ]; then
    echo "  ❌ No PRs found in range"
    echo "✅ ANALYSIS COMPLETE: No PRs to analyze"
    exit 0
fi

echo "  📊 Collected $pr_count PRs for comprehensive analysis"
echo ""

# Detailed file overlap analysis with matrix
echo "🔍 DETAILED FILE OVERLAP ANALYSIS"
file_matrix=()
overlap_results=()

# Build file change matrix
for pr_data_line in "${pr_data[@]}"; do
    IFS='|' read -r pr_num merge_commit timestamp date_str author files_changed lines_added lines_deleted commit_count parent1 parent2 <<< "$pr_data_line"
    
    if [ ! -z "$parent2" ]; then
        # Get all changed files for this PR
        git diff --name-only $parent1..$parent2 2>/dev/null | while read file; do
            if [ ! -z "$file" ]; then
                echo "$pr_num,$file" >> "/tmp/file_matrix_$$"
            fi
        done
    fi
done

# Analyze overlaps if we have file data
if [ -f "/tmp/file_matrix_$$" ]; then
    # Find overlapping files
    cut -d',' -f2 "/tmp/file_matrix_$$" | sort | uniq -d > "/tmp/overlap_files_$$"
    
    if [ -s "/tmp/overlap_files_$$" ]; then
        echo "  🔴 FILE OVERLAPS DETECTED:"
        
        while read overlap_file; do
            prs_touching_file=$(grep ",$overlap_file$" "/tmp/file_matrix_$$" | cut -d',' -f1 | sort -n | tr '\n' ',' | sed 's/,$//')
            pr_count_for_file=$(echo "$prs_touching_file" | tr ',' '\n' | wc -l)
            
            overlap_results+=("$overlap_file|$prs_touching_file|$pr_count_for_file")
            echo "    📄 $overlap_file: PRs [$prs_touching_file] ($pr_count_for_file PRs)"
        done < "/tmp/overlap_files_$$"
    else
        echo "  ✅ No file overlaps detected"
    fi
    
    rm -f "/tmp/overlap_files_$$" "/tmp/file_matrix_$$"
else
    echo "  ⚠️  No file change data available"
fi

echo ""

# Advanced timing pattern analysis
echo "📅 ADVANCED TIMING PATTERN ANALYSIS"
timing_patterns=()
rapid_sequences=()
velocity_analysis=()

# Sort PRs by timestamp for timing analysis
sorted_data=($(printf '%s\n' "${pr_data[@]}" | sort -t'|' -k3 -n))

prev_timestamp=""
prev_pr=""
prev_author=""

for pr_data_line in "${sorted_data[@]}"; do
    IFS='|' read -r pr_num merge_commit timestamp date_str author files_changed lines_added lines_deleted commit_count parent1 parent2 <<< "$pr_data_line"
    
    echo "  📅 PR #$pr_num: $date_str"
    echo "     👤 $author"
    echo "     📊 $files_changed files, +$lines_added/-$lines_deleted lines"
    
    # Calculate development velocity (lines per hour)
    total_lines=$((lines_added + lines_deleted))
    if [ $commit_count -gt 0 ] && [ $total_lines -gt 0 ]; then
        # Estimate development time (assuming minimum 15 minutes per commit)
        estimated_hours=$(echo "scale=2; $commit_count * 0.25" | bc -l 2>/dev/null || echo "$commit_count")
        velocity=$(echo "scale=1; $total_lines / $estimated_hours" | bc -l 2>/dev/null || echo "0")
        velocity_analysis+=("PR#$pr_num|$velocity|$total_lines|$estimated_hours")
        echo "     ⚡ Velocity: $velocity lines/hour (est. ${estimated_hours}h for $total_lines lines)"
    fi
    
    # Check for rapid submissions
    if [ ! -z "$prev_timestamp" ]; then
        time_diff=$((timestamp - prev_timestamp))
        hours=$(echo "scale=1; $time_diff / 3600" | bc -l 2>/dev/null || echo "0")
        
        if [ $time_diff -lt 3600 ]; then  # Less than 1 hour
            minutes=$((time_diff / 60))
            rapid_sequences+=("$prev_pr|$pr_num|$minutes|$time_diff")
            echo "     🚨 RAPID: $minutes minutes after PR #$prev_pr"
        elif [ $time_diff -lt 14400 ]; then  # Less than 4 hours
            echo "     ⚠️  Quick: ${hours}h after PR #$prev_pr"
        fi
    fi
    
    timing_patterns+=("$pr_num|$timestamp|$date_str|$author")
    prev_timestamp=$timestamp
    prev_pr=$pr_num
    prev_author=$author
    echo ""
done

# Author concentration analysis
echo "👥 AUTHOR CONCENTRATION ANALYSIS"
unique_authors=($(printf '%s\n' "${pr_data[@]}" | cut -d'|' -f5 | sort | uniq))
author_count=${#unique_authors[@]}

echo "  📊 Unique authors: $author_count"
for author in "${unique_authors[@]}"; do
    author_pr_count=$(printf '%s\n' "${pr_data[@]}" | grep -F "|$author|" | wc -l)
    echo "    👤 $author: $author_pr_count PRs"
done

# Risk scoring with detailed breakdown
echo "🎯 COMPREHENSIVE RISK ASSESSMENT"
overlap_risk=0
timing_risk=0
velocity_risk=0
concentration_risk=0

# File overlap risk
if [ ${#overlap_results[@]} -gt 0 ]; then
    overlap_risk=$((${#overlap_results[@]} * 25))
    echo "  📄 File Overlap Risk: +$overlap_risk (${#overlap_results[@]} overlapping files)"
fi

# Timing risk
if [ ${#rapid_sequences[@]} -gt 0 ]; then
    timing_risk=$((${#rapid_sequences[@]} * 30))
    echo "  ⏱️  Timing Risk: +$timing_risk (${#rapid_sequences[@]} rapid sequences)"
fi

# Velocity risk (very high velocity suspicious)
high_velocity_count=0
for velocity_data in "${velocity_analysis[@]}"; do
    velocity=$(echo "$velocity_data" | cut -d'|' -f2)
    if [ ! -z "$velocity" ] && (( $(echo "$velocity > 500" | bc -l 2>/dev/null || echo "0") )); then
        high_velocity_count=$((high_velocity_count + 1))
    fi
done

if [ $high_velocity_count -gt 0 ]; then
    velocity_risk=$((high_velocity_count * 20))
    echo "  ⚡ Velocity Risk: +$velocity_risk ($high_velocity_count high-velocity PRs)"
fi

# Author concentration risk
if [ $author_count -eq 1 ] && [ $pr_count -gt 3 ]; then
    concentration_risk=25
    echo "  👤 Concentration Risk: +$concentration_risk (single author, multiple PRs)"
fi

total_risk=$((overlap_risk + timing_risk + velocity_risk + concentration_risk))
echo "  🎯 Total Risk Score: $total_risk/100"

# Risk level determination
if [ $total_risk -ge 75 ]; then
    risk_level="CRITICAL"
    risk_color="🔴"
elif [ $total_risk -ge 50 ]; then
    risk_level="HIGH"
    risk_color="🟠"
elif [ $total_risk -ge 25 ]; then
    risk_level="MEDIUM"
    risk_color="🟡"
else
    risk_level="LOW"
    risk_color="🟢"
fi

echo "  $risk_color Risk Level: $risk_level"
echo ""

# Generate structured output based on format
echo "📋 STRUCTURED DATA OUTPUT ($OUTPUT_FORMAT)"
case "$OUTPUT_FORMAT" in
    "json")
        cat << EOF
{
  "analysis_metadata": {
    "pr_range": "$start_pr-$end_pr",
    "total_prs": $pr_count,
    "unique_authors": $author_count,
    "analysis_timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  },
  "risk_assessment": {
    "total_score": $total_risk,
    "level": "$risk_level",
    "breakdown": {
      "file_overlap_risk": $overlap_risk,
      "timing_risk": $timing_risk,
      "velocity_risk": $velocity_risk,
      "concentration_risk": $concentration_risk
    }
  },
  "file_overlaps": [
$(for result in "${overlap_results[@]}"; do
    IFS='|' read -r file prs count <<< "$result"
    echo "    {\"file\": \"$file\", \"prs\": \"$prs\", \"pr_count\": $count},"
done | sed '$s/,$//')
  ],
  "rapid_sequences": [
$(for sequence in "${rapid_sequences[@]}"; do
    IFS='|' read -r pr1 pr2 minutes seconds <<< "$sequence"
    echo "    {\"from_pr\": $pr1, \"to_pr\": $pr2, \"minutes\": $minutes, \"seconds\": $seconds},"
done | sed '$s/,$//')
  ],
  "velocity_analysis": [
$(for velocity_data in "${velocity_analysis[@]}"; do
    IFS='|' read -r pr velocity lines hours <<< "$velocity_data"
    echo "    {\"pr\": \"$pr\", \"velocity\": $velocity, \"total_lines\": $lines, \"estimated_hours\": $hours},"
done | sed '$s/,$//')
  ]
}
EOF
        ;;
    "csv")
        echo "# Comprehensive PR Analysis - CSV Export"
        echo "# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
        echo "# Range: PRs $start_pr-$end_pr, Risk Score: $total_risk ($risk_level)"
        echo ""
        echo "# PR Summary"
        echo "PR_Number,Timestamp,Date,Author,Files_Changed,Lines_Added,Lines_Deleted,Commits"
        for pr_data_line in "${pr_data[@]}"; do
            IFS='|' read -r pr_num merge_commit timestamp date_str author files_changed lines_added lines_deleted commit_count parent1 parent2 <<< "$pr_data_line"
            echo "$pr_num,$timestamp,\"$date_str\",\"$author\",$files_changed,$lines_added,$lines_deleted,$commit_count"
        done
        echo ""
        echo "# File Overlaps"
        echo "File,PRs,PR_Count"
        for result in "${overlap_results[@]}"; do
            IFS='|' read -r file prs count <<< "$result"
            echo "\"$file\",\"$prs\",$count"
        done
        echo ""
        echo "# Rapid Sequences"
        echo "From_PR,To_PR,Minutes,Seconds"
        for sequence in "${rapid_sequences[@]}"; do
            IFS='|' read -r pr1 pr2 minutes seconds <<< "$sequence"
            echo "$pr1,$pr2,$minutes,$seconds"
        done
        ;;
    *)
        echo "=== COMPREHENSIVE ANALYSIS SUMMARY ==="
        echo "📊 Scope: PRs $start_pr-$end_pr ($pr_count PRs analyzed)"
        echo "👥 Authors: $author_count unique contributors"
        echo "🎯 Risk Assessment: $total_risk/100 ($risk_level)"
        echo ""
        echo "📄 File Overlaps (${#overlap_results[@]} detected):"
        if [ ${#overlap_results[@]} -gt 0 ]; then
            for result in "${overlap_results[@]}"; do
                IFS='|' read -r file prs count <<< "$result"
                echo "  - $file: PRs [$prs] ($count PRs)"
            done
        else
            echo "  - None detected"
        fi
        echo ""
        echo "⚡ Rapid Sequences (${#rapid_sequences[@]} detected):"
        if [ ${#rapid_sequences[@]} -gt 0 ]; then
            for sequence in "${rapid_sequences[@]}"; do
                IFS='|' read -r pr1 pr2 minutes seconds <<< "$sequence"
                echo "  - PR #$pr1 → PR #$pr2: $minutes minutes apart"
            done
        else
            echo "  - None detected"
        fi
        echo ""
        echo "⚡ Development Velocity Analysis:"
        if [ ${#velocity_analysis[@]} -gt 0 ]; then
            for velocity_data in "${velocity_analysis[@]}"; do
                IFS='|' read -r pr velocity lines hours <<< "$velocity_data"
                echo "  - $pr: $velocity lines/hour ($lines lines in ~${hours}h)"
            done
        else
            echo "  - No velocity data available"
        fi
        ;;
esac

echo ""
echo "✅ COMPREHENSIVE ANALYSIS COMPLETE"
echo "📋 Purpose: Evidence collection for dual report generation"
echo "🎯 Data ready for LLM analysis and cursor rule processing" 