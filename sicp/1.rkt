(define (average x y) 
  (/ (+ x y) 2)) 
(define (square x)
  (* x x))
(define (improve guess x)
  (average guess (/ x guess)))
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))
(define (sqrt x)
  (sqrt-iter 1.0 x))


(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

(define (factorial n)
  (define (fact-iter product counter)
    (if (> counter n)
        product
        (fact-iter (* counter product)
                   (+ counter 1))))
  (fact-iter 1 1))

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))


(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))


(define (fib n)
  (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (count-change amount)
  (cc amount 5))
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))   

(define (cube x)
  (* x x x))
(define (p x)
  (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))


(define (expt b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b (- counter 1) (* product b))))

(define (expt b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b (- counter 1) (* product b))))

(define (square x) (* x x))
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

                                                                   

(define (divides? a b)
  (= (remainder b a) 0))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (square x)
  (* x x))
(define (prime? n)
  (= n (smallest-divisor n)))


  (define (sum-integers a b)
  (if (> a b)
      0
      (+ a (sum-integers (+ a 1) b))))
(define (cube x) (* x x x))
(define (sum-cubes a b)
  (if (> a b)
      0
      (+ (cube a) (sum-cubes (+ a 1) b))))
(define (pi-sum a b)
  (if (> a b)
      0
      (+ (/ 1.0  (* a (+ a 2))) (pi-sum (+ a 4) b))))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b))


(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b))
(define (cube x) (* x x x))
(define (identity x) x)
(define (sum-integers a b)
  (sum identity a inc b))
(define (pi-term x)
  (/ 1.0 (* x (+ x 2))))
(define (pi-next x)
  (+ x 4))
(define (pi-sum a b)
  (sum pi-term a pi-next b))


#lang racket

(define (sum term a next  b )
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
(define (inc n) (+ n 1))
(define (identity x) x)
(define (sum-integers a b)
  (sum  identity a inc b ))
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) 
     dx))
(define cube (lambda (x) (* x x x)))
(define (integral1 f a b n)
  (define (h) (/ (- b a) n))
  (define (integral-term-idx i)
    (cond ((or (= i 0) (= i n)) 1)
          ((even? i) 2)
          (else 4)))       
  (define (integral-term i) (* (integral-term-idx i)
                               (f (+ (* i h) a))))
  (* (sum integral-term 0 inc n) (/ h 3)))  