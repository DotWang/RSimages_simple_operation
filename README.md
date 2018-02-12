# RSimages_simple_operation
## write_in_text.pro
Before deal with the bunch of files, obtain their flienames simultaneously, then take the next steps.
## subset_via_shp_update.pro
Batch cliping RS images by specified shapefile
### Notice
- Shapefile should have the same spatial reference as the images, best to export shp from ROI in ENVI.
For example, for 122039 row/col number of images acquired by TM sensors, the shp should be gained from ROI that have same row/col.
- *.tif or *.hdr files are best to be transform to *.hdr
## hdr2tif_example.pro
Batch tranforming the *.hdr file into *.tif file, so as to be operated for other software, like matlab.
## svm_classify.pro
Batch classifying the RS images with ENVI SVM classifier. The extension name of train data is *.roi instead of *.xml, which can be export
from ENVI Classic software, and generalized for every images.
