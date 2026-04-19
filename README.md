# Anisotropic BRDF for Real-Time Cloth Rendering
This repository contains the shader code implementation for the paper:
**Anisotropic BRDF Modeling for High-Fidelity Real-Time Cloth Rendering**
Submitted to *Computer Animation and Virtual Worlds*.

## Important Note
This code is directly associated with the manuscript submitted to *Computer Animation and Virtual Worlds*.
If you use this code, please cite the corresponding paper.

## 1. Project Information
- Shader File: ClothAnisotropic.shader
- Engine: Unity 2022.3.62f3c1 (URP)
- Platform: Windows 11 64-bit
- Test Hardware: Intel Core Ultra5 125H + Intel Arc integrated graphics

## 2. Dependencies
- Unity URP (Universal Render Pipeline)
- Shader compatible with Unity 2022 LTS

## 3. Key Algorithm Implemented
This shader implements a **lightweight anisotropic BRDF** for cloth rendering:
- Anisotropic specular highlights aligned with fabric weave direction
- Controllable anisotropic roughness (αx, αy)
- Tangent direction control for fabric orientation
- Optimized for integrated graphics (low computation cost)

## 4. Usage Instructions
1. Import ClothAnisotropic.shader into your Unity URP project
2. Create a new material using this shader
3. Adjust roughness, tangent direction, and color parameters
4. Apply to cloth meshes for real-time anisotropic rendering

## 5. Reproducibility
All experiments in the paper can be reproduced using this shader.
