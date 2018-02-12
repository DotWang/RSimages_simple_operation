;Batch process RS images with ENVI SVM Classifier,C-SVC
PRO svm_classify

  e = ENVI()

  COMPILE_OPT idl2

  image_dir='C:\';manually change the file path

  output_path='C:\';manually change the result path

  image_files=file_search(image_dir+'\*.tif',count=file_num)

  for f_n=0,file_num-1 do begin

    strname = strsplit(image_files[f_n],'\',/extract,count=n)

    print,strname

    image_files[f_n]=strname[n-1]

  endfor
  ;roi file instead of xml
  ENVI_RESTORE_rois,'C:\'

  roi_ids=ENVI_get_roi_ids(roi_names=roi_names)
  
  for i=0,file_num-1 do begin

    file = FILEPATH(image_files[i],ROOT_DIR=image_dir)

    raster1 = e.OpenRaster(file)

    fid = ENVIRasterToFID(raster1)

    ENVI_FILE_QUERY, fid, file_type=file_type, nl=nl, ns=ns,dims=dims,nb=nb
    
    pos = INDGEN(nb)

    out_name = output_path+'\'+file_baseName(image_files[i],'.tif')+'_classify'
    ;probability, penalty coefficent, RBF
    thresh=0
    
    penalty=100
    
    kernel_type=2
    
    ENVI_DOIT,'ENVI_SVM_DOIT',fid=fid,dims=dims,out_name=out_name,$

      ns = ns, nl = nl,pos=pos,roi_ids=roi_ids,thresh=thresh,$
        
      penalty=penalty,kernel_type=kernel_type

  endfor

  print,'finished'

  e.close

end