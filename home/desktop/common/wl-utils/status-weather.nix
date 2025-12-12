{ pkgs, ... }:

{
  # Weather script for waybar
  home.packages = [
    (pkgs.writeShellScriptBin "status-weather" ''
      # Waybar weather module script
      # Fetches weather data from wttr.in and formats it for waybar

      LOCATION="Brighton,CO"
      UNITS="u"  # u for US units (F, mph), m for metric

      # Fetch weather data (redirect stderr to avoid JSON pollution)
      weather_data=$(${pkgs.curl}/bin/curl -sf "wttr.in/''${LOCATION}?format=j2&''${UNITS}" 2>/dev/null)

      if [ -z "$weather_data" ]; then
          echo '{"text": "󰼯 N/A", "tooltip": "Weather data unavailable"}'
          exit 0
      fi

      # Parse JSON data
      temp=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_F')
      feels_like=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].FeelsLikeF')
      condition=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherDesc[0].value')
      humidity=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].humidity')
      wind_speed=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].windspeedMiles')
      wind_dir=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].winddir16Point')
      precip=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].precipMM')
      uv=$(echo "$weather_data" | ${pkgs.jq}/bin/jq -r '.current_condition[0].uvIndex')

      # Map weather condition to icon
      get_icon() {
          case "$1" in
              *[Cc]lear*|*[Ss]unny*) echo "󰖙" ;;
              *[Pp]artly*[Cc]loudy*|*[Pp]artly*cloudy*) echo "󰖕" ;;
              *[Cc]loudy*|*[Oo]vercast*) echo "󰖐" ;;
              *[Rr]ain*|*[Dd]rizzle*) echo "󰖗" ;;
              *[Tt]hunder*|*[Ss]torm*) echo "󰖓" ;;
              *[Ss]now*|*[Ss]leet*) echo "󰖘" ;;
              *[Ff]og*|*[Mm]ist*|*[Hh]aze*) echo "󰖑" ;;
              *) echo "󰖐" ;;
          esac
      }

      icon=$(get_icon "$condition")

      # Format display text
      text="''${icon} ''${temp}°F"

      # Build tooltip with detailed info (actual newlines, jq will escape them)
      tooltip="<b>''${condition}</b>
Temperature: ''${temp}°F (feels like ''${feels_like}°F)
Humidity: ''${humidity}%
Wind: ''${wind_dir} ''${wind_speed} mph
Precipitation: ''${precip}mm
UV Index: ''${uv}"

      # Output JSON for waybar on a single line
      ${pkgs.jq}/bin/jq -n --unbuffered --compact-output \
          --arg text "$text" \
          --arg tooltip "$tooltip" \
          '{text: $text, tooltip: $tooltip, class: "weather"}' 2>/dev/null || \
          echo '{"text":"󰼯 Error","tooltip":"Failed to generate weather data"}'
    '')
  ];
}
