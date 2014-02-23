;;; test-chainmap.el --- test of chainmap.el

;; Copyright (C) 2014 by Syohei YOSHIDA

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

(require 'ert)
(require 'chainmap)

(ert-deftest chainmap-constructor ()
  "constructor"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal))
        (map3 (make-hash-table :test 'equal)))
    (let ((chain (chainmap map1 map2 map3)))
      (should (= (length chain) 3)))))

(ert-deftest chainmap-parents ()
  "chainmap-parents"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal)))
    (let* ((chain (chainmap map1 map2))
           (got (chainmap-parents chain)))
      (should (= (length got) 1)))))

(ert-deftest chainmap-gethash ()
  "chainmap-gethash"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal))
        (map3 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "foo" 20 map2)
    (puthash "foo" 30 map3)
    (let* ((chain (chainmap map1 map2 map3))
           (got (chainmap-gethash "foo" chain)))
      (should (= got 10)))))

(ert-deftest chainmap-gethash-found-in-not-top-map ()
  "key is found in not top map"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal))
        (map3 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "bar" 20 map2)
    (puthash "baz" 30 map3)
    (let* ((chain (chainmap map1 map2 map3))
           (got (chainmap-gethash "baz" chain)))
      (should (= got 30)))))

(ert-deftest chainmap-puthash ()
  "chainmap-puthash"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "foo" 20 map2)
    (let ((chain (chainmap map1 map2)))
      (chainmap-puthash "bar" "baz" chain)
      (should (string= (chainmap-gethash "bar" chain) "baz")))))

(ert-deftest chainmap-remhash ()
  "chainmap-remhash"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "bar" 20 map1)
    (puthash "bar" "2nd-map" map2)
    (let ((chain (chainmap map1 map2)))
      (chainmap-remhash "bar" chain)
      (should (string= (chainmap-gethash "bar" chain) "2nd-map")))))

(ert-deftest chainmap-remhash-from-deep-map ()
  "chainmap-remhash from deep-map"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal))
        (map3 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "bar" 20 map2)
    (puthash "bar" 30 map3)
    (let ((chain (chainmap map1 map2 map3)))
      (chainmap-remhash "bar" chain)
      (should (= (chainmap-gethash "bar" chain) 30)))))

(ert-deftest chainmap-new-child ()
  "chainmap-new-child"
  (let ((map1 (make-hash-table :test 'equal))
        (map2 (make-hash-table :test 'equal))
        (map3 (make-hash-table :test 'equal)))
    (puthash "foo" 10 map1)
    (puthash "foo" 20 map2)
    (puthash "foo" 30 map3)
    (let* ((chain (chainmap map1 map2 map3))
           (new-map (chainmap-new-child chain)))
      (puthash "foo" 1 new-map)
      (let ((got (chainmap-gethash "foo" chain)))
        (should (= got 1))))))

(provide 'test-chainmap)

;;; test-chainmap.el ends here
