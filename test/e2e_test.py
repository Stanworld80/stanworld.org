import urllib.request
import urllib.error
import ssl
import sys

def check_url(url):
    print(f"Testing URL: {url} ... ", end="")
    sys.stdout.flush()
    
    # Bypass SSL verification since o2switch staging has self-signed certs
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req, context=ctx, timeout=10) as response:
            code = response.getcode()
            if code in [200, 301, 302]:
                print(f"SUCCESS (HTTP {code})")
                return True
            else:
                print(f"FAILED (HTTP {code})")
                return False
    except urllib.error.HTTPError as e:
        print(f"FAILED (HTTP {e.code})")
        return False
    except Exception as e:
        print(f"FAILED ({str(e)})")
        return False

def run_e2e_tests():
    print("=== STARTING E2E LINK VALIDATION TESTS ===")
    
    # 1. Main home page
    homepage_url = "https://stanislasselleinformatique.fr/"
    
    # 2. Main target links (blog, guessnumber, calendar)
    links_to_test = [
        homepage_url,
        "https://stanvision.stanworld.org/",
        "https://guessnumber.stanworld.org/",
        "https://www.stanworld.org/calendar/",
        # Inner product links in the new modal list
        "https://ebt.stanworld.org/",
        "https://financemanager.stanworld.org/",
        "https://webbasewithuser.stanworld.org/",
    ]
    
    success = True
    for link in links_to_test:
        if not check_url(link):
            success = False
            
    print("==========================================")
    if success:
        print("ALL E2E LINK TESTS PASSED!")
        sys.exit(0)
    else:
        print("SOME E2E LINK TESTS FAILED!")
        sys.exit(1)

if __name__ == "__main__":
    run_e2e_tests()
