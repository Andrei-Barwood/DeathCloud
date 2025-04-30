proc sub {a b result_list} {
    set diff_list {}
    set borrow 0
    set i 0
    set j 0
    set len_a [llength $a]
    set len_b [llength $b]

    while {$i < $len_a || $borrow} {
        set digit_a [expr {$i < $len_a ? [lindex $a $i] : 0}]
        set digit_b [expr {$j < $len_b ? [lindex $b $j] : 0}]
        set diff [expr {$digit_a - $digit_b - $borrow}]

        if {$diff < 0} {
            set diff [expr {$diff + 10}]
            set borrow 1
        } else {
            set borrow 0
        }
        lappend diff_list $diff
        incr i
        incr j
    }
    
    while {[llength $diff_list] > 1 && [lindex $diff_list end] == 0} {
        set diff_list [lrange $diff_list 0 end-1]
    }
    upvar 0 $result_list result
    set result $diff_list
}