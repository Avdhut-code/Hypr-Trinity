#!/usr/bin/env bash

# Function that handles TAB completion for hyprtrinity and install.sh
_hyprtrinity_completions() {
    local cur prev words cword
    
    # Standard helper function provided by bash-completion package.
    # It sets:
    #   'cur'  -> word currently being typed (e.g. "--th")
    #   'prev' -> previous word typed (e.g. "--theme")
    #   'words' -> array of all words typed so far
    _get_comp_words_by_ref -n : cur prev words cword 2>/dev/null || {
        # Fallback if _get_comp_words_by_ref isn't available
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
    }

    # -------------------------------------------------------------------------
    # 1. SPECIAL CASE HANDLING (Sub-arguments for specific flags)
    # -------------------------------------------------------------------------
    # If the user just typed '--theme' or '-t', suggest theme-specific sub-flags
    case "${prev}" in
        -t|--theme)
            COMPREPLY=( $(compgen -W "--vscode --obsidian" -- "${cur}") )
            return 0
            ;;
    esac

    # -------------------------------------------------------------------------
    # 2. MAIN FLAG DEFINITIONS
    # -------------------------------------------------------------------------
    # List all primary flags supported by install.sh (both short and long)
    local main_flags="
        -h --help
        -v --version
        -n --no-optional
        -y --yes-optional
        -u --update
        -r --restore
        -t --theme
        -ri --reinstall
        -d --debian
        -a --arch
        -f --fedora
    "

    # -------------------------------------------------------------------------
    # 3. DYNAMIC FILTERING (Prevent suggesting already used flags)
    # -------------------------------------------------------------------------
    # We iterate over words typed so far and filter out any flags already present.
    local unused_flags=""
    for flag in ${main_flags}; do
        local found=false
        for word in "${words[@]}"; do
            if [[ "${word}" == "${flag}" ]]; then
                found=true
                break
            fi
        done
        if [[ "${found}" == false ]]; then
            unused_flags="${unused_flags} ${flag}"
        fi
    done

    # -------------------------------------------------------------------------
    # 4. GENERATE MATCHES
    # -------------------------------------------------------------------------
    # compgen filters 'unused_flags' using what the user is currently typing ('cur')
    COMPREPLY=( $(compgen -W "${unused_flags}" -- "${cur}") )
}

# Bind the function to both your command alias and script execution syntax:
# 1. When running via symlink: `hyprtrinity --<TAB>`
complete -F _hyprtrinity_completions hyprtrinity

# 2. When running directly: `./install.sh --<TAB>` or `bash install.sh --<TAB>`
complete -F _hyprtrinity_completions install.sh
complete -F _hyprtrinity_completions ./install.sh