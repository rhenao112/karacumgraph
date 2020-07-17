Feature: Validate Scheme Contract

  Background: Set Settings
    * url 'https://graphql-pokemon.now.sh'
    * def pokemonContract = read('com/sophossolutions/contracts/pokemon-contract.json')
    * def pokemonBadContract = read('com/sophossolutions/contracts/pokemon-bad-contract.json')

  Scenario: Scheme Valid Contract
    Given def query = read('com/sophossolutions/queries/by-name.graphql')
    And def variables = { name: 'Charmander' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match response == pokemonContract

  Scenario: Scheme Invalid Contract
    Given def query = read('com/sophossolutions/queries/by-name.graphql')
    And def variables = { name: 'Charmander' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    And match response == pokemonBadContract

    
    
    
    