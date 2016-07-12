(define list-index-item
  (lambda (pred lst idx)
    (if (>= idx (length lst))
        #f
        (if (pred (list-ref lst idx))
            idx
            (list-index-item pred lst (+ idx 1))))))
(define list-index
  (lambda(pred lst)
    (list-index-item pred lst 0)))

(list-index number? '(a 2 (1 3) b 7))
(list-index symbol? '(a (b c) 17 foo))
(list-index symbol? '(1 2 (a b) 3))