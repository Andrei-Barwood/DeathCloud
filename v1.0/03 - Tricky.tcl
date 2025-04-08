proc uadd_l {a_l b s_l_var} {
    # Convertir b a entero grande (implícito en Tcl)
    set tmp_l $b

    # Sumar a_l + tmp_l
    set sum [expr {$a_l + $tmp_l}]

    # Asignar el resultado a la variable por nombre
    upvar $s_l_var s_l
    set s_l $sum

    # Retornar 0 como código de éxito
    return 0
}
