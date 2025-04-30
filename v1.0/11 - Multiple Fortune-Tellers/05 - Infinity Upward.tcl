proc mult {a b len_b} {
    set product_list [list 0]
    set i 0

    foreach digit_b $b {
        set temp_product {}
        set carry 0
        set j 0

        foreach digit_a $a {
            set product [expr {$digit_a * $digit_b + $carry}]
            lappend temp_product [expr {$product % 10}]
            set carry [expr {$product / 10}]
            incr j
        }
        if {$carry > 0} {
            lappend temp_product $carry
        }


        for {set k 0} {$k < $i} {incr k} {
            linsert temp_product 0 0
        }


        set product_list_temp {}
        addkar $product_list $temp_product [expr {[llength $product_list] > [llength $temp_product] ? [llength $temp_product] : [llength $product_list]}] product_list_temp
        set product_list $product_list_temp

        incr i
    }
    return $product_list
}