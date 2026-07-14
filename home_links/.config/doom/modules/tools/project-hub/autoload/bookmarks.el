;;; tools/project-hub/autoload/bookmarks.el -*- lexical-binding: t; -*-

(defun +project-hub--project-dir ()
  (or (when-let* ((pr (project-current))) (expand-file-name (project-root pr)))
      default-directory))

(defun +project-hub--bookmark-items ()
  (require 'bookmark)
  (bookmark-maybe-load-default-file)
  (let ((here (+project-hub--project-dir)))
    (thread-last bookmark-alist
      (seq-filter (lambda (bm)
                    (bookmark-prop-get bm 'project)))
      (seq-sort-by (lambda (bm)
                     (+ (if (bookmark-prop-get bm 'pinned) 1e12 0)
                        (or (bookmark-prop-get bm 'last-used) 0)))
                   #'>)
      (mapcar (lambda (bm)
                (let ((name (bookmark-name-from-full-record bm)))
                  (if (bookmark-prop-get bm 'pinned)
                      (concat (propertize "★ " 'face 'warning) name)
                    name)))))))

(defun +project-hub--bookmark-jump (cand &rest _)
  (let ((name (string-remove-prefix "★ " (substring-no-properties cand))))
    (when-let* ((proj (bookmark-prop-get (bookmark-get-bookmark name) 'project)))
      (+project-hub-switch-to-project proj nil))
    (bookmark-prop-set name 'last-used (truncate (float-time)))
    (bookmark-jump name)))

(defvar +project-hub--source-bookmarks
  `(:name "Bookmark"
    :narrow ?m
    :category bookmark
    :face consult-bookmark
    :items ,#'+project-hub--bookmark-items
    :action ,#'+project-hub--bookmark-jump))

;;;###autoload
(defun +project-hub/bookmark-add (name)
  "Bookmark point, tagged with the current project."
  (interactive
   (list (read-string "Bookmark: " nil nil
                      (format "%s: %s"
                              (if (bound-and-true-p persp-mode)
                                  (+workspace-current-name)
                                "default")
                              (or (buffer-file-name) (buffer-name))))))
  (require 'bookmark)
  (bookmark-set name)
  (bookmark-prop-set name 'project (+project-hub--project-dir))
  (bookmark-prop-set name 'last-used (truncate (float-time)))
  (bookmark-save))

;;;###autoload
(defun +project-hub/bookmark-toggle-pin ()
  "Toggle pin on the bookmark at point or prompt for one."
  (interactive)
  (require 'bookmark)
  (bookmark-maybe-load-default-file)
  (let* ((name (completing-read "Toggle pin: "
                                (mapcar #'bookmark-name-from-full-record
                                        (seq-filter (lambda (bm) (bookmark-prop-get bm 'project))
                                                    bookmark-alist))))
         (bm (bookmark-get-bookmark name))
         (pinned (bookmark-prop-get bm 'pinned)))
    (bookmark-prop-set bm 'pinned (not pinned))
    (bookmark-save)
    (message "%s %s" name (if pinned "unpinned" "pinned"))))
