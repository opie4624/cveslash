defmodule Cveupdater do
  import SweetXml

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
    body
    |> :zlib.gunzip
    |> xpath(
      ~x"//entry"l,
      _id: ~x"./vuln:cve-id/text()",
      summary: ~x"./vuln:summary/text()",
      references: [
        ~x"./vuln:references"lo,
        type: ~x"./@reference_type",
        source: ~x"./vuln:source/text()",
        reference: ~x"./vuln:reference/text()",
        url: ~x"./vuln:reference/@href"
      ],
      cvss: [
        ~x"./vuln:cvss/cvss:base_metrics"o,
        score: ~x"./cvss:score/text()",
        access_vector: ~x"./cvss:access-vector/text()",
        access_complexity: ~x"./cvss:access-complexity/text()",
        authentication: ~x"./cvss:authentication/text()",
        confidentiality_impact: ~x"./cvss:confidentiality-impact/text()",
        integrity_impact: ~x"./cvss:integrity-impact/text()",
        availability_impact: ~x"./cvss:availability-impact/text()"
      ],
      published: ~x"./vuln:published-datetime/text()",
      modified: ~x"./vuln:last-modified-datetime/text()"
    )
  end

  def load_entries(start_year, end_year) do
    for year <- start_year..end_year do
      to_char_list(to_string(['https://nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-', to_char_list(year), '.xml.gz']))
      |> fetch_entries
      |> Cvestore.insert_entries
    end
  end
end
