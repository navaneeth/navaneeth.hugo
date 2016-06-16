+++
categories = ["programming", "elixir"]
date = "2016-06-14T19:01:04+05:30"
description = ""
keywords = []
title = "Accessing nested keys from a map in Elixir"

+++


Erlang VM is a powerful pattern matching system. Pattern matching comes very handy when you want to access nested fields in a map.

Recently at work, I had to parse a large JSON and extract value of a key. This post shows how you can use pattern matching to extract deeply nested values from a JSON.

<!--more-->

Here is a sample JSON

```
"apiGroups": {
    "affiliate": {
      "name": "affiliate",
      "apiListings": {
        "televisions": {
          "availableVariants": {
            "v1.1.0": {
              "resourceName": "televisions",
              "get": "https://affiliate-api.flipkart.net/affiliate/1.0/feeds/16/category/ckf-czl.json?expiresAt=1465939211609&sig=6ef13e817f5e7a3e974407e766e82ddc",
              "deltaGet": "https://affiliate-api.flipkart.net/affiliate/1.0/deltaFeeds/16/category/ckf-czl.json?expiresAt=1465939211609&sig=6ef13e817f5e7a3e974407e766e82ddc",
              "post": null,
              "put": null,
              "delete": null
            },
          }
        }
      }
    }
  }
```

From this, I have to extract the value for the key `get`.

Here is how you can pattern match and extract the value:

```
  defp get_product_url(category) do
    case HTTPotion.get("https://affiliate-api.flipkart.net/affiliate/api/.....") do
      %HTTPotion.Response{body: body, status_code: 200} ->
        %{"apiGroups" =>
          %{"affiliate" =>
            %{"apiListings" =>
              %{^category =>
                %{"availableVariants" =>
                  %{"v1.1.0" =>
                    %{"get" => product_url}
                  }
                }
              }
            }
          }
        } = Poison.decode!(body)
        product_url
      %HTTPotion.ErrorResponse{message: reason} ->
        Logger.error reason
    end
  end
```

Did you notice the `^category`? In this case, we are using value of `category` as the key. `^` symbol tells Elixir to expand the variable.

Caveat: Using this style, you will get cryptic error message which just says right hand side values can't be matched with left hand side in case of wrong data format. Thus, use this carefully in situations where you are sure about the data format. 

Pretty neat!
