# MisProfesiones 📜🧪🪓

**MisProfesiones** es un Addon minimalista y ultra-estable desarrollado para **World of Warcraft: Wrath of the Lich King (v3.3.5a)**. Está diseñado específicamente para solventar las limitaciones del cliente clásico de WoW en servidores privados modificados que permiten disponer de múltiples o todas las profesiones simultáneamente (**All-Prof / Todas las Profesiones**).

El cliente nativo de la 3.3.5a tiene un error visual muy común: cuando un personaje aprende una tercera profesión o más, la pestaña de habilidades de la interfaz oficial (`K`) las oculta o bugea, impidiendo abrirlas con normalidad o desaprenderlas de forma segura. Este Addon ofrece una ventana alternativa ligera con estética rolera de pergamino oficial que escanea el libro de hechizos en caliente y permite gestionar tus profesiones sin fallos.

---

## ✨ Características Principales

- **Detección Dinámica Bilingüe:** Escanea directamente el libro de hechizos nativo (`GetSpellName`), garantizando que aparezcan todas las profesiones activas (primarias y secundarias), sin importar cuántas tengas aprendidas.
- **Acceso Directo (Clic en Icono):** Haz clic en el icono de cualquier profesión listada para abrir de inmediato su correspondiente panel oficial de recetas/habilidades.
- **Interfaz del Olvido Inteligente (X):** Un botón limpio para desaprender profesiones de forma segura. Calcula el índice exacto en caliente (`GetSkillLineInfo`) en el momento del clic, sorteando el bloqueo de Blizzard para profesiones ocultas. Incluye un mensaje de confirmación emergente oficial nativo (`StaticPopupDialogs`).
- **Diseño Integrado (Gossip / Pergamino Medieval):** Ventana de interfaz con el fondo clásico de pergamino liso estirado por coordenadas (`TexCoords`) y bordes dorados de Blizzard. Se integra al 100% con el arte del juego sin causar errores de texturas verdes ni cortes visuales.
- **Soporte Multilingüe Automático:** Detecta el idioma del cliente (`GetLocale`). Si juegas en español o inglés, adaptará todos sus textos de forma nativa. Adicionalmente, incluye un selector manual de idioma en la parte inferior izquierda de la interfaz.
- **Botón Flotante y Movible:** Incluye un botón con icono de libro antiguo que puedes arrastrar a cualquier punto de tu pantalla para abrir/cerrar el panel con comodidad.

---

## 🛠️ Arquitectura del Addon

El Addon sigue estrictamente el patrón clásico de diseño de interfaces de World of Warcraft, desacoplando la lógica de eventos de la maquetación visual:

### 1. `MisProfesiones.toc` (Tabla de Contenidos)
Registra los metadatos obligatorios para que el cliente de WoW indexe el Addon al arrancar. Define el número de interfaz clásico (`30300`) y el orden de carga de los archivos de lógica y renderizado.

### 2. `MisProfesiones.xml` (Capa de Presentación y Estructura)
Define la maquetación visual del panel utilizando el dialecto XML oficial de Blizzard.
- **`FrameProfresionTemplate`**: Una plantilla virtual ligera reutilizada dinámicamente para renderizar cada fila (Icono clickable + Nombre con fuente marrón tinta manuscrita + Botón de acción rápido).
- **`ScrollFrame` y `ScrollChild`**: Un contenedor dinámico con barra de scroll para empaquetar de forma infinita las profesiones detectadas, evitando que los elementos se desborden de la pantalla.
- **Capa artística (`<Layers>`)**: Inyecta directamente las rutas internas de los archivos `.blp` del juego (`UI-Achievement-Parchment-Horizontal` y `UI-DialogBox-Gold-Border`) configurados sin mosaico (`tile="false"`) para un acabado estético liso e impecable.

### 3. `MisProfesiones.lua` (Capa de Lógica y Control de Eventos)
Controla el ciclo de vida del Addon mediante el registro de eventos clave del motor de WoW:
- **`ADDON_LOADED`**: Inicializa las variables guardadas, comprueba el idioma base del jugador y configura el menú desplegable inferior.
- **`SKILL_LINES_CHANGED`**: El evento crítico. Cada vez que tu personaje aprende, olvida o sube de nivel una profesión, el Addon borra el contenedor visual y realiza un re-escaneo instantáneo en el hilo de ejecución para mantener la lista actualizada al segundo.
- **`GetSpellName(i, BOOKTYPE_SPELL)`**: Bucle de fuerza bruta optimizado que lee las IDs de hechizos del jugador. Es el método más seguro en la versión 3.3.5a para detectar profesiones "invisibles" de la tercera pestaña.

---

## 🚀 Instalación

1. Descarga el repositorio o los archivos del Addon.
2. Asegúrate de que la carpeta contenedora se llame exactamente **`MisProfesiones`**.
3. Copia la carpeta dentro de la ruta de instalación de tu cliente de WoW:
   `...\World of Warcraft 3.3.5a\Interface\AddOns\MisProfesiones\`
4. Entra al juego. En la ventana de selección de personaje, haz clic en el botón **"Accesorios" (Addons)** en la esquina inferior izquierda y asegúrate de que **MisProfesiones** esté marcado.

---

## 🎮 Modo de Uso

- **Abrir/Cerrar Ventana:** Haz clic izquierdo sobre el **botón flotante del libro antiguo** que aparecerá en tu pantalla.
- **Mover Interfaz:** Mantén pulsado el **Clic Izquierdo** sobre el botón flotante o sobre cualquier zona vacía del fondo de pergamino de la ventana principal para arrastrarlos.
- **Comandos de Chat:** Si prefieres usar macros o teclado, puedes escribir los siguientes comandos rápidos en el chat del juego:
  - `/profesiones`
  - `/profs`
- **Abrir Recetas:** Haz clic directo sobre el icono redondo de la profesión que quieras inspeccionar.
- **Olvidar Profesión:** Haz clic sobre la **X** situada a la derecha de la profesión. Aparecerá un cuadro de diálogo del sistema oficial preguntándote si estás seguro antes de proceder a borrar de forma irreversible la habilidad.

---
<img width="1366" height="705" alt="Wow 2026-05-26 19-42-42" src="https://github.com/user-attachments/assets/1693015b-27bd-4f19-85d6-9f03e8be8df2" />
