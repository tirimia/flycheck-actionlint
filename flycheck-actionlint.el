;;; flycheck-actionlint.el --- Flycheck integration for actionlint -*- lexical-binding: t -*-

;; Copyright (C) 2023 Theodor-Alexandru Irimia

;; Author: Theodor-Alexandru Irimia
;; Maintainer: Theodor-Alexandru Irimia
;; Version: 0.1.0
;; Package-Requires: ((emacs "26") (flycheck "32"))
;; Homepage: https://github.com/tirimia/flycheck-actionlint
;; Keywords: convenience, github, linter


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; Flycheck integration for Actionlint. See README.md

;;; Code:

(require 'flycheck)

(defgroup flycheck-actionlint nil
  "Flycheck integration for Actionlint."
  :prefix "flycheck-actionlint-"
  :group 'flycheck)

(defcustom flycheck-actionlint-shellcheck "shellcheck"
  "Command name or file path of shellcheck external command. If nil, shellcheck integration will be disabled."
  :type 'string
  :group 'flycheck-actionlint)

(defcustom flycheck-actionlint-pyflakes "pyflakes"
  "Command name or file path of pyflakes external command. If empty, pyflakes integration will be disabled."
  :type 'string
  :group 'flycheck-actionlint)

(defcustom flycheck-actionlint-ignore nil
  "Regular expressions matching to error messages you want to ignore."
  :type '(repeat string)
  :group 'flycheck-actionlint)

(defun flycheck-actionlint--project-root (&rest _)
  "Return the nearest directory containing a .github folder."
  (and buffer-file-name
       (file-truename (locate-dominating-file buffer-file-name ".github"))))

(defun flycheck-actionlint--enable-p ()
  "Return non-nil if the actionlint linter should be enabled."
  (and (flycheck-buffer-saved-p)
       (string-match-p "\\.github/workflows/$"
                       (file-name-directory (buffer-file-name)))
       (string-match-p "\\.ya?ml$" (buffer-file-name))))

(defun flycheck-actionlint--shellcheck-arg ()
  "Generate the command line argument for shellcheck based on 'flycheck-actionlint-shellcheck'."
  (format "-shellcheck=%s" flycheck-actionlint-shellcheck))

(defun flycheck-actionlint--pyflakes-arg ()
  "Generate the command line argument for pyflakes based on 'flycheck-actionlint-pyflakes'."
  (format "-pyflakes=%s" flycheck-actionlint-pyflakes))

(defun flycheck-actionlint--ignore-args ()
  "Generate the command line arguments that the declared expressions in 'flycheck-actionlint-ignore' describe."
  (let* ((formatter (lambda (exp) (format "-ignore '%s'" exp)))
         (flags (mapcar formatter flycheck-actionlint-ignore))
         (all-flags (string-join flags " ")))
    (unless (string-empty-p all-flags) all-flags)))

(flycheck-def-executable-var actionlint "actionlint")
(flycheck-define-checker actionlint
  "A Github Actions checker using actionlint"
  :command ("actionlint"
            "-oneline"
            (eval (flycheck-actionlint--shellcheck-arg))
            (eval (flycheck-actionlint--pyflakes-arg))
            (eval (flycheck-actionlint--ignore-args))
            source-original)
  :error-patterns ((error line-start (file-name) ":" line ":" column ": " (message) line-end))
  :modes (yaml-mode yaml-ts-mode)
  :predicate flycheck-actionlint--enable-p
  :error-filter flycheck-increment-error-columns
  :working-directory flycheck-actionlint--project-root)

;;;###autoload
(defun flycheck-actionlint-setup ()
  "Setup Flycheck with Actionlint."
  (interactive)
  (add-to-list 'flycheck-checkers 'actionlint))

(provide 'flycheck-actionlint)
;;; flycheck-actionlint.el ends here
