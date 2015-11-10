require 'gherkin3_reformat'

describe Gherkin3Reformat do
  it "should format a simple feature" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      Feature:   My Feature
        
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      Feature: My Feature
      END
    )
  end
  
  it "should format a feature with scenarios" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      Feature:   My Feature
      Scenario:   A scenario  
      Given a step
      When stuff
      Then yay
      
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      Feature: My Feature

        Scenario: A scenario
          Given a step
          When stuff
          Then yay
      END
    )
  end
  
  it "should format a feature with scenarios" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      Feature:   My Feature
      Some blurb
      Scenario:   A scenario  
      Some more blurb
      Given a step
      When stuff
      Then yay
      
      Scenario: MOAR SCENARIO!!
        Given another step
          When it happens
            Then woo
        
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      Feature: My Feature
        Some blurb

        Scenario: A scenario
          Some more blurb
          Given a step
          When stuff
          Then yay

        Scenario: MOAR SCENARIO!!
          Given another step
          When it happens
          Then woo
      END
    )
  end
  
  it "should format a feature with tags" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      @tag1   @tag2
      Feature:   My Feature
          @tag3 @more_tag      
      Scenario: My Scenario
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      @tag1 @tag2
      Feature: My Feature

        @tag3 @more_tag
        Scenario: My Scenario
      END
    )
  end
  
  it "should format a feature with a scenario outline" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      Feature:   My Feature
      Scenario Outline: My Scenario Outline
        Given some <parameter> stuff
       Then I should see <result>
          Examples:
       Some silly examples
          |parameter|   result |
          |hello |  world|
          |goodbye  | moon     |
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      Feature: My Feature

        Scenario Outline: My Scenario Outline
          Given some <parameter> stuff
          Then I should see <result>
        Examples:
          Some silly examples
          | parameter | result |
          | hello     | world  |
          | goodbye   | moon   |
      END
    )
  end
  
  it "should format a feature with multiline arguments" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      Feature:   My Feature
      Scenario: My Scenario
        Given some stuff:
        """text
        Hello World
        """
       Then I should see:
         |header1|header2|
         |1|2|
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      Feature: My Feature

        Scenario: My Scenario
          Given some stuff:
            """text
            Hello World
            """
          Then I should see:
            | header1 | header2 |
            | 1       | 2       |
      END
    )
  end
  
  it "should format a feature with comments" do
    result = Gherkin3Reformat.format_string (<<-END.gsub(/^ {6}/, '')
      @tag
      #A comment
      Feature:   My Feature
      #More comment
      Scenario: My Scenario
        Some blurb
        Yet more blurb
        #Step comment
        Given some stuff:
        #"""
        #commented out
        #"""
        """text
        Hello World
        """
       Then I should see:
         #Table comment
         |header1|header2|
         #|3|4|
         |1|2|
         #Final comment
      END
    )
    expect(result).to eq(<<-END.gsub(/^ {6}/, '')
      #A comment
      @tag
      Feature: My Feature

        #More comment
        Scenario: My Scenario
          Some blurb
          Yet more blurb
          #Step comment
          Given some stuff:
            #"""
            #commented out
            #"""
            """text
            Hello World
            """
          Then I should see:
            #Table comment
            | header1 | header2 |
            #|3|4|
            | 1       | 2       |
      #Final comment
      END
    )
  end
end