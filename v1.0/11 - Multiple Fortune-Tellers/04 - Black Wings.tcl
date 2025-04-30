proc shiftadd {a b shift result_list} {
    set shifted_b [linsert $b 0 [lrepeat $shift 0]]
    addkar $a $shifted_b [expr {[llength $a] > [llength $shifted_b] ? [llength $shifted_b] : [llength $a]}] result
}