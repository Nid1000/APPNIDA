<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ContactoController extends Controller
{
    public function store(Request $request)
    {
        try {
            $data = $request->validate([
                'nombre' => ['required', 'string', 'min:2', 'max:80'],
                'email' => ['required', 'email'],
                'telefono' => ['nullable', 'string', 'min:6', 'max:20'],
                'mensaje' => ['required', 'string', 'min:5', 'max:1000'],
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'statusCode' => 400,
                'error' => 'Datos inválidos',
                'message' => 'Validación fallida',
                'details' => $e->errors(),
            ], 400);
        }

        Log::info('Nuevo contacto', $data);

        $id = (string) round(microtime(true) * 1000);
        return response()->json([
            'ok' => true,
            'id' => $id,
            'message' => 'Mensaje recibido. ¡Gracias por contactarnos!',
        ], 201);
    }
}

