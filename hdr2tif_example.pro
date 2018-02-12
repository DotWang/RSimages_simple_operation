;batch transforming the ENVI hdr file to TIFF file
PRO img2tif_example

   e = ENVI()

   input_path = 'D:\';manually change the path of hdr files
   
   output_path = 'D:\';manually change the path of tif files
   
   filename = input_path +'\*.hdr'
   
   thesefiles = file_search(filename,count=file_num)

   for f_n=0,file_num-1 do begin
    
    strname = strsplit(thesefiles[f_n],'\',/extract,count=n)
    
    print,strname
    
    thesefiles[f_n]= strname[n-1]
    
   endfor
     
  for f_n=0,file_num-1 do begin
      
     file = FILEPATH(thesefiles[f_n],ROOT_DIR=input_path)
     
     strname = strsplit(thesefiles[f_n],'.',/extract)
     
     thesefiles[f_n]= strname[0]
     
     raster1 = e.OpenRaster(file,ERROR=err)
     
     IF err THEN e.ReportError, 'Please provide a valid file.', /INFORMATION
     
     newFile = FILEPATH(thesefiles[f_n]+'.tif',ROOT_DIR=output_path);filename have no change
     
     e.ExportRaster,raster1 ,newFile, 'TIFF' 
     
 endfor
 
 print,'finished'
 
 e.close

end