#!/usr/bin/env bash

# --- Konfiguration ---
# PyMOL ausführbare Datei
PYMOL_PATH="/home/roessel/pymol/pymol"
# Ausgabeordner für die Renderings 
OUTPUT_DIR="/home/roessel/RENDER"

CONFIG_FILE="render_config.txt"
DEFAULT_WIDTH=4000
DEFAULT_HEIGHT=4000
OUTPUT_FORMAT="png"

PYMOL_SETTINGS=$(cat <<'EOF'
set ray_shadow, 1
set ray_trace_mode, 1
set antialias, 4
EOF
)

if [[ ! -d "$OUTPUT_DIR" ]]; then
    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

get_resolution() {
    local filename="$1"
    if [[ -f "$CONFIG_FILE" ]]; then
        local line
        line=$(grep -E "^${filename}[[:space:]]*" "$CONFIG_FILE" 2>/dev/null)
        if [[ -n "$line" ]]; then
            local w h
            read -r _ w h <<< "$line"
            if [[ "$w" =~ ^[0-9]+$ ]] && [[ "$h" =~ ^[0-9]+$ ]]; then
                echo "$w $h"
                return
            fi
        fi
    fi
    echo "$DEFAULT_WIDTH $DEFAULT_HEIGHT"
}

found=false
for FILE in *.pse; do
    if [[ -f "$FILE" ]]; then
        found=true
        BASENAME="${FILE%.pse}"
        OUTPUT_FILE="${BASENAME}.${OUTPUT_FORMAT}"
        OUTPUT_PATH="${OUTPUT_DIR}/${OUTPUT_FILE}"     
        PYMOL_OUTPUT_BASE="${OUTPUT_PATH%.*}"
        read WIDTH HEIGHT <<< "$(get_resolution "$BASENAME")"

        echo "============================================================"
        echo "Rendering $FILE -> $OUTPUT_PATH (${WIDTH}x${HEIGHT})"
        echo "============================================================"

        "$PYMOL_PATH" -cq "$FILE" -d "
$PYMOL_SETTINGS
ray ${WIDTH},${HEIGHT}
png ${PYMOL_OUTPUT_BASE}
quit
"
        # Prüft den Exit-Status von PyMOL
        if [ $? -ne 0 ]; then
            echo "ERROR: PyMOL rendering failed for $FILE."
        fi
    fi
done

if ! $found; then
    echo "No .pse files found in the current directory."
    exit 1
fi

echo "============================================================"
echo "RENDERING FINISHED SUCCESSFULLY"
echo "============================================================"
