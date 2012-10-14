(require 'ert)
(require 'markup)

(ert-deftest markup-escape-string ()
  "Tests the escape feature."
  (should (equal (markup-escape-string "<script type=\"text/javascript\">alert();</script>")
                 "&lt;script type=&quot;text/javascript&quot;&gt;alert();&lt;/script&gt;")))

(ert-deftest markup-normal ()
  ;; normal 'p' tag.
  (should (equal (markup (:p "hoge"))
                 "<p>hoge</p>")))

(ert-deftest markup-multiple-items ()
  (should (equal (markup (:ul (:li "one") (:li "two")))
                 "<ul><li>one</li><li>two</li></ul>")))

(ert-deftest markup-br ()
  (should (equal (markup (:br))
                 "<br />")))

(ert-deftest markup-br-attribute ()
  (should (equal (markup (:br :style "clear: both;"))
                 "<br style=\"clear: both;\" />")))


(ert-deftest markup-class ()
  (should (equal (markup (:div :class "someclass" "content"))
              "<div class=\"someclass\">content</div>")))

(ert-deftest markup-p-empty ()
  (should (equal (markup (:p nil))
                 "<p></p>")))

(ert-deftest markup-p-with-attributes ()
  (should (equal (markup (:p :id "title" :class "important" "Hello, World!"))
                 "<p id=\"title\" class=\"important\">Hello, World!</p>")))

(ert-deftest markup-nested-tag ()
  (should (equal (markup (:p (:div :style "padding: 10px;" "fuga")))
                 "<p><div style=\"padding: 10px;\">fuga</div></p>")))

(ert-deftest markup-escape-body-and-attribute-values ()
  (should (equal (markup (:div :name "<script type=\"text/javascript\">alert();</script>" "<hoge>"))
                 "<div name=\"&lt;script type=&quot;text/javascript&quot;&gt;alert();&lt;/script&gt;\">&lt;hoge&gt;</div>")))

(ert-deftest markup-direct-string ()
  (should (equal (markup "test")
                 "test")))

(ert-deftest markup-direct-strings ()
  (should (equal (markup "test" "test2" "test3")
                 "testtest2test3")))

(ert-deftest markup-function-in-markup-elements ()
  (flet ((myfun () "some text"))
    (should (equal (markup (myfun))
                   "some text"))))

(ert-deftest markup-variables ()
  (should (equal (let ((my-var "Some content!"))
                   (markup (:p my-var)))
                 "<p>Some content!</p>")))

(ert-deftest markup-embed-expressions ()
  (should (equal (markup (:ul (loop for v in '("a" "b" "c") collect
                                    (markup (:li v)))))
                 "<ul><li>a</li><li>b</li><li>c</li></ul>")))

(ert-deftest markup-nil-body ()
  (should (equal (markup (:ul nil))
                 "<ul></ul>")))

(ert-deftest markup-auto-escape ()
  (should (equal (markup (:div (let ((s "<a>Foo</a>")) s)))
                 "<div>&lt;a&gt;Foo&lt;/a&gt;</div>")))

;;; HTML

(ert-deftest html-br ()
    (should (equal (markup-html (:br))
                   "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"><html><br></html>")))

(ert-deftest html-content ()
    (should (equal (markup-html (:ul
                          (loop for v in '("a" "b" "c")
                                collect (markup (:li v (:br))))))
                   "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"><html><ul><li>a<br></li><li>b<br></li><li>c<br></li></ul></html>")))

(ert-deftest html5-br ()
  (should (equal (markup-html5 (:br))
                 "<!DOCTYPE html><html><br /></html>")))

(ert-deftest html5-content ()
  (should (equal (markup-html5 (:ul (loop for v in '("a" "b" "c")
                                   collect (markup (:li v (:br))))))
                 "<!DOCTYPE html><html><ul><li>a<br /></li><li>b<br /></li><li>c<br /></li></ul></html>")))

;;; RAW & ESC

(ert-deftest markup-esc ()
  (should (equal (markup (:p (markup-esc "<hoge>")))
                 "<p>&lt;hoge&gt;</p>")))

(ert-deftest markup-esc-with-expression ()
  (should (equal (markup (:p (markup-esc (concat "<" "hage" ">"))))
                 "<p>&lt;hage&gt;</p>")))

(ert-deftest markup-raw ()
  (should (equal (markup (:p "<hoge>" (:div (markup-raw "Tiffany & Co."))))
                 "<p>&lt;hoge&gt;<div>Tiffany & Co.</div></p>")))

(ert-deftest markup-raw-with-expression ()
  (should (equal (markup (:p "<hoge>"
                             (:div (markup-raw (concat "Tiffany" " & " "Co.")))))
                 "<p>&lt;hoge&gt;<div>Tiffany & Co.</div></p>")))

(ert-deftest markup-raw-with-nil ()
  (should (equal (markup (:p (markup-raw (let (x) x))))
                 "<p></p>")))
