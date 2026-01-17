(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services shells))

(home-environment
  (services
    (append 
      (list 
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
                   (bashrc (list (local-file "./.bashrc" "bashrc")))
                   (bash-profile (list (local-file "./.bash_profile" "bash_profile")))
                   (bash-logout (list (local-file "./.bash_logout" "bash_logout"))))))
      %base-home-services)))
