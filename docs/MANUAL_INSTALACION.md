# MANUAL DE INSTALACIÓN Y CONFIGURACIÓN - SoldaSur IA Chatbot (v5.0.2)

Este manual detalla los requisitos del sistema, pasos de instalación, configuración del entorno, mantenimiento del catálogo de productos y la arquitectura del repositorio de **SoldaSur IA Chatbot**.

---

## Índice

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación y Puesta en Marcha](#instalación-y-puesta-en-marcha)
3. [Ejecución de la Aplicación](#ejecución-de-la-aplicación)
4. [Configuración del Modelo de Lenguaje (Ollama)](#configuración-del-modelo-de-lenguaje-ollama)
5. [Mantenimiento y Scraping](#mantenimiento-y-scraping)
6. [Escalamiento: Agregar una Nueva Marca](#escalamiento-agregar-una-nueva-marca)
7. [Estructura del Repositorio](#estructura-del-repositorio)
8. [Solución de Problemas Técnicos](#solución-de-problemas-técnicos)
9. [Glosario Técnico](#glosario-técnico)

---

## Requisitos del Sistema

### Requisitos Mínimos de Hardware
| Componente | Especificación Mínima | Especificación Recomendada |
|------------|-----------------------|----------------------------|
| **Procesador** | Intel Core i5 / AMD Ryzen 5 | Intel Core i7 / AMD Ryzen 7 |
| **Memoria RAM** | 8 GB | 16 GB (o superior para Ollama local) |
| **Almacenamiento** | 10 GB libres | SSD con 15 GB libres |

### Software Base Requerido
1. **Python 3.10 o superior** (asegurarse de marcar "Add Python to PATH" durante la instalación).
2. **Ollama** (para la ejecución local y privada del modelo de lenguaje).
3. **Navegador Web** (Google Chrome, Mozilla Firefox, Microsoft Edge o Safari).

---

## Instalación y Puesta en Marcha

### Paso 1: Instalar Python (v3.10 o superior)
1. Descarga el instalador oficial de Python según tu sistema operativo desde la sección de descargas del sitio oficial: [https://www.python.org/downloads/](https://www.python.org/downloads/). Se recomienda una versión estable como **Python 3.10.x, 3.12.x o 3.14.x**.
2. Ejecuta el instalador descargado.
3. > [!IMPORTANT]
   > En la primera pantalla del instalador (especialmente en Windows), asegúrate de marcar la casilla **"Add Python to PATH"** (o *"Agregar Python al PATH"*). Si omites este paso, tu sistema no reconocerá el comando `python` en la terminal.
4. Sigue los pasos predeterminados y finaliza la instalación.
5. Abre una nueva consola (CMD o PowerShell) y verifica la versión de Python instalada corriendo:
   ```bash
   python --version
   ```
   Debe retornar un texto como `Python 3.10.x` o superior.

### Paso 2: Instalar y Configurar Ollama
1. Descarga el instalador de Ollama desde su sitio web oficial: [https://ollama.com](https://ollama.com).
2. Ejecuta el archivo descargado e instala la aplicación.
3. Inicia el servidor de Ollama. Si no se ejecuta automáticamente en la bandeja del sistema, abre una terminal y arráncalo con:
   ```bash
   ollama serve
   ```
4. Abre otra terminal de tu sistema (CMD o PowerShell en Windows) y descarga el modelo de lenguaje ejecutando:
   ```bash
   ollama pull llama3.2:3b
   ```
   *(Nota: Puedes cambiar el modelo en `configs/prompts.json` si prefieres utilizar otro como `mistral` o `llama3:8b` si tu hardware lo permite)*.

### Paso 3: Crear el Entorno Virtual de Python
Abre la consola en la raíz de la carpeta del proyecto (`SOLDASUR_PP2_1C_2026/`) y ejecuta:

**En Windows (Símbolo del Sistema / CMD):**
```cmd
python -m venv venv
venv\Scripts\activate
```

**En Windows (PowerShell):**
```powershell
python -m venv venv
# Si obtienes un error de permisos la primera vez, ejecuta en PowerShell:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\venv\Scripts\Activate.ps1
```

**En Linux/macOS:**
```bash
python -m venv venv
source venv/bin/activate
```

### Paso 4: Instalar Dependencias de Python
Con el entorno virtual activado (verás el prefijo `(venv)` en tu terminal), instala todas las librerías necesarias especificadas en el archivo de requerimientos:
```bash
pip install -r requirements.txt
```

*(Opcional: Si los scrapers interactivos requieren automatización de navegador con Playwright, ejecuta `playwright install chromium` para descargar su binario)*.

---

## Ejecución de la Aplicación

Para iniciar el servidor del chatbot y poder interactuar con él desde tu navegador web:

### Opción A: Inicio Automático (Recomendado en Windows)
En la raíz del proyecto, haz doble clic en el archivo **`EjecutarSoldy.bat`**. Este script se encargará automáticamente de:
1. Verificar si Ollama está ejecutándose (y lo iniciará en segundo plano si es necesario).
2. Programar la apertura automática de tu navegador por defecto en `http://localhost:9000`.
3. Activar el entorno virtual `venv` y levantar la aplicación FastAPI con Uvicorn en el puerto 9000 en primer plano.

---

### Opción B: Inicio Manual (Consola)
1. Asegúrate de iniciar el servidor de Ollama en una terminal si no se encuentra corriendo:
   ```bash
   ollama serve
   ```
2. Abre otra terminal, activa el entorno virtual (`venv` según tu consola) y levanta la API del backend ejecutando:
   ```bash
   python -m uvicorn app.main:app --port 9000 --reload
   ```
3. El servidor iniciará y estará disponible en: `http://localhost:9000`.
4. Abre tu navegador web y entra a `http://localhost:9000` para abrir la interfaz del chat.

---

## Configuración del Modelo de Lenguaje (Ollama)

Si deseas utilizar un modelo de lenguaje local diferente al predeterminado (`llama3.2:3b`) —como por ejemplo `llama3.1:8b` para mayor capacidad—, puedes configurarlo de forma centralizada:
1. Abre el archivo de configuración [configs/models.json](../configs/models.json) (si no existe, se puede crear en esa ubicación).
2. Modifica la propiedad `"ollama_model"` con el identificador exacto de tu modelo. Por ejemplo:
   ```json
   {
     "ollama_model": "llama3.1:8b"
   }
   ```
3. Antes de iniciar la aplicación, descarga el modelo correspondiente en tu terminal ejecutando:
   ```bash
   ollama pull llama3.1:8b
   ```

---

## Mantenimiento y Scraping

El sistema permite actualizar la información de sus productos de forma autónoma haciendo scraping web de los sitios oficiales de las marcas.

### Actualizar el Catálogo de Productos
Para actualizar los datos comerciales, imágenes y fichas de productos, ejecuta los scripts de scraping correspondientes:

* **Para PEISA:**
  ```bash
  python scraping/peisa_product_scraper.py
  ```
* **Para Weber:**
  ```bash
  python scraping/weber_product_scraper.py
  ```

Los scrapers descargarán la información más reciente y dejarán un archivo JSON unificado con los productos en la ruta correspondiente (por ejemplo, `web_app/data/peisa_catalog.json` y `weber_catalog.json`).

### Generación de Embeddings Vectoriales (Marcas Clásicas)
Si actualizaste la información de los catálogos y quieres que el chatbot empiece a usar estos nuevos datos en sus búsquedas semánticas libres:
```bash
python RAG_engine/scripts/ingest.py --all
```
*(Puedes especificar `--peisa` o `--weber` para actualizar una única marca)*.

---

## Escalamiento: Agregar una Nueva Marca

Una de las ventajas clave de la arquitectura **v5.0.2** es la capacidad de incorporar nuevas marcas al catálogo y a las calculadoras de manera dinámica sin alterar el código central del backend.

Para agregar una nueva marca al sistema (por ejemplo: `Durlock` u otra):

### Paso 1: Generar la Carpeta Origen
Ejecuta el scraper de la nueva marca o crea manualmente una carpeta temporal que recopile sus archivos. Dicha carpeta debe llamarse exactamente igual al nombre de la marca en minúsculas y estar ubicada dentro de `scraping/data_raw/`.

> [!IMPORTANT]
> Los archivos del catálogo de productos y configuraciones deben seguir estrictamente el formato y esquema de datos detallado en el [Anexo: Estándar de Estructura de Datos Scrapeados para Escalamiento](#anexo-estándar-de-estructura-de-datos-scrapeados-para-escalamiento).

Estructura de archivos requerida dentro de `scraping/data_raw/<marca_lower>/`:
```text
scraping/data_raw/<marca_lower>/
├── config.json                     # Palabras clave de clasificación y prompt del LLM
├── <marca_lower>_catalog.json      # Catálogo JSON con los productos estructurados
├── <marca_lower>-logo.png          # Imagen del logo comercial de la marca
├── calculator_kb.json              # (Opcional) Árbol de decisiones si tiene calculadora
└── calculator_engine.py            # (Opcional) Expresiones matemáticas si tiene calculadora
```

*Nota: La propiedad `"categories_processed"` en tu catálogo de productos permite especificar nombres estilizados para las categorías comerciales de los productos de forma que se rendericen correctamente en el menú del chatbot.*

### Paso 2: Ejecutar el Instalador Automático
Abre la terminal en la raíz del proyecto y ejecuta el instalador indicando el nombre de la carpeta de la marca:
```bash
python app/modules/escalamiento/install_brand.py NombreMarca
```
Por ejemplo, para instalar Durlock: `python app/modules/escalamiento/install_brand.py Durlock`

El script realizará las siguientes acciones de forma automática:
1. **Validación**: Verifica que las dependencias estén presentes.
2. **Base de Datos Vectorial**: Calcula los embeddings de los productos y compila el índice FAISS (`products_<marca>.faiss`) y el archivo de metadatos (`metadata_<marca>.json`) en `RAG_engine/database/`.
3. **Generación de Módulos RAG**: Autogenera los archivos de consultas y respuestas semánticas (`rag_query_<marca>.py` y `rag_llm_<marca>.py`) en `RAG_engine/query/`.
4. **Copia de Assets**: Copia el logotipo de la marca al frontend.
5. **Registro Dinámico**: Da de alta a la marca en `configs/brands_registry.json` y configura su prompt en `configs/prompts.json`.

Si la marca tiene calculadora, copia manualmente los archivos `calculator_kb.json` y `calculator_engine.py` en sus correspondientes rutas en el backend (`app/` y `app/modules/expertSystem/`) para habilitarla al instante.

---

## Estructura del Repositorio

A continuación se detalla la ubicación de los componentes del sistema para tareas de soporte técnico o auditorías:

```text
SOLDASUR_PP2_1C_2026/
│
├── 📄 EjecutarSoldy.bat                  # Script de inicio automático (Windows)
├── 📄 requirements.txt                   # Librerías de Python requeridas
├── 📄 README.md                          # Documentación del proyecto
├── 📄 TAREA.md                           # Tareas y configuraciones de migración de imágenes
│
├── 📂 app/                               # BACKEND DE LA APLICACIÓN
│   ├── 📄 main.py                        # Servidor FastAPI y endpoints web
│   ├── 📄 app.py                         # Funciones auxiliares y motor experto PEISA
│   ├── 📄 orchestrator.py                # Clasificador de intenciones e híbrido de chats
│   │
│   └── 📂 modules/                       # SUBMÓDULOS DE APLICACIÓN
│       ├── 📂 escalamiento/
│       │   └── 📄 install_brand.py       # Script de instalación automática de marcas
│       └── 📂 expertSystem/
│           ├── 📄 expert_engine_peisa.py # Motor del sistema experto de PEISA
│           ├── 📄 expert_engine_weber.py # Motor de cálculos de materiales Weber
│           └── 📄 product_loader.py      # Cargador de productos desde Excel/SQLite
│
├── 📂 configs/                           # ARCHIVOS DE CONFIGURACIÓN DINÁMICA
│   ├── 📄 brands_registry.json           # Registro de marcas y sus palabras clave
│   └── 📄 prompts.json                   # System prompts y parámetros de Ollama
│
├── 📂 docs/                              # DOCUMENTACIÓN TÉCNICA Y DE USUARIO
│   ├── 📄 MANUAL_ESCALAMIENTO.md.bk      # Copia de seguridad de guía de escalamiento
│   ├── 📄 MANUAL_TECNICO_ORQUESTADOR.md  # Flujo del orquestador e intenciones
│   ├── 📄 MANUAL_TECNICO_SISTEMA_EXPERTO_RAG.md # Reglas y fórmulas de sistemas expertos y RAG (PEISA/Weber)
│   ├── 📄 MANUAL_USUARIO.md.bk           # Copia de seguridad de manual de usuario original
│   ├── 📄 MANUAL_USUARIO.md              # Guía operativa y comercial de usuario
│   └── 📄 MANUAL_INSTALACION.md          # Este manual técnico de instalación y escalamiento
│
├── 📂 RAG_engine/                        # MOTOR RAG (BÚSQUEDA VECTORIAL)
│   ├── 📂 database/                      # Índices FAISS y metadatos compilados
│   │   ├── 📄 peisa_products.db          # BD SQLite de metadatos de PEISA
│   │   ├── 📄 peisa_products.faiss       # Índice vectorial de PEISA
│   │   └── 📄 weber_products.faiss       # Índice vectorial de Weber
│   │
│   ├── 📂 query/                         # Código RAG de inferencia de cada marca
│   │   ├── 📄 rag_query_peisa.py
│   │   ├── 📄 rag_llm_peisa.py
│   │   ├── 📄 rag_query_weber.py
│   │   └── 📄 rag_llm_weber.py
│   │
│   └── 📂 scripts/                       # Ingestas de datos tradicionales
│       ├── 📄 ingest.py                  # Orquestador central (--peisa, --weber, --all)
│       └── 📄 peisa_ingest.py            # Ingesta PEISA
│
├── 📂 scraping/                          # MÓDULOS DE EXTRACCIÓN (SCRAPERS)
│   ├── 📂 data_raw/                      # Carpeta de entrada con productos extraídos
│   ├── 📄 peisa_product_scraper.py       # Scraper de productos PEISA (BeautifulSoup)
│   └── 📄 weber_product_scraper.py       # Scraper de productos Weber (Playwright)
│
└── 📂 web_app/                           # INTERFAZ FRONTEND (HTML/CSS/JS Estático)
    ├── 📄 index.html                     # Archivo visual principal de acceso
    ├── 📄 soldasur.css                   # Estilos visuales del chat Soldy y tarjetas
    ├── 📄 soldasur.js                    # Orquestador JS del chatbot en el navegador
    │
    ├── 📂 data/                          # Catálogos comerciales consumidos por el navegador
    │   ├── 📄 peisa_catalog.json
    │   └── 📄 weber_catalog.json
    │
    └── 📂 js_modules/                    # Scripts del comportamiento del chat
        ├── 📄 core.js                    # Estado de navegación y listado de productos
        ├── 📄 chatbot.js                 # Handler para llamadas al LLM
        ├── 📄 peisa_expert.js            # Flujo interactivo de la calculadora PEISA
        └── 📄 weber_expert.js            # Flujo interactivo de la calculadora Weber
```

---

## Solución de Problemas Técnicos

### 1. El import de la librería `faiss` se muestra en rojo en mi editor
* **Causa**: Falso positivo común. Ocurre si tu editor de código (como VS Code) no tiene seleccionado el entorno virtual de Python (`venv`) donde está instalada la dependencia, o si el analizador de código estático no puede resolver extensiones de C++.
* **Solución**: En tu IDE, selecciona el intérprete de Python correcto apuntando a `.\venv\Scripts\python.exe`. A nivel de ejecución de código, esto no te impedirá correr la aplicación.

### 2. El chatbot se queda "pensando" indefinidamente
* **Causa**: El servicio local de Ollama está apagado o el modelo no está descargado.
* **Solución**: Abre una terminal de tu sistema y corre `ollama serve` para inicializar el servicio. Verifica si el modelo está presente con `ollama list` y, de ser necesario, descárgalo con `ollama pull llama3.2:3b`.

### 3. Error: "Address already in use" (Puerto 8000/9000 ocupado)
* **Causa**: Ya tienes otra instancia del backend corriendo o hay otro servicio escuchando en el puerto.
* **Solución**: Cierra cualquier otra consola del backend activa. Si persiste, detén el proceso ocupante ejecutando en Windows:
  ```cmd
  netstat -ano | findstr :9000
  taskkill /f /pid <NUMERO_PID>
  ```

---

## Glosario Técnico

* **RAG (Generación Aumentada por Recuperación)**: Técnica de IA que busca en una base de conocimientos específica (catálogos de Soldasur) antes de enviar la pregunta al modelo de lenguaje (LLM), evitando que el chatbot invente respuestas.
* **Sistema Experto**: IA basada en reglas explícitas lógicas y matemáticas. Útil para cálculos deterministicos como el dimensionamiento de calefacción o adhesivos.
* **FAISS (Facebook AI Similarity Search)**: Librería optimizada de búsqueda de similitud que permite buscar textos afines comparando números llamados "embeddings".
* **LLM (Modelo de Lenguaje Grande)**: Algoritmo generativo capaz de entender y formular textos amigables. En este proyecto se utiliza Ollama local con Llama 3.2.

---

## Anexo: Estándar de Estructura de Datos Scrapeados para Escalamiento

Este anexo define la estructura de directorios, nombres de archivos y esquemas de datos que debe cumplir cualquier scraper de nuevas marcas para que el instalador automático (`install_brand.py`) pueda procesar e integrar los productos, imágenes, documentos y sistemas expertos de forma 100% autónoma.

### 1. Estructura de Carpetas en el Repositorio

Los scrapers deben dejar todos los datos obtenidos dentro de la carpeta `scraping/data_raw/<nombre_marca>/` de la raíz del repositorio `SOLDASUR_PP2_1C_2026/`. 

La estructura exacta requerida es la siguiente:

```text
SOLDASUR_PP2_1C_2026/
└── scraping/
    └── data_raw/
        └── <marca_lower>/                    # Identificador de la marca en minúsculas (ej: durlock)
            ├── config.json                   # Configuración, palabras clave y prompts de la marca
            ├── <marca_lower>_catalog.json    # Catálogo estructurado de productos (ej: durlock_catalog.json)
            ├── <marca_lower>-logo.png        # Logotipo de la marca (cualquier imagen con 'logo' en el nombre)
            ├── calculator_kb.json            # (Opcional) Base de conocimiento del sistema experto
            ├── calculator_engine.py          # (Opcional) Lógica/Cálculos del sistema experto
            │
            ├── documentos/                   # Fichas técnicas, manuales y folletos en PDF
            │   └── *.pdf
            │
            ├── img/                          # Imágenes reales de los productos
            │   └── *.png | *.jpg | *.jpeg
            │
            └── logica/                       # (Opcional) Copia de archivos JS/calc de la web original
                └── *.js
```

---

### 2. Especificación de Archivos de Configuración

#### A. Archivo `config.json`
Establece los metadatos de la marca, los desencadenadores de conversación y el System Prompt del modelo RAG.

> [!IMPORTANT]
> **Generación Automática Obligatoria:**
> El script de scraping de la marca debe encargarse de autogenerar este archivo `config.json` en la carpeta `scraping/data_raw/<marca_lower>/` al finalizar la ejecución si este no existe. Se debe poblar con valores por defecto representativos (incluyendo palabras clave sugeridas y una plantilla base del prompt del sistema).
> De esta forma, el usuario o desarrollador puede posteriormente abrir dicho archivo para ajustar la personalidad, el tono del chatbot o editar `configs/prompts.json` una vez instalado.

```json
{
  "brand_key": "DURLOCK",
  "display_name": "Durlock",
  "direct_keywords": [
    "durlock",
    "placa",
    "placas",
    "yeso",
    "perfiles"
  ],
  "anchor_text": "placas de yeso placas de cemento siding masillas adhesivos aislantes perfiles construccion en seco revestimientos cielorrasos desmontables",
  "system_prompt": "Sos Soldy, el asesor experto de SOLDASUR especializado en productos Durlock. Ayudas al cliente con informacion tecnica sobre placas, perfiles y consumos. Tus respuestas deben ser breves, profesionales y en español rioplatense (voseo). NUNCA uses markdown ni formateo en tus respuestas.",
  "temperature": 0.2,
  "max_tokens": 250,
  "has_calculator": true,
  "calculator_display": "Calculadora Durlock"
}
```

*   `brand_key`: Identificador único en mayúsculas.
*   `display_name`: Nombre a mostrar en la interfaz de chat.
*   `direct_keywords`: Palabras clave en minúsculas que fuerzan la activación de esta marca en el chat.
*   `anchor_text`: Texto semántico descriptivo utilizado para el enrutamiento inteligente mediante IA.
*   `system_prompt`: Instrucción de comportamiento y personalidad del LLM.
*   `has_calculator`: `true` si la marca tiene un calculador/sistema experto; `false` si no.
*   `calculator_display`: Título del botón del calculador en el frontend.

---

### 3. Esquema del Catálogo de Productos (`<marca_lower>_catalog.json`)

El catálogo debe guardarse en la raíz de la carpeta de la marca bajo el nombre `<marca_lower>_catalog.json` (ej: `durlock_catalog.json`). Consiste en un array JSON de objetos con el siguiente esquema estricto:

```json
[
  {
    "model": "Placa Estándar Durlock®",
    "description": "La Placa Durlock® Estandar es la placa ideal para renovar o construir...",
    "url": "https://durlock.com/productos/placa-estandar-durlock/",
    "imagen_url": "https://durlock.com/files/productos/estandar-2.png",
    "local_imagen_path": "data_raw/durlock/img/estandar-2.png",
    "imagen_local": "data_raw/durlock/img/estandar-2.png",
    "categories": [
      "placas-de-yeso"
    ],
    "categories_processed": [
      "Placas de yeso"
    ],
    "applications": [
      "pared",
      "revestimiento",
      "cielorraso"
    ],
    "specifications": {
      "Placa": "Espesor | ancho | Largo",
      "Estándar de Durlock®": "15mm. | 1,2mts. | 2,6mts."
    },
    "advantages": [
      "Fácil instalación",
      "Excelente terminación"
    ],
    "technical_features": [
      "Espesor nominal: 15mm"
    ],
    "prestaciones": {
      "RESISTENCIA AL FUEGO": "3/5",
      "AISLACIÓN ACÚSTICA": "2.5/5",
      "RESISTENCIA AL IMPACTO": "3/5"
    },
    "documentos": [
      {
        "nombre": "DT - Pared Simple",
        "url": "https://durlock.com/files/biblioteca/archivos/dt--pared-simple-durlock-2.pdf",
        "filename": "dt--pared-simple-durlock-2.pdf",
        "local_path": "data_raw/durlock/documentos/dt--pared-simple-durlock-2.pdf"
      }
    ]
  }
]
```

> **COMPATIBILIDAD CON EL FRONTEND:**
> 1. El campo `"imagen_local"` es **crítico**. Debe contener la ruta de la imagen relativa a la carpeta `scraping/` del repositorio, usando barras diagonales `/` y comenzando con `data_raw/` (ej: `data_raw/durlock/img/estandar-2.png`). El frontend le concatena `/scraping/` al inicio para servir la imagen estática.
> 2. Las categorías en `"categories"` deben guardarse como una lista de slugs en minúsculas (ej: `["placas-de-yeso"]`).
> 3. Se debe incluir un campo `"categories_processed"` con la lista de nombres de categorías estilizados y amigables para el usuario final (ej: `["Placas de yeso"]`). El instalador automático (`install_brand.py`) **priorizará siempre** el uso de `"categories_processed"` para estructurar el menú del chat y los metadatos vectoriales. Si no está disponible, caerá en des-slugificar `"categories"`.
> 4. Las aplicaciones o uso del producto se pueden definir bajo cualquiera de las siguientes claves: `"applications"`, `"aplicacion"`, `"aplicaciones"` o `"aplicar"`. El instalador automático resolverá estas variantes de forma transparente mediante un fallback automático, normalizándolo como `"applications"` (un array de strings) en los metadatos compilados para el motor RAG.
> 5. El campo `"prestaciones"` (opcional) es un diccionario de valores clave de rendimiento y desempeño del producto (ej: escalas, palabras clave o números como `3/5`).
> 6. En `"documentos"`, el subcampo `"local_path"` debe apuntar al PDF en la carpeta `documentos/` de forma relativa a la carpeta `scraping/`, comenzando con `data_raw/` y usando barras `/`.

---

### 4. Archivos del Sistema Experto / Calculador (Opcional)

Si el `config.json` define `"has_calculator": true`, la carpeta de la marca debe incluir obligatoriamente los archivos que estructuran las reglas lógicas:

#### A. Archivo `calculator_kb.json`
Contiene la base de conocimiento con el árbol de decisiones en formato JSON. Estructura recomendada:

```json
[
  {
    "id": "pantalla_inicial",
    "pregunta": "Seleccione el tipo de estructura que desea construir:",
    "tipo": "opciones",
    "opciones": [
      {"texto": "Pared Divisoria", "siguiente": "pared_simple"},
      {"texto": "Cielorraso", "siguiente": "cielorraso_estructura"}
    ]
  },
  {
    "id": "pared_simple",
    "tipo": "respuesta",
    "texto": "Para una pared divisoria estándar, te recomendamos usar placas de 12.5mm con perfilería de 70mm."
  }
]
```

#### B. Archivo `calculator_engine.py`
Contiene la clase python con la lógica de cálculo y navegación. Debe seguir esta firma exacta:

```python
class ExpertEngine:
    async def process(self, conversation_id: str, expert_state: dict, 
                      option_index: int = None, input_values: dict = None) -> dict:
        """
        Procesa el estado actual y calcula los materiales en base a los m2 ingresados.
        """
        # Lógica de cálculo y transiciones de nodo...
        return {
            "conversation_id": conversation_id,
            "node_id": "resultado_calculo",
            "type": "response",
            "text": "Los materiales requeridos para tu proyecto de 20m2 son...",
            "options": []
        }
```

---

### 5. El Flujo de Instalación

Una vez que la carpeta `scraping/data_raw/<marca_lower>/` está completamente estructurada con todos los archivos listos:

1.  **Ejecutar Instalador:**
    Se corre el comando de instalación en la raíz del repositorio pasando el nombre de la marca (ej: `Durlock` o `durlock`):
    ```bash
    python app/modules/escalamiento/install_brand.py Durlock
    ```
    *(O bien ejecutando el archivo batch `instalar_marca.bat Durlock`)*
2.  **Resultado Automático:**
    `install_brand.py` compilará la base vectorial FAISS en `RAG_engine/database/`, generará los módulos de consulta `rag_query_durlock.py` e inferencia `rag_llm_durlock.py`, copiará el logotipo a `web_app/img/durlock-logo.png`, instalará los archivos del calculador en `app/` y registrará las configuraciones en `configs/brands_registry.json` y `configs/prompts.json`.

