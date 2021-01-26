defmodule AshTest.Habit do
  use Ash.Resource, data_layer: AshPostgres.DataLayer,
                    authorizers: [AshPolicyAuthorizer.Authorizer]

  postgres do
    table "habits"
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

    attribute :body, :string do
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

    relationships do
      belongs_to :player, AshTest.Player do
        required? true
      end
    end

    policies do
      # Anything you can use in a condition, you can use in a check, and vice-versa
      # This policy applies if the actor is a super_user
      # Addtionally, this policy is declared as a `bypass`. That means that this check is allowed to fail without
      # failing the whole request, and that if this check *passes*, the entire request passes.
      bypass actor_attribute_equals(:admin, true) do
        authorize_if always()
      end

      # This will likely be a common occurrence. Specifically, policies that apply to all read actions
      policy action_type(:read) do
        #      forbid_if not_logged_in()

        # unless the actor is an active user, forbid their request
#        forbid_unless actor_attribute_equals(:active, true)
        # if the record is marked as public, authorize the request
        #      authorize_if attribute(:public, true)
        # if the actor is related to the data via that data's `owner` relationship, authorize the request
        authorize_if relates_to_actor_via(:player)
      end

      policy action_type(:write) do
        forbid_unless relates_to_actor_via(:player)
      end
    # More built in checks here: https://github.com/ash-project/ash_policy_authorizer/blob/master/lib/ash_policy_authorizer/check/built_in_checks.ex
    # `create_timestamp` above is just shorthand for:
    # attribute :created_at, :utc_datetime,
    #   writable?: false,
    #   default: &DateTime.utc_now/0
  end
end
end