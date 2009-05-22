Feature: Adding a card

  As a user
  I want to add cards to my rolodex
  So I can store my secrets without forgetting them

  Scenario: Adding the first card
    Given I don't have a rolodex

    When I run "roc add github"
    Then the app should output "Creating new rolodex."
    And the app should prompt "Please enter a password for your rolodex: "

    When I enter "wibble"
    Then the app should launch my editor
    And my editor should contain:
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

    When I run "roc show github"
    Then the app should prompt "Password: "

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

    When I run "roc add github"
    Then the app should prompt "Password: "

    When I enter "wibble"
    Then the app should launch my editor
    And my editor should contain:
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

    When I run "roc show github"
    Then the app should prompt "Password: "

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

    When I run "roc add github"
    Then the app should prompt "Password: "

    When I enter "wibble"
    Then the app should exit with status 1
    And the app should error:
      """
      error: "github" already exists
      """
