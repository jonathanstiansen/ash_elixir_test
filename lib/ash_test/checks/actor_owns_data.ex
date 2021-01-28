defmodule AshTest.Checks.ActorOwnsData do
    use AshPolicyAuthorizer.SimpleCheck

    # First argument is the actor
    def match?(%AshTest.Player{id: id}, %{changeset: %Ash.Changeset{data: data}}, opts) do
     field = opts[:owner_field]
     Map.get(data, field) == id
    end
    def match?(nil, _, _), do: false

end
