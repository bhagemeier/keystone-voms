.. _test:

Test it!
========

Once you have everything configured you can test it requesting a token using
a valid VOMS proxy. 

First get a valid VOMS proxy::

    $ voms-proxy-init -voms <VOMS> -rfc

Then, get a unscoped token::

    $ curl --cert $X509_USER_PROXY  -d '{"auth":{"voms": true}}' \
    -H "Content-type: application/json" https://<keystone_host>/v2.0/tokens

This will give you something like::


    {
        "access": {
            "token": {
                "expires": "2011-08-10T17:45:22.838440",
                "id": "0eed0ced-4667-4221-a0b2-24c91f242b0b"
            }
        }
    }

Use the token ID that you obtained, to get a list of the tenants that you are
allowed to access::

     $ curl -H "X-Auth-Token:0eed0ced-4667-4221-a0b2-24c91f242b0b" \
     http://localhost:35357/v2.0/tenants

If this is sucessful, you should get something like::
     
     {
        "tenants_links": [],
        "tenants": [
            {
                "description": "Some Tenant", 
                "enabled": true, 
                "id": "999f045cb1ff4684a15ebb334af61461", 
                "name": "TenantName"
            }
        ]
    }

Identify the tenant, and request a scoped token::

    $ curl --cert $X509_USER_PROXY  \
    -d '{"auth":{"voms": true, "tenantName": "TenantName"}}' \
    -H "Content-type: application/json" https://<keystone_host>/v2.0/tokens

Finally, you should obtain your token::

    {
        "access": {
                (...)
            }, 
            "serviceCatalog": [
                    (...)
            ], 
            "token": {
                "expires": "2013-07-30T12:16:23Z", 
                "id": "ccb739df861e76a5a9039d21ec040a91", 
                "issued_at": "2013-07-29T12:16:23.625426", 
                "tenant": {
                    "description": "Some Tenant", 
                    "enabled": true, 
                    "id": "999f045cb1ff4684a15ebb334af61461", 
                    "name": "TenantName"
                }
            }, 
            "user": {
                (...)
            }
        }
    }

