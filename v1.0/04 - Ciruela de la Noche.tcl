proc usub_l {a_l b d_l_var} {
    set tmp_l $b
    set diff [expr {$a_l - $tmp_l}]
    upvar $d_l_var d_l
    set d_l $diff
    return 0
}
