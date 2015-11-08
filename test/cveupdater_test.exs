defmodule CveupdaterTest do
  use ExUnit.Case
  doctest Cveupdater

  test "the truth" do
    assert 1 + 1 == 2
  end

	test "retrieves a file from http" do
		assert Regex.match?(~r/examples/i, to_string(Cveupdater.fetch_body('http://www.example.com/')))
	end

	test "retrieves a file from https" do
		assert Regex.match?(~r/examples/i, to_string(Cveupdater.fetch_body('https://www.example.com/')))
	end
end
