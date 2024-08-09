#!/usr/bin/sh

SRC=
ASMB_DIR=common # assembly destination folder
NOOP= # dry run
DEBUG=

print_help() {
    echo -e "Generate AsciiDoc reference from a Hammer full-help MarkDown file"
    echo -e "  Generates one assembly and one module per hammer command."
    echo
    echo -e "Usage:"
    echo -e "    $0 [OPTIONS ...] SOURCE_FILE"
    echo
    echo -e "SOURCE_FILE    path to the Hammer-generated full-help in MarkDown"
    echo
    echo -e "Options:"
    echo -e "  --target-dir, -T DIR
    echo -e "               Path to a folder where the reference assembly"
    echo -e "               will be placed. Default: $ASMB_DIR"
    echo -e "                 Modules will be placed in DIR/modules/"
    echo -e "  --help, -h   Print help and exit"
    echo -e "  --noop       Dry run (don't do anything, only preview output)"
    echo -e "  --debug, -d  Debug mode (verbose output)"
}

bye() {
    echo -e ''
    echo -e "$1"
    echo -e 'Exiting ...'
    echo -e ''
    exit 1
}

# Process user arguments
if [ $# -eq 0 ]; then print_help; exit 1; fi
while [ $# -gt 1 ]; do
    case "$1" in
        --target-dir|-T)
            ASMB_DIR="$2"
            shift 2
            ;;
        --noop)
            NOOP=yes
            DEBUG=yes
            echo -e "I: Dry run: ON"
            echo -e "I: Debug: ON"
            shift 1
            ;;
        --debug|-d)
            DEBUG=yes
            echo -e "I: Debug: ON"
            shift 1
            ;;
        --assembly-only|-a)
            ASSEMBLY_ONLY=yes
            echo -e "I: Assembly only: ON"
            shift 1
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
        *)
            bye "E: Invalid option: $1"
            ;;
    esac
done
SRC=$1

# Define internal variables
if [ -n "$ASMB_DIR" ]; then
    mod_path=$ASMB_DIR/modules # module destination folder
    asmb_file=$ASMB_DIR/assembly_hammer-reference.adoc
else
    mod_path=modules
    asmb_file=assembly_hammer-reference.adoc
fi
details_tmp="$mod_path/tmp_hammer-option-details"
echo -e >$details_tmp # reset

details_file="$mod_path/ref_hammer-option-details.adoc"
details_header='[id="hammer-option-details"]\n= Option details\n\nHammer options accept the following option types and values:'

asmb_header='[id="hammer-reference"]\n= Hammer reference\n\nYou can review the usage of Hammer statements.\nThese usage statements are current to the versions of Hammer and its components released for {ProjectXY}.\n'
asmb_footer='include::modules/ref_hammer-option-details.adoc[leveloffset=+1]'

# Create folders
{ [ -n "$NOOP" ] || mkdir -p $mod_path ; } && echo -e "Created folders: " $mod_path

# Output headers
if [ -z "$NOOP" ]; then
    echo -e "$asmb_header" >$asmb_file && \
        [ -n "$DEBUG" ] && echo -e "I: Assembly header written"
fi
if [ -z "$ASSEMBLY_ONLY" ]; then
    echo -e "$details_header" >$details_file && \
        { [ -n "$DEBUG" ] && echo -e "I: Option details header written" ; } || \
        echo -e "W: Something went wrong writing option details header"
fi

# Read lines from the source file
cat "$SRC" | while read line ; do
# FYI read strips leading spaces

    # Analyze simple lines
    case "$line" in
        "# Hammer CLI help") # BOF
            echo -e "I: [Beginning of input file] correct"
            continue
        ;;
        '- ['*) # Skip MD TOC
            continue
        ;;
        "# hammer") # top-command
            echo -e "I: [cmd-1]: $line"
            id_core=hammer
            mod_file="$mod_path/ref_$id_core.adoc"
            id='[id="hammer"]'
            heading='= hammer'
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$id\n$heading" >$mod_file
            { [ -z "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] ; } && \
                echo -e "include::modules/ref_hammer.adoc[leveloffset=+1]\n" >>$asmb_file
            begin_section=yes
            skip_section=
            continue
        ;;
        "## hammer"*) # command
            echo -e "I: [cmd-2]: $line"
            id_core=`echo -e $line | sed 's/^## //' | sed 's/ /-/g'`
            filename=ref_$id_core.adoc
            mod_file="$mod_path/$filename"
            id=[id=\"$id_core\"]
            heading=`echo -e $line | sed 's/^## hammer/=/'`
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$id\n$heading" >$mod_file
            { [ -z "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] ; } && \
                echo -e "include::modules/$filename[leveloffset=+1]\n" >>$asmb_file
            begin_section=yes
            skip_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        "### hammer"*) # subcommand
            [ -n "$DEBUG" ] && echo -e "I: [cmd-3]: $line"
            id_core=`echo -e $line | sed 's/^### //' | sed 's/ /-/g'`
            id=[id=\"$id_core\"]
            heading=`echo -e $line | sed 's/^### hammer/==/'`
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$id\n$heading" >>$mod_file
            begin_section=yes
            skip_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        "#### hammer"*) # subsubcommand
            [ -n "$DEBUG" ] && echo -e "I: [cmd-4]: $line"
            id_core=`echo -e $line | sed 's/^#### //' | sed 's/ /-/g'`
            id=[id=\"$id_core\"]
            heading=`echo -e $line | sed 's/^#### hammer/===/'`
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$id\n$heading" >>$mod_file
            begin_section=yes
            skip_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        "##### hammer"*) # subsubsubcommand
            [ -n "$DEBUG" ] && echo -e "I: [cmd-5]: $line"
            id_core=`echo -e $line | sed 's/^##### //' | sed 's/ /-/g'`
            id=[id=\"$id_core\"]
            heading=`echo -e $line | sed 's/^##### hammer/====/'`
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$id\n$heading" >>$mod_file
            begin_section=yes
            skip_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        "Usage:")
            [ -n "$DEBUG" ] && echo -e "I: [Usage]ID: $id_core"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e ".Usage" >>$mod_file
            skip_section=
            continue
        ;;
        "Parameters:")
            [ -n "$DEBUG" ] && echo -e "I: [Parameters]ID: $id_core"
            [ -n "$DEBUG" ] && echo -e "I: [Parameters] Skipping"
            skip_section=yes
            #[ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            #    echo -e ".Parameters" >>$mod_file
            continue
        ;;
        "Subcommands:")
            [ -n "$DEBUG" ] && echo -e "I: [Subcommands]ID: $id_core"
            [ -n "$DEBUG" ] && echo -e "I: [Subcommands] Skipping"
            skip_section=yes
            #[ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            #    echo -e ".Subcommands" >>$mod_file
            continue
        ;;
        "Options:")
            [ -n "$DEBUG" ] && echo -e "I: [Options]ID: $id_core"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e ".Options" >>$mod_file
            options=yes
            skip_section=
            continue
        ;;
        *"Predefined field sets"*)
            [ -n "$DEBUG" ] && echo -e "I: [Predefined field sets]ID: $id_core"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e ".Predefined field sets" >>$mod_file
            field_sets=yes
            table_delim=0
            skip_section=
            options=
            continue
        ;;
        *"Option details"*)
            [ -n "$DEBUG" ] && echo -e "I: [Option details]"
            option_details=yes
            skip_section=
            options=
            field_sets=
            continue
        ;;
        "Provider specific options:")
            [ -n "$DEBUG" ] && echo -e "I: [Provider specific options]ID: $id_core"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e ".Provider specific options\n" >>$mod_file
            provider_specific=yes
            skip_section=
            options=
            field_sets=
            option_details=
            continue
        ;;
        *Search*fields*)
            [ -n "$DEBUG" ] && echo -e "I: [Search / Order fields]ID: $id_core"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e ".Search / Order fields" >>$mod_file
            search_fields=yes
            skip_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            continue
        ;;
        'Following parameters'*|'Overriding'*) # after Option details
            [ -n "$DEBUG" ] && echo -e "I: [Schematic] $line"
            [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
                echo -e "$line" >>$mod_file
            options=yes
            skip_section=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        "") # Copy empty line
            if [ -n "$option_details" ] && [ -z "$ASSEMBLY_ONLY" ] ; then
                echo -e $line >>$details_tmp
            elif [ -z "$NOOP" ] && [ -z "$ASSEMBLY_ONLY" ] && [ -n "$mod_file" ]; then
                echo -e $line >>$mod_file
            fi
            continue
        ;;
        '```') # Just unset stuff
            begin_section=
            options=
            field_sets=
            option_details=
            provider_specific=
            search_fields=
            continue
        ;;
        'Here you can find option types'*) # Skip
            continue
        ;;
        *) # analyze everything else
        ;;
    esac

    # Analyze complex lines
    if [ -n "$skip_section" ]; then
        continue
    elif [ -n "$begin_section" ]; then
        [ -n "$DEBUG" ] && echo -e "I: [Sentence]: ^${line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "\n$line" >>$mod_file
    elif echo -e "${line}" | grep -Eq '^hammer.+OPTIONS' - ; then # usage line
        fixed_line=`echo -e $line | sed 's/^/# /'`
        [ -n "$DEBUG" ] && echo -e "I: [Usage line]: ^${fixed_line}"
        fixed_line=`echo -e "----\n$fixed_line\n----"`
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif echo -e "${line}" | grep -Eq '^\[?SUBCOM|^\[ARG\]' - ; then # param line
        fixed_line=`echo -e $line | sed -E 's/^(\[?SUBCOMMAND\S?|\[ARG\] \.{3})\s+([A-Z].+)$/\* \`\1\` \{endash\} \2/'`
        [ -n "$DEBUG" ] && echo -e "I: [Param line]: ^${fixed_line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif [ -n "$options" ]; then
        fixed_line=`echo -e "$line" | sed 's/\x27/\`/g'` #replace apostrophes
        fixed_line=`echo -e "$fixed_line" | sed -E 's/..1m|..0m/\*/g'` #bold
        if echo -e "${line}" | grep -Eq '^-{1,2}[a-z\[]' - ; then # option line
            fixed_line=`echo -e "$fixed_line" | sed -E 's/^(-[a-z])/\`\1\`/' | sed -E 's/( )(-[a-z])/\1\`\2\`/g'`
            fixed_line=`echo -e "$fixed_line" | sed -E 's/(--\S+\s[A-Z\_]{3,})/\`\1\`/' | sed -E 's/([A-Z\_]{3,})(\`)/xref:hammer-option-details-\L\1\E\[\1\]\2/'`
            fixed_line=`echo -e "$fixed_line" | sed -E 's/^(--\S+)/\`\1\`/' | sed -E 's/( )(--\S+)/\1\`\2\`/g'`
            fixed_line=`echo -e "$fixed_line" | sed -E 's/   +/ \{endash\} /'`
            fixed_line="* $fixed_line"
            [ -n "$DEBUG" ] && echo -e "I: [Option item]: ^${fixed_line}"
        else # option sentence
            fixed_line=`echo -e "$fixed_line" | sed -E 's/( )(--\S+)([\.\)])/\1\`\2\`\3/g'`
            fixed_line=`echo -e "$fixed_line" | sed -E 's/( )(--\S+)/\1\`\2\`/g'`
            [ -n "$DEBUG" ] && echo -e "I: [Option sentence]: ^${fixed_line}"
        fi
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif [ -n "$field_sets" ]; then
        if echo -e "${line}" | grep -Eq '[-\|]{3,}' - ; then
            table_delim=$((table_delim+1))
            if [ $table_delim -gt 1 ] && echo -e "${line}" | grep -Eqv '\|' - ; then
                table_delim=3
            fi
            if [ $table_delim -eq 1 ] || [ $table_delim -eq 3 ]; then
                fixed_line="|==="
            elif [ $table_delim -eq 2 ]; then
                fixed_line=""
            fi
        else
            fixed_line="| $line"
        fi
        [ -n "$DEBUG" ] && echo -e "I: [Field line]: ^${fixed_line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif [ -n "$option_details" ]; then
        if echo -e "$line" | grep -Eq "^(KEY_VALUE_)?LIST|^SCHEMA"; then
            without_newline=-n
            fixed_line="${line} "
        else
            fixed_line="$line"
        fi
        echo -e $without_newline "$fixed_line" >>$details_tmp
        [ -n "$DEBUG" ] && echo -e "I: [Detail line]tmp: ^${fixed_line}"
        without_newline=
    elif [ -n "$provider_specific" ]; then
        if echo -e "$line" | grep -Eq "^--[^:]+:$"; then
            fixed_line=`echo -e "$line" | sed -E 's/(--[^:]+):/\`\1\`/'`
            fixed_line="\n* $fixed_line:\n"
        elif echo -e "$line" | grep -Eq "^[A-Zo].+:$"; then
            fixed_line=`echo -e "$line" | sed -E 's/oVirt/\{oVirt\}/'`
            fixed_line="$fixed_line"
        elif echo -e "$line" | grep -Eq "^(..1m)?[a-z][A-Za-z\_]+(..0m)?\s+[A-Za-z]"; then
            fixed_line=`echo -e "$line" | sed -E 's/^((..1m)?[a-z][A-Za-z\_]+(..0m)?)\s+/\`\1\` \{endash\} /'`
            fixed_line="** $fixed_line\n"
        elif echo -e "$line" | grep -Eq "^(..1m)?[a-z][A-Za-z\_]+(..0m)?$"; then
            fixed_line=`echo -e "$line" | sed -E 's/^((..1m)?[a-z][A-Za-z\_]+(..0m)?)/\`\1\` \{endash\} /'`
            fixed_line="** $fixed_line"
        elif echo -e "$line" | grep -Eq "^[a-z]+ +- +"; then
            fixed_line=`echo -e "$line" | sed -E 's/^([a-z]+) +- +/\`\1\` \{endash\} /'`
            fixed_line="*** $fixed_line"
        elif echo -e "$line" | grep -Eq "^..1mNOTE:..0m"; then
            fixed_line=`echo -e "$line" | sed -E 's/..1mNOTE:..0m //g'`
        elif echo -e "$line" | grep -Eq "^Virtual"; then
            fixed_line="$line, "
        else
            fixed_line="$line"
        fi
        fixed_line=`echo -e "$fixed_line" | sed -E 's/..1m|..0m/\*/g'`
        [ -n "$DEBUG" ] && echo -e "I: [Provider spec]: ^${fixed_line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif [ -n "$search_fields" ]; then # search field
        #[ -n "$DEBUG" ] && echo -e "I: [LINE]: ^${line}"
        fixed_line=`echo -e $line | sed -E 's/^([a-z][a-z\_\.]+)\s+(.+)$/\`\1\` \{endash\} \2/'`
        fixed_line=`echo -e $fixed_line | sed -E 's/^([a-z][a-z\_\.]+)$/\`\1\`/'`
        fixed_line="* $fixed_line"
        [ -n "$DEBUG" ] && echo -e "I: [Search field]: ^${fixed_line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    elif echo -e "${line}" | grep -Eq '^([a-z][a-z-]+(, )?)+\s+[A-Z].+$' - ; then
        # subcom line
        fixed_line=`echo -e $line | sed -E "s/^([a-z][a-z-]+)\s+([A-Z].+)$/xref:$id_core-\1\[\1\] \{endash\} \2/"`
        fixed_line=`echo -e $fixed_line | sed -E "s/^([a-z][a-z-]+)(, [a-z][a-z-]+)?\s+([A-Z].+)$/xref:$id_core-\1\[\1\]\2 \{endash\} \3/"`
        fixed_line=`echo -e $fixed_line | sed -E "s/^([a-z][a-z-]+)$/xref:$id_core-\1\[\1\]/"`
        fixed_line="* $fixed_line"
        [ -n "$DEBUG" ] && echo -e "I: [Subcom line]: ^${fixed_line}"
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$fixed_line" >>$mod_file
    else
        [ -n "$NOOP" ] || [ -n "$ASSEMBLY_ONLY" ] || \
            echo -e "$line" >>$mod_file
        echo -e "W: [unrecognized (copied)]: ^${line}"
    fi

done
echo -e "I: [End of input file]"

# Output assembly footer
[ -n "$NOOP" ] || echo -e $asmb_footer >>$asmb_file

echo

# Process option details
echo -e "Processing option details..."
sort $details_tmp | uniq | \
    sed -E 's/^([A-Z\_]+)\s+/\n\[id="hammer-option-details-\L\1\E"\]\n\1:: /' >>$details_file
[ -n "$DEBUG" ] || rm $details_tmp # Delete tmp file

echo
echo -e "I: Finished"
exit 0
