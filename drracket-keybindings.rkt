#lang s-exp framework/keybinding-lang
;; ============================================================================
;; DrRacket Custom Keybindings
;; 
;; Features:
;; - Send code to REPL (Emacs-style)
;; ============================================================================

(require drracket/tool-lib)
(module test racket/base)

;; ============================================================================
;; Send Code to REPL
;; ============================================================================

;; Ctrl+C, Ctrl+E: Send current expression to REPL
(keybinding "c:c;c:e" 
  (lambda (ed evt) (send-toplevel-form ed #f)))

;; Ctrl+C, Ctrl+R: Send selection to REPL
(keybinding "c:c;c:r" 
  (lambda (ed evt) (send-selection ed #f)))

;; Ctrl+C, Alt+E: Send expression and focus REPL
(keybinding "c:c;~c:m:e" 
  (lambda (ed evt) (send-toplevel-form ed #t)))

;; Ctrl+C, Alt+R: Send selection and focus REPL
(keybinding "c:c;~c:m:r" 
  (lambda (ed evt) (send-selection ed #t)))

;; ============================================================================
;; Helper Functions for Send to REPL
;; ============================================================================

(define/contract (send-toplevel-form defs shift-focus?)
  (-> any/c boolean? any)
  (when (is-a? defs drracket:unit:definitions-text<%>)
    (define sp (send defs get-start-position))
    (when (= sp (send defs get-end-position))
      (cond
        [(send defs find-up-sexp sp)
         ;; Find the top-level expression
         (let loop ([pos sp])
           (define next-up (send defs find-up-sexp pos))
           (cond
             [next-up (loop next-up)]
             [else
              (send-range-to-repl defs pos
                                  (send defs get-forward-sexp pos)
                                  shift-focus?)]))]
        [else
         ;; At top-level, find nearest expression
         (define fw (send defs get-forward-sexp sp))
         (define bw (send defs get-backward-sexp sp))
         (cond
           [(and (not fw) (not bw)) (void)]
           [(not fw)
            (send-range-to-repl defs bw
                                (send defs get-forward-sexp bw)
                                shift-focus?)]
           [else
            (send-range-to-repl defs
                                (send defs get-backward-sexp fw)
                                fw
                                shift-focus?)])]))))

(define/contract (send-selection defs shift-focus?)
  (-> any/c boolean? any)
  (when (is-a? defs drracket:unit:definitions-text<%>)
    (send-range-to-repl defs
                        (send defs get-start-position)
                        (send defs get-end-position)
                        shift-focus?)))

(define/contract (send-range-to-repl defs start end shift-focus?)
  (->i ([defs (is-a?/c drracket:unit:definitions-text<%>)]
        [start exact-positive-integer?]
        [end (start) (and/c exact-positive-integer? (>=/c start))]
        [shift-focus? boolean?])
       any)
  (unless (= start end)
    (define ints (send (send defs get-tab) get-ints))
    (define frame (send (send defs get-tab) get-frame))
    
    ;; Copy expression to interactions
    (send defs move/copy-to-edit
          ints start end
          (send ints last-position)
          #:try-to-move? #f)
    
    ;; Remove trailing whitespace
    (let loop ()
      (define last-pos (- (send ints last-position) 1))
      (when (last-pos . > . 0)
        (define last-char (send ints get-character last-pos))
        (when (char-whitespace? last-char)
          (send ints delete last-pos (+ last-pos 1))
          (loop))))
    
    ;; Add newline
    (send ints insert "\n" (send ints last-position) (send ints last-position))
    
    ;; Show interactions and execute
    (send frame ensure-rep-shown ints)
    (when shift-focus? (send (send ints get-canvas) focus))
    (send ints do-submission)))