{ config, pkgs, lib, nixGL, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "richard";
  home.homeDirectory = "/home/richard";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # wayland
    (config.lib.nixGL.wrap pkgs.niri)
    pkgs.foot
    pkgs.xwayland-satellite
    pkgs.libgbm
    pkgs.mesa
    pkgs.libdrm
    pkgs.wl-clipboard	# for pass
    pkgs.swaybg

    # linux-desktop (default: no config)
    pkgs.brave
    pkgs.brightnessctl
    pkgs.chafa
    pkgs.ctpv # config copied
    pkgs.libnotify
    pkgs.libsixel
    pkgs.lsix
    pkgs.mpv
    pkgs.neofetch

    # development (no config)
    pkgs.gcc
    pkgs.gnumake


    # packages with configuration files just copied by Home Manager
    # (at least for the time being)
    pkgs.lf
    pkgs.mutt
    pkgs.todoman
    pkgs.rxvt-unicode-unwrapped-emoji
    # I list Vim in this category although I still configure it via symlinks
    pkgs.vim
    # And I list those two although I still configure them manually
    pkgs.isync
    pkgs.msmtp

    # fonts
    pkgs.nerd-fonts.fantasque-sans-mono
    pkgs.noto-fonts
    pkgs.fontconfig

    # work only packages
    pkgs.eduvpn-client

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "docs" ''
      [ -z "$DOCSDIR" ] && DOCSDIR="$HOME/docs/"
      ls "$DOCSDIR" | dmenu | xargs -I{} xdg-open "$DOCSDIR/{}"
    '')
    (pkgs.writeScriptBin "mutt_bgrun" (builtins.readFile ./bin/mutt_bgrun))
    (pkgs.writeScriptBin "papers" (builtins.readFile ./bin/papers))
    (pkgs.writeScriptBin "pinentry-switch" (builtins.readFile ./bin/pinentry-switch))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Config files just copied by Home Manager
  xdg.configFile = {
    "ctpv/config".source = config/ctpv/config;
    "latexmk/latexmkrc".source = config/latexmk/latexmkrc;
    "lf/lfrc".source = config/lf/lfrc;
    "mutt/bindings".source = config/mutt/bindings;
    "mutt/colors.transparent".source = config/mutt/colors.transparent;
    "mutt/mailcap".source = config/mutt/mailcap;
    "mutt/muttlisp".source = config/mutt/muttlisp;
    "readline/inputrc".source = config/readline/inputrc;
    "tmux/tmux.conf".source = config/tmux/tmux.conf;
    "todoman/config.py".source = config/todoman/config.py;
    # some xmodmap invoked by niri does not seach /usr/share/X11/xkb/,
    # so we also add our variant for the local user
    "xkb/symbols/my_gb".source = ./my_gb;
  };

  home.file = {
    ".XCompose".source = ./XCompose;
  };

  # Mime information
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [ "gimp.desktop" "org.pwmt.zathura.desktop" "org.gnome.Evince.desktop" ];
      "application/x-gzip" = [ "gvim.desktop" ];
      "application/x-bibtex" = [ "gvim.desktop" ];
      "text/x-tex" = [ "gvim.desktop" ];
      "text/rust" = [ "gvim.desktop" "org.gnome.gedit.desktop" ];
      "text/x-python" = [ "gvim.desktop" ];
      "text/calendar" = [ "gvim.desktop" ];
      "application/postscript" = [ "org.pwmt.zathura-ps.desktop" ];
      "application/octet-stream" = [ "chromium.desktop" "gvim.desktop" "sxiv.desktop" ];
      "text/plain" = [ "gvim.desktop" ];
      "image/jpeg" = [ "sxiv.desktop" "gimp.desktop" ];
      "application/zip" = [ "gvim.desktop" ];
      "image/webp" = [ "chromium.desktop" ];
      "x-scheme-handler/tg" = [ "userapp-Telegram Desktop-ZM8SS0.desktop" "userapp-Telegram Desktop-J2PVW0.desktop" "userapp-Telegram Desktop-J7WK41.desktop" "org.telegram.desktop.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "image/png" = [ "sxiv.desktop" ];
      "application/x-tar" = [ "gvim.desktop" ];
      "text/x-go" = [ "gvim.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };
    defaultApplicationPackages = [
      pkgs.zathura
    ];
    defaultApplications = {
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "image/png" = [ "sxiv.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "image/jpg" = [ "sxiv.desktop" ];
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/about" = [ "brave-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
      "text/*" = [ "leafpad.desktop" ];
      "text/x-c" = [ "leafpad.desktop" ];
      "text/x-c++" = [ "leafpad.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "image/jpeg" = [ "sxiv.desktop" ];
      "text/rust" = [ "org.gnome.gedit.desktop" ];
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/richard/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    VISUAL = "vim";
    # some programs are stupid and don't respect $VISUAL precedence
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    INPUTRC = "${config.home.homeDirectory}/.config/readline/inputrc";
    PAPERSDIR = "${config.home.homeDirectory}/forschung/literatur";
    PYTHON_BASIC_REPL = 1;
    EXECIGNORE = "/usr/bin/latexminted";
    XDG_CONFIG_HOME = "${config.xdg.configHome}";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Programs whose configuration is generated by home-manager
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    shellAliases = {
      # some more ls aliases
      ls = "ls --color=auto";
      ll = "ls -AlFhv";
      lk = "ls -gFhv";
      la = "ls -Av";
      l = "ls -CFv";
      # shortcuts
      j = "jobs";
      systemstrg = "systemctl";
      # typo aliases
      "ö" = "l";
      "öö" = "ll";
      fin = "find";
      "cd.." = "cd ..";
      bim = "vim";
      ipa = "ip a";
      # retry last command with sudo
      please = "sudo !!";
      # force last command
      yolo = "!! -f";
      # everyone likes to be a jedi
      force = "git";
      # web sites
      xkcd = "w3m xkcd.com";
      fefe = "w3m blog.fefe.de";
      mensa = "w3m lucas-vogel.de/mensa";
      # fix commands that change and become broken
      pdfbook = "pdfbook2 --paper=a4paper --no-crop";
      # Zettelkasten interaction
      zetk = "vim +Zettelkasten";
      nzet = "vim +NewZettel";
      # workaround broken texlive in nixpkgs
      tlmgr = "tlmgr --repository ctan";
    };
    initExtra = ''
      # stolen from http://stackoverflow.com/questions/1527049/join-elements-of-an-array
      join_by() {
          local IFS="$1"; shift; echo "$*";
      }

      google() {
          browser_cmd=(w3m)
          if [ "$#" -gt 0 ]; then
              browser_cmd+=("duckduckgo.com/?q=$(join_by + "$@")")
          else
              browser_cmd+=(duckduckgo.com)
          fi
          "''${browser_cmd[@]}"
      }

      lyrics() {
          browser_cmd=(w3m)
          if [ "$#" -gt 0 ]; then
              browser_cmd+=("darklyrics.com/search?q=$(join_by + "$@")")
          else
              browser_cmd+=(darklyrics.com)
          fi
          "''${browser_cmd[@]}"
      }

      translate() {
          browser_cmd=(w3m)
          if [ "$#" -gt 0 ]; then
              browser_cmd+=("dict.tu-chemnitz.de/dings.cgi?query=$(join_by + "$@")")
          else
              browser_cmd+=(dict.tu-chemnitz.de)
          fi
          "''${browser_cmd[@]}"
      }

      tdoc() {
          pdf_viewer=zathura
          doc_url=texdoc.net/pkg
          curl -L "''${doc_url}/$1" | zathura - &
          disown %1
      }

      lf () {
          exec {ldp}< <(:)
          tmp="/dev/fd/''${ldp}"
          command lf --last-dir-path="$tmp" "$@"
          dir="$(cat "$tmp")"
          if [ -d "$dir" ]; then
              if [ "$dir" != "$(pwd)" ]; then
                  cd "$dir"
              fi
          fi
          exec {ldp}<&-
      }

      rtfm () {
          cmd=`history | awk '
          {prevlast=last; last=$0}
          END{if (NR>1) {$0=prevlast; print $2}}
          '`
          # TODO handle subcommands
          # TODO handle aliases
          case $(type -t "$cmd") in
              builtin)
                  help "$cmd";;
              *)
                  man "$cmd";;
          esac
      }

      saveq () {
          curl "$(xclip -o -sel clip)" >/home/richard/offtopic/Q/"$(date +'%y-%m-%d')".gif
      }

      krass() {
          [ "$#" -ne 1 ] && return 1
          KRASSPATH=~/offtopic/krass
          cat "''${KRASSPATH}/$1" 2>/dev/null
          cat >> "''${KRASSPATH}/$1"
      }

      dpdf () {
          curl -L "$1" | zathura - & disown %+
      }

      # TODO accelerate! C?

      fcd () {
          history | grep '^[[:digit:]]\+[[:blank:]]\+cd' | while read cmd; do target=$(echo "$cmd" | awk '{print $3}'); [ -d "$target" ] && echo "$cmd"; done | tac | fzf
      }

      fcd2 () {
          history | grep '^[[:digit:]]\+[[:blank:]]\+cd' | awk '{ $1=""; print }' | sort -u | while read cmd; do target=$(echo "$cmd" | awk '{print $2}'); [ -d "$target" ] && echo "$cmd"; done | tac | fzf
      }
      HISTSIZE=
      HISTFILESIZE=
      HISTCONTROL=ignorespace

      PS1='[\u@\h \W]\$ '
      # FROM https://jichu4n.com/posts/debug-trap-and-prompt_command-in-bash/
      # This will run before any command is executed.
      function PreCommand() {
          if [ -z "$AT_PROMPT" ]; then
              return
          fi
          if [[ "$BASH_COMMAND" = "__fzf_"* ]]; then
              return
          fi
          unset AT_PROMPT

          # Do stuff.
          printf "\033]0;%s\007" "''${BASH_COMMAND//[^[:print:]]/}"
      }
      trap "PreCommand" DEBUG

      # This will run after the execution of the previous full command line.
      function PostCommand() {
          AT_PROMPT=1

          # Do stuff.
          shell_name="$(basename -- $0)"
          [ -n "$TMUX" ] && shell_name="''${shell_name:1}"
          printf "\033]0;%s\007" "''${shell_name}: `dirs +0`"
      }
      PROMPT_COMMAND="PostCommand"

      FZF_DEFAULT_OPTS="--layout=reverse"
      bind -m vi-insert -x '"\C-t": fzf-file-widget'

      # https://github.com/4z3/fzf-plugins

      FZF_CTRL_R_EDIT_KEY=ctrl-e
      FZF_CTRL_R_EXEC_KEY=enter

      __fzf_history__() (
        local output opts script
        shopt -u nocaseglob nocasematch
        edit_key=''${FZF_CTRL_R_EDIT_KEY:-enter}
        exec_key=''${FZF_CTRL_R_EXEC_KEY:-ctrl-x}
        opts="--height ''${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore ''${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ''${FZF_CTRL_R_OPTS-} --expect=$edit_key,$exec_key +m --read0"
        script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
        if selected=$(
          builtin fc -lnr -2147483648 |
            last_hist=$(HISTTIMEFORMAT=''' builtin history 1) perl -n -l0 -e "$script" |
            FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) --query "$__fzf_old_readline_line")
        then
          key=''${selected%%$'\n'*}
          line=''${selected#*$'\n'}

          result=$(sed 's/^ *\([0-9]*\)\** *//' <<< "$line")

          case $key in
            $edit_key) result=$result$__fzf_edit_suffix__;;
            $exec_key) result=$result$__fzf_exec_suffix__;;
          esac

          echo "$result"
        else
          # Ensure that no new line gets produced by CTRL-X CTRL-P.
          echo "$__fzf_edit_suffix__"
        fi
      )

      __fzf_edit_suffix__=#FZFEDIT#
      __fzf_exec_suffix__=#FZFEXEC#

      __fzf_rebind_ctrl_x_ctrl_p__() {
        if test "''${READLINE_LINE: -''${#__fzf_edit_suffix__}}" = "$__fzf_edit_suffix__"; then
          READLINE_LINE=''${READLINE_LINE:0:-''${#__fzf_edit_suffix__}}
          bind '"\C-x\C-p": ""'
        elif test "''${READLINE_LINE: -''${#__fzf_exec_suffix__}}" = "$__fzf_exec_suffix__"; then
          READLINE_LINE=''${READLINE_LINE:0:-''${#__fzf_exec_suffix__}}
          bind '"\C-x\C-p": "\C-m"'
        fi
      }

      __fzf_history_save_readline_line() {
        __fzf_old_readline_line="$READLINE_LINE"
      }

      bind '"\C-x\C-p": ""'
      bind -x '"\C-x\C-o": __fzf_rebind_ctrl_x_ctrl_p__'
      bind -x '"\C-x\C-i": __fzf_history_save_readline_line'

      if [[ ! -o vi ]]; then
        bind '"\C-r": "\C-x\C-i \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^\C-x\C-o\C-x\C-p"'
      else
        bind '"\C-x\C-a": vi-movement-mode'
        bind '"\C-x\C-e": shell-expand-line'
        bind '"\C-x\C-r": redraw-current-line'
        bind '"\C-x^": history-expand-line'
        bind -m vi-insert '"\C-r": "\C-x\C-i\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a\C-x\C-o\C-x\C-p"'
      fi
      '';
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Richard Mörbitz";
        email = "richard.moerbitz@tu-dresden.de";
      };
      diff = {
        tool = "vimdiff";
        algorithm = "histogram";
        renames = true;
        mnemonicPrefix = true;
        colorMoved = "plain";
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "master";
      };
      "filter \"lfs\"" = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge --skip -- %f";
        process = "git-lfs filter-process --skip";
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      help = {
        autocorrect = "prompt";
      };
      commit = {
        verbose = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc ];
    modes = [ "window" "drun" "calc" ];
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = [ config.programs.password-store.settings.PASSWORD_STORE_DIR ];
    };
  };
  programs.swaylock.package = null;
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-medium collection-fontsextra collection-latexextra; };
  };
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "";
      incremental-search = true;
      database = "sqlite";
      default-bg = "#FFFFFF";
    };
  };
  programs.gpg = {
    enable = true;
  };
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    settings = {
      global = {
        ### Display ###

        # Which monitor should the notifications be displayed on.
        monitor = 0;

        # Display notification on focused monitor.  Possible modes are:
        #   mouse: follow mouse pointer
        #   keyboard: follow window with keyboard focus
        #   none: don't follow anything
        #
        # "keyboard" needs a window manager that exports the
        # _NET_ACTIVE_WINDOW property.
        # This should be the case for almost all modern window managers.
        #
        # If this option is set to mouse or keyboard, the monitor option
        # will be ignored.
        follow = "none";

        ### Geometry ###

        # dynamic width from 0 to 300
        # width = (0, 300)
        # constant width of 300
        width = "300";

        # The maximum height of a single notification, excluding the frame.
        # this was changed to behave like width in 1.12.0
        height = "(0, 300)";

        # Position the notification in the top right corner
        origin = "top-right";

        # Offset from the origin
        offset = "(30, 20)";

        # Scale factor. It is auto-detected if value is 0.
        scale = 0;

        # Maximum number of notification (0 means no limit)
        notification_limit = 0;

        ### Progress bar ###

        # Turn on the progess bar. It appears when a progress hint is passed with
        # for example dunstify -h int:value:12
        progress_bar = true;

        # Set the progress bar height. This includes the frame, so make sure
        # it's at least twice as big as the frame width.
        progress_bar_height = 10;

        # Set the frame width of the progress bar
        progress_bar_frame_width = 1;

        # Set the minimum width for the progress bar
        progress_bar_min_width = 150;

        # Set the maximum width for the progress bar
        progress_bar_max_width = 300;


        # Show how many messages are currently hidden (because of
        # notification_limit).
        indicate_hidden = "yes";

        # The transparency of the window.  Range: [0; 100].
        # This option will only work if a compositing window manager is
        # present (e.g. xcompmgr, compiz, etc.). (X11 only)
        transparency = 0;

        # Draw a line of "separator_height" pixel height between two
        # notifications.
        # Set to 0 to disable.
        # If gap_size is greater than 0, this setting will be ignored.
        separator_height = 2;

        # Padding between text and separator.
        padding = 8;

        # Horizontal padding.
        horizontal_padding = 8;

        # Padding between text and icon.
        text_icon_padding = 0;

        # Defines width in pixels of frame around the notification window.
        # Set to 0 to disable.
        frame_width = 3;

        # Defines color of the frame around the notification window.
        frame_color = "#aaaaaa";

        # Size of gap to display between notifications - requires a compositor.
        # If value is greater than 0, separator_height will be ignored and a border
        # of size frame_width will be drawn around each notification instead.
        # Click events on gaps do not currently propagate to applications below.
        gap_size = 0;

        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "frame";

        # Sort messages by urgency.
        sort = "yes";

        # Don't remove messages, if the user is idle (no mouse or keyboard input)
        # for longer than idle_threshold seconds.
        # Set to 0 to disable.
        # A client can set the 'transient' hint to bypass this. See the rules
        # section for how to disable this if necessary
        # idle_threshold = 120

        ### Text ###

        font = "Fantasque Sans Mono 10";

        # The spacing between lines.  If the height is smaller than the
        # font height, it will get raised to the font height.
        line_height = 4;

        # Possible values are:
        # full: Allow a small subset of html markup in notifications:
        #        <b>bold</b>
        #        <i>italic</i>
        #        <s>strikethrough</s>
        #        <u>underline</u>
        #
        #        For a complete reference see
        #        <https://docs.gtk.org/Pango/pango_markup.html>.
        #
        # strip: This setting is provided for compatibility with some broken
        #        clients that send markup even though it's not enabled on the
        #        server. Dunst will try to strip the markup but the parsing is
        #        simplistic so using this option outside of matching rules for
        #        specific applications *IS GREATLY DISCOURAGED*.
        #
        # no:    Disable markup parsing, incoming notifications will be treated as
        #        plain text. Dunst will not advertise that it has the body-markup
        #        capability if this is set as a global setting.
        #
        # It's important to note that markup inside the format option will be parsed
        # regardless of what this is set to.
        markup = "full";

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        #   %n  progress value if set without any extra characters
        #   %%  Literal %
        # Markup is allowed
        format = "<b>%s</b>\\n%b";

        # Alignment of message text.
        # Possible values are "left", "center" and "right".
        alignment = "left";

        # Vertical alignment of message text and icon.
        # Possible values are "top", "center" and "bottom".
        vertical_alignment = "center";

        # Show age of message if message is older than show_age_threshold
        # seconds.
        # Set to -1 to disable.
        show_age_threshold = 60;

        # Specify where to make an ellipsis in long lines.
        # Possible values are "start", "middle" and "end".
        ellipsize = "middle";

        # Ignore newlines '\n' in notifications.
        ignore_newline = "no";

        # Stack together notifications with the same content
        stack_duplicates = true;

        # Hide the count of stacked notifications with the same content
        hide_duplicate_count = false;

        # Display indicators for URLs (U) and actions (A).
        show_indicators = "yes";

        ### Icons ###

        # Recursive icon lookup. You can set a single theme, instead of having to
        # define all lookup paths.
        enable_recursive_icon_lookup = true;

        # Set icon theme (only used for recursive icon lookup)
        icon_theme = "Adwaita";
        # You can also set multiple icon themes, with the leftmost one being used first.
        # icon_theme = "Adwaita, breeze"

        # Align icons left/right/top/off
        icon_position = "left";

        # Scale small icons up to this size, set to 0 to disable. Helpful
        # for e.g. small files or high-dpi screens. In case of conflict,
        # max_icon_size takes precedence over this.
        min_icon_size = 32;

        # Scale larger icons down to this size, set to 0 to disable
        max_icon_size = 128;

        # Paths to default icons (only neccesary when not using recursive icon lookup)
        #icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

        ### History ###

        # Should a notification popped up from history be sticky or timeout
        # as if it would normally do.
        sticky_history = "yes";

        # Maximum amount of notifications kept in history
        history_length = 20;

        ### Misc/Advanced ###

        # dmenu path.
        dmenu = "/usr/bin/dmenu -p dunst:";

        # Browser for opening urls in context menu.
        browser = "/usr/bin/xdg-open";

        # Always run rule-defined scripts, even if the notification is suppressed
        always_run_script = true;

        # Define the title of the windows spawned by dunst
        title = "Dunst";

        # Define the class of the windows spawned by dunst
        class = "Dunst";

        # Define the corner radius of the notification window
        # in pixel size. If the radius is 0, you have no rounded
        # corners.
        # The radius will be automatically lowered if it exceeds half of the
        # notification height to avoid clipping text and/or icons.
        corner_radius = 3;

        # Ignore the dbus closeNotification message.
        # Useful to enforce the timeout set by dunst configuration. Without this
        # parameter, an application may close the notification sent before the
        # user defined timeout.
        ignore_dbusclose = false;

        ### Wayland ###
        # These settings are Wayland-specific. They have no effect when using X11

        # Uncomment this if you want to let notications appear under fullscreen
        # applications (default: overlay)
        # layer = top

        # Set this to true to use X11 output on Wayland.
        force_xwayland = false;

        ### mouse

        # Defines list of actions for each mouse event
        # Possible values are:
        # * none: Don't do anything.
        # * do_action: Invoke the action determined by the action_name rule. If there is no
        #              such action, open the context menu.
        # * open_url: If the notification has exactly one url, open it. If there are multiple
        #             ones, open the context menu.
        # * close_current: Close current notification.
        # * close_all: Close all notifications.
        # * context: Open context menu for the notification.
        # * context_all: Open context menu for all notifications.
        # These values can be strung together for each mouse event, and
        # will be executed in sequence.
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";

        # Shortcuts are specified as [modifier+][modifier+]...key
        # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
        # "mod3" and "mod4" (windows-key).
        # Xev might be helpful to find names for keys.

        # Close notification.
        close = "ctrl+space";

        # Close all notifications.
        close_all = "ctrl+shift+space";

        # Redisplay last message(s).
        # On the US keyboard layout "grave" is normally above TAB and left
        # of "1". Make sure this key actually exists on your keyboard layout,
        # e.g. check output of 'xmodmap -pke'
        history = "ctrl+grave";

        # Context menu.
        context = "ctrl+shift+period";
      };

      urgency_low = {
        # IMPORTANT: colors have to be defined in quotation marks.
        # Otherwise the "#" and following would be interpreted as a comment.
        #background = "#222222"
        background = "#A5C7FF";  # winter
        foreground = "#888888";
        timeout = 10;
        # Icon for notifications with low urgency, uncomment to enable
        #default_icon = /path/to/icon
      };

      urgency_normal = {
        #background = "#285577"
        background = "#000000C0";
        frame_color = "#A5C7FF";  # winter
        #frame_color = "#5DA9F6";  # winter
        #frame_color = "#DCF88F"  # spring
        foreground = "#ffffff";
        timeout = 10;
        # Icon for notifications with normal urgency, uncomment to enable
        #default_icon = /path/to/icon
      };

      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        frame_color = "#ff0000";
        timeout = 0;
        # Icon for notifications with critical urgency, uncomment to enable
        #default_icon = /path/to/icon
      };
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-all;
    extraConfig = ''
      allow-loopback-pinentry
      '';
  };
  services.kanshi = {
    enable = true;
    settings = [
      {
	output.criteria = "eDP-1";
	output.alias = "internal";
      }
      {
	output.criteria = "Dell Inc. DELL U2715H GH85D7B225PS";
	output.alias = "workLeft";
	output.mode = "2048x1152@60Hz";
      }
      {
	output.criteria = "Dell Inc. DELL U2415 7MT017AU09MS";
	output.alias = "workRight";
	output.transform = "90";
      }
      {
	profile.name = "docked";
	profile.outputs = [
	  {
	    criteria = "$internal";
	    status = "enable";
	    position = "0,0";
	  }
	  {
	    criteria = "$workLeft";
	    status = "enable";
	    position = "1920,0";
	  }
	  {
	    criteria = "$workRight";
	    status = "enable";
	    position = "3968,-360";
	  }
	];
      }
    ];
  };
  nixGL.packages = nixGL.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "FantasqueSansM Nerd Font:size=12" ];
      sansSerif = [ "Noto Sans:style=Regular,size=12" ];
    };
    configFile.symbols = {
      enable = true;
      label = "nerd-font-symbols";
      priority = 10;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <!--
            fix classifying unknown fonts as sans serif
            https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/#trial-the-first-monospace-font-falling-back-to-proportional-unicode-glyph
        -->
        <fontconfig>
            <alias>
                <family>Fantasque Sans Mono</family>
                <default><family>monospace</family></default>
            </alias>
            <alias>
                <family>Iosevka</family>
                <default><family>monospace</family></default>
            </alias>
            <alias>
                <family>monospace</family>
                <!--
                <prefer><family>Iosevka</family></prefer>
                -->
                <prefer><family>Noto Sans Mono</family></prefer>
            </alias>
            <match>
                <test compare="eq" name="family">
                    <string>sans-serif</string>
                </test>
                <test compare="eq" name="family">
                    <string>monospace</string>
                </test>
                <edit mode="delete" name="family"/>
            </match>
        </fontconfig>
        '';
    };
  };
  targets.genericLinux.enable = true;
}
# vim: shiftwidth=2 softtabstop=2
