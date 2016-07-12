(define empty-stack
  (lambda()
    (lambda (cmd)
      (cond
        ((eqv? cmd 'top)
         (display "try top on empty stack"))
        ((eqv? cmd 'pop)
         (display "try pop on empty stack"))
        (else
         (display "unknow cmd on stack"))))))
(define push
  (lambda (saved-stack var)
    (lambda (cmd)
      (cond
        ((eqv? cmd 'top) var)
        ((eqv? cmd 'pop) saved-stack)
        (else
         (display "error cmd"))))))
(define pop
  (lambda (stack)
    (stack 'pop)))
(define top
  (lambda (stack)
    (stack 'top)))
(define e(empty-stack))
(define x1 (push e 1))
(define x2 (push x1 2))
(top x2)