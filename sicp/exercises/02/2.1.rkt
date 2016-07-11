(define (norm x y)
  (cond ((and (> x 0) (> y 0)) (cons x y))
         ((and (> x 0) (< y 0)) (cons (- x) (- y)))
         ((and (< x 0) (> y 0)) (cons x y))
         ((and (< x 0) (< y 0)) (cons (- x) (- y)))
         (else (cons x y))))
(define (make-rat n d) 
  (let ((g (gcd n d)))
  (norm (/ n g) (/ d g))))