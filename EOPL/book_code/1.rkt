(define in-S?
  (lambda (n)
    (if (zero? n)
        #t
        (if (>= (- n 3) 0)
            (in-S? (- n 3))
            #f))))

(define list-length
  (lambda (lst)
    (if (null? lst)
        0
        (+ 1 (list-length (cdr lst))))))

(define nth-element
  (lambda (lst n)
    (if (null? lst)
        (fprintf (current-error-port) "nth-element:List too short by ~s elements.~% " (+ n 1))
        (if (zero? n)
            (car lst)
            (nth-element (cdr lst) (- n 1))))))

(define remove-first
  (lambda (s los)
    (if (null? los)
        '()
        (if (eqv? (car los) s)
            (cdr los)
            (cons (car los) (remove-first s (cdr los)))))))                  

(define occurs-free?
  (lambda (var exp)
    (cond 
      ((symbol? exp) (eqv? var exp))
      ((eqv? (car exp) 'lambda)
       (and 
        (not (eqv? var (car (cadr exp))))
        (occurs-free? var (caddr exp))))
      (else
       (or
        (occurs-free? var (car exp))
        (occurs-free? var (cadr exp)))))))



(define subst
  (lambda (new old slist)
    (cond ((null? slist)  '())
          ((not (pair? slist)) slist)
          (else (cons (if (eqv? (car slist) old)
                          new
                          (subst new old (car slist)))  (subst new old (cdr slist)))))))

(define subst
  (lambda (new old slist)
    (if (null? slist)
        '()
        (cons 
         (subst-in-s-exp new old (car slist))
         (subst new old (cdr slist))))))
(define subst-in-s-exp
  (lambda (new old sexp)
    (if (symbol? sexp)
        (if (eqv? sexp old) new sexp)
        (subst new old sexp))))
                               
(define number-elements-from 
  (lambda (lst n)
    (if (null? lst)
        '()
        (cons (list n (car lst))
              (number-elements-from (cdr lst) (+ n 1))))))
(define number-elements
  (lambda (lst)
    (number-elements-from lst 0)))

(define list-sum
  (lambda (loi)
   (if (null? loi)
       0
       (+ (car loi) (list-sum (cdr loi))))))


(define partial-vector-sum
  (lambda (v n)
    (if (zero? n)
        (list-ref v 0)
        (+ (list-ref v n) (partial-vector-sum v (- n 1))))))
(define vector-sum
  (lambda (v)
    (let ([n (length v)])
    (if (zero? n)
        0
        (partial-vector-sum v (- n 1))))))                                                         