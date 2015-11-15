defmodule Cvestore do
	use Amnesia
	require IEx

	defdatabase CveStore do
		deftable Cve, [:id, :summary, :published, :modified]
			#@type t :: %Cve{id: String.t, summary: String.t, published: String.t, modified: String.t}
		#end
	end

	def insert_entries(entries) do
		Amnesia.transaction do
			for entry <- entries do
				%{
					id: to_string(entry[:id]),
					summary: to_string(entry[:summary]),
					published: to_string(entry[:published]),
					modified: to_string(entry[:modified])
				}
				|> CveStore.Cve.write
			end
		end
	end
end
