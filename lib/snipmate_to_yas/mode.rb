module SnipmateToYas
  ## Represents a snippet mode and its corresponding mode name in Vim or Emacs
  class Mode
    attr_accessor :parent

    VIM_TO_EMACS_MODE_MAP = {
      '_' => '_',
      'actionscript' => 'actionscript',
      'ada' => 'ada',
      'apache' => 'apache',
      'arduino' => 'arduino',
      'autoit' => 'autoit',
      'awk' => 'awk',
      'c' => 'c',
      'chef' => 'chef',
      'clojure' => 'clojure',
      'cmake' => 'cmake',
      'codeigniter' => 'codeigniter',
      'coffee' => 'coffee',
      'cpp' => 'c++',
      'cs' => 'csharp',
      'css' => 'css',
      'd' => 'd',
      'dart' => 'dart',
      'diff' => 'diff',
      'django' => 'django',
      'dosini' => 'dosini',
      'eelixir' => 'eelixir',
      'elixir' => 'elixir',
      'erlang' => 'erlang',
      'eruby' => 'eruby',
      'falcon' => 'falcon',
      'fortran' => 'fortran',
      'go' => 'go',
      'haml' => 'haml',
      'haskell' => 'haskell',
      'html' => 'html',
      'htmldjango' => 'htmldjango',
      'htmltornado' => 'htmltornado',
      'jade' => 'jade',
      'java' => 'java',
      'javascript' => 'js',
      'jsp' => 'jsp',
      'julia' => 'julia',
      'laravel' => 'laravel',
      'ledger' => 'ledger',
      'ls' => 'ls',
      'lua' => 'lua',
      'make' => 'make',
      'mako' => 'mako',
      'markdown' => 'markdown',
      'objc' => 'objc',
      'openfoam' => 'openfoam',
      'perl' => 'perl',
      'php' => 'php',
      'plsql' => 'plsql',
      'po' => 'po',
      'processing' => 'processing',
      'progress' => 'progress',
      'puppet' => 'puppet',
      'python' => 'python',
      'r' => 'r',
      'rails' => 'rails',
      'rst' => 'rst',
      'ruby' => 'ruby',
      'rust' => 'rust',
      'scala' => 'scala',
      'scheme' => 'scheme',
      'scss' => 'scss',
      'sh' => 'sh',
      'slim' => 'slim',
      'snippets' => 'snippets',
      'sql' => 'sql',
      'stylus' => 'stylus',
      'supercollider' => 'supercollider',
      'systemverilog' => 'systemverilog',
      'tcl' => 'tcl',
      'tex' => 'tex',
      'textile' => 'textile',
      'vim' => 'vim',
      'xslt' => 'xslt',
      'yii' => 'yii',
      'yii-chtml' => 'yii-chtml',
      'zsh' => 'zsh'
    }

    def initialize(name)
      @name = name
      @parent = Mode.from_vim('_') unless name == '_'
    end

    def self.from_emacs(mode_name)
      new(VIM_TO_EMACS_MODE_MAP.key(mode_name))
    end

    def self.from_vim(mode_name)
      new(mode_name)
    end

    def emacs_name
      VIM_TO_EMACS_MODE_MAP[@name]
    end

    def vim_name
      @name
    end
  end
end
