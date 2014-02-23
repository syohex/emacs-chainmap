;;; chainmap.el --- ChainMap implementation in Emacs Lisp

;; Copyright (C) 2014 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-chainmap
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defun chainmap-puthash (key value chain)
  (let ((map (car chain)))
    (puthash key value map)))

(defun chainmap-gethash (key chain)
  (cl-loop with default-value = (cl-gensym)
           for map in chain
           for value = (gethash key map default-value)
           when (not (equal value default-value))
           return value))

(defun chainmap-remhash (key chain)
  (cl-loop named remove-loop
           with default-value = (cl-gensym)
           for map in chain
           for value = (gethash key map default-value)
           when (not (equal value default-value))
           do
           (progn
             (remhash key map)
             (cl-return-from remove-loop))))

(defun chainmap-new-child (chain)
  (let ((new-map (make-hash-table :test 'equal)))
    (setcar chain new-map)
    new-map))

(defun chainmap-parents (chain)
  (cdr chain))

;;;###autoload
(defun chainmap (&rest maps)
  maps)

(provide 'chainmap)

;;; chainmap.el ends here
