# Verilog for Kakoune

# Detection
hook global BufCreate .*[.]v %{
    set-option buffer filetype verilog
}

# Set up comments
hook global BufSetOption filetype=verilog %{
	set-option buffer comment_block_begin /*
	set-option buffer comment_block_end */
	set-option buffer comment_line //
}

# Highlighting
add-highlighter shared/verilog regions
add-highlighter shared/verilog/code default-region group
add-highlighter shared/verilog/string region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/verilog/comment_line region '//' $ fill comment
add-highlighter shared/verilog/comment region /\* \*/ fill comment
add-highlighter shared/verilog/code/ region '`' \b 0:value

evaluate-commands %sh{
    keywords='always assign automatic cell deassign default defparam design disable edge genvar ifnone incdir instance liblist library localparam negedge noshowcancelled parameter posedge primitive pulsestyle_ondetect pulsestyle_oneventi release scalared showcancelled specparam strength table tri tri0 tri1 triand trior use vectored'
    blocks='case casex casez else endcase for forever if repeat wait while begin config end endconfig endfunction endgenerate endmodule endprimitive endspecify endtable endtask fork function generate initial join macromodule module specify task'
    declarations='event inout input integer output real realtime reg signed time trireg unsigned wand wor wire'
    gates='and or xor nand nor xnor buf not bufif0 notif0 bufif1 notif1 pullup pulldown pmos nmos cmos tran tranif1 tranif0'

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list verilog_static_words $(join "${keywords} ${blocks} ${declarations} ${gates}" ' ')"

	# Highlight keywords
    printf %s "
        add-highlighter shared/go/code/ regex \b($(join "${keywords}" '|'))\b 0:keyword
        add-highlighter shared/go/code/ regex \b($(join "${blocks}" '|'))\b 0:attribute
        add-highlighter shared/go/code/ regex \b($(join "${declarations}" '|'))\b 0:type
        add-highlighter shared/go/code/ regex \b($(join "${gates}" '|'))\b 0:builtin
    "
	}
