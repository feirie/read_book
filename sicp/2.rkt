(define (make-rat n d) 
  (let ((g (gcd n d)))
  (cons (/ n g) (/ d g))))
(define (norm x y)
    )

(define (number x) (car x))
(define (denom x) (cdr x))
(define  (print-rat x)
  (newline)
  (display (number x))
  (display "/")
  (display (denom x))
  )
(define (add-rat x y)
  (make-rat (+ (* (number x) (denom y))
               (* (number y) (denom x)))
            (* (denom x) (denom y))))
(define (sub-rat x y)
  (make-rat (- (* (number x) (denom y))
               (* (number y) (denom x)))
            (* (denom x) (denom y))))
(define (mul-rat x y)
  (make-rat (* (number x) (number y))
            (* (denom x) (denom y))))
(define (div-rat x y)
  (make-rat (* (number x) (denom y)
            (* (denom x) (number y)))))

(define (equal-rat? x y)
  (= (* (number x) (denom y)
            (* (denom x) (number y)))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define one-half (make-rat 1 2))
(define one-third (make-rat 1 3))
(print-rat (add-rat one-half one-third))
(print-rat (mul-rat one-half one-third))
(print-rat (add-rat one-third one-third))


(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1 -- CONS" m))))
  dispatch)
(define (car z) (z 0))
(define (cdr z) (z 1))
(define a (cons 1 2))
(car a)

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (test g . w)
  (display w))

(define (reverse lst)
  (iter lst '()))
(define (iter remained-items result)
  (if (null? remained-items)
      result
      (iter (cdr remained-items)
            (cons (car remained-items) result))))
(define (same-parity first . other)
  (cons first
        (filter (if (even? first)
                    even?
                    odd?)
                other)
        ))


(define (map proc items)
  (if (null? items)
      null
      (cons (proc (car items))
            (map proc (cdr items)))))

            
(define s2 (list (list 7)))


(define (scale-tree tree factor)
  (cond ((null? tree) null)
        ((not (pair? tree)) (* tree factor))
        (else (cons (scale-tree (car tree) factor)
                    (scale-tree (cdr tree) factor)))))
(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree facotr))))
  tree)

(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)) 10)

(define (atom? exp)
  (not (cons? exp)))
(define (deriv exp var)
  (cond ((constant? exp var) 0)
        ((same-var? exp var) 1)
        ((sum? exp)
         (make-sum (deriv (a1 exp) var)
                   (deriv (a2 exp) var)))
        ((product? exp)
         (make-sum 
          (make-product (m1 exp)
                        (deriv (m2 exp) var))
          (make-product (m2 exp)
                        (deriv (m1 exp) var))))))

(define (constant? exp var)
  (and (atom? exp)
       (not (eq? exp var))))
(define (same-var? exp var)
  (and (atom? exp)
       (eq? exp var)))
(define (sum? exp)
  (and (not (atom? exp))
       (eq? (car exp) '+)))
(define (make-sum a1 a2)
  (cond ((and (number? a1)
              (number? a2))
         (+ a1 a2))
        ((and (number? a1)
              (= a1 0))
         a2)
        ((and (number? a2)
              (= a2 0))
         a1)
        (else
             (list '+ a1 a2))))
(define a1 cadr)
(define a2 caddr)
(define (product? exp)
  (and (not (atom? exp))
       (eq? (car exp) '*)))
(define (make-product m1 m2)
  (cond ((and (number? m1)
              (number? m2))
         (* m1 m2))
        ((and (number? m1)
              (= m1 1))
         m2)
        ((and (number? m2)
              (= m2 1))
         m1)
        ((and (number? m1)
              (= m1 0))
         0)
        ((and (number? m2)
              (= m2 0))
         0)
        (else
             (list '* m1 m2))))
(define m1 cadr)
(define m2 caddr)
(define foo
  '(+ (* a (* x x))
      (* b x)
      c))
