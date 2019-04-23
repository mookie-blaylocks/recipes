#lang racket

(require racket/gui/base)

(define frame (new frame% [label "Example"]))

(define msg (new message% [parent frame]
                 [label "No events so far..."]))

(new button% [parent frame]
     [label "Click Me"]
     [callback (lambda (button event)
                 (send msg set-label "Button-click"))])

(define my-canvas%
  (class canvas% ; The base class is canvas%
    ; Define the overriding method to handle mouse events
    (define/override (on-event event)
      (send msg set-label "Canvas mouse"))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (send msg set-label "Canvas keyboard"))
    ; Call the superclass init, passing on all init args
    (super-new)))

(new my-canvas% [parent frame])

(new button% [parent frame]
     [label "Pause"]
     [callback (lambda (button event) (sleep 5))])

(define panel (new horizontal-panel% [parent frame]))
(new button% [parent panel]
     [label "Left"]
     [callback (lambda (button event)
                 (send msg set-label "Left click"))])
(new button% [parent panel]
     [label "Right"]
     [callback (lambda (button event)
                 (send msg set-label "Right click"))])

(define frame2 (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))

(new canvas% [parent frame2]
     [paint-callback
      (lambda (canvas dc)
        (send dc set-scale 3 3)
        (send dc set-text-foreground "blue")
        (send dc draw-text "Don't Panic!" 0 0))])

(send frame2 show #f)

(send frame show #f)


