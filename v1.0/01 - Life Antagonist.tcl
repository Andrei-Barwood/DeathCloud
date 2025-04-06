proc add_l {a_l b_l} {
    set CLINTMAXDIGIT 4096
    set BITPERDGT 16
    set BASE [expr {1 << $BITPERDGT}]

    set len_a [llength $a_l]
    set len_b [llength $b_l]

    if {$len_a < $len_b} {
        set aptr [lreverse $b_l]
        set bptr [lreverse $a_l]
    } else {
        set aptr [lreverse $a_l]
        set bptr [lreverse $b_l]
    }

    set result {}
    set carry 0
    set i 0

    
    foreach a $aptr b $bptr {
        set sum [expr {$a + $b + ($carry & ($BASE - 1))}]
        lappend result [expr {$sum & ($BASE - 1)}]
        set carry [expr {$sum >> $BITPERDGT}]
        incr i
    }

    
    foreach a [lrange $aptr $i end] {
        set sum [expr {$a + ($carry & ($BASE - 1))}]
        lappend result [expr {$sum & ($BASE - 1)}]
        set carry [expr {$sum >> $BITPERDGT}]
    }

    
    if {$carry > 0} {
        lappend result 1
    }

    
    set OFL 0
    if {[llength $result] > $CLINTMAXDIGIT} {
        set result [lrange $result 0 [expr {$CLINTMAXDIGIT - 1}]]
        set OFL 1
    }

    
    return [list $result $OFL]
}
