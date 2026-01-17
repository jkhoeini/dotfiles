(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services shells))

(home-environment
  (packages (specifications->packages (list "glibc-locales"
                                            "emacs"
                                            "recutils"
                                            "fontconfig"
                                            "font-ghostscript"
                                            "font-dejavu"
                                            "font-gnu-freefont"
                                            "font-adobe-source-han-sans"
                                            "nss-certs"
                                            "guile"
                                            "book-sicp"
                                            "info-reader")))
  (services
    (append 
      (list 
        (simple-service 'my-env-vars
                        home-environment-variables-service-type
                        `(("GUIX_LOCPATH" . "$HOME_ENVIRONMENT/profile/lib/locale")
                          ("SSL_CERT_DIR" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs")
                          ("SSL_CERT_FILE" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs/ca-certificates.crt")
                          ("GIT_SSL_CAINFO" . "$SSL_CERT_FILE")
                          ("CURL_CA_BUNDLE" . "$SSL_CERT_FILE")))
        (service home-bash-service-type
                 (home-bash-configuration
                   (aliases '((".." . "cd ..") 
                              ("..." . "cd ../..")
                              ("...." . "cd ../../..")
                              ("c" . "opencode")
                              ("cd" . "zd")
                              ("d" . "docker")
                              ("decompress" . "tar -xzf")
                              ("ff" . "fzf --preview '\\''bat --style=numbers --color=always {}'\\''")
                              ("g" . "git")
                              ("gcad" . "git commit -a --amend")
                              ("gcam" . "git commit -a -m")
                              ("gcm" . "git commit -m")
                              ("ls" . "eza -lh --group-directories-first --icons=auto")
                              ("lsa" . "ls -a")
                              ("lt" . "eza --tree --level=2 --long --icons --git")
                              ("lta" . "lt -a")
                              ("r" . "rails")))
                   (bashrc (list (local-file "./.bashrc" "bashrc"))))))
      %base-home-services)))
