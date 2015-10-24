module SnipmateToYas
  ## Represents a snippet mode and its corresponding mode name in Vim or Emacs
  class Mode
    attr_accessor :parent
    attr_accessor :vim_name

    # Modes that have a different name between Vim and Emacs
    VIM_TO_EMACS_MODE_MAP = {
      'cpp' => 'c++',
      'cs' => 'csharp',
      'javascript' => 'js'
    }

    # Modes that may have multiple implementations in Emacs, like the ruby-mode
    # which have the alternative enhanced ruby mode
    EMACS_MODE_ALIASES = {
      'clojure' => ['cider-repl-mode'],
      'js' => ['js2'],
      'ruby' => ['enh-ruby']
    }

    def initialize(name)
      @vim_name = name
      @parent = Mode.from_vim('_') unless name == '_'
    end

    def self.from_emacs(mode_name)
      new(VIM_TO_EMACS_MODE_MAP.key(mode_name) || mode_name)
    end

    def self.from_vim(mode_name)
      new(mode_name)
    end

    def emacs_name
      VIM_TO_EMACS_MODE_MAP[@vim_name] || @vim_name
    end

    def aliases
      EMACS_MODE_ALIASES[emacs_name] || []
    end
  end
end
