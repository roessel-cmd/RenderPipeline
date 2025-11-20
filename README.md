# **PyMOL Render Pipeline**

**An automated PyMOL rendering pipeline for consistent, high-quality molecular visualizations with standardized coloring, lighting, and post-processing.**

- Render.sh (for Linux) 
- Render.ps1 (for Windows)
---

## **Features**

* **Automated batch rendering** of all `.pse` files
* **Per-file resolution overrides** via `render_config.txt`
* **High-quality PyMOL ray-tracing settings**
* **Automatic output directory creation**
* **Consistent PNG export**
* Ideal for **publications, presentations, and automated workflows**

---

## **Directory Structure**

```
project/
│── render.sh            # Main pipeline script
│── render_config.txt    # Optional resolution overrides
│── *.pse                # PyMOL session files
└── /RENDER/             # Output images (auto-created)
```

---

## **Configuration**

### **PyMOL Path**

```
PYMOL_PATH="/your/path/pymol/pymol"
```

### **Output Directory**

```
OUTPUT_DIR="/home/yourpath/RENDER"
```

### **Default Resolution**

```
DEFAULT_WIDTH=4000
DEFAULT_HEIGHT=4000
```

### **Per-file Resolution Overrides (`render_config.txt`)**

```
example1 6000 6000
example2 3000 2000
```

---

## **PyMOL Rendering Settings**

```
(can be adapted to any pymol setting available ...) 
set ray_shadow, 1
set ray_trace_mode, 1
set antialias, 4
```

---

## ▶️ **Usage**

1. Place your `.pse` files in the same directory
2. (Optional) define resolutions in `render_config.txt`
3. Make script executable:

```
chmod +x render.sh
```

4. Run the pipeline:

```
./render.sh
```

All renders are saved to the **RENDER** directory.

---

## **Output Format**

For each input file:

```
input.pse  →  RENDER/input.png
```

Resolution depends on `render_config.txt` or defaults to **4000×4000**.

---

