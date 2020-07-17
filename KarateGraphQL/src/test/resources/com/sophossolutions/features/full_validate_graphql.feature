Feature: Exmple graphql Pokemon

  Background: Set Settings
    * url 'https://graphql-pokemon.now.sh'
    * def pokemonContract = read('com/sophossolutions/contracts/pokemon-contract.json')
    * def pokemonBadContract = read('com/sophossolutions/contracts/pokemon-bad-contract.json')

  Scenario: Simple GraphQL Request
    Given text query =
      """
      {
        pokemon(name: "Blastoise") {
          id
          number
          name
          attacks {
            special {
              name
              type
              damage
            }
          }
        }
      }
      """
    And request { query: '#(query)' }
    When method post
    Then status 200
    #* print 'response:', response
    * match $.data.pokemon.number == '009'
    * def attacks = get[0] response..special
    * match attacks contains { name: 'Hydro Pump', type: 'Water', damage: 90 }

  Scenario: GraphQL From a File and Variables
    Given def query = read('com/sophossolutions/queries/by-name.graphql')
    And def variables = { name: 'Charmander' }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    * def expected = [{ name: 'Flamethrower', type: 'Fire', damage: 55 }, { name: 'Flame Charge', type: 'Fire', damage: 25 }]
    * match $.data.pokemon contains { number: '004', name: 'Charmander', attacks: { special: '#(^expected)' } }

  Scenario Outline: GraphQL From File and Examples Table
    Given def query = read('com/sophossolutions/queries/by-name.graphql')
    And def variables = { name: "<name>" }
    And request { query: '#(query)', variables: '#(variables)' }
    When method post
    Then status 200
    * def expected = [{ damage: <damage1>, name: "<evolution1>", type: "<type1>" }, { damage: <damage2>, name: "<evolution2>", type: "<type2>" }]
    And match $.data.pokemon contains {  number: "<number>", name: "<name>", attacks: { special: '#(expected)' } }

    Examples: 
      | name       | number | evolution1   | type1    | damage1 | evolution2   | type2    | damage2 |
      | Charmander |    004 | Flamethrower | Fire     |      55 | Flame Charge | Fire     |      25 |
      | Blastoise  |    009 | Flash Cannon | Steel    |      60 | Ice Beam     | Ice      |      65 |
      | Pikachu    |    025 | Thunder      | Electric |     100 | Thunderbolt  | Electric |      55 |

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
