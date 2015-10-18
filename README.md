# SnipmateToYas

This gem converts [SnipMate](https://github.com/garbas/vim-snipmate) snippets
into [YASnippet](https://github.com/capitaomorte/yasnippet) snippets.

This gem was built mostly to convert the
[vim-snippets](https://github.com/honza/vim-snippets) library to a format
compatible with Emacs but it works with any Snipmate snippet.

Here is how a sample taken from vim-snippets would be converted (note how the
interpolation the code between backticks is handled):

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

Snipmate read multiple snippets from a single file while YASnippet use one
folder per snippet with one snippet per file.

So suppose you'd convert the ruby snippets and the snippets file contained the
following tow snippets:

```
# /my/vim/snippets/ruby.snippets

snippet enc
	# encoding: utf-8
snippet #!
	#!/usr/bin/env ruby
	# encoding: utf-8
```

the following files'd be generated:


/target/folder/ruby-mode/enc
```
# name: enc
# key: enc
# --
# encoding: utf-8
```

/target/folder/ruby-mode/#!

```
# name: #!
# key: #!
# --
#!/usr/bin/env ruby
# encoding: utf-8
```

The mode names not always are equal, for example in Vim we have the cpp-mode
while in Emacs we have the c++-mode.  So the snippets from a file called
cpp.snippets would be saved in a folder called c++-mode and not cpp-mode.

The snippet interpolations in SnipMate use vim-script, while the interpolations
in YASnippet use Elisp. This is handled by this script in a extremely simple
way, but most interpolations should work.  If you found some error please let me
know.

For information of configuration options please check the CLI:

    $ snipmate_to_yas --help


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/cartolari/snipmate_to_yas

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
