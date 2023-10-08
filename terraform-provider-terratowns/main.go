// "package main" is a special package that indicates it contains the code for an executable application. 
// It likely contains code that can be compiled into a binary and run.
package main

// "fmt" is a package that provides functions for formatting and printing text.
// It includes functions for formatting and printing data types: strings, numbers, dates, and times. 
// It also includes functions for reading and writing text to and from files.
import (
    //"fmt"
	//"log"
    "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
    "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

// "func main" is a special function that is the entry point for all executable Go programs. 
// It's the only required function in an executable Go program, and is typically used to initialize and start the main program loop.
func main() {
  plugin.Serve(&plugin.ServeOpts{
	ProviderFunc: Provider,
})

}

func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider {
		ResourcesMap: map[string]*schema.Resource{

		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint for the external service",
			},
			"token": {
				Type: schema.TypeString,
				Sensitive: true, // sensitive hides the token in the logs
				Required: true,
				Description: "The bearer token for authorisation",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID for configuration",
				//ValidateFunc: validateUUID,
			},
		},
	}

	//p.ConfigureContextFunc = providerConfigure(p)
	return p
}

// func validateUUID(v interface{}, k string) (ws []string, errors []error) {
// 	log.Print("validateUUID:start")
// 	value := v.(string)
// 	if _,err = uuid.Parse(value); err != nil {
// 		errors = append(error, fmt.Errorf("invalid UUID format"))
// 	}
// 	log.Print("validateUUID:end")
// }