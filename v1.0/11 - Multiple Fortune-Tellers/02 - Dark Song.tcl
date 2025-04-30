proc addkar {a b len result_list} {
    set sum_list {}
    set carry 0
    set i 0
    set j 0

    while {$i < [llength $a] || $j < [llength $b] || $carry} {
        set digit_a [expr {$i < [llength $a] ? [lindex $a $i] : 0}]
        set digit_b [expr {$j < [llength $b] ? [lindex $b $j] : 0}]
        set sum [expr {$digit_a + $digit_b + $carry}]
        lappend sum_list [expr {$sum % 10}]
        set carry [expr {$sum / 10}]
        incr i
        incr j
    }
    upvar 0 $result_list result
    set result $sum_list
}