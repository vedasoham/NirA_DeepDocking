<div align="center">

# NirA-DeepDocking
### Accelerating ultra-large-library docking with deep learning for NirA-targeted drug-molecule discovery.

<p align="center">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Deep_Learning-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" />
  <img src="https://img.shields.io/badge/Molecular_Docking-14b8a6?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge" />
</p>

---

### Overview
This repository implements a **deep learning-guided virtual screening protocol** to identify potential inhibitors of the **NirA protein**—a mission-critical enzyme for therapeutic targeting. By leveraging an ultra-large chemical library and neural network filtering, this workflow achieves a massive reduction in computational overhead while maintaining high precision.

---

### Graphical Abstract
<img src="https://raw.githubusercontent.com/vedasoham/NirA_DeepDocking/main/.github/protocol.png" width="100%" alt="Deep Docking Protocol Workflow" />

</div>

### Methodology
The methodology combines deep neural network-based filtering with molecular docking to rapidly prioritize promising binders from an initial library of **~9 million compounds**.

1.  **Sampling from Library**: High-diversity sampling from **ZINC**, **DUDE**, **IMPPAT**, and **COCONUT**.
2.  **Data Preparation**: Automated preparation of decoys and actives based on precise molecular weight and activity criteria.
3.  **Dataset Split**: Stratified partitioning of ~9 million phytochemicals into Training, Validation, and Testing sets.
4.  **Neural Network Training**: Implementation of a feed-forward DNN with optimized hyperparameters for score prediction.
5.  **Virtual Screening**: Rapid prediction of docking scores to discard low-affinity compounds and retain high-confidence virtual hits.
6.  **Validation & Refinement**: Top hits undergo rigorous validation via molecular docking followed by iterative re-scoring and training rounds.

---

**Breif about the modal :---**

**Initial Library Size**: ~9,000,000 Compounds
**Virtual Hits Identified**: 44,168 Compounds

**Model Architecture**: Feed-forward Deep Neural Network
**Optimization**: Iterative Refinement & Hyperparameter Tuning

---

### Citation
If you utilize this protocol or build upon this research, please cite the original framework and our specialized implementation:

* **Original Framework**: [Gentile, F. et al. Artificial intelligence–enabled virtual screening of ultra-large chemical libraries with deep docking. Nat. Protoc. 17, 672–697](https://www.nature.com/articles/s41596-021-00659-2)
* **Source Implementation**: [Original Deep Docking GitHub](https://github.com/jamesgleave/DD_protocol).

---

**CONTACT for COLLABORATION**: `thedrsoham[at]gmail[dot]com`


<div align="center">
*"Not the end, but the beginning of a mission."*

</div>
