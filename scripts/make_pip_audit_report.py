import argparse
import json
import yaml
import requests


def get_yaml_data(pysec_id):
    """ For a given PYSEC Id, fetches the corresponding Yaml file and returns the data """
    github_yaml_url = f"https://raw.githubusercontent.com/pypa/advisory-database/main/vulns/urllib3/{pysec_id}.yaml"
    print(f" - Attempting to read the file {github_yaml_url}")
    try:
        response = requests.get(github_yaml_url)
        if response.status_code:
            yml_data = yaml.safe_load(response.text)
            return yml_data
        else:
            raise f"Got a non-success return code {response.status_code} as response"
    except Exception as e:
        print(f"ERR: Error occured while getting data from Github for {pysec_id}")
        print(str(e))


def get_pysec_id_info(package_name, version):
    """ For a given PYSEC ID get associated headline and CVE"""
    if package_name is None or version is None:
        print("ERR: Package name and version must be specified")

    payload = {"version": version,
               "package": {"name": package_name,
                           "ecosystem": "PyPI"}}

    try:
        print(f"Making a call for {package_name} / {version}")
        response = requests.post("https://api.osv.dev/v1/query", data=json.dumps(payload))
        if response.status_code:

            vdata = json.loads(response.text)

            associated_cve = None
            if 'aliases' in vdata.get('vulns')[0]['aliases']:
                for alias in vdata.get('vulns')[0]['aliases']:
                    if 'CVE-' in alias:
                        associated_cve = alias

            published_on = vdata.get('vulns')[0]['published']
            headline = vdata.get('vulns')[0]['details']

            r_list = []
            for r_entry in vdata.get('vulns')[0]['references']:
                r_list.append(r_entry.get('url'))
            references = ",".join(r_list)
            return {'headline': headline,
                    'cve': associated_cve,
                    'published_on': published_on,
                    'references': references}
    except Exception as e:
        print("Error occured making a call to api.osv.dev")
        print(str(e))


if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--scanfile", help="Path of the scan file to load", required=True)
    parser.add_argument("-o", "--outfile", help="Path of the Out file to dump the results", required=True)

    args = parser.parse_args()

    audit_data = []

    with open(args.scanfile, 'r') as SCAN_FILE:
        jsondata = json.load(SCAN_FILE)
        for entry in jsondata['dependencies']:
            data_block = {}

            # Pick only those with associated vulns.
            from pprint import pprint
            pprint(entry)

            if 'vulns' in entry and len(entry.get('vulns')) > 0:
                data_block['name'] = entry.get('name')
                data_block['version'] = entry.get('version')
                vuln = entry.get('vulns')[0]
                pysec_id = vuln.get('id')
                name = entry.get('name')
                version = entry.get('version')

                vuln_details = get_pysec_id_info(name, version)

                data_block['headline'] = vuln_details.get('headline')
                data_block['cve_id'] = vuln_details.get('cve')
                data_block['published_on'] = vuln_details.get('published_on')
                data_block['references'] = vuln_details.get('references')

                audit_data.append(data_block)

    with open(args.outfile, 'w') as AUDIT_FILE:
        json.dump(audit_data, AUDIT_FILE, indent=4)
