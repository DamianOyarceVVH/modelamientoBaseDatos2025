# ==========================================
# sp_eco_trash_menu.py
# CRUD y visualización de Procedimientos Almacenados (MySQL) desde Python
# Autor: Dany (adaptado por ChatGPT)
# Propósito: Permitir ejecutar y visualizar los procedimientos almacenados
# de la base de datos `eco_trash` (roles, usuarios, basureros, materiales,
# objetos, metodos_pago, pagos) usando el conector oficial `mysql.connector`.
# Cada función está comentada para explicar qué hace cada línea y porqué.
# ==========================================

# Requisitos:
# 1) Instalar el conector oficial de MySQL para Python:
#    pip install mysql-connector-python
# 2) Ajustar las credenciales en DB_CONFIG según tu entorno.

# ---------- IMPORTS ----------
# Importa el conector oficial de MySQL para Python
import mysql.connector
# Importa 'datetime' para construir fechas cuando se inserten pagos
from datetime import datetime

# ---------- CONFIGURACIÓN DE CONEXIÓN ----------
# Diccionario con los parámetros necesarios para establecer la conexión con la BD.
DB_CONFIG = {
    "host": "localhost",        # Servidor MySQL (ej: localhost)
    "user": "root",             # Usuario con permisos adecuados
    "password": "1234",         # Contraseña del usuario (reemplazar)
    "database": "eco_trash",    # Base de datos objetivo creada con los SP
    # "port": 3306,               # (Opcional) Puerto si no es el por defecto
}

# ---------- FUNCIÓN DE CONEXIÓN ----------

def conectar():
    """
    Crea y devuelve una conexión a MySQL usando los parámetros definidos en DB_CONFIG.
    Si la conexión falla, se lanzará una excepción mysql.connector.Error que debe manejar
    el llamador.
    """
    # Conecta a MySQL y devuelve el objeto de conexión
    return mysql.connector.connect(**DB_CONFIG)


# ---------- FUNCIONES GENERALES DE AYUDA ----------

def _call_proc_no_results(proc_name: str, args: list = None) -> bool:
    """
    Llama a un procedimiento almacenado que NO devuelve result sets (por ejemplo, INSERT o UPDATE).
    - proc_name: nombre del procedimiento (string)
    - args: lista de argumentos positional, puede ser None
    Devuelve True si la operación se completó correctamente, False en caso de error.
    """
    cnx = cur = None  # inicializa variables para conexión y cursor
    try:
        # Crea la conexión con los parámetros del bloque DB_CONFIG
        cnx = conectar()
        # Crea un cursor a partir de la conexión para ejecutar instrucciones y SP
        cur = cnx.cursor()
        # Llama al procedimiento almacenado con los argumentos (si los hay)
        if args is None:
            cur.callproc(proc_name)
        else:
            cur.callproc(proc_name, args)
        # Confirma la transacción para que los cambios persistan en la BD
        cnx.commit()
        # Si todo fue bien, devuelve True
        return True
    except mysql.connector.Error as e:
        # Muestra el error en consola para depuración
        print(f"❌ Error ejecutando {proc_name}:", e)
        # Si la conexión aún está activa, intenta un rollback para dejar la BD consistente
        if cnx and cnx.is_connected():
            try:
                cnx.rollback()
            except Exception:
                pass
        return False
    finally:
        # Cierra el cursor si fue creado para liberar recursos
        if cur:
            cur.close()
        # Cierra la conexión si sigue abierta
        if cnx and cnx.is_connected():
            cnx.close()


def _call_proc_with_results(proc_name: str, args: list = None):
    """
    Llama a un procedimiento almacenado que devuelve resultados (SELECT).
    Retorna una lista de tuplas (filas) con los datos devueltos por el SP.
    - proc_name: nombre del procedimiento
    - args: lista de argumentos o None
    """
    cnx = cur = None
    results = []  # lista donde se acumularán las filas devueltas por el/los result sets
    try:
        # Abre la conexión
        cnx = conectar()
        # Crea un cursor (por defecto cursor de tipo que devuelve tuplas)
        cur = cnx.cursor()
        # Llama al procedimiento con o sin argumentos
        if args is None:
            cur.callproc(proc_name)
        else:
            cur.callproc(proc_name, args)

        # Los procedimientos pueden devolver uno o varios conjuntos de resultados.
        # 'stored_results()' permite iterar sobre cada conjunto de resultados retornado.
        
        # <-- CORREGIDO: Se agregaron los paréntesis () de nuevo
        # Tu versión de la librería los requiere.
        for stored in cur.stored_results(): 
            
            # fetchall() obtiene todas las filas del result set actual
            rows = stored.fetchall()
            # agrega las filas a la lista global
            results.extend(rows)

        # Devuelve la lista completa de filas (puede estar vacía si el SP no devolvió filas)
        return results

    except mysql.connector.Error as e:
        # En caso de error, muestra el detalle y devuelve una lista vacía
        print(f"❌ Error leyendo resultados de {proc_name}:", e)
        return []
    finally:
        # Cierra recursos siempre
        if cur:
            cur.close()
        if cnx and cnx.is_connected():
            cnx.close()


# ---------- FUNCIONES PARA 'roles' ----------
# (Esta sección parece estar correcta y consistente)

def roles_insertar(nombre: str, descripcion: str, created_by: str = "script") -> bool:
    """
    Llama al procedimiento sp_roles_insertar para insertar un nuevo rol.
    Devuelve True si la inserción fue exitosa, False si ocurrió un error.
    """
    # Prepara los parámetros en el mismo orden que define el SP
    args = [nombre, descripcion, created_by]
    # Usa la función genérica que ejecuta SPs sin resultados
    return _call_proc_no_results("sp_roles_insertar", args)


def roles_borrado_logico(id_roles: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_roles_borrado_logico para marcar un rol como eliminado (deleted = 1).
    """
    args = [id_roles, updated_by]
    return _call_proc_no_results("sp_roles_borrado_logico", args)


def roles_restaurar(id_roles: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_roles_restaurar para marcar un rol como activo (deleted = 0).
    """
    args = [id_roles, updated_by]
    return _call_proc_no_results("sp_roles_restaurar", args)


def roles_listar_activos():
    """
    Llama a sp_roles_listar_activos y muestra el resultado en consola de forma legible.
    """
    rows = _call_proc_with_results("sp_roles_listar_activos")
    # Imprime encabezado para el usuario
    print("\n=== ROLES ACTIVOS ===")
    try:
        # Recorre filas y muestra columnas esperadas: id_roles, nombre, descripcion, created_at, created_by
        for row in rows:
            # Asumimos el orden definido en el SP
            id_roles, nombre, descripcion, created_at, created_by = row
            print(f"ID:{id_roles:<3} | {nombre:<20} | {descripcion:<30} | Creado:{created_at} | By:{created_by}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_roles_listar_activos' no coincide.")


def roles_listar_todo():
    """
    Llama a sp_roles_listar_todo y muestra todos los roles (incluye campo 'deleted').
    """
    rows = _call_proc_with_results("sp_roles_listar_todo")
    print("\n=== TODOS LOS ROLES ===")
    try:
        for row in rows:
            # id_roles, nombre, descripcion, created_at, created_by, deleted
            id_roles, nombre, descripcion, created_at, created_by, deleted = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_roles:<3} | {nombre:<20} | {descripcion:<30} | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_roles_listar_todo' no coincide.")


# ---------- FUNCIONES PARA 'usuarios' ----------

def usuarios_insertar(nombre: str, apellido: str, num_contacto: str, email: str, roles_id_roles: int, created_by: str = "script") -> bool:
    """
    Llama a sp_usuarios_insertar para crear un nuevo usuario.
    """
    args = [nombre, apellido, num_contacto, email, roles_id_roles, created_by]
    return _call_proc_no_results("sp_usuarios_insertar", args)


def usuarios_borrado_logico(id_usuario: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_usuarios_borrado_logico para marcar un usuario como eliminado.
    """
    args = [id_usuario, updated_by]
    return _call_proc_no_results("sp_usuarios_borrado_logico", args)


def usuarios_restaurar(id_usuario: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_usuarios_restaurar para marcar un usuario como activo.
    """
    args = [id_usuario, updated_by]
    return _call_proc_no_results("sp_usuarios_restaurar", args)


def usuarios_listar_activos():
    """
    Llama a sp_usuarios_listar_activos e imprime usuarios con su rol asociado.
    """
    rows = _call_proc_with_results("sp_usuarios_listar_activos")
    print("\n=== USUARIOS ACTIVOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 6 columnas (según el Python original)
        for row in rows:
            # Se asume que el SP devuelve: id, nombre, apellido, num_contacto, rol, created_at
            id_usuario, nombre, apellido, num_contacto, rol_nombre, created_at = row
            print(f"ID:{id_usuario:<3} | {nombre} {apellido:<20} | Rol:{rol_nombre:<12} | Contacto:{num_contacto}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_usuarios_listar_activos' no coincide.")
        if rows: print(f"Se esperaban 6 columnas, pero la fila recibida fue: {rows[0]}")


def usuarios_listar_todo():
    """
    Llama a sp_usuarios_listar_todo e imprime todos los usuarios, activos y borrados.
    """
    rows = _call_proc_with_results("sp_usuarios_listar_todo")
    print("\n=== TODOS LOS USUARIOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 7 columnas (según el Python original)
        for row in rows:
            # Se asume que el SP devuelve: id, nombre, apellido, num_contacto, rol, deleted, created_at
            id_usuario, nombre, apellido, num_contacto, rol_nombre, deleted, created_at = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_usuario:<3} | {nombre} {apellido:<20} | Rol:{rol_nombre:<12} | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_usuarios_listar_todo' no coincide.")
        if rows: print(f"Se esperaban 7 columnas, pero la fila recibida fue: {rows[0]}")


# ---------- FUNCIONES PARA 'basureros' ----------
# (Esta sección parece estar correcta y consistente)

def basureros_insertar(ubicacion: str, capacidad_kg: int, created_by: str = "script") -> bool:
    args = [ubicacion, capacidad_kg, created_by]
    return _call_proc_no_results("sp_basureros_insertar", args)


def basureros_borrado_logico(id_basurero: int, updated_by: str = "script") -> bool:
    args = [id_basurero, updated_by]
    return _call_proc_no_results("sp_basureros_borrado_logico", args)


def basureros_restaurar(id_basurero: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_basureros_restaurar para marcar un basurero como activo.
    """
    args = [id_basurero, updated_by]
    return _call_proc_no_results("sp_basureros_restaurar", args)


def basureros_listar_activos():
    rows = _call_proc_with_results("sp_basureros_listar_activos")
    print("\n=== BASUREROS ACTIVOS ===")
    try:
        for row in rows:
            id_basurero, ubicacion, capacidad_kg, created_at = row
            print(f"ID:{id_basurero:<3} | Ubicacion:{ubicacion:<40} | Capacidad:{capacidad_kg}kg")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_basureros_listar_activos' no coincide.")


def basureros_listar_todo():
    rows = _call_proc_with_results("sp_basureros_listar_todo")
    print("\n=== TODOS LOS BASUREROS ===")
    try:
        for row in rows:
            id_basurero, ubicacion, capacidad_kg, created_at, deleted = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_basurero:<3} | {ubicacion:<40} | {capacidad_kg}kg | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_basureros_listar_todo' no coincide.")


# ---------- FUNCIONES PARA 'materiales' ----------

def materiales_insertar(nombre: str, composicion: str, precio_unidad: float, unidad_medida: str, created_by: str = "script") -> bool:
    """
    (NOTA: Ajustado para incluir 'unidad_medida' según el SP original del SQL)
    """
    args = [nombre, composicion, precio_unidad, unidad_medida, created_by]
    return _call_proc_no_results("sp_materiales_insertar", args)


def materiales_borrado_logico(id_material: int, updated_by: str = "script") -> bool:
    args = [id_material, updated_by]
    return _call_proc_no_results("sp_materiales_borrado_logico", args)


def materiales_restaurar(id_material: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_materiales_restaurar para marcar un material como activo.
    """
    args = [id_material, updated_by]
    return _call_proc_no_results("sp_materiales_restaurar", args)


def materiales_listar_activos():
    rows = _call_proc_with_results("sp_materiales_listar_activos")
    print("\n=== MATERIALES ACTIVOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 5 columnas (según el Python original, usando created_at)
        for row in rows:
            # Se asume que el SP devuelve: id, nombre, composicion, precio, created_at
            id_material, nombre, composicion, precio_unidad, created_at = row
            print(f"ID:{id_material:<3} | {nombre:<20} | {composicion:<30} | Precio:{precio_unidad}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_materiales_listar_activos' no coincide.")
        if rows: print(f"Se esperaban 5 columnas, pero la fila recibida fue: {rows[0]}")


def materiales_listar_todo():
    rows = _call_proc_with_results("sp_materiales_listar_todo")
    print("\n=== TODOS LOS MATERIALES ===")
    try:
        # <-- CORREGIDO: Ajustado a 6 columnas (según el Python original, usando created_at)
        for row in rows:
            # Se asume que el SP devuelve: id, nombre, composicion, precio, deleted, created_at
            id_material, nombre, composicion, precio_unidad, deleted, created_at = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_material:<3} | {nombre:<20} | Precio:{precio_unidad} | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_materiales_listar_todo' no coincide.")
        if rows: print(f"Se esperaban 6 columnas, pero la fila recibida fue: {rows[0]}")


# ---------- FUNCIONES PARA 'objetos' ----------

def objetos_insertar(nombre: str, descripcion: str, cantidad: int, id_material: int, id_basurero: int, created_by: str = "script") -> bool:
    """
    (NOTA: Ajustado para incluir 'cantidad' según el SP original del SQL)
    """
    args = [nombre, descripcion, cantidad, id_material, id_basurero, created_by]
    return _call_proc_no_results("sp_objetos_insertar", args)


def objetos_borrado_logico(id_objeto: int, updated_by: str = "script") -> bool:
    args = [id_objeto, updated_by]
    return _call_proc_no_results("sp_objetos_borrado_logico", args)


def objetos_restaurar(id_objeto: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_objetos_restaurar para marcar un objeto como activo.
    """
    args = [id_objeto, updated_by]
    return _call_proc_no_results("sp_objetos_restaurar", args)


def objetos_listar_activos():
    rows = _call_proc_with_results("sp_objetos_listar_activos")
    print("\n=== OBJETOS ACTIVOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 6 columnas (según el Python original)
        for row in rows:
            # Se asume que el SP devuelve: id, objeto, descripcion, material, ubicacion, created_at
            id_objetos, objeto, descripcion, material, basurero_ubicacion, created_at = row
            print(f"ID:{id_objetos:<3} | {objeto:<25} | Material:{material:<12} | Ubic:{basurero_ubicacion}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_objetos_listar_activos' no coincide.")
        if rows: print(f"Se esperaban 6 columnas, pero la fila recibida fue: {rows[0]}")


def objetos_listar_todo():
    rows = _call_proc_with_results("sp_objetos_listar_todo")
    print("\n=== TODOS LOS OBJETOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 7 columnas (según el Python original)
        for row in rows:
            # Se asume que el SP devuelve: id, objeto, descripcion, material, ubicacion, deleted, created_at
            id_objetos, objeto, descripcion, material, basurero_ubicacion, deleted, created_at = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_objetos:<3} | {objeto:<25} | Material:{material:<12} | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_objetos_listar_todo' no coincide.")
        if rows: print(f"Se esperaban 7 columnas, pero la fila recibida fue: {rows[0]}")


# ---------- FUNCIONES PARA 'pagos' ----------
# (CORREGIDO: Esta sección se revirtió a la versión original del Python, que usa 6 parámetros
# de inserción y espera 7 y 8 columnas al listar, ya que esto causaba el error)

def pagos_insertar(monto: float, fec_pago: datetime, id_objetos: int, id_usuario: int, id_metodo_pago: int, created_by: str = "script") -> bool:
    # <-- CORREGIDO: Revertido a la versión de 6 parámetros del Python original
    # Convierte la fecha a string aceptada por MySQL si es un datetime
    fec_str = fec_pago.strftime('%Y-%m-%d %H:%M:%S') if isinstance(fec_pago, datetime) else fec_pago
    args = [monto, fec_str, id_objetos, id_usuario, id_metodo_pago, created_by]
    return _call_proc_no_results("sp_pagos_insertar", args)


def pagos_borrado_logico(id_pago: int, updated_by: str = "script") -> bool:
    args = [id_pago, updated_by]
    return _call_proc_no_results("sp_pagos_borrado_logico", args)


def pagos_restaurar(id_pago: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_pagos_restaurar para marcar un pago como activo.
    """
    args = [id_pago, updated_by]
    return _call_proc_no_results("sp_pagos_restaurar", args)


def pagos_listar_activos():
    rows = _call_proc_with_results("sp_pagos_listar_activos")
    print("\n=== PAGOS ACTIVOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 7 columnas (esta era la causa del error)
        for row in rows:
            # Se asume que el SP devuelve: id, monto, fecha, objeto, usuario, metodo_pago, created_at
            id_pago, monto, fec_pago, objeto_asociado, usuario_nombre, metodo_pago, created_at = row
            print(f"ID:{id_pago:<3} | {monto} | Fecha:{fec_pago} | Obj:{objeto_asociado} | Usu:{usuario_nombre} | MP:{metodo_pago}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_pagos_listar_activos' no coincide.")
        if rows: print(f"Se esperaban 7 columnas, pero la fila recibida fue: {rows[0]}")


def pagos_listar_todo():
    rows = _call_proc_with_results("sp_pagos_listar_todo")
    print("\n=== TODOS LOS PAGOS ===")
    try:
        # <-- CORREGIDO: Ajustado a 8 columnas
        for row in rows:
            # Se asume que el SP devuelve: 7 columnas + deleted + created_at
            id_pago, monto, fec_pago, objeto_asociado, usuario_nombre, metodo_pago, deleted, created_at = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_pago:<3} | {monto} | {fec_pago} | {estado} | Obj:{objeto_asociado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_pagos_listar_todo' no coincide.")
        if rows: print(f"Se esperaban 8 columnas, pero la fila recibida fue: {rows[0]}")


# ---------- FUNCIONES PARA 'metodos_pago' (Asumido del Script Python) ----------
# (Esta sección parece estar correcta y consistente)

def metodos_pago_insertar(nombre: str, otros_detalles: str, created_by: str = "script") -> bool:
    # Asume SP: sp_metodos_pago_insertar(p_nombre, p_otros_detalles, p_created_by)
    args = [nombre, otros_detalles, created_by]
    return _call_proc_no_results("sp_metodos_pago_insertar", args)


def metodos_pago_borrado_logico(id_metodo_pago: int, updated_by: str = "script") -> bool:
    # Asume SP: sp_metodos_pago_borrado_logico(p_id_metodo_pago, p_updated_by)
    args = [id_metodo_pago, updated_by]
    return _call_proc_no_results("sp_metodos_pago_borrado_logico", args)


def metodos_pago_restaurar(id_metodo_pago: int, updated_by: str = "script") -> bool:
    """
    Llama a sp_metodos_pago_restaurar para marcar un método como activo.
    (Asume que este SP existe)
    """
    args = [id_metodo_pago, updated_by]
    return _call_proc_no_results("sp_metodos_pago_restaurar", args)


def metodos_pago_listar_activos():
    # Asume SP: sp_metodos_pago_listar_activos()
    rows = _call_proc_with_results("sp_metodos_pago_listar_activos")
    print("\n=== METODOS DE PAGO ACTIVOS ===")
    try:
        for row in rows:
            id_metodo, nombre, otros_detalles, created_at = row
            print(f"ID:{id_metodo:<3} | {nombre:<20} | {otros_detalles}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_metodos_pago_listar_activos' no coincide.")


def metodos_pago_listar_todo():
    # Asume SP: sp_metodos_pago_listar_todo()
    rows = _call_proc_with_results("sp_metodos_pago_listar_todo")
    print("\n=== TODOS LOS METODOS DE PAGO ===")
    try:
        for row in rows:
            id_metodo, nombre, otros_detalles, deleted, created_at = row
            estado = "ACTIVO" if deleted == 0 else "ELIMINADO"
            print(f"ID:{id_metodo:<3} | {nombre:<20} | {estado}")
    except ValueError:
        print("❌ Error de desestructuración. La cantidad de columnas recibidas de 'sp_metodos_pago_listar_todo' no coincide.")


# ---------------- MENÚ PRINCIPAL POR TABLAS ----------------

def menu_tabla_roles():
    while True:
        print("\n--- MENÚ ROLES ---")
        print("1) Insertar rol")
        print("2) Listar roles ACTIVOS")
        print("3) Listar roles (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            nombre = input("Nombre rol: ").strip()
            descripcion = input("Descripcion: ").strip()
            created_by = input("Creado por (user): ").strip() or "script"
            ok = roles_insertar(nombre, descripcion, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            roles_listar_activos()
        elif op == "3":
            roles_listar_todo()
        elif op == "4":
            try:
                idr = int(input("ID rol a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = roles_borrado_logico(idr, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idr = int(input("ID rol a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = roles_restaurar(idr, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_usuarios():
    while True:
        print("\n--- MENÚ USUARIOS ---")
        print("1) Insertar usuario")
        print("2) Listar usuarios ACTIVOS")
        print("3) Listar usuarios (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            nombre = input("Nombre: ").strip()
            apellido = input("Apellido: ").strip()
            num_contacto = input("Contacto: ").strip()
            email = input("Email: ").strip()
            try:
                role_id = int(input("ID Rol (numérico): ").strip())
            except ValueError:
                print("ID rol inválido")
                continue
            created_by = input("Creado por: ").strip() or "script"
            ok = usuarios_insertar(nombre, apellido, num_contacto, email, role_id, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            usuarios_listar_activos()
        elif op == "3":
            usuarios_listar_todo()
        elif op == "4":
            try:
                idu = int(input("ID usuario a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = usuarios_borrado_logico(idu, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idu = int(input("ID usuario a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = usuarios_restaurar(idu, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_basureros():
    while True:
        print("\n--- MENÚ BASUREROS ---")
        print("1) Insertar basurero")
        print("2) Listar basureros ACTIVOS")
        print("3) Listar basureros (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            ubicacion = input("Ubicacion: ").strip()
            try:
                capacidad = int(input("Capacidad (kg): ").strip())
            except ValueError:
                print("Capacidad inválida")
                continue
            created_by = input("Creado por: ").strip() or "script"
            ok = basureros_insertar(ubicacion, capacidad, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            basureros_listar_activos()
        elif op == "3":
            basureros_listar_todo()
        elif op == "4":
            try:
                idb = int(input("ID basurero a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = basureros_borrado_logico(idb, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idb = int(input("ID basurero a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = basureros_restaurar(idb, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_materiales():
    while True:
        print("\n--- MENÚ MATERIALES ---")
        print("1) Insertar material")
        print("2) Listar materiales ACTIVOS")
        print("3) Listar materiales (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            nombre = input("Nombre material: ").strip()
            composicion = input("Composicion: ").strip()
            try:
                precio = float(input("Precio unidad (ej: 0.50): ").strip())
            except ValueError:
                print("Precio inválido")
                continue
            unidad_medida = input("Unidad medida (ej: kg): ").strip() or "kg"
            created_by = input("Creado por: ").strip() or "script"
            ok = materiales_insertar(nombre, composicion, precio, unidad_medida, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            materiales_listar_activos()
        elif op == "3":
            materiales_listar_todo()
        elif op == "4":
            try:
                idm = int(input("ID material a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = materiales_borrado_logico(idm, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idm = int(input("ID material a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = materiales_restaurar(idm, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_objetos():
    while True:
        print("\n--- MENÚ OBJETOS ---")
        print("1) Insertar objeto")
        print("2) Listar objetos ACTIVOS")
        print("3) Listar objetos (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            nombre = input("Nombre objeto: ").strip()
            descripcion = input("Descripcion: ").strip()
            try:
                cantidad = int(input("Cantidad (numérico): ").strip())
                id_mat = int(input("ID material (numérico): ").strip())
                id_bas = int(input("ID basurero (numérico): ").strip())
            except ValueError:
                print("IDs o cantidad inválidos")
                continue
            created_by = input("Creado por: ").strip() or "script"
            ok = objetos_insertar(nombre, descripcion, cantidad, id_mat, id_bas, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            objetos_listar_activos()
        elif op == "3":
            objetos_listar_todo()
        elif op == "4":
            try:
                ido = int(input("ID objeto a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = objetos_borrado_logico(ido, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                ido = int(input("ID objeto a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = objetos_restaurar(ido, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_metodos_pago():
    while True:
        print("\n--- MENÚ METODOS DE PAGO ---")
        print("1) Insertar método de pago")
        print("2) Listar métodos ACTIVOS")
        print("3) Listar métodos (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        if op == "1":
            nombre = input("Nombre método: ").strip()
            otros = input("Otros detalles: ").strip()
            created_by = input("Creado por: ").strip() or "script"
            ok = metodos_pago_insertar(nombre, otros, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            metodos_pago_listar_activos()
        elif op == "3":
            metodos_pago_listar_todo()
        elif op == "4":
            try:
                idm = int(input("ID método a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = metodos_pago_borrado_logico(idm, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idm = int(input("ID método a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = metodos_pago_restaurar(idm, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


def menu_tabla_pagos():
    while True:
        print("\n--- MENÚ PAGOS ---")
        print("1) Insertar pago")
        print("2) Listar pagos ACTIVOS")
        print("3) Listar pagos (TODOS)")
        print("4) Borrado lógico por ID")
        print("5) Restaurar por ID")
        print("0) Volver")
        op = input("Opción: ").strip()
        # <-- CORREGIDO: Revertido al menú de 6 parámetros del Python original
        if op == "1":
            try:
                monto = float(input("Monto (ej: 1000.50): ").strip())
            except ValueError:
                print("Monto inválido")
                continue
            # Permitir al usuario ingresar fecha en formato legible o usar NOW si deja vacío
            fec_input = input("Fecha pago (YYYY-MM-DD HH:MM:SS) o vacío para NOW: ").strip()
            if fec_input == "":
                fec = datetime.now()
            else:
                try:
                    fec = datetime.strptime(fec_input, '%Y-%m-%d %H:%M:%S')
                except ValueError:
                    print("Formato fecha inválido")
                    continue
            try:
                id_obj = int(input("ID objeto: ").strip())
                id_user = int(input("ID usuario: ").strip())
                id_mp = int(input("ID metodo pago: ").strip())
            except ValueError:
                print("IDs inválidos")
                continue
            created_by = input("Creado por: ").strip() or "script"
            ok = pagos_insertar(monto, fec, id_obj, id_user, id_mp, created_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "2":
            pagos_listar_activos()
        elif op == "3":
            pagos_listar_todo()
        elif op == "4":
            try:
                idp = int(input("ID pago a BORRAR lógicamente: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script"
            ok = pagos_borrado_logico(idp, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "5":
            try:
                idp = int(input("ID pago a RESTAURAR: ").strip())
            except ValueError:
                print("ID inválido")
                continue
            updated_by = input("Actualizado por: ").strip() or "script_restore"
            ok = pagos_restaurar(idp, updated_by)
            print("✅ OK" if ok else "❌ Error")
        elif op == "0":
            break
        else:
            print("Opción no válida")


# ---------- MENÚ PRINCIPAL ----------

def menu_principal():
    """
    Menú principal que permite acceder a los sub-menús por tabla.
    """
    while True:
        print("\n===== MENÚ PRINCIPAL (eco_trash - SP) =====")
        print("1) Roles")
        print("2) Usuarios")
        print("3) Basureros")
        print("4) Materiales")
        print("5) Objetos")
        print("6) Metodos de Pago")
        print("7) Pagos")
        print("0) Salir")
        opcion = input("Selecciona una opción: ").strip()
        if opcion == "1":
            menu_tabla_roles()
        elif opcion == "2":
            menu_tabla_usuarios()
        elif opcion == "3":
            menu_tabla_basureros()
        elif opcion == "4":
            menu_tabla_materiales()
        elif opcion == "5":
            menu_tabla_objetos()
        elif opcion == "6":
            menu_tabla_metodos_pago()
        elif opcion == "7":
            menu_tabla_pagos()
        elif opcion == "0":
            print("Saliendo...")
            break
        else:
            print("Opción no válida. Intenta nuevamente.")


# Punto de entrada del script
if __name__ == "__main__":
    print("Iniciando interfaz de procedimientos almacenados para 'eco_trash'.")
    print("Asegúrate de tener los procedimientos creados en la base de datos y ajustar DB_CONFIG.")
    menu_principal()