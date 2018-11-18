#lang racket

(require "jid.rkt")
(require "stanza.rkt")
(require "error.rkt")
(require "session.rkt")

(provide jingle-call)

; Initiate a jingle audio call.
(define (jingle-call session
                     to
                     #:from [from #f])
  (when (not from) (set! from (xmpp-session-jid session)))
  (xmpp-send-iq/set
   session
   #:to to
   #:from from
   `(jingle ((xmlns "urn:xmpp:jingle:1")
             (action "session-initiate")
             (initiator ,(jid->string from))
             (sid ,(symbol->string (gensym 'sid))))
            (content ((creator "initiator")
                      (name ,(symbol->string (gensym 'name))))
                     (description ((xmlns "urn:xmpp:jingle:apps:rtp:1")
                                   (media "audio")))
                     (transport ((xmlns "urn:xmpp:jingle:transports:ice-udp:1")
                                 (pwd ,(symbol->string (gensym 'pwd)))
                                 (ufrag ,(symbol->string (gensym 'ufrag)))))))))
