{ config, pkgs, ... }:

{
   
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  # Disable NetworkManager's internal DNS resolution
  networking.networkmanager.dns = "none";

  # These options are unnecessary when managing DNS ourselves
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.nameservers= [
    "192.168.178.71"
    "100.100.100.100"
    "8.8.8.8"
    "1.1.1.1"
  ];

  

  networking.resolvconf.enable = true;

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "*";
      listen-address = [
        "127.0.0.1"
        "192.168.178.71"
      ];

      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;
      bind-interfaces = true;
      local-service = true;

      server = [
        "/ts.net/100.100.100.100"
        "/fritz.box/192.168.178.1"
        "8.8.8.8"
      ];

      domain = "hobbit.hole,foxhound-shark.ts.net,fritz.box";
      local = "/hobbit.hole/";

      address = [
        "/hobbit.hole/192.168.178.69"
      ];

      srv-host = [
        "_http_tcp.photos.hobbit.hole,photos.hobbit.hole,2342,0,0"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mkcert
    nss
  ];
 
  systemd.services.local-certs = {
    description = "Create local SSL certificates";
    wantedBy = [ "multi-user.target" ];
  
    # Add required dependencies
    after = [ "network.target" ];

    environment = {
      # Set the CA root directory
      CAROOT = "/etc/local-certs/CA";
    };
  
    script = ''
      # Set working directory
      cd /root
    
      # Ensure directory exists first
      mkdir -p /etc/local-certs
    
      # Setup mkcert with more verbose output
      echo "Installing root CA..."
      ${pkgs.mkcert}/bin/mkcert -install || exit 1
    
      echo "Generating certificates..."
      ${pkgs.mkcert}/bin/mkcert \
        "*.hobbit.hole" \
        "photos.hobbit.hole" \
        "localhost" \
        "127.0.0.1" || exit 1
    
      echo "Moving certificates..."
      # Use more robust mv with error checking
      if [ -f ./_wildcard.hobbit.hole+3.pem ]; then
        mv ./_wildcard.hobbit.hole+3.pem /etc/local-certs/cert.pem
        mv ./_wildcard.hobbit.hole+3-key.pem /etc/local-certs/key.pem
        chmod 644 /etc/local-certs/cert.pem
        chmod 600 /etc/local-certs/key.pem
        echo "Certificates installed successfully"
      else
        echo "Certificate files not found"
        exit 1
      fi
    '';
  
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Add these for better error handling
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
