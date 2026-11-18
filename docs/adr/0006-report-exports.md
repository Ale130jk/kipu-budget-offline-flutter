# ADR-0006 · Reportes PDF y Excel generados en el dispositivo

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

RF-05 exige PDF y Excel sin backend. El PDF debe mostrar acentos y símbolos monetarios; el Excel debe ser multi-hoja y filtrable.

## Decisión

- **PDF:** `pdf` + `printing`. Se embebe Roboto (Regular/Bold) desde `assets/fonts/` porque las fuentes base del paquete no cubren Unicode completo. Montos con `NumFormat.custom`, fechas como texto `dd/MM/yyyy`.
- **Excel:** `excel` para construir hojas (Resumen, Sobres, Movimientos). La librería no expone autofiltros, así que se parchea el XML de la hoja con `archive` para insertar `<autoFilter ref="...">` en el encabezado.
- **Entrega:** vista previa con `Printing.layoutPdf`; compartir con `SharePlus` escribiendo bytes en un archivo temporal.

## Consecuencias

- Los tests decodifican el Excel con `Excel.decodeBytes` y verifican el XML del autofiltro; el PDF se valida por cabecera `%PDF`.
- La exportación requiere `WidgetsFlutterBinding` en tests por la carga de fuentes.
- Si `excel` añade soporte nativo de autofiltros, se elimina el parche de `archive`.
- Todo ocurre offline; no se sube ningún dato.
