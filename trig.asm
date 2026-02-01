; === TRIG FUNCTIONS - REMOVED ===
; CHANGE: SIN, COS, TAN, ATN removed to save ~100 bytes
; These functions now point to NOFUNC which returns ILLEGAL QUANTITY error
; 
; The function dispatch table still has entries for these functions
; (for token compatibility) but they all point to NOFUNC in kernal_stubs.asm
