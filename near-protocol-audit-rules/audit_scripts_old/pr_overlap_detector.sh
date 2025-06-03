#!/bin/bash

# PR Overlap Detection Script
# Detects potential gaming through commit duplication/overlap across PRs

echo "=== PR OVERLAP ANALYSIS TOOL ==="
echo "Detecting potential PR gaming through commit overlap..."
echo ""

# Function to analyze a specific PR range
analyze_pr_range() {
    local start_pr=$1
    local end_pr=$2
    
    echo "Analyzing PRs $start_pr-$end_pr for overlap..."
    echo ""
    
    # Step 1: Find all PRs in range
    echo "🔍 Step 1: Finding PRs in range $start_pr-$end_pr"
    pr_list=()
    for pr_num in $(seq $start_pr $end_pr); do
        merge_commit=$(git log --grep="Merge pull request #$pr_num" --pretty=format:"%H" -1 2>/dev/null)
        if [ ! -z "$merge_commit" ]; then
            pr_list+=($pr_num)
            echo "  Found: PR #$pr_num (merge: ${merge_commit:0:7})"
        fi
    done
    
    if [ ${#pr_list[@]} -eq 0 ]; then
        echo "  ❌ No PRs found in range $start_pr-$end_pr"
        return 1
    fi
    
    echo "  ✅ Found ${#pr_list[@]} PRs: ${pr_list[*]}"
    echo ""
    
    # Step 2: Extract commits for each PR
    echo "🔍 Step 2: Extracting commits for each PR"
    declare -A pr_commits
    declare -A pr_files
    declare -A pr_stats
    declare -A commit_to_prs
    
    for pr_num in "${pr_list[@]}"; do
        echo "  Analyzing PR #$pr_num..."
        
        # Get the merge commit
        merge_commit=$(git log --grep="Merge pull request #$pr_num" --pretty=format:"%H" -1)
        
        # Get the branch that was merged (second parent of merge commit)
        branch_head=$(git rev-list --parents -n 1 $merge_commit | cut -d' ' -f3)
        
        if [ ! -z "$branch_head" ]; then
            # Get base commit (merge base with main)
            base_commit=$(git merge-base main $branch_head 2>/dev/null || git merge-base HEAD~20 $branch_head)
            
            # Get all commits in this PR
            commits=$(git rev-list $base_commit..$branch_head --reverse)
            pr_commits[$pr_num]="$commits"
            
            # Get files changed in this PR
            files=$(git diff --name-only $base_commit..$branch_head | sort | tr '\n' ' ')
            pr_files[$pr_num]="$files"
            
            # Get stats
            stats=$(git diff --shortstat $base_commit..$branch_head)
            pr_stats[$pr_num]="$stats"
            
            commit_count=$(echo "$commits" | wc -l)
            file_count=$(echo "$files" | wc -w)
            
            echo "    📊 $commit_count commits, $file_count files"
            echo "    📈 $stats"
            
            # Track which PRs each commit appears in
            for commit in $commits; do
                if [[ -z "${commit_to_prs[$commit]}" ]]; then
                    commit_to_prs[$commit]="$pr_num"
                else
                    commit_to_prs[$commit]="${commit_to_prs[$commit]} $pr_num"
                fi
            done
        fi
    done
    echo ""
    
    # Step 3: Detect duplicate commits
    echo "🚨 Step 3: Detecting duplicate commits across PRs"
    duplicate_found=false
    
    for commit in "${!commit_to_prs[@]}"; do
        prs="${commit_to_prs[$commit]}"
        pr_count=$(echo $prs | wc -w)
        
        if [ $pr_count -gt 1 ]; then
            duplicate_found=true
            commit_msg=$(git log --pretty=format:"%s" -1 $commit)
            commit_author=$(git log --pretty=format:"%an" -1 $commit)
            commit_date=$(git log --pretty=format:"%ad" --date=short -1 $commit)
            echo "  🔴 DUPLICATE: Commit $commit appears in PRs: $prs"
            echo "      Message: $commit_msg"
            echo "      Author: $commit_author, Date: $commit_date"
        fi
    done
    
    if [ "$duplicate_found" = false ]; then
        echo "  ✅ No duplicate commits found"
    fi
    echo ""
    
    # Step 4: Detect file overlap
    echo "🚨 Step 4: Detecting file overlap across PRs"
    echo "  File overlap matrix:"
    overlap_detected=false
    
    for pr1 in "${pr_list[@]}"; do
        for pr2 in "${pr_list[@]}"; do
            if [ $pr1 -lt $pr2 ]; then
                files1=(${pr_files[$pr1]})
                files2=(${pr_files[$pr2]})
                
                # Find intersection
                common_files=()
                for file1 in "${files1[@]}"; do
                    for file2 in "${files2[@]}"; do
                        if [ "$file1" = "$file2" ]; then
                            common_files+=("$file1")
                        fi
                    done
                done
                
                if [ ${#common_files[@]} -gt 0 ]; then
                    overlap_detected=true
                    overlap_pct=$((${#common_files[@]} * 100 / ${#files1[@]}))
                    echo "    🔴 PR #$pr1 ↔ PR #$pr2: ${#common_files[@]} common files ($overlap_pct% overlap)"
                    if [ $overlap_pct -gt 50 ]; then
                        echo "      ⚠️  HIGH OVERLAP WARNING: >50% file overlap detected!"
                        echo "      Common files: ${common_files[*]}"
                    fi
                fi
            fi
        done
    done
    
    if [ "$overlap_detected" = false ]; then
        echo "  ✅ No significant file overlap detected"
    fi
    echo ""
    
    # Step 5: Timing analysis
    echo "🚨 Step 5: PR timing analysis"
    declare -A pr_dates
    for pr_num in "${pr_list[@]}"; do
        merge_commit=$(git log --grep="Merge pull request #$pr_num" --pretty=format:"%H" -1)
        merge_date=$(git log --pretty=format:"%ad" --date=format:"%Y-%m-%d %H:%M:%S" -1 $merge_commit)
        merge_timestamp=$(git log --pretty=format:"%at" -1 $merge_commit)
        pr_dates[$pr_num]=$merge_timestamp
        echo "    PR #$pr_num merged: $merge_date"
    done
    
    # Check for rapid PR submissions
    echo ""
    echo "  🕐 Rapid submission analysis:"
    sorted_prs=($(for pr in "${!pr_dates[@]}"; do echo "$pr ${pr_dates[$pr]}"; done | sort -k2 -n | cut -d' ' -f1))
    
    for i in $(seq 0 $((${#sorted_prs[@]}-2))); do
        pr1=${sorted_prs[$i]}
        pr2=${sorted_prs[$((i+1))]}
        time_diff=$((${pr_dates[$pr2]} - ${pr_dates[$pr1]}))
        hours=$((time_diff / 3600))
        
        if [ $time_diff -lt 3600 ]; then  # Less than 1 hour
            minutes=$((time_diff / 60))
            echo "    ⚠️  PR #$pr1 → PR #$pr2: $minutes minutes apart (RAPID!)"
        elif [ $time_diff -lt 86400 ]; then  # Less than 1 day
            echo "    🟡 PR #$pr1 → PR #$pr2: $hours hours apart"
        fi
    done
    echo ""
    
    # Step 6: Generate gaming risk score
    echo "🎯 Step 6: Gaming Risk Assessment"
    risk_score=0
    risk_factors=()
    
    if [ "$duplicate_found" = true ]; then
        risk_score=$((risk_score + 50))
        risk_factors+=("Duplicate commits detected")
    fi
    
    if [ "$overlap_detected" = true ]; then
        risk_score=$((risk_score + 30))
        risk_factors+=("High file overlap detected")
    fi
    
    # Check for rapid submissions
    rapid_count=0
    for i in $(seq 0 $((${#sorted_prs[@]}-2))); do
        pr1=${sorted_prs[$i]}
        pr2=${sorted_prs[$((i+1))]}
        time_diff=$((${pr_dates[$pr2]} - ${pr_dates[$pr1]}))
        if [ $time_diff -lt 3600 ]; then
            rapid_count=$((rapid_count + 1))
        fi
    done
    
    if [ $rapid_count -gt 0 ]; then
        risk_score=$((risk_score + rapid_count * 20))
        risk_factors+=("$rapid_count rapid PR submissions")
    fi
    
    echo "  Risk Score: $risk_score/100"
    
    if [ $risk_score -ge 70 ]; then
        echo "  🔴 HIGH RISK: Strong indicators of PR gaming detected!"
    elif [ $risk_score -ge 40 ]; then
        echo "  🟡 MEDIUM RISK: Some concerning patterns detected"
    else
        echo "  🟢 LOW RISK: No significant gaming indicators"
    fi
    
    if [ ${#risk_factors[@]} -gt 0 ]; then
        echo "  Risk factors: ${risk_factors[*]}"
    fi
}

# Usage function
usage() {
    echo "Usage: $0 <start_pr> <end_pr>"
    echo "Example: $0 234 248"
    echo "         $0 244 247"
    exit 1
}

# Main execution
if [ $# -ne 2 ]; then
    usage
fi

analyze_pr_range $1 $2 