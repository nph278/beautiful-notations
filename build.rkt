#lang racket

(require xml)

(struct entry (title summary links image))

(define title "Beautiful Notations")
(define summary "A collection of concise and asthetic notations")
(define favicon "/images/favicon.png")

(define entries
  (map (lambda (x) (apply entry x))
       '(("Lambda Diagrams"
          "An elagant notation for lambda calculus expressions. A horizontal line repesents a lambda binding. A vertical line coming from one represents a instance of that variable. Joining two values with a horizontal connector represents application."
          ("https://tromp.github.io/cl/diagrams.html")
          "lambda.gif")
         ("Canadian Aboriginal Syllabics"
          "An abugita used for indeginous languages in Canada. Each consonant is assigned a symbol. The symbol will be rotated based on what vowel comes after it."
          ("https://en.wikipedia.org/wiki/Canadian_Aboriginal_syllabics"
           "https://en.wikipedia.org/wiki/Abugida")
          "syllabics.jpg")
         ("Cistercian Numerals"
          "A system of numerals developed by monks in the 13th century. It can represent numbers up to 9999 with one glyph. Each glyph is a vertical line with a base-10 numeral ijn each corner."
          ("https://en.wikipedia.org/wiki/Cistercian_numerals")
          "cistercian.png")
         ("Kaktovik Numerals"
          "A base-20 system of numerals originally used for the Iñupiaq language, invented by students in Kaktovik, Alaska. It uses vertical lines for ones, and horizontal lines for fives, giving a sub-base of five."
          ("https://en.wikipedia.org/wiki/Kaktovik_numerals")
          "kaktovik.png")
         ("Hangul (Korean Alphabet)"
          "The alphabet used for writing Korean. It was designed in 1443 by King Sejong the Great. It has simple symbols for consonants and vowels, and each syllable is organized into a block."
          ("https://en.wikipedia.org/wiki/Hangul"
           "https://en.wikipedia.org/wiki/Seong_the_Great")
          "hangul.png")
         ("Coxeter-Dynkin Diagrams"
          "A notation for describing collections of mirrors. Each node represents a mirror, and each edge represents a joining of two mirrors. The number on an edge represents the fraction of 180 degrees that the connection of the mirrors has an angle of. If nodes are not connected by an edge, the angle is 90 degrees. If they are connected by an unlabeled edge, the angle is 60 degrees. Each collection can be used to create a mathematical group."
          ("https://en.wikipedia.org/wiki/Coxeter%E2%80%93Dynkin_diagram"
           "https://en.wikipedia.org/wiki/Coxeter_group")
          "coxeter.png"))))

(define (entry->xexpr entry)
  `(div ((class "entry"))
        (h2 ,(entry-title entry))
        (img ((src ,(string-append "/images/" (entry-image entry))) (alt ,(entry-title entry))))
        (p ,(entry-summary entry))
        (ul ((class "link-list"))
            ,@(map (lambda (url)
                     `(li (a ((href ,url)) ,url)))
                   (entry-links entry)))))

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
                 (link ((rel "stylesheet")
                        (href "/style.css")))
                 (link ((rel "icon")
                        (type "image/gif")
                        (href ,favicon)))
                 (title ,title))
           (body (h1 ,title)
                 (p ,summary)
                 ,@(map entry->xexpr entries))))))

(call-with-output-file "./index.html"
  (lambda (port)
    (write-string html port))
  #:exists 'replace)
