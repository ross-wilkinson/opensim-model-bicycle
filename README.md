# opensim-model-bicycle

OpenSim bicycle model and example files.

![OpenSim bicycle model](./opensim_snapshot_bicycle.png)

| Author(s) | Brief Description | Intended Uses and Known Limitations | Included Material | Updated |
|-|-|-|-|-|
| Ross Wilkinson, Ph.D. | A 6-DoF bicycle model built for OpenSim. Despite the massless bodies, the frame geometry creates relatively accurate bicycle dynamics. Includes a DoF at each wheel, the cranks, and the steering tube. Built using MATLAB-OpenSim API. Contains contact geometries at the saddle, pedals, handlebar, and wheels. | Forward analyses of standing cycling in OpenSim. No drivetrain or coupling between crank and rear-wheel motion. Contact geometry of wheels needs to be changed from a single sphere to a series of spheres around tire surface. Bodies are currently massless. | Model file and MATLAB script to build and edit model parameters. | March 4, 2020 |

## Example

The example script 'exampleBuildBicycle.mlx' shows how to build the model by first loading in the structure 'S', which contains the required body dimensions to build the model.

Simply clone or download the files from this repository and run 'exampleBuildBicycle.mlx' in MATLAB.
