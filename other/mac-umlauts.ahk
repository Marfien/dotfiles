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
    UmlautTypingMode := false
}
+a:: {
    SendText "Ä" 
    UmlautTypingMode := false
}
o:: {
    SendText "ö"
    UmlautTypingMode := false
}
+o:: {
    SendText "Ö"
    UmlautTypingMode := false
}
u:: {
    SendText "ü"
    UmlautTypingMode := false
}
+u:: {
    SendText "Ü"
    UmlautTypingMode := false
}
s:: {
    SendText "ß" 
    UmlautTypingMode := false
}

#HotIf
