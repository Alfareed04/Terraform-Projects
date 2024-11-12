resource_name = "Project2-rg"
location = "East US"

vnets={
    "project2_vnet" ={
        name="project2_vnet"
        address_space="10.1.0.0/16"
    }
}

subnets={
    "Subnet" ={
        subnet_name ="Subnet"
        address_prefix = "10.1.1.0/24"
    }
}

nsg_name = "nsg"
routetable_name = "p2-route-table"


security_rules = {
  "security_rules" = {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"    
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}