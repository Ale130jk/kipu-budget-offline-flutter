# ADR-0005 · Respaldo con `VACUUM INTO` y restauración por ATTACH

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

El usuario debe poder llevarse sus datos y recuperarlos sin nube. Copiar el archivo SQLite en caliente puede producir una copia inconsistente si hay escrituras en curso.

## Decisión

**Exportar:** `VACUUM INTO '<ruta temporal>'` genera una copia consistente y compacta; se lee a memoria y se comparte como `.sqlite`.

**Restaurar:**

1. Verificar cabecera `SQLite format 3\0` antes de abrir nada.
2. `ATTACH DATABASE` del archivo elegido.
3. Comprobar `PRAGMA backup.user_version` contra `schemaVersion`.
4. Verificar que existen todas las tablas esperadas.
5. Desactivar FKs, borrar en orden inverso a las dependencias, insertar todas las tablas y ejecutar `PRAGMA foreign_key_check`.
6. Confirmar dentro de una transacción; reactivar FKs y `DETACH` en `finally`.

La restauración es destructiva y la UI exige confirmación explícita.

## Consecuencias

- Un archivo ajeno o de otra versión se rechaza con `DomainException`, sin tocar los datos actuales.
- Los streams de Drift se refrescan con `customUpdate(updates:)` por tabla.
- El archivo temporal de restauración se elimina siempre.
- El respaldo no incluye preferencias del sistema (biometría) fuera de `app_settings`.
