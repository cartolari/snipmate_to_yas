# SnipmateToYas

This gem converts [SnipMate](https://github.com/garbas/vim-snipmate) snippets
into [YASnippet](https://github.com/capitaomorte/yasnippet) snippets.

This gem was built mostly to convert the
[vim-snippets](https://github.com/honza/vim-snippets) snippet library to a
format compatible with emacs but it works with any Snipmate definition.

Here is a sample taken from vim-snippets and note how the interpolation (the
code between backticks are handled):

```
snippet cla-
	class ${1:`substitute(vim_snippets#Filename(), '\(_\|^\)\(.\)', '\u\2', 'g')`} < DelegateClass(${2:ParentClass})
		def initialize(${3:args})
			super(${4:del_obj})

			${0}
		end
	end
```

and how it'll be converted to YASnippet

```
# name: cla-
# key: cla-
# --
class ${1:`(s-replace " " "" (s-titleized-words (file-name-base (or (buffer-file-name) ""))))`} < DelegateClass(${2:ParentClass})
	def initialize(${3:args})
		super(${4:del_obj})

		$0
	end
end
```

## Installation

    $ gem install snipmate_to_yas

## Usage

Before using this it's important to know some differences between SnipMate and
YASnippet.

SnipMate uses (generally) one file per mode (with all snippets inside it), while
YASnippet use one folder per snippet with one snippet per file

The mode names not always are equal, for example in Vim we have the cpp-mode
while in emacs we have the c++-mode. This is handled by this gem. If you have
find a mode that is not correctly mapped, please open an issue since this should
be trivial to fix.

The snippet interpolations in SnipMate use vim-script, while the interpolations
in YASnippet use Elisp. This is handled by this script in a simple but some
times error prone manner. There is map between the literal interpolation inside
the SnipMate snippets and how they should look in YASnippet. The gem ships with
some defaults but allows configuration through the CLI.

For information of configuration options please check the CLI:

    $ snipmate_to_yas --help


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/cartolari/snipmate_to_yas.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
