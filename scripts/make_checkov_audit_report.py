import xml.dom.minidom
import argparse
import json


def parse(xmlfile):

    #
    try :
        doc = xml.dom.minidom.parse(xmlfile)
    except Exception as e:
        print("ERR: Unable to load XML File ")
        print(str(e))

    failures = doc.getElementsByTagName("failure")

    scan_data = []
    for failure in failures:
        parent = failure.parentNode
        description = failure.firstChild.nodeValue
        headline = parent.getAttribute("name") + parent.getAttribute("file").replace("/", " - ")

        description = description.replace('\t', '     ').replace('\n', '     ')
        scan_data.append( { 'headline': headline,
                            'description': description })
    return scan_data


if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--scanfile", help="Path of the scan file to load", required=True)
    parser.add_argument("-o", "--outfile", help="Path of the Out file to dump the results", required=True)

    args = parser.parse_args()

    data = parse(args.scanfile)

    with open(args.outfile, 'w') as OUT_FILE:
        json.dump(data, OUT_FILE, indent=4)
