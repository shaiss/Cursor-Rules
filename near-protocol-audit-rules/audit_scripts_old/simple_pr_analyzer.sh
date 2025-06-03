#!/bin/bash

# Simple PR Gaming Detection Tool
# Works with basic shell features, focuses on commit overlap detection

echo "=== SIMPLE PR GAMING DETECTOR ==="
echo "Analyzing PRs for gaming patterns..."
echo ""

if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_pr> <end_pr>"
    echo "Example: $0 227 231"
    exit 1
fi

start_pr=$1
end_pr=$2

echo "🔍 Analyzing PR range: $start_pr-$end_pr"
echo ""

# Step 1: Find PRs and their details
echo "📋 Step 1: Gathering PR information"
pr_found=0
temp_file="/tmp/pr_analysis_$$"

for pr_num in $(seq $start_pr $end_pr); do
    merge_line=$(git log --grep="Merge pull request #$pr_num" --oneline -1 2>/dev/null)
    
    if [ ! -z "$merge_line" ]; then
        pr_found=$((pr_found + 1))
        merge_hash=$(echo "$merge_line" | cut -d' ' -f1)
        merge_date=$(git log --pretty=format:"%ad" --date=format:"%m/%d %H:%M" -1 $merge_hash)
        
        echo "  ✅ PR #$pr_num: $merge_hash ($merge_date)"
        echo "$pr_num|$merge_hash|$merge_date" >> $temp_file
    fi
done

if [ $pr_found -eq 0 ]; then
    echo "  ❌ No PRs found in range $start_pr-$end_pr"
    rm -f $temp_file
    exit 1
fi

echo "  Found $pr_found PRs"
echo ""

# Step 2: Analyze each PR's commits and files
echo "🔍 Step 2: Extracting commits and file changes"
commit_file="/tmp/commits_$$"
file_changes="/tmp/files_$$"

> $commit_file
> $file_changes

while IFS='|' read pr_num merge_hash merge_date; do
    echo "  Analyzing PR #$pr_num..."
    
    # Get the actual branch commits (not just merge commit)
    # Try different approaches to find the branch
    branch_commits=""
    
    # Method 1: Get commits between merge commit's parents
    parent1=$(git log --pretty=format:"%P" -1 $merge_hash | cut -d' ' -f1)
    parent2=$(git log --pretty=format:"%P" -1 $merge_hash | cut -d' ' -f2)
    
    if [ ! -z "$parent2" ]; then
        # This is a real merge commit
        branch_commits=$(git rev-list $parent1..$parent2)
        base_commit=$parent1
        head_commit=$parent2
    else
        # This might be a fast-forward merge, skip for now
        echo "    ⚠️  Fast-forward merge detected, skipping detailed analysis"
        continue
    fi
    
    if [ ! -z "$branch_commits" ]; then
        commit_count=$(echo "$branch_commits" | wc -l)
        
        # Get file changes
        files_changed=$(git diff --name-only $base_commit..$head_commit | wc -l)
        stats=$(git diff --shortstat $base_commit..$head_commit)
        
        echo "    📊 $commit_count commits, $files_changed files changed"
        echo "    📈 $stats"
        
        # Store commits for overlap analysis
        for commit in $branch_commits; do
            commit_msg=$(git log --pretty=format:"%s" -1 $commit | head -c 50)
            echo "$pr_num|$commit|$commit_msg" >> $commit_file
        done
        
        # Store files for overlap analysis
        git diff --name-only $base_commit..$head_commit | while read file; do
            echo "$pr_num|$file" >> $file_changes
        done
    fi
    
done < $temp_file

echo ""

# Step 3: Look for duplicate commits across PRs
echo "🚨 Step 3: Checking for duplicate commits"
duplicate_found=false

if [ -f $commit_file ]; then
    # Extract unique commits and count occurrences
    cut -d'|' -f2 $commit_file | sort | uniq -d > /tmp/dup_commits_$$
    
    if [ -s /tmp/dup_commits_$$ ]; then
        duplicate_found=true
        echo "  🔴 DUPLICATE COMMITS DETECTED:"
        
        while read dup_commit; do
            echo "    Commit $dup_commit appears in:"
            grep "$dup_commit" $commit_file | while IFS='|' read pr commit msg; do
                echo "      - PR #$pr: $msg"
            done
            echo ""
        done < /tmp/dup_commits_$$
    else
        echo "  ✅ No duplicate commits found"
    fi
    
    rm -f /tmp/dup_commits_$$
else
    echo "  ⚠️  No commit data available for analysis"
fi

echo ""

# Step 4: Check for file overlap
echo "🚨 Step 4: Checking for file overlap between PRs"
overlap_found=false

if [ -f $file_changes ] && [ -s $file_changes ]; then
    # Check for files that appear in multiple PRs
    cut -d'|' -f2 $file_changes | sort | uniq -d > /tmp/overlap_files_$$
    
    if [ -s /tmp/overlap_files_$$ ]; then
        overlap_found=true
        echo "  🔴 FILE OVERLAP DETECTED:"
        
        while read overlap_file; do
            prs_with_file=$(grep "|$overlap_file$" $file_changes | cut -d'|' -f1 | sort | uniq | tr '\n' ' ')
            echo "    File: $overlap_file"
            echo "    PRs: $prs_with_file"
            echo ""
        done < /tmp/overlap_files_$$
    else
        echo "  ✅ No file overlap detected"
    fi
    
    rm -f /tmp/overlap_files_$$
else
    echo "  ⚠️  No file change data available for analysis"
fi

echo ""

# Step 5: Timing analysis
echo "🚨 Step 5: PR timing analysis"
echo "  PR submission timeline:"

# Sort PRs by merge time and check for rapid submissions
sort -t'|' -k3 $temp_file | while IFS='|' read pr_num merge_hash merge_date; do
    full_date=$(git log --pretty=format:"%ad" --date=format:"%Y-%m-%d %H:%M:%S" -1 $merge_hash)
    echo "    PR #$pr_num: $full_date"
done

echo ""

# Step 6: Generate risk assessment
echo "🎯 Step 6: Gaming Risk Assessment"
risk_score=0
risk_factors=""

if [ "$duplicate_found" = true ]; then
    risk_score=$((risk_score + 70))
    risk_factors="$risk_factors duplicate_commits"
fi

if [ "$overlap_found" = true ]; then
    risk_score=$((risk_score + 50))
    risk_factors="$risk_factors file_overlap"
fi

# Check for rapid submissions (multiple PRs within hours)
rapid_submissions=0
if [ $pr_found -gt 1 ]; then
    # Get timestamps and check differences
    git log --grep="Merge pull request #" --pretty=format:"%at %s" | grep -E "#($start_pr|$((start_pr+1))|$((start_pr+2))|$((start_pr+3))|$((start_pr+4)))" > /tmp/timestamps_$$ 2>/dev/null
    
    if [ -s /tmp/timestamps_$$ ]; then
        prev_time=""
        while read timestamp msg; do
            if [ ! -z "$prev_time" ]; then
                time_diff=$((timestamp - prev_time))
                if [ $time_diff -lt 3600 ]; then  # Less than 1 hour
                    rapid_submissions=$((rapid_submissions + 1))
                fi
            fi
            prev_time=$timestamp
        done < /tmp/timestamps_$$
    fi
    
    rm -f /tmp/timestamps_$$
fi

if [ $rapid_submissions -gt 0 ]; then
    risk_score=$((risk_score + rapid_submissions * 25))
    risk_factors="$risk_factors rapid_submissions"
fi

echo "  Risk Score: $risk_score/100"

if [ $risk_score -ge 80 ]; then
    echo "  🔴 HIGH RISK: Strong indicators of PR gaming!"
    echo "      Recommendation: Investigate immediately"
elif [ $risk_score -ge 50 ]; then
    echo "  🟡 MEDIUM RISK: Concerning patterns detected"
    echo "      Recommendation: Review process and discuss with team"
elif [ $risk_score -ge 25 ]; then
    echo "  🟠 LOW-MEDIUM RISK: Some minor concerns"
    echo "      Recommendation: Monitor future submissions"
else
    echo "  🟢 LOW RISK: No significant gaming indicators"
    echo "      Recommendation: Normal development patterns"
fi

if [ ! -z "$risk_factors" ]; then
    echo "  Risk factors detected: $risk_factors"
fi

echo ""
echo "📋 Summary for Management:"
echo "  - PRs analyzed: $pr_found"
echo "  - Duplicate commits: $([ "$duplicate_found" = true ] && echo "YES" || echo "NO")"
echo "  - File overlap: $([ "$overlap_found" = true ] && echo "YES" || echo "NO")"
echo "  - Rapid submissions: $rapid_submissions"
echo "  - Overall risk: $([ $risk_score -ge 80 ] && echo "HIGH" || [ $risk_score -ge 50 ] && echo "MEDIUM" || echo "LOW")"

# Cleanup
rm -f $temp_file $commit_file $file_changes

echo ""
echo "✅ Analysis complete!" 