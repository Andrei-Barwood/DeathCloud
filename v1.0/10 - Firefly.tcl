# Helper constants
set BITPERDGT 16
set USHORT_MASK 0xFFFF
set CLINTMAXDIGIT 256

# Helper procedures
proc cpy_l {dest src} {
    upvar $dest d $src s
    set d [lrange $s 0 end]
}

proc EQZ_L {a} {
    expr {[lindex $a 0] == 0 && [llength $a] == 1}
}

proc SETZERO {a} {
    upvar $a var
    set var {0}
}

proc NSDPTR_L {a} {
    set i [expr {[llength $a] - 1}]
    while {$i > 0 && [lindex $a $i] == 0} { incr i -1 }
    return $i
}

proc LSDPTR_L {a} {
    return 0
}

proc DIGITS_L {a} {
    return [llength $a]
}

proc SETDIGITS {a n} {
    upvar $a var
    set len [llength $var]
    if {$n > $len} {
        for {set i $len} {$i < $n} {incr i} {
            lappend var 0
        }
    } else {
        set var [lrange $var 0 [expr {$n - 1}]]
    }
}

proc RMLDZRS_L {a} {
    upvar $a var
    while {[llength $var] > 1 && [lindex $var end] == 0} {
        set var [lrange $var 0 end-1]
    }
}

proc ANDMAX_L {a} {
    upvar $a var
    set var [lrange $var 0 [expr {$::CLINTMAXDIGIT - 1}]]
}

proc sqr_l {f_l_name pp_l_name} {
    upvar $f_l_name f_l $pp_l_name pp_l
    set OFL 0
    set a_l $f_l
    if {[EQZ_L $a_l]} {
        SETZERO pp_l
        return 0
    }

    set p_l {}
    SETDIGITS p_l [expr {[DIGITS_L $a_l] * 2}]

    set msdptrb_l [NSDPTR_L $a_l]
    set msdptra_l [expr {$msdptrb_l - 1}]

    # Init result with zero
    for {set i 0} {$i < [expr {[DIGITS_L $a_l] * 2 + 2}]} {incr i} {
        lappend p_l 0
    }

    set carry 0
    set av [lindex $a_l 0]
    for {set i 1} {$i <= $msdptrb_l} {incr i} {
        set b [lindex $a_l $i]
        set product [expr {($av * $b + ($carry & $::USHORT_MASK)) & 0xFFFFFFFF}]
        set p_l [lreplace $p_l $i $i [expr {$product & $::USHORT_MASK}]]
        set carry [expr {$product >> $::BITPERDGT}]
    }
    lset p_l [expr {$msdptrb_l + 1}] [expr {$carry & $::USHORT_MASK}]

    for {set i 1} {$i <= $msdptra_l} {incr i} {
        set carry 0
        set av [lindex $a_l $i]
        for {set j [expr {$i + 1}]; set k [expr {$2 * $i + 1}]} {$j <= $msdptrb_l} {incr j; incr k} {
            set product [expr {$av * [lindex $a_l $j] + [lindex $p_l $k] + ($carry & $::USHORT_MASK)}]
            lset p_l $k [expr {$product & $::USHORT_MASK}]
            set carry [expr {$product >> $::BITPERDGT}]
        }
        lset p_l [expr {$2 * $i + 1 + $msdptrb_l - $i}] [expr {$carry & $::USHORT_MASK}]
    }

    set carry 0
    for {set i 0} {$i <= [expr {$msdptrb_l * 2 + 1}]} {incr i} {
        set val [expr {([lindex $p_l $i] << 1) + ($carry & $::USHORT_MASK)}]
        lset p_l $i [expr {$val & $::USHORT_MASK}]
        set carry [expr {$val >> $::BITPERDGT}]
    }
    lset p_l [expr {$msdptrb_l * 2 + 2}] [expr {$carry & $::USHORT_MASK}]

    set carry 0
    for {set i 0} {$i <= $msdptrb_l} {incr i} {
        set square [expr {[lindex $a_l $i] * [lindex $a_l $i] + [lindex $p_l [expr {2 * $i}]] + ($carry & $::USHORT_MASK)}]
        lset p_l [expr {2 * $i}] [expr {$square & $::USHORT_MASK}]
        set carry [expr {$square >> $::BITPERDGT}]
        set temp [expr {[lindex $p_l [expr {2 * $i + 1}]] + ($carry & $::USHORT_MASK)}]
        lset p_l [expr {2 * $i + 1}] [expr {$temp & $::USHORT_MASK}]
        set carry [expr {$temp >> $::BITPERDGT}]
    }

    SETDIGITS p_l [expr {[DIGITS_L $a_l] * 2}]
    RMLDZRS_L p_l
    if {[DIGITS_L $p_l] > $::CLINTMAXDIGIT} {
        ANDMAX_L p_l
        set OFL 1
    }
    cpy_l pp_l p_l
    return $OFL
}
