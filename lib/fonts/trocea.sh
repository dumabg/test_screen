#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "USO: $0 <NOMBRE_DEL_FICHERO>"
    exit 1
fi

ARCHIVO_ORIGEN="$1"
NOMBRE_ARCHIVO="${ARCHIVO_ORIGEN%.*}"
NOMBRE_ARCHIVO=$(echo "$NOMBRE_ARCHIVO" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | sed -E 's/([A-Z]+)/_\1/g; s/__*/_/g; s/^_//')
DIR_TEMP="$NOMBRE_ARCHIVO"_parts

mkdir -p "$DIR_TEMP"

cp $ARCHIVO_ORIGEN $DIR_TEMP/${NOMBRE_ARCHIVO}.mod

# Divide el archivo en partes de 500K
split -b 500K -d -a 2 "$DIR_TEMP/${NOMBRE_ARCHIVO}.mod" "$DIR_TEMP/${NOMBRE_ARCHIVO}_part"

# Crea los archivos .dart para cada parte
for PARTE in "$DIR_TEMP/${NOMBRE_ARCHIVO}_part"*; do
    echo $PARTE
    NUMERO_PARTE=$(echo "$PARTE" | grep -o '[0-9]*$')
    # Convert binary data to hex
    CONTENIDO_ARCHIVO_TROZEADO=$(python3 generate_list_int.py -i $PARTE)
    # Convert to lowerCamelCase
    FUNC_NAME=$(echo "font_${NOMBRE_ARCHIVO}_part" | sed -r 's/(^|_)([a-z])/\U\2/g; s/_//g')
    # Ensure the first letter is lowercase
    FUNC_NAME="${FUNC_NAME,}"
    cat <<EOF > "$DIR_TEMP/font_${NOMBRE_ARCHIVO}_part${NUMERO_PARTE}.dart"
import 'dart:typed_data';

Uint8List ${FUNC_NAME}${NUMERO_PARTE}() =>
   Uint8List.fromList([$CONTENIDO_ARCHIVO_TROZEADO]);
EOF
done

# Genera el archivo principal .dart
cat <<EOF > "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
import 'dart:typed_data';
EOF

for PARTE in "$DIR_TEMP/font_${NOMBRE_ARCHIVO}_part"*; do
    ARCHIVO_PART=$(basename "$PARTE")
    echo "import '$ARCHIVO_PART';" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
done

cat <<EOF >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"

Uint8List concatenateUint8Lists(List<Uint8List> lists) {
  int totalLength = 0;
  for (final list in lists) {
    totalLength += list.length;
  }

  final result = Uint8List(totalLength);
  int offset = 0;

  for (final list in lists) {
    result.setRange(offset, offset + list.length, list);
    offset += list.length;
  }

  return result;
}

EOF

echo "" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"

  # Convert to lowerCamelCase
FUNC_NAME=$(echo "font_${NOMBRE_ARCHIVO}" | sed -r 's/(^|_)([a-z])/\U\2/g; s/_//g')
# Ensure the first letter is lowercase
FUNC_NAME="${FUNC_NAME,}"
echo "Uint8List ${FUNC_NAME}() {" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
echo "    return concatenateUint8Lists([" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
for PARTE in "$DIR_TEMP/font_${NOMBRE_ARCHIVO}_part"*; do
    NUMERO_PARTE=$(echo "$PARTE" | sed -n 's/.*_part\([^\.]*\)\.dart/\1/p')
     # Convert to lowerCamelCase
    FUNC_NAME=$(echo "font_${NOMBRE_ARCHIVO}_part" | sed -r 's/(^|_)([a-z])/\U\2/g; s/_//g')
    # Ensure the first letter is lowercase
    FUNC_NAME="${FUNC_NAME,}"
    echo "        ${FUNC_NAME}${NUMERO_PARTE}()," >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
done
echo "    ]);" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
echo "}" >> "$DIR_TEMP/${NOMBRE_ARCHIVO}.dart"
