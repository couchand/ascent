# apex ast nodes

class ApexClass
  constructor: (@name, @modifiers, taxonomy, @body) ->
    @implements = taxonomy.implements
    @extends = taxonomy.extends

module.exports =
  ApexClass: ApexClass
