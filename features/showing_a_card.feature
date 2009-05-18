Feature: Showing a card

  As a user
  I want to view cards in my rolodex
  So I can see the secrets I've forgotten

  Scenario: Showing an existent card
    Given I have a rolodex with password "wibble"
    And I have card "github" with content:
      """
      site: http://www.github.com
      user: oggy
      pass: kablam!
      """

    When I run the app with "show github"
    Then the app should output:
      """
      github
        site: http://www.github.com
        user: oggy
        pass: kablam!
      """

  Scenario: Showing multiple cards
    Given I have a rolodex with password "wibble"
    And I have card "github" with content:
      """
      site: http://www.github.com
      user: oggy
      pass: kablam!
      """
    And I have card "lighthouse" with content:
      """
      site: http://www.lighthouseapp.com
      user: oggy
      pass: Foozle?
      """

    When I run the app with "show lighthouse github"
    Then the app should output:
      """
      lighthouse
        site: http://www.lighthouseapp.com
        user: oggy
        pass: Foozle?
      github
        site: http://www.github.com
        user: oggy
        pass: kablam!
      """

  Scenario: Showing a nonexistent card
    Given I have a rolodex with password "wibble"

    When I run the app with "show github"
    Then the app should exit with status 1
    And there should be no output
    And the app should error:
      """
      error: cannot find "github"
      """
