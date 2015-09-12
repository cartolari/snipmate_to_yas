module SnipmateToYas
  module Snipmate
    ## Default interpolation converter, contains some interpolation mappings of
    ## snippets found in honza/vim-snippets library
    class DefaultInterpolationConverter
      # rubocop:disable Metrics/LineLength
      INTERPOLATIONS_MAP = {
        'g:snips_author' => '"Name"',
        'g:snips_email' => '"Email"',
        'g:snips_github' => '"Github user"',

        'strftime("%B %d, %Y")' => '(format-time-string "%B %d, %Y")',
        'strftime("%H:%M")' => '(format-time-string "%H:%M")',
        'strftime("%Y")' => '(format-time-string "%Y")',
        'strftime("%Y-%m-%d %H:%M")' => '(format-time-string "%Y-%m-%d %H:%M")',
        'strftime("%Y-%m-%d")' => '(format-time-string "%Y-%m-%d")',
        'strftime("%Y/%m/%d")' => '(format-time-string "%Y/%m/%d")',
        'strftime("%d %B, %Y")' => '(format-time-string "%d %B, %Y")',
        'strftime("%d/%m/%y %H:%M:%S")' => '(format-time-string "%d/%m/%y %H:%M:%S")',

        "vim_snippets#Filename('$1.py', 'foo.py')" => '(file-name-nondirectory (buffer-file-name))',
        %q{substitute(substitute(vim_snippets#Filename(), '_spec$', '', ''), '\(_\|^\)\(.\)', '\u\2', 'g')} =>
          '(replace-regexp-in-string "Spec" "" (s-replace " " "" (s-titleized-words (file-name-base (or (buffer-file-name) "")))) nil t)',
        %q{substitute(vim_snippets#Filename(), '\(_\|^\)\(.\)', '\u\2', 'g')} => '(s-replace " " "" (s-titleized-words (file-name-base (or (buffer-file-name) ""))))',
        %q{substitute(vim_snippets#Filename('', 'Page Title'), '^.', '\u&', '')} => '(file-name-base)',

        %q{system("grep \`id -un\` /etc/passwd | cut -d \":\" -f5 | cut -d \",\" -f1")} => '',
        'vim_snippets#Filename("$1")' => '(file-name-base)',
        'vim_snippets#Filename("$1.h")' => '(concat (file-name-base) ".h")',
        "vim_snippets#Filename('$1')" => '(file-name-base)',
        "vim_snippets#Filename('$1', 'ClassName')" => '(file-name-base)',
        "vim_snippets#Filename('$1Delegate', 'MyProtocol')" => '(concat (file-name-base) "Delegate")',
        "vim_snippets#Filename('$1', 'name')" => '(file-name-base)',
        "vim_snippets#Filename('$1', 'NSObject')" => '(file-name-base)',
        "vim_snippets#Filename('$1', '$1_t')" => '(concat (file-name-base) "_t")',
        'vim_snippets#Filename("$1", "untitled")' => '(file-name-base)',
        'vim_snippets#Filename("$2", "untitled")' => '(file-name-base)',
        'vim_snippets#Filename("$3", "untitled")' => '(file-name-base)',
        "vim_snippets#Filename('', 'fqdn')" => '(file-name-base)',
        "vim_snippets#Filename('', 'my')" => '(file-name-base)',
        "vim_snippets#Filename('', 'name')" => '(file-name-base)',
        "vim_snippets#Filename('', 'someClass')" => '(file-name-base)'
      }
      # rubocop:enable Metrics/LineLength

      def convert(snippet)
        INTERPOLATIONS_MAP[snippet]
      end
    end
  end
end
