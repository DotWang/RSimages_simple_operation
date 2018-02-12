;batch writing the filename into text
pro write_in_txt

  input_path = 'C:\';manually change the path of input files

  filename = input_path +'\*.tif'

  thesefiles = file_search(filename,count=file_num)

  for f_n=0,file_num-1 do begin
    
    strname = strsplit(thesefiles[f_n],'\',/extract,count=n)
    
    print,strname
    
    thesefiles[f_n]= strname[n-1]
    
  endfor
  
  newfile=FILEPATH('name.txt',ROOT_DIR=input_path);output file
  
  for f_n=0,file_num-1 do begin
    
    file = FILEPATH(thesefiles[f_n],ROOT_DIR=input_path)
    
    strname = strsplit(thesefiles[f_n],'.',/extract)
    
    thesefiles[f_n]= strname[0]
    
    openw,lun,newfile,/Get_lun,/append
    
    printf,lun,thesefiles[f_n]
    
    free_lun,lun
    
  endfor
  
  print,'finish'
  
end