# ADR-0001 · Monolito modular con interfaces públicas

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

La app debe ser mantenible y demostrar separación de responsabilidades sin pagar el coste operativo de varios paquetes o servicios. El dominio es pequeño (cuentas, sobres, movimientos, reportes), pero las reglas de negocio son estrictas.

## Decisión

Un único proyecto Flutter organizado en `lib/modules/<módulo>/` con tres capas:

- `domain/`: modelos y una interfaz pública (p. ej. `EnvelopesRepository`).
- `data/`: implementación Drift de esa interfaz.
- `presentation/`: widgets que solo conocen la interfaz.

El esquema SQLite vive en `core_db`; los módulos reciben la misma instancia de `AppDatabase`. La composición (qué implementación usa cada interfaz) ocurre únicamente en `lib/app/providers.dart`.

## Consecuencias

- Los tests pueden usar las implementaciones reales contra `NativeDatabase.memory()` sin mocks.
- Un módulo puede extraerse a paquete moviendo su carpeta y su provider.
- `core_db` es un punto único de cambio de esquema; hay que evitar que acumule lógica de negocio.
- `reports` puede leer tablas de otros módulos, pero solo en modo lectura.
