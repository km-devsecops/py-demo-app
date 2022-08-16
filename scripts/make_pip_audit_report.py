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


def get_pysec_id_info(pysec_id):
    """ For a given PYSEC ID get associated headline and CVE"""
    if pysec_id is None:
        print("ERR: PYSEC ID must be specified")

    data = get_yaml_data(pysec_id)

    headline = data.get('details', 'NotDefined')

    associated_cve = None
    if data['aliases']:
        for alias in data['aliases']:
            if 'CVE-' in alias:
                associated_cve = alias
    return headline, associated_cve


if __name__ == '__main__':

    pysecid = 'PYSEC-2020-148'
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--scanfile", help="Path of the scan file to load", required=True)

    args = parser.parse_args()

    audit_data = []

    with open(args.scanfile, 'r') as SCAN_FILE:
        jsondata = json.load(SCAN_FILE)
        for entry in jsondata['dependencies']:
            data_block = {}

            # Pick only those with associated vulns.
            if len(entry.get('vulns')) > 0 :
                data_block['name'] = entry.get('name')
                data_block['version'] = entry.get('version')
                vuln = entry.get('vulns')[0]
                pysec_id = vuln.get('id')
                headline, cve_id = get_pysec_id_info(pysecid)
                data_block['headline'] = headline
                data_block['cve_id'] = cve_id

                audit_data.append(data_block)

    with open('reports/audit_formatted.json', 'w') as AUDIT_FILE:
        json.dump(audit_data, AUDIT_FILE, indent=4)