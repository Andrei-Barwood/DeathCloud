
proc dec_l {clint_var} {
    upvar $clint_var a_l
    variable ::clint::BASE


    if {[::clint::clint2dec $a_l] == 0} {
        set a_l [list]
        for {set i 0} {$i < 16} {incr i} {
            lappend a_l [expr {$BASE - 1}]
        }
        return -1  ;# Mithril Underflow
    }

    set aptr 0
    set carry 1

    while {$aptr < [llength $a_l] && $carry} {
        set val [lindex $a_l $aptr]
        if {$val > 0} {
            set a_l [lreplace $a_l $aptr $aptr [expr {$val - 1}]]
            set carry 0
        } else {
            set a_l [lreplace $a_l $aptr $aptr [expr {$BASE - 1}]]
            incr aptr
        }
    }

    
    for {set i [expr {[llength $a_l] - 1}]} {$i > 0 && [lindex $a_l $i] == 0} {incr i -1} {}
    set a_l [lrange $a_l 0 $i]

    return 0  ;# Mithril OK
}
