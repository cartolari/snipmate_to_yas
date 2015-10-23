module SnipmateToYas
  ## Represents a snippet mode and its corresponding mode name in Vim or Emacs
  class Mode
    attr_accessor :parent

    VIM_TO_EMACS_MODE_MAP = {
      'cpp' => 'c++',
      'cs' => 'csharp',
      'javascript' => 'js'
    }

    def initialize(name)
      @name = name
      @parent = Mode.from_vim('_') unless name == '_'
    end

    def self.from_emacs(mode_name)
      new(VIM_TO_EMACS_MODE_MAP.key(mode_name) || mode_name)
    end

    def self.from_vim(mode_name)
      new(mode_name)
    end

    def emacs_name
      VIM_TO_EMACS_MODE_MAP[@name] || @name
    end

    def vim_name
      @name
    end
  end
end
