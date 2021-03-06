# frozen_string_literal: true
require "spec_helper"

if !TESTING_INTERPRETER
describe GraphQL::InternalRepresentation::Print do # rubocop:disable Layout/IndentationWidth
  describe "printing queries" do
    let(:query_str) { <<-GRAPHQL
    {
      cheese(id: 1) {
        flavor
        ...EdibleFields
        ... on Edible {
          o2: origin
        }
      }
    }

    fragment EdibleFields on Edible {
      o: origin
    }
    GRAPHQL
  }
    it "prints the rewritten query" do
      query_plan = GraphQL::InternalRepresentation::Print.print(Dummy::Schema.graphql_definition, query_str)
      expected_plan = <<-GRAPHQL
query {
  ... on Query {
    cheese(id: 1) {
      ... on Cheese {
        flavor()
        o2: origin()
        o: origin()
      }
    }
  }
}
      GRAPHQL

      assert_equal expected_plan, query_plan
    end
  end
end
end
