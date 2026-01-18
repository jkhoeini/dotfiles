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
                        `(("SSL_CERT_DIR" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs")
                          ("SSL_CERT_FILE" . "$HOME_ENVIRONMENT/profile/etc/ssl/certs/ca-certificates.crt")
                          ("GIT_SSL_CAINFO" . "$SSL_CERT_FILE")
                          ("CURL_CA_BUNDLE" . "$SSL_CERT_FILE")))
        (service home-bash-service-type
                 (home-bash-configuration
                   (bashrc (list (plain-file "omarchy-bashrc" "source ~/.local/share/omarchy/default/bash/rc"))))))
      %base-home-services)))
