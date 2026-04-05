# Cómo ejecutar (Laravel + Next + Flutter)

## 1) Base de datos (MySQL)
- La BD se llama `delicias_bakery`.
- Importa `WEBNIDA/delicias_bakery.sql` en tu MySQL.
- Verifica el `.env` del backend: `WEBNIDA/backend/.env`:
  - `DB_HOST=127.0.0.1`
  - `DB_PORT=3306`
  - `DB_DATABASE=delicias_bakery`
  - `DB_USERNAME=root`
  - `DB_PASSWORD=` (vacío si tu root no tiene clave)

## 2) Backend (Laravel API) — puerto 5001
En PowerShell:

```ps1
cd C:\Users\usuario\Downloads\APPNID\WEBNIDA\backend
npm run backend
```

Prueba:
- `http://127.0.0.1:5001/up`
- `http://127.0.0.1:5001/api/categorias`
- `http://127.0.0.1:5001/uploads/` (debe responder 404 si no hay archivo, pero NO “connection refused”)

## 3) Frontend (Next) — puerto 3000
En otra terminal:

```ps1
cd C:\Users\usuario\Downloads\APPNID\WEBNIDA\frontend
npm install
npm run dev
```

## 4) Flutter (Android)
### Opción A: Wi‑Fi (misma red)
- Configura en la app: `192.168.152.1:5001`

### Opción B: USB (recomendado)
En tu PC:
```ps1
adb devices
adb reverse tcp:5001 tcp:5001
```
En la app configura: `127.0.0.1:5001`

## Nota importante
- Si cierras la ventana donde corre el backend, `http://127.0.0.1:5001` se cae y el admin mostrará “No se pudo conectar con el backend”.
