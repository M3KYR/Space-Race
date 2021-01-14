(load "juego.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; VENTANA PRINCIPAL

;; Ventana del menú principal
(define main-menu-frame (new frame%
                             [label "Space Race"]
                             [width 500]
                             [height 450]
                             [x 800]
                             [y 200]
                             [style '(no-resize-border)]
                             [alignment '(center top)]
                             [stretchable-width #f]	 
                             [stretchable-height #f]))

;; Panel principal
(define main-panel (new vertical-panel%
                        [parent main-menu-frame]
                        [alignment '(center top)]
                        [min-width 500]
                        [min-height 450]
                        [stretchable-width #f]	 
                        [stretchable-height #f]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; TÍTULO

;; Panel contenedor
(define title-panel (new panel%
                         [parent main-panel]
                         [alignment '(center center)]
                         [min-width 500]
                         [min-height 100]
                         [stretchable-width #f]	 
                         [stretchable-height #f]))

;; Canvas del título
(define title-canvas (new canvas%
                          [parent title-panel]
                          [style '(transparent)]
                          [min-width 500]	 
                          [min-height 100]
                          [stretchable-width #f]	 
                          [stretchable-height #f]
                          [paint-callback
                           (lambda (canvas dc)
                             (send dc set-scale 3 3)
                             (send dc set-text-foreground "black")
                             (send dc draw-text "SPACE RACE" 50 10))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CONTROLES DEL JUGADOR

;; Panel contenedor
(define controls-panel (new horizontal-panel%
                            [parent main-panel]
                            [alignment '(center center)]
                            [style '(border)]
                            [min-width 500]
                            [stretchable-width #f]	 
                            [stretchable-height #f]))

;; Panel de los controles del jugador 1
(define player1-controls-panel (new vertical-panel%
                                    [parent controls-panel]
                                    [style '(border)]
                                    [min-width 250]
                                    [alignment '(center center)]
                                    [stretchable-width #f]	 
                                    [stretchable-height #f]))

;; Texto de los controles del jugador 1
(define player1-controls-message (new message%
                                      [parent player1-controls-panel]
                                      [label "CONTROLES JUGADOR 1\n\nArriba: W\n\nAbajo: S"]))

;; Panel de los controles del jugador 2
(define player2-controls-panel (new vertical-panel%
                                    [parent controls-panel]
                                    [style '(border)]
                                    [min-width 250]
                                    [alignment '(center center)]
                                    [stretchable-width #f]	 
                                    [stretchable-height #f]))

;; Texto de los controles del jugador 2
(define player2-controls-message (new message%
                                      [parent player2-controls-panel]
                                      [label "CONTROLES JUGADOR 2\n\nArriba: UP-ARROW\n\nAbajo: DOWN-ARROW"]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; DIFICULTAD

;; Panel contenedor
(define difficulty-checkbox-panel (new horizontal-panel%
                                       [parent main-panel]
                                       [alignment '(center center)]
                                       [min-width 500]
                                       [min-height 50]
                                       [stretchable-width #f]	 
                                       [stretchable-height #f]))

;; Texto de Dificultad:
(define difficulty-message (new message%
                                [parent difficulty-checkbox-panel]
                                [label "Dificultad: "]))

;; Checkbox para el modo Fácil
(define easy-checkbox (new check-box%
                           [parent difficulty-checkbox-panel]
                           [label "Fácil"]
                           [callback (lambda (checkbox event)
                                       (if (send easy-checkbox get-value)
                                           (begin (send medium-checkbox set-value #f)
                                                  (send hard-checkbox set-value #f)
                                                  (set! MAX-METEORS 20)
                                                  (set! MIN-METEOR-SPEED 1))
                                           (send easy-checkbox set-value #t)))]))

;; Checkbox para el modo Normal
(define medium-checkbox (new check-box%
                             [parent difficulty-checkbox-panel]
                             [label "Normal"]
                             [value #t]
                             [callback (lambda (checkbox event)
                                         (if (send medium-checkbox get-value)
                                             (begin (send easy-checkbox set-value #f)
                                                    (send hard-checkbox set-value #f)
                                                    (set! MAX-METEORS 50)
                                                    (set! MIN-METEOR-SPEED 2))
                                             (send medium-checkbox set-value #t)))]))

;; Checkbox para el modo Difícil
(define hard-checkbox (new check-box%
                           [parent difficulty-checkbox-panel]
                           [label "Difícil"]
                           [callback (lambda (checkbox event)
                                       (if (send hard-checkbox get-value)
                                           (begin (send easy-checkbox set-value #f)
                                                  (send medium-checkbox set-value #f)
                                                  (set! MAX-METEORS 80)
                                                  (set! MIN-METEOR-SPEED 3))
                                           (send hard-checkbox set-value #t)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; RESOLUCIÓN

;; Función para actualizar los valores relacionados con la resolución de la pantalla
(define (update-resolution width height)
  (set! WIDTH width)
  (set! HEIGHT height)
  (set! SCALE (/ HEIGHT 900))
  (set! INITIAL-Y (- HEIGHT (/ HEIGHT 6)))
  (set! PLAYER1-INITIAL-X (+ 100 (/ WIDTH 4)))
  (set! PLAYER2-INITIAL-X (- WIDTH PLAYER1-INITIAL-X))
  (set! BACKGROUND (place-image (scale SCALE (rectangle 10 400 "solid" "white"))
                                (/ WIDTH 2)
                                (- INITIAL-Y 100)
                                (empty-scene WIDTH HEIGHT "black"))))

;; Panel contenedor
(define resolution-checkbox-panel (new horizontal-panel%
                                       [parent main-panel]
                                       [alignment '(center center)]
                                       [min-width 500]
                                       [min-height 50]
                                       [stretchable-width #f]	 
                                       [stretchable-height #f]))

;; Texto de Resolución:
(define resolution-message (new message%
                                [parent resolution-checkbox-panel]
                                [label "Resolución: "]))

;; Checkbox para 800x600
(define res1-checkbox (new check-box%
                         [parent resolution-checkbox-panel]
                         [label "800x600"]
                         [value #t]
                         [callback (lambda (checkbox event)
                                       (if (send res1-checkbox get-value)
                                           (begin (send res2-checkbox set-value #f)
                                                  (send res3-checkbox set-value #f)
                                                  (update-resolution 800 600))
                                           (send res1-checkbox set-value #t)))]))

;; Checkbox para 1280x720
(define res2-checkbox (new check-box%
                           [parent resolution-checkbox-panel]
                           [label "1280x720"]
                           [callback (lambda (checkbox event)
                                       (if (send res2-checkbox get-value)
                                           (begin (send res1-checkbox set-value #f)
                                                  (send res3-checkbox set-value #f)
                                                  (update-resolution 1280 720))
                                           (send res2-checkbox set-value #t)))]))

;; Checkbox para 1600x900
(define res3-checkbox (new check-box%
                           [parent resolution-checkbox-panel]
                           [label "1600x900"]
                           [callback (lambda (checkbox event)
                                       (if (send res3-checkbox get-value)
                                           (begin (send res1-checkbox set-value #f)
                                                  (send res2-checkbox set-value #f)
                                                  (update-resolution 1600 900))
                                           (send res3-checkbox set-value #t)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SCORE

;; Texto de advertencia
(define score-message (new message%
                           [parent main-panel]
                           [font small-control-font]
                           [label "Si la puntuación escogida es menor que 1 o no es un número, toma 10 como valor por defecto"]))

;; Panel contenedor
(define score-text-panel (new horizontal-panel%
                              [parent main-panel]
                              [alignment '(center center)]
                              [min-width 170]
                              [min-height 50]
                              [stretchable-width #f]	 
                              [stretchable-height #f]))

;; Campo de texto
(define score-text-field (new text-field%
                              [parent score-text-panel]
                              [label "Puntuación máxima:"]
                              [init-value (number->string 10)]
                              [callback (lambda (text-field event)
                                          (if (or (not (string->number (send text-field get-value))) (< (string->number (send text-field get-value)) 1))
                                              (set! MAX-SCORE 10)
                                              (set! MAX-SCORE (string->number (send text-field get-value)))))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BOTONES PRINCIPALES

;; Panel contenedor
(define button-panel (new horizontal-panel%
                          [parent main-panel]
                          [alignment '(center center)]
                          [min-width 500]
                          [min-height 50]
                          [stretchable-width #f]	 
                          [stretchable-height #f]))

;; Botón de Inicio
(define start-button (new button%
                          [label "INICIAR"]
                          [parent button-panel]
                          [callback (lambda (button event) (send main-menu-frame show #f) (game) (send main-menu-frame show #t))]))

;; Botón de Salir
(define exit-button (new button%
                         [label "SALIR"]
                         [parent button-panel]
                         [callback (lambda (button event) (exit))]))

;; Se hace visible la ventana principal
(send main-menu-frame show #t)