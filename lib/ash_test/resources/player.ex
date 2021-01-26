defmodule AshTest.Player do
  use Ash.Resource, data_layer: AshPostgres.DataLayer,
    authorizers: [AshPolicyAuthorizer.Authorizer]

  postgres do
    table "players"
    repo AshTest.Repo
  end

  actions do
    create :default
    read :default
    update :default
    destroy :default
  end

#  {:ok, player} = Ash.Changeset.new(AshTest.Player, %{username: "jono@gmail.com"}) |> AshTest.Api.create()

  attributes do
    attribute :username, :string,
              allow_nil?: false

    uuid_primary_key :id
  end



  identities do
    identity :unique_username, [:username]
  end

  relationships do
    has_many :habits, AshTest.Habit, destination_field: :player_id
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
      forbid_unless actor_attribute_equals(:active, true)
      # if the record is marked as public, authorize the request
#      authorize_if attribute(:public, true)
      # if the actor is related to the data via that data's `owner` relationship, authorize the request
      authorize_if relates_to_actor_via(:owner)
    end

    policy action_type(:write) do
       forbid_unless always()
    end
  end


end
