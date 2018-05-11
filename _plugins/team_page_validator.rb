
require 'find'
require 'json-schema'
require 'yaml'

# technically, could do this with nested schemas... who cares, this works

boolType = { "type" => "boolean" }
intType = { "type" => "integer" }
stringType = { "type" => "string" }

stringArrayType = {
  "type" => "array",
  "items" => {
    "type" => "string"
  }
}

nullOrString = { "anyOf" => [
    stringType,
    { "type" => "null" }
]}

nullOrInt = { "anyOf" => [
    intType,
    { "type" => "null" }
]}

robotCodeType = {
  "type" => "array",
  "items" => [stringType, {
    "type" => "string",
    "enum" => ["Android", "Arduino", "C++", "C", "C#", "F#", "HTML", "Javascript",
               "Java", "Kotlin", "LabVIEW", "LaTeX", "PBASIC", "PHP", "Python", "RoboRealm",
               "Ruby", "Scala", "Swift"]
  }],
  "additionalItems" => false,
}

schema = {
  "type" => "object",
  "additionalProperties": false,
  "required" => ["title", "team"],
  "properties" => {
    "title" => stringType,
    "team" => {
      "type" => "object",
      "additionalProperties" => false,
      "required" => ["type", "number", "name", "location"],
      "properties" => {
        "type" => stringType,
        "number" => intType,
        "name" => nullOrString,
        "rookie_year" => nullOrInt,
        "location" => nullOrString,
        "district" => stringType,
        "sponsors" => stringArrayType,
        "links" => {
          "type" => "object",
          "properties" => {
            "Website" => nullOrString,
          },
        }
      },
    },
    "robot_code" => {
      "type" => "object",
      "patternProperties" => {
        "^(\\d+)$" => {
          "type" => "array",
          "items" => {
            "type" => "object",
            "properties" => {
              "Dashboard" => robotCodeType,
              "Lights" => robotCodeType,
              "Robot" => robotCodeType,
              "Practice Robot" => robotCodeType,
              "Scouting" => robotCodeType,
              "UI" => robotCodeType,
              "Vision" => robotCodeType,
              "VR" => robotCodeType,
            },
            "additionalProperties" => false
          }
        }
      },
      "additionalProperties" => false
    },
    
    # Note: the following are jekyll-specific properties, since we're not able
    #       to get at the raw front-matter content
    "draft" => boolType,
    "categories" => stringArrayType,
    "date" => { "type" => "date-time" },
    "ext" => stringType,
    "layout" => stringType,
    "slug" => stringType,
    "tags" => stringArrayType
  }
}

Jekyll::Hooks.register :documents, :pre_render do |doc|
  next if doc.collection.label != "frc"
  begin
    JSON::Validator.validate!(schema, doc.data)
  rescue JSON::Schema::ValidationError => e
    Jekyll.logger.error "Error in team data at `#{doc.relative_path}`: #{e.message}"
    raise e
  end
end


#Find.find('_frc') do |f|
#  next if File.directory?(f)
#  next if not f.end_with?('.md')
#  data = YAML.load_file(File.open(f))
#  begin
#    JSON::Validator.validate!(schema, data)
#  rescue JSON::Schema::ValidationError => e
#    p "In file #{f}, #{e.message}"
#    exit 1
#  end
#end

#p "All files passed!"
