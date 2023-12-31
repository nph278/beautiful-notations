#lang racket

(require xml)
(require css-expr)

(struct entry (title summary links image))

(define title "Beautiful Notations")
(define summary "A collection of concise and asthetic notations")
(define favicon "./images/favicon.png")
(define source-link "https://github.com/nph278/beautiful-notations")

(define entries
  (map (lambda (x) (apply entry x))
       '(("Lambda Diagrams"
          "An elagant notation for lambda calculus expressions. A horizontal line repesents a lambda binding. A vertical line coming from one represents a instance of that variable. Joining two values with a horizontal connector represents application."
          ("https://tromp.github.io/cl/diagrams.html"
           "https://en.wikipedia.org/wiki/Lambda_calculus")
          "lambda.gif")
         ("Canadian Aboriginal Syllabics"
          "An abugita used for indeginous languages in Canada. Each consonant is assigned a symbol. The symbol will be rotated based on what vowel comes after it."
          ("https://en.wikipedia.org/wiki/Canadian_Aboriginal_syllabics"
           "https://en.wikipedia.org/wiki/Abugida")
          "syllabics.jpg")
         ("Cistercian Numerals"
          "A system of numerals developed by monks in the 13th century. It can represent numbers up to 9999 with one glyph. Each glyph is a vertical line with a base-10 numeral in each corner. This gives it a sub-base of 10."
          ("https://en.wikipedia.org/wiki/Cistercian_numerals")
          "cistercian.png")
         ("Kaktovik Numerals"
          "A base-20 system of numerals originally used for the Iñupiaq language, invented by students in Kaktovik, Alaska. It uses vertical lines for ones, and horizontal lines for fives, giving a sub-base of five."
          ("https://en.wikipedia.org/wiki/Kaktovik_numerals")
          "kaktovik.png")
         ("Hangul (Korean Alphabet)"
          "The alphabet used for writing Korean. It was designed in 1443 by King Sejong the Great. It has simple symbols for consonants and vowels, and each syllable is organized into a block. The shapes for the letters are based on the shape that the mouth makes when making that sound."
          ("https://en.wikipedia.org/wiki/Hangul"
           "https://en.wikipedia.org/wiki/Sejong_the_Great")
          "hangul.png")
         ("Coxeter-Dynkin Diagrams"
          "A notation for describing collections of mirrors. Each node represents a mirror, and each edge represents a joining of two mirrors. The number on an edge represents the fraction of 180 degrees that the connection of the mirrors has an angle of. If nodes are not connected by an edge, the angle is 90 degrees. If they are connected by an unlabeled edge, the angle is 60 degrees. Each collection can be used to create a mathematical group."
          ("https://en.wikipedia.org/wiki/Coxeter%E2%80%93Dynkin_diagram"
           "https://en.wikipedia.org/wiki/Coxeter_group")
          "coxeter.png")
         ("Symmetric Interaction Combinators / Interaction Nets"
          "A graph-based system of representing computations. There are simple symmetric rules for reducing patterns within a graph. Lambda calculus expressions can be converted into interaction nets."
          ("https://zicklag.github.io/blog/interaction-nets-combinators-calculus/"
           "https://en.wikipedia.org/wiki/Lambda_calculus")
          "interaction.webp")
         ("Feynman Diagrams"
          "A representation of interactions of subatomic particles. Space varies vertically. Time varies horizontally. Electrons are repesented by arrows. Photons are wavy lines. Gluons are spring-like lines. Other particles are represented by different kinds of lines."
          ("https://en.wikipedia.org/wiki/Feynman_diagram")
          "feynman.png")
         ("Vonnegut Story Diagrams"
          "A representation of the plot of a story. The vertical axis represents how good the situation is. The horizontal axis represents time."
          ("https://www.eadeverell.com/character-arc/")
          "vonnegut.png")
         ("Piet"
          "Piet is a stack-oriented programming language that uses a 2d array of color to represent programs."
          ("https://esolangs.org/wiki/Piet")
          "piet.gif"))))

(define (entry->xexpr entry)
  `(div ((class "entry"))
        (h2 ,(entry-title entry))
        (img ((src ,(string-append "./images/" (entry-image entry))) (alt ,(entry-title entry))))
        (p ,(entry-summary entry))
        (ul ((class "link-list"))
            ,@(map (lambda (url)
                     `(li (a ((href ,url)) ,url)))
                   (entry-links entry)))))

(define css
  (css-expr->css
   '([body
      #:color white
      #:background black
      #:font-family monospace]
     [a
      #:color cyan
      #:word-break break-word]
     [a:visited
      #:color lime]
     [.entry
      #:padding 1em
      #:margin-top 1em
      #:border (2px white solid)
      [img
       #:max-height 10em
       #:max-width 100%
       #:height auto
       #:width auto
       #:border (2px white solid)
       #:background white]]
     [.link-list
      #:list-style-type none
      #:margin 0
      #:padding 0])))

(define html
  (string-append
   "<!DOCTYPE html>"
   (xexpr->string
    `(html ((lang "en"))
           (head (meta ((charset "UTF-8")))
                 (meta ((name "viewport")
                        (content "width=device-width,initial-scale=1")))
                 (meta ((name "description")
                        (content ,summary)))
                 (link ((rel "icon")
                        (type "image/gif")
                        (href ,favicon)))
                 (title ,title)
                 (style ,css))
           (body (h1 ,title)
                 (p ,summary)
                 (p (a ((href ,source-link)) "Source code"))
                 ,@(map entry->xexpr entries))))))

(call-with-output-file "./index.html"
  (lambda (port)
    (write-string html port))
  #:exists 'replace)
