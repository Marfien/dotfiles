global UmlautTypingMode := false

Timeout() {
    global UmlautTypingMode
    UmlautTypingMode := false
}

!u:: {
    global UmlautTypingMode
    UmlautTypingMode := true
    SetTimer(Timeout, -2000)
}

!s:: {
    SendText "ß"
}

#HotIf UmlautTypingMode

a:: {
    SendText "ä"
    global UmlautTypingMode
    UmlautTypingMode := false
}
+a:: {
    SendText "Ä" 
    global UmlautTypingMode
    UmlautTypingMode := false
}
o:: {
    SendText "ö"
    global UmlautTypingMode
    UmlautTypingMode := false
}
+o:: {
    SendText "Ö"
    global UmlautTypingMode
    UmlautTypingMode := false
}
u:: {
    SendText "ü"
    global UmlautTypingMode
    UmlautTypingMode := false
}
+u:: {
    SendText "Ü"
    global UmlautTypingMode
    UmlautTypingMode := false
}

#HotIf
