require "gherkin3_reformat/version"

require 'gherkin3/parser'

module Gherkin3Reformat
  def self.format(feature)
    items = []
    items.push(feature)
    feature[:comments].each {|comment| items.push(comment)}
    items.push(feature[:background]) if feature.has_key?(:background)
    feature[:scenarioDefinitions].each do |scenario|
      items.push(scenario)
      if scenario.has_key?(:examples) then 
        scenario[:examples].each do |example|
          items.push(example)
          table = [example[:tableHeader]] + example[:tableBody]
          items.concat(self.handle_table(table, 4))
          
        end
      end
      scenario[:tags].each{|tag| items.push(tag)}
      scenario[:steps].each do |step|
        if step.has_key?(:argument) then
          argument = step[:argument]
          case argument[:type]
          when :DataTable
            items.concat(self.handle_table(argument[:rows], 6))
          when :DocString
            items.push(argument)
          end
        end
        items.push(step)
      end
    end
    
    items.sort! do |a, b|
      linecomp = a[:location][:line] <=> b[:location][:line]
      linecomp != 0 ? linecomp : a[:location][:column] <=> b[:location][:column]
    end
    
    self.calculate_comment_indents_and_add_newlines_before_scenarios(items)
    
    items.map {|item| self.pretty_print(item)}.join('')
  end
  
  def self.format_string(data)
    parser = Gherkin3::Parser.new
    self.format(parser.parse(data))
  end
  
  def self.format_file(filename)
    parser = Gherkin3::Parser.new
    File.open(filename) do |file|
      self.format(parser.parse(file))
    end
  end
  
  private
  
    def self.pretty_print(node)
      formatted = case node[:type]
      when :Feature
        self.pretty_print_node_with_blurb_and_indent(node, 0)
      when :Background, :Scenario, :ScenarioOutline, :Examples
        self.pretty_print_node_with_blurb_and_indent(node, 2)
      when :Step
        "#{' ' * 4}#{node[:keyword]}#{node[:text]}\n"
      when 'TableRow'
        "#{' ' * node[:indent]}| #{node[:cells].map{|cell| cell[:value].ljust(cell[:maxWidth], ' ')}.join(' | ')} |\n"
      when :DocString
        self.pretty_print_docstring(node)
      when 'Comment'
        "#{' ' * node[:indent]}#{node[:text].strip}\n"
      end
      if node[:precedingNewline] then "\n#{formatted}" else formatted end
    end
    
    def self.pretty_print_node_with_blurb_and_indent(node, indent)
      tags = node[:tags].any? ? "#{' ' * indent}#{node[:tags].map {|tag| tag[:name]}.join(' ')}\n" : ''
      first_row = "#{' ' * indent}#{node[:keyword]}: #{node[:name].strip}".rstrip
      description = node.has_key?(:description) ? node[:description].split("\n").map {|row| (' ' * (indent + 2)) + row.strip}.join("\n") + "\n" : ''
      "#{tags}#{first_row}\n#{description}"
    end
    
    def self.handle_table(table, indent)
      widths = table.map{
        |row| row[:cells].map{|cell| cell[:value].size}
      }.reduce{
        |row1, row2| row1.zip(row2).map(&:max)
      }
      table.map do |row|
        row[:cells].zip(widths).each do |cell, width|
          cell[:maxWidth] = width
        end
        row[:indent] = indent
        row
      end
    end
    
    def self.pretty_print_docstring(docstring)
      %Q{#{' ' * 6}"""#{docstring[:contentType]}\n#{' ' * 6}#{docstring[:content].gsub("\n", "\n#{' ' * 6}")}\n#{' ' * 6}"""\n}
    end
    
    def self.calculate_comment_indents_and_add_newlines_before_scenarios(items)
      target_for_preceding_newline = nil
      indent = 0
      attach_any_newlines = lambda do
        target_for_preceding_newline[:precedingNewline] = true if target_for_preceding_newline
        target_for_preceding_newline = nil
      end
      items.reverse.each do |item|
        case item[:type]
        when :Feature
          attach_any_newlines.call
          indent = 0
        when :Background, :Scenario, :ScenarioOutline
          attach_any_newlines.call
          indent = 2
          target_for_preceding_newline = item
        when :Step
          attach_any_newlines.call
          indent = 4
        when :Examples
          attach_any_newlines.call
          indent = 2
        when 'TableRow'
          attach_any_newlines.call
          indent = item[:indent]
        when :DocString
          attach_any_newlines.call
          indent = 6
        when 'Comment'
          target_for_preceding_newline = item if target_for_preceding_newline
          item[:indent] = indent
        end
      end
      attach_any_newlines.call
    end
end