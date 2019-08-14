#lang scribble/manual
@(require (for-label (only-meta-in 0 plaitypus/untyped)
                     (only-in racket/base only-in)))

@title{Untyped with Typed Syntax}

@defmodulelang[plaitypus/untyped]{
The @racketmodname[plaitypus/untyped] language supports the same syntax as
@racketmodname[plaitypus], but it performs no type checking.}

The @racket[define-syntax], @racket[define-syntax-rule],
@racket[module+], and @racket[require] forms from
@racketmodname[plaitypus/untyped] are the bindings from
@racketmodname[racket/base] instead of @racketmodname[plaitypus].

@deftogether[(
@defidform[typed-in]
@defidform[opaque-type-in]
)]{

Forms for @racket[require] that simulate the ones from
@racketmodname[plaitypus] by expanding to uses of @racket[only-in].}
