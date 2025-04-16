set CLINTMAXDIGIT 1024
set BITPERDGT 16
set E_CLINT_OK 0
set E_CLINT_OFL 1

proc cpy_l {dest src} {
    upvar $dest d $src s
    set d [list {*}$s]
}

proc EQZ_L {a} {
    expr {[lsearch -exact $a 0] == 0 && [llength $a] == 1}
}

proc SETZERO_L {a} {
    upvar $a var
    set var {0}
}

proc LSDPTR_L {a} {
    return 0
}

proc MSDPTR_L {a} {
    expr {[llength $a] - 1}
}

proc DIGITS_L {a} {
    expr {[llength $a]}
}

proc SETDIGITS_L {a digits} {
 
    upvar $a var
    set len [llength $var]
    if {$digits > $len} {
        for {set i $len} {$i < $digits} {incr i} {
            lappend var 0
        }
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

proc umul_l {aa_l b pp_l} {
    upvar $aa_l a $pp_l pp
    set OFL $::E_CLINT_OK

    set a_l [list {*}$a]
    if {[EQZ_L a_l] || $b == 0} {
        SETZERO_L pp
        return $::E_CLINT_OK
    }

    set p_l {}
    set carry 0

    set aptr_l 0
    set msdptra_l [MSDPTR_L a_l]

    for {set i 0} {$i <= $msdptra_l} {incr i} {
        set prod [expr {$b * [lindex $a_l $i] + ($carry & 0xFFFF)}]
        set carry [expr {$prod >> $::BITPERDGT}]
        lappend p_l [expr {$prod & 0xFFFF}]
    }

    lappend p_l [expr {$carry & 0xFFFF}]

    SETDIGITS_L p_l [expr {[llength $a_l] + 1}]
    RMLDZRS_L p_l

    if {[llength $p_l] > $::CLINTMAXDIGIT} {
        ANDMAX_L p_l
        set OFL $::E_CLINT_OFL
    }

    set pp [list {*}$p_l]
    return $OFL
}
