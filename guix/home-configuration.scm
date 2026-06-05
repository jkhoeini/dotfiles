(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services pm)
             (gnu home services shells))


(define-syntax ln-s
  (syntax-rules ()
    ((_ file-name)
     (symlink-to (local-file-absolute-file-name (local-file file-name))))))

(define-syntax my-config-symlink
  (lambda (stx)
    (syntax-case stx ()
      ((_ file-name)
       (string? (syntax->datum #'file-name))
       (let* ((name (syntax->datum #'file-name))
              (path (string-append "../home_links/.config/" name)))
         (with-syntax ((p (datum->syntax stx path)))
           #'`(,file-name ,(ln-s p))))))))

(define-syntax my-config-symlink*
  (syntax-rules ()
    ((_ file-name ...)
     (list (my-config-symlink file-name) ...))))


(home-environment
 (packages (specifications->packages (list "glibc-locales"
                                           "emacs-pgtk"
                                           "emacs-telega"
                                           "cmake"
                                           "recutils"
                                           "fontconfig"
                                           "font-ghostscript"
                                           "font-dejavu"
                                           "font-gnu-freefont"
                                           "font-gnu-unifont"
                                           "font-adobe-source-han-sans"
                                           "font-juliamono"
                                           "nss-certs"
                                           "guile"
                                           "book-sicp"
                                           "info-reader"
                                           "jujutsu")))

 (services
  (append 
   (list 
    (simple-service 'my-env-vars
                    home-environment-variables-service-type
                    `(("SSL_CERT_DIR" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs")
                      ("SSL_CERT_FILE" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs/ca-certificates.crt")
                      ("GIT_SSL_CAINFO" . "$SSL_CERT_FILE")
                      ("CURL_CA_BUNDLE" . "$SSL_CERT_FILE")))
    (simple-service 'my-bash-setup
                    home-bash-service-type
                    (home-bash-extension
                     (bashrc (list (plain-file "omarchy-bashrc" "source ~/.local/share/omarchy/default/bash/rc")))))
    (simple-service 'my-zsh-setup
                    home-zsh-service-type
                    (home-zsh-extension
                     (zprofile (list (plain-file "zprofile"
                                                  "export LANG=\"en_US.UTF-8\"\nexport LC_ALL=\"en_US.UTF-8\"\nexport LC_CTYPE=\"en_US.UTF-8\"\n\n# Start ssh-agent if not already running\nif ! pgrep -q ssh-agent; then\n  eval \"$(ssh-agent -s)\"\nfi\n")))
                     (zshrc (list (plain-file "source-rc"
                                  "source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/rc.zsh\n")))
                     (environment-variables '())))
    (service home-batsignal-service-type
             (home-batsignal-configuration))
    (service home-xdg-configuration-files-service-type
             (my-config-symlink* "antidote/plugins.txt"
                                 "zsh/rc.zsh"
                                 "doom/config.el"
                                 "doom/init.el"
                                 "doom/packages.el"))) 
   
   %base-home-services)))
