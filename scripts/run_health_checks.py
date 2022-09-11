import requests

url = 'https://dev.d3taz5v9576vwj.amplifyapp.com/'

try:
    response = requests.get(url)
    if response.ok:
        print(f"Got successful response {response.status_code}")
    else:
        print(f"Got unsuccessful response {response.status_code}")
except Exception as e:
    print(str(e))
