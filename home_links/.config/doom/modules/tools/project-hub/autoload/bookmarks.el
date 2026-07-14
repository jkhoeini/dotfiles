;;; tools/project-hub/autoload/bookmarks.el -*- lexical-binding: t; -*-

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
