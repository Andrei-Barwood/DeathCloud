source "01 - Songs.tcl"
source "02 - Dark Song.tcl"
source "03 - Internal Mirror.tcl"
source "04 - Black Wings.tcl"
source "05 - Infinity Upward.tcl"

proc kmul {aptr_l bptr_l len_a len_b p_l} {
    global CLINTMAXSHORT MUL_THRESHOLD

    if {$len_a == $len_b && $len_a >= $MUL_THRESHOLD && ($len_a % 2) == 0} {
        set l2 [expr {$len_a / 2}]

        set a1ptr_l [lrange $aptr_l $l2 end]
        set b1ptr_l [lrange $bptr_l $l2 end]

        set c0_l {}
        kmul $aptr_l $bptr_l $l2 $l2 c0_l

        set c1_l {}
        kmul $a1ptr_l $b1ptr_l $l2 $l2 c1_l

        set c01_l {}
        addkar $a1ptr_l $aptr_l $l2 c01_l
        addkar $b1ptr_l $bptr_l $l2 c01_l

        set c10_l {}
        
        set c01_copy $c01_l
        addkar $b1ptr_l $bptr_l $l2 c01_copy

        set c2_l {}
        kmul [lrange $c01_l 0 end] [lrange $c10_l 0 end] [llength $c01_l] [llength $c10_l] c2_l

        set tmp_l {}
        sub $c2_l $c1_l tmp_l
        sub $tmp_l $c0_l c2_l

        set tmp_l {}
        shiftadd $c1_l $c2_l $l2 tmp_l
        shiftadd $tmp_l $c0_l $l2 p_l
    } else {
        
        set c1_l [lrange $aptr_l 0 [expr {$len_a - 1}]]
        set c2_l [lrange $bptr_l 0 [expr {$len_b - 1}]]

        
        set digits_c1 [llength $c1_l]
        set digits_c2 [llength $c2_l]
        set p_l [mult $c1_l $c2_l $len_b]
        
    }
}




set CLINTMAXSHORT 100
set MUL_THRESHOLD 10

