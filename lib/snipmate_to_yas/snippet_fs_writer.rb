module SnipmateToYas
  ## Writes a list of snippets to the file system
  class SnippetFsWriter
    def initialize(snippets, base_directory)
      @snippets = snippets
      @base_directory = base_directory
      @snippets_directory = File.join(
        base_directory, "#{@snippets.mode.emacs_name}-mode"
      )
    end

    def write
      FileUtils.mkdir_p(@snippets_directory)
      write_snippets
      write_yas_parents
      write_aliases_links
    end

    protected

    def write_snippets
      @snippets.each do |snippet|
        path = File.join(@snippets_directory, filename(snippet.expand_key))
        File.open(path, 'w') { |f| f << snippet.text }
      end
    end

    def write_yas_parents
      parent_mode = @snippets.mode.parent
      return unless parent_mode

      path = File.join(@snippets_directory, '.yas-parents')
      File.open(path, 'w') { |f| f << "#{parent_mode.emacs_name}-mode" }
    end

    def write_aliases_links
      @snippets.mode.aliases.each do |mode_alias|
        File.symlink(
          "#{@snippets.mode.emacs_name}-mode",
          File.join(@base_directory, "#{mode_alias}-mode")
        )
      end
    end

    ## Cleaned up filename from +key+
    def filename(key)
      return '_' if key.match(/^\.$/)
      key.gsub(%r{[\x00\/\\:\*\?\"<>\|]}, '_')
    end
  end
end
