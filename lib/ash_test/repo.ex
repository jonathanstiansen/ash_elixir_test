defmodule AshTest.Repo do
  use AshPostgres.Repo,
      otp_app: :ash_test
end
