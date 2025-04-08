

namespace eval ::clint {
    variable BASE 65536


    proc LSDPTR_L {clint} {
        return 0
    }


    proc MSDPTR_L {clint} {
        set i [expr {[llength $clint] - 1}]
        while {$i >= 0 && [lindex $clint $i] == 0} {
            incr i -1
        }
        return $i
    }

    
    proc DIGITS_L {clint} {
        set msd [MSDPTR_L $clint]
        return [expr {$msd + 1}]
    }

    
    proc SETZERO {clint_var} {
        upvar $clint_var clint
        set clint [list 0]
    }

    
    proc u2clint_l {n} {
        variable BASE
        set clint [list]
        while {$n > 0} {
            lappend clint [expr {$n % $BASE}]
            set n [expr {$n / $BASE}]
        }
        if {[llength $clint] == 0} {
            lappend clint 0
        }
        return $clint
    }

   
    proc clint2dec {clint} {
        variable BASE
        set result 0
        set power 1
        foreach digit $clint {
            set result [expr {$result + $digit * $power}]
            set power [expr {$power * $BASE}]
        }
        return $result
    }
} 

