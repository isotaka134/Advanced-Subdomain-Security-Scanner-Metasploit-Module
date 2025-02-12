require 'msf/core'
require 'open3'
require 'json'
require 'net/http'

class MetasploitModule < Msf::Auxiliary
  def initialize
    super(
      'Name'        => 'Advanced Subdomain Security Scanner',
      'Description' => 'Scans all subdomains of a given domain for open ports, vulnerabilities, and Azure info.',
      'Author'      => ['HAMZA EL-HAMDAOUI'],
      'License'     => MSF_LICENSE
    )

    register_options([
      OptString.new('DOMAIN', [true, 'Target domain to scan']),
      OptString.new('OUTPUT_FILE', [false, 'Filename to save results', 'scan_results.txt'])
    ])
  end

  def run_command(cmd)
    output, error, status = Open3.capture3(cmd)
    output.strip
  end

  def subdomain_scan(domain)
    print_status("Finding subdomains...")
    subdomains = run_command("subfinder -d #{domain}").split("\n")
    subdomains
  end

  def port_scan(subdomains)
    results = ""
    subdomains.each do |subdomain|
      print_status("Scanning open ports on #{subdomain}...")
      results << "#{subdomain}:\n" + run_command("nmap -p- #{subdomain}") + "\n\n"
    end
    results
  end

  def nuclei_scan(subdomains)
    results = ""
    subdomains.each do |subdomain|
      print_status("Running Nuclei scan on #{subdomain}...")
      results << "#{subdomain}:\n" + run_command("nuclei -u #{subdomain}") + "\n\n"
    end
    results
  end

  def azure_tenant_scan(subdomains)
    results = ""
    subdomains.each do |subdomain|
      print_status("Checking Azure Tenant ID for #{subdomain}...")
      url = URI("https://login.microsoftonline.com/#{subdomain}/v2.0/.well-known/openid-configuration")
      response = Net::HTTP.get(url)
      begin
        json = JSON.parse(response)
        results << "#{subdomain}: #{json['issuer']}\n\n"
      rescue
        results << "#{subdomain}: No Azure Tenant ID found.\n\n"
      end
    end
    results
  end

  def run
    domain = datastore['DOMAIN']
    output_file = datastore['OUTPUT_FILE']
    return unless domain

    subdomains = subdomain_scan(domain)
    results = "Subdomains:\n" + subdomains.join("\n") + "\n\n"
    results << "Open Ports:\n" + port_scan(subdomains) + "\n\n"
    results << "Nuclei Scan:\n" + nuclei_scan(subdomains) + "\n\n"
    results << "Azure Tenant:\n" + azure_tenant_scan(subdomains) + "\n\n"

    File.write(output_file, results)
    print_good("Scan complete! Results saved to #{output_file}")
  end
end
