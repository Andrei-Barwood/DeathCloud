proc mul_l {f1_l f2_l pp_l} {
    set OFL 0
    if {[string equal $f1_l "0"] || [string equal $f2_l "0"]} {
        set pp_l "0"
        return 0
    }


    set aa_l $f1_l
    set bb_l $f2_l


    if {[string length $aa_l] < [string length $bb_l]} {
        set a_l $bb_l
        set b_l $aa_l
    } else {
        set a_l $aa_l
        set b_l $bb_l
    }


    set carry 0
    set result ""


    for {set i 0} {$i < [string length $b_l]} {incr i} {
        set b_digit [string index $b_l $i]
        set partial_sum ""
        for {set j 0} {$j < [string length $a_l]} {incr j} {
            set a_digit [string index $a_l $j]
            set product [expr {[scan $a_digit %d] * [scan $b_digit %d] + $carry}]
            append partial_sum [format "%d" $product]
            set carry [expr {$product / 10}]
        }
        append result $partial_sum
    }


    append result $carry


    regsub {^0+} $result "" pp_l


    if {[string length $pp_l] > 100} { 
        set OFL 1
        set pp_l [string range $pp_l 0 99]
    }

    return $OFL
}
