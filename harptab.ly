\version "2.12.3"


#(define setKey #f)
#(define add-tab-numbers #f)


#(let ((HarpKey 0))
     (define (NoteEvent? music)
             (equal? (ly:music-property music 'name) 'NoteEvent))
     
     (define (EventChord? music)
             (equal? (ly:music-property music 'name) 'EventChord))
     
     (define* (blow hole #:optional (bends 0))
              (case bends
                ((0) (markup #:italic (string-append hole)))
                ((1) (markup #:italic (string-append hole "'")))
                ((2) (markup #:italic (string-append hole "''")))
                ((3) (markup #:italic (string-append hole "'''")))
                (else " ")))
     (define* (draw hole #:optional (bends 0))
              (case bends
                ((0) (markup #:italic (string-append "-" hole)))
                ((1) (markup #:italic (string-append "-" hole "'")))
                ((2) (markup #:italic (string-append "-" hole "''")))
                ((3) (markup #:italic (string-append "-" hole "'''")))
                (else " ")))
     
     (define (get-harmonica-tab NoteEvent)
             (case (- (- (ly:pitch-semitones (ly:music-property NoteEvent 'pitch)) HarpKey) 12)
                   ((-12) (blow "1"))
                   ((-11) (draw "1" 1))
                   ((-10) (draw "1"))
                   ;((-9) (overblow "1"))
                   ((-8) (blow "2"))
                   ((-7) (draw "2" 2))
                   ((-6) (draw "2" 1))
                   ((-5) (draw "2"))
                   ;((-5) (blow "3"))
                   ((-4) (draw "3" 3))
                   ((-3) (draw "3" 2))
                   ((-2) (draw "3" 1))
                   ((-1) (draw "3"))
                   ((0) (blow "4"))
                   ((1) (draw "4" 1))
                   ((2) (draw "4"))
                   ;((3) (overblow "4"))
                   ((4) (blow "5"))
                   ((5) (draw "5"))
                   ;((6) (overblow "5"))
                   ((7) (blow "6"))
                   ((8) (draw "6" 1))
                   ((9) (draw "6"))
                   ;((10) (overblow "6"))
                   ((11) (draw "7"))
                   ((12) (blow "7"))
                   ;((13) (overdraw "7"))
                   ((14) (draw "8"))
                   ((15) (blow "8" 1))
                   ((16) (blow "8"))
                   ((17) (draw "9"))
                   ((18) (blow "9" 1))
                   ((19) (blow "9"))
                   ;((20) (overdraw "9"))
                   ((21) (draw "10"))
                   ((22) (blow "10" 2))
                   ((23) (blow "10" 1))
                   ((24) (blow "10"))
                   (else (markup #:simple " "))))
     
     (define (make-tab-number NoteEvent)
             (make-music 'TextScriptEvent
               'direction UP
               'text (get-harmonica-tab NoteEvent)))
     
     (set! add-tab-numbers (lambda (music)
               (if (EventChord? music)
                   (set! (ly:music-property music 'elements)
                         (append (ly:music-property music 'elements)
                                 (let ((elems (ly:music-property music 'elements)))
                                      (map make-tab-number (filter NoteEvent? elems))))))
               music))
     
     (set! setKey (lambda (key)
               (set! HarpKey key))))

#(define HarmonicaTab
  (define-music-function
    (parser location key music)
    (number? ly:music?)
    (setKey key)
    (music-map add-tab-numbers music)))
