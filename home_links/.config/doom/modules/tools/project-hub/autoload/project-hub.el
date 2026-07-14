;;; tools/project-hub/autoload/project-hub.el -*- lexical-binding: t; -*-

(defvar +project-hub--history nil)

(defvar +project-hub--pins nil)
(defvar +project-hub--pins-file
  (file-name-concat doom-data-dir "project-hub-pins.el"))

(defun +project-hub--project-dir ()
  (or (when-let* ((pr (project-current))) (expand-file-name (project-root pr)))
      default-directory))

(defun +project-hub--canon-dir (dir)
  (abbreviate-file-name (file-name-as-directory (expand-file-name dir))))

(defun +project-hub--pins-load ()
  (setq +project-hub--pins
        (if (file-exists-p +project-hub--pins-file)
            (condition-case nil
                (with-temp-buffer
                  (insert-file-contents +project-hub--pins-file)
                  (read (current-buffer)))
              (error nil))
          nil)))

(defun +project-hub--pins-save ()
  (let ((dir (file-name-directory +project-hub--pins-file)))
    (unless (file-directory-p dir) (make-directory dir t)))
  (let ((print-length nil)
        (print-level nil))
    (with-temp-file +project-hub--pins-file
      (pp +project-hub--pins (current-buffer)))))

(defun +project-hub--pins-get (type &optional project)
  (unless +project-hub--pins (+project-hub--pins-load))
  (pcase type
    ('buffers (alist-get (+project-hub--canon-dir (or project default-directory))
                         (alist-get 'buffers +project-hub--pins)
                         nil nil #'equal))
    ('projects (alist-get 'projects +project-hub--pins))
    ('sessions (alist-get 'sessions +project-hub--pins))))

(defun +project-hub--pin-toggle (type target &optional project)
  (unless +project-hub--pins (+project-hub--pins-load))
  (unless +project-hub--pins (setq +project-hub--pins nil))
  (pcase type
    ('buffers
     (let ((proj (+project-hub--canon-dir (or project default-directory))))
       (unless (assq 'buffers +project-hub--pins)
         (push '(buffers) +project-hub--pins))
       (let ((proj-pins (alist-get proj (alist-get 'buffers +project-hub--pins)
                                   nil nil #'equal)))
         (if (member target proj-pins)
             (setf (alist-get proj (alist-get 'buffers +project-hub--pins)
                              nil 'remove #'equal)
                   (remove target proj-pins))
           (push target (alist-get proj (alist-get 'buffers +project-hub--pins)
                                   nil nil #'equal))))))
    ('projects
     (unless (assq 'projects +project-hub--pins)
       (push '(projects) +project-hub--pins))
     (let ((canon (+project-hub--canon-dir target)))
       (if (member canon (alist-get 'projects +project-hub--pins))
           (setf (alist-get 'projects +project-hub--pins)
                 (remove canon (alist-get 'projects +project-hub--pins)))
         (push canon (alist-get 'projects +project-hub--pins)))))
    ('sessions
     (unless (assq 'sessions +project-hub--pins)
       (push '(sessions) +project-hub--pins))
     (if (member target (alist-get 'sessions +project-hub--pins))
         (setf (alist-get 'sessions +project-hub--pins)
               (remove target (alist-get 'sessions +project-hub--pins)))
       (push target (alist-get 'sessions +project-hub--pins)))))
  (+project-hub--pins-save))

(defun +project-hub--pinned-p (type target &optional project)
  (member target (+project-hub--pins-get type project)))

;;; Sources

(defvar +project-hub--source-buffers
  `(:name "Buffer"
    :narrow ?b
    :category buffer
    :face consult-buffer
    :default t
    :state ,(lambda ()
              (let ((state (consult--buffer-state)))
                (lambda (action cand)
                  (funcall state action (and cand (get-buffer cand) cand)))))
    :items ,(lambda ()
              (let* ((proj (+project-hub--project-dir))
                     (pinned-files (+project-hub--pins-get 'buffers proj))
                     (open-bufs (cl-loop for b in (if (bound-and-true-p persp-mode)
                                                      (persp-buffer-list)
                                                    (buffer-list))
                                         for name = (buffer-name b)
                                         unless (or (eq b (current-buffer))
                                                    (string-prefix-p " " name))
                                         collect name))
                     (open-files (cl-loop for name in open-bufs
                                          for buf = (get-buffer name)
                                          when (and buf (buffer-file-name buf))
                                          collect (buffer-file-name buf)))
                     (pinned-open (cl-loop for name in open-bufs
                                           for buf = (get-buffer name)
                                           when (and buf (buffer-file-name buf)
                                                     (member (buffer-file-name buf) pinned-files))
                                           collect (cons (concat "★ " name) name)))
                     (pinned-closed (cl-loop for f in pinned-files
                                            unless (member f open-files)
                                            collect (cons (concat "★ " (file-name-nondirectory f)) f)))
                     (unpinned-open (cl-loop for name in open-bufs
                                            for buf = (get-buffer name)
                                            unless (and buf (buffer-file-name buf)
                                                        (member (buffer-file-name buf) pinned-files))
                                            collect name)))
                (append pinned-open pinned-closed unpinned-open)))
    :action ,(lambda (cand &rest _)
               (if (get-buffer cand)
                   (switch-to-buffer cand)
                 (find-file cand)))
    :new ,(lambda (name) (switch-to-buffer (get-buffer-create name)))))

(defvar +project-hub--source-workspaces
  `(:name "Workspace"
    :narrow ?w
    :category workspace
    :face font-lock-constant-face
    :items ,(lambda ()
              (when (bound-and-true-p persp-mode)
                (cl-remove (+workspace-current-name)
                           (+workspace-list-names)
                           :test #'equal)))
    :action ,(lambda (name &rest _) (+workspace/switch-to name))))

(defvar +project-hub--source-projects
  `(:name "Project"
    :narrow ?p
    :hidden t
    :category project
    :face font-lock-keyword-face
    :items ,(lambda ()
              (when (bound-and-true-p persp-mode)
                (let* ((open (+workspace-list-names))
                       (pinned-dirs (+project-hub--pins-get 'projects))
                       (all-dirs (project-known-project-roots)))
                  (append
                   (cl-loop for dir in pinned-dirs
                            for name = (file-name-nondirectory (directory-file-name dir))
                            when (cl-find dir all-dirs :test #'equal)
                            collect (cons (concat "★ " name) dir))
                   (cl-loop for dir in all-dirs
                            for name = (file-name-nondirectory (directory-file-name dir))
                            unless (or (member name open)
                                       (cl-find dir pinned-dirs :test #'equal))
                            collect (cons name dir))))))
    :action ,(lambda (dir &rest _)
               (+project-hub-switch-to-project dir nil)
               (project-switch-project dir))))

(defun +project-hub--session-sources ()
  "Return agent-shell session consult sources with pin support."
  (when (and (fboundp 'sqlite-available-p) (sqlite-available-p)
             (require 'agent-shell-sessions-consult nil t))
    (clrhash agent-shell-sessions-consult--candidates)
    (let ((pinned-ids (+project-hub--pins-get 'sessions)))
      (mapcar (lambda (src)
                (let ((orig-items (plist-get src :items))
                      (src-copy (map-delete (copy-sequence src) :default)))
                  (plist-put src-copy :items
                             (lambda ()
                               (let ((items (funcall orig-items)))
                                 (+project-hub--sort-pinned-sessions items pinned-ids))))
                  src-copy))
              (append (agent-shell-sessions-consult-sources nil)
                      (agent-shell-sessions-consult-sources t))))))

(defun +project-hub--sort-pinned-sessions (items pinned-ids)
  (let (pinned unpinned)
    (dolist (cand items)
      (let ((data (agent-shell-sessions-consult-session-data cand)))
        (if (and data (member (plist-get data :id) pinned-ids))
            (push (cons (concat "★ " cand) cand) pinned)
          (push cand unpinned))))
    (append (nreverse pinned) (nreverse unpinned))))

;;;###autoload
(defun +project-hub/open ()
  "Unified hub: buffers, workspaces, projects, and agent sessions."
  (interactive)
  (require 'consult)
  (consult--multi
   (append (list '+project-hub--source-buffers
                 '+project-hub--source-workspaces
                 '+project-hub--source-projects)
           (+project-hub--session-sources))
   :prompt "Hub: "
   :history '+project-hub--history
   :require-match nil
   :sort nil))

;;;###autoload
(defun +project-hub-switch-to-project (project-dir buffer)
  "Switch to workspace for PROJECT-DIR, adding BUFFER."
  (when (and project-dir (file-directory-p project-dir)
             (bound-and-true-p persp-mode))
    (let ((ws-name (file-name-nondirectory (directory-file-name project-dir))))
      (+workspace-switch ws-name t)
      (when buffer (persp-add-buffer buffer)))))

;;;###autoload
(defun +project-hub/toggle-pin-buffer (cand)
  "Toggle pin for buffer CAND in the current project."
  (interactive "sBuffer: ")
  (let* ((file (or (and (get-buffer cand) (buffer-file-name (get-buffer cand)))
                   (and (file-exists-p cand) cand)))
         (proj (+project-hub--project-dir)))
    (if file
        (progn
          (+project-hub--pin-toggle 'buffers file proj)
          (message "%s %s" (file-name-nondirectory file)
                   (if (+project-hub--pinned-p 'buffers file proj) "pinned" "unpinned")))
      (message "Cannot pin non-file buffer: %s" cand))))

;;;###autoload
(defun +project-hub/toggle-pin-project (cand)
  "Toggle pin for project CAND."
  (interactive "sProject: ")
  (let ((dir (+project-hub--canon-dir cand)))
    (+project-hub--pin-toggle 'projects dir)
    (message "%s %s" (file-name-nondirectory (directory-file-name dir))
             (if (+project-hub--pinned-p 'projects dir) "pinned" "unpinned"))))

;;;###autoload
(defun +project-hub/toggle-pin-session (cand)
  "Toggle pin for agent session CAND."
  (interactive "sSession: ")
  (if-let* ((data (agent-shell-sessions-consult-session-data cand))
            (id (plist-get data :id)))
      (progn
        (+project-hub--pin-toggle 'sessions id)
        (message "%s %s" (string-trim cand)
                 (if (+project-hub--pinned-p 'sessions id) "pinned" "unpinned")))
    (user-error "Unknown session: %s" cand)))
