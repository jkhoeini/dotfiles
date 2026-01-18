(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services pm)
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
                          (zprofile (list (local-file "../home_links/.zprofile" "zprofile")))
                          (zshrc (list (local-file "../home_links/.zshrc" "zshrc")))
                          (environment-variables '())))
        (service home-batsignal-service-type
                 (home-batsignal-configuration)))
      %base-home-services)))
