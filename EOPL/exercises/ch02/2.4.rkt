(define empty-stack
  (lambda ()
    '()))
(define empty-stack?
  (lambda (stack)
    (equal? stack '())))
(define push
  (lambda (stack item)
    (cons item stack)))
(define top
  (lambda (stack)
    (car stack)))
(define pop
  (lambda (stack)
    (if (empty-stack? stack)
        (fprintf (current-error-port)  "stack is empty,can't pop")
        (cdr stack))))