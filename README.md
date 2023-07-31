# flycheck-actionlint - Flycheck for Github Actions
Integration of [Actionlint](https://github.com/rhysd/actionlint) into [Flycheck](https://github.com/flycheck/flycheck).

## Installation

This package is not yet available on MELPA, so for now you either copy the [file](flycheck-actionlint.el) into your ```load-path``` or use [straight](https://github.com/radian-software/straight.el)

```emacs-lisp
(straight-use-package
  '(flycheck-actionlint :type git :host github :repo "tirimia/flycheck-actionlint"))
```

Alternatively, if you are on a newer version of Emacs or already have use-package installed:

```emacs-lisp
(use-package flycheck-actionlint
  :straight (:host github :repo "tirimia/flycheck-actionlint"))
```

## Usage

Simply call the ```flycheck-actionlint-setup``` function. Be that in a hook or right after loading the package, up to you.
