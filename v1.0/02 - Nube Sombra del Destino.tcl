proc sub_l {aa_l bb_l} {
    set CLINTMAXDIGIT 4096
    set BITPERDGT 16
    set BASE [expr {1 << $BITPERDGT}]

    set a_l [lreverse $aa_l]
    set b_l [lreverse $bb_l]

    
    while {[llength $a_l] < [llength $b_l]} { lappend a_l 0 }
    while {[llength $b_l] < [llength $a_l]} { lappend b_l 0 }

    set UFL 0
    set d_l {}
    set carry 0

    
    if {[compare_l $a_l $b_l] < 0} {
        set a_l [setmax_l $CLINTMAXDIGIT]
        set UFL 1
    }

    
    for {set i 0} {$i < [llength $a_l]} {incr i} {
        set a [lindex $a_l $i]
        set b [expr {$i < [llength $b_l] ? [lindex $b_l $i] : 0}]
        set sub [expr {$a - $b - (($carry & $BASE) >> $BITPERDGT)}]
        if {$sub < 0} {
            set sub [expr {$sub + $BASE}]
            set carry $BASE
        } else {
            set carry 0
        }
        lappend d_l [expr {$sub & ($BASE - 1)}]
    }

    
    while {[llength $d_l] > 1 && [lindex $d_l end] == 0} {
        set d_l [lrange $d_l 0 end-1]
    }

    
    if {$UFL} {
        set res [add_l $d_l $aa_l]
        set d_l [inc_l [lindex $res 0]]
    }

    return [list [lreverse $d_l] $UFL]
}

proc compare_l {a b} {
    set la [llength $a]
    set lb [llength $b]
    if {$la != $lb} {
        return [expr {$la - $lb}]
    }
    for {set i [expr {$la - 1}]} {$i >= 0} {incr i -1} {
        set ai [lindex $a $i]
        set bi [lindex $b $i]
        if {$ai != $bi} {
            return [expr {$ai - $bi}]
        }
    }
    return 0
}

proc setmax_l {digits} {
    set maxlist {}
    for {set i 0} {$i < $digits} {incr i} {
        lappend maxlist 65535
    }
    return $maxlist
}

proc inc_l {l} {
    set BITPERDGT 16
    set BASE [expr {1 << $BITPERDGT}]
    set l [lreverse $l]
    set carry 1
    set result {}
    foreach d $l {
        set sum [expr {$d + $carry}]
        lappend result [expr {$sum & ($BASE - 1)}]
        set carry [expr {$sum >= $BASE ? 1 : 0}]
    }
    if {$carry > 0} {
        lappend result 1
    }
    return [lreverse $result]
}
