Feature: Adding a card

  As a user
  I want to add cards to my rolodex
  So I can store my secrets without forgetting them

  Scenario: Adding the first card
    Given I don't have a rolodex

    When I run the app with "add github"
    Then the app should output "Creating new rolodex."
    And I should be prompted "Please enter a password for your rolodex:"

    When I enter "wibble"
    Then the app should launch my text editor
    And the contents of the file should be:
      """
      site: http://www.github.com
      user: 
      pass: 
      """

    When I save the content:
      """
      site: http://www.github.com
      user: oggy
      pass: kablam!
      """
    Then the app should exit with status 0
    And there should be no output
    And there should be no error

    When I run the app with "show github"
    Then I should be prompted for a password

    When I enter "wibble"
    Then the app should output:
      """
      github
        site: http://www.github.com
        user: oggy
        pass: kablam!
      """

  Scenario: Successfully adding a new card
    Given I have a rolodex with password "wibble"

    When I run the app with "add github"
    Then I should be prompted for a password

    When I enter "wibble"
    Then the app should launch my text editor
    And the contents of the file should be:
      """
      site: http://www.github.com
      user: 
      pass: 
      """

    When I save the content:
      """
      site: http://www.github.com
      user: oggy
      pass: kablam!
      """
    Then the status code should be 0
    And there should be no output

    When I run the app with "show github"
    Then I should be prompted for a password

    When I enter "wibble"
    Then the app should output:
      """
      github
        site: http://www.github.com
        user: oggy
        pass: kablam!
      """

  Scenario: Adding a duplicate a card
    Given I have a rolodex with password "wibble"
    And I have a card "github"

    When I run the app with "add github"
    Then I should be prompted for a password

    When I enter "wibble"
    Then the app should exit with status 1
    And there should be no output
    And the app should error:
      """
      error: "github" already exists
      """
