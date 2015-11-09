defmodule Cveupdater do
	require Record

	for {record_name, record_definition} <- Record.extract_all(from_lib: "xmerl/include/xmerl.hrl"), do: Record.defrecord(record_name, record_definition)

	@doc ~S"""
	Returns a list of CVE Entries and their attributes given the URL or path to a GZ XML file.
	
  ## Examples
	
	    iex> Cveupdater.fetch_entries 'https://nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-2002.xml.gz'
			[{_id: 'CVE-2002-0001'}]
	"""
	def fetch_entries(url) do
		:ssl.start
		:inets.start
		{:ok, {{_, 200, _}, _, body}} = :httpc.request(url)
		for entry <- body
		|> :zlib.gunzip
		|> to_char_list
		|> Exmerl.parse
		|> Tuple.to_list
		|> List.first
		|> Exmerl.XPath.find("/nvd/entry"), do: xmlElement entry
	end

end
