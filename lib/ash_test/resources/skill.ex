defmodule AshTest.Skill do
  use Ash.Resource, data_layer: AshPostgres.DataLayer,
                    authorizers: [AshPolicyAuthorizer.Authorizer]

  postgres do
    table "skills"
    repo AshTest.Repo
  end

  actions do
    create :default
    read :default
    update :default
    destroy :default
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      constraints max_length: 255
    end

    # Alternatively, you can use the keyword list syntax
    # You can also set functional defaults, via passing in a zero
    # argument function or an MFA
    attribute :public, :boolean, allow_nil?: false, default: false

    # This is set on create
    create_timestamp :created_at
    # This is updated on all updates
    update_timestamp :updated_at

    # `create_timestamp` above is just shorthand for:
    # attribute :created_at, :utc_datetime,
    #   writable?: false,
    #   default: &DateTime.utc_now/0
  end

  policies do
    bypass always() do
      authorize_if actor_attribute_equals(:admin, true)
    end

#    policy action_type(:read) do
#      authorize_if logged_in()
#    end

    # More built in checks here: https://github.com/ash-project/ash_policy_authorizer/blob/master/lib/ash_policy_authorizer/check/built_in_checks.ex
    policy action_type(:write) do
      forbid_if always()
    end
  end

end
