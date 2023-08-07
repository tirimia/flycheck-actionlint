# flycheck-actionlint - Flycheck for Github Actions

![GitHub](https://img.shields.io/github/license/tirimia/flycheck-actionlint)
[![MELPA](https://melpa.org/packages/flycheck-actionlint-badge.svg)](https://melpa.org/#/flycheck-actionlint)
[![MELPA Stable](https://stable.melpa.org/packages/flycheck-actionlint-badge.svg)](https://stable.melpa.org/#/flycheck-actionlint)

Integration of [Actionlint](https://github.com/rhysd/actionlint) into [Flycheck](https://github.com/flycheck/flycheck).

## Installation

This package is now available on MELPA !!!

```emacs-lisp
(use-package flycheck-actionlint)
```

## Usage

Simply call the ```flycheck-actionlint-setup``` function. Be that in a hook or right after loading the package, up to you.

Example:

```emacs-lisp
(use-package flycheck-actionlint
  :config (flycheck-actionlint-setup))
```
