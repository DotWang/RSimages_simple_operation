;clip the ENVI RS images by Shapefile mask, some codes from network，sometimes failed.
PRO Subset_via_shp_update
  e = ENVI()
  
  COMPILE_OPT idl2
  
  image_dir='C:\' ;change the path of the images

  shp_dir='C:\';change the path of the shapefile

  output_path='C:\';change the output path



  image_files=file_search(image_dir+'\*.hdr',count=file_num)  ;ENVI *.hdr file format filtering

  for f_n=0,file_num-1 do begin

    strname = strsplit(image_files[f_n],'\',/extract,count=n) 

    print,strname

    image_files[f_n]= strname[n-1] ;save the filename
    
  endfor

  for i=0,file_num-1 do begin


    file = FILEPATH(image_files[i],ROOT_DIR=image_dir)

    raster1 = e.OpenRaster(file)

    fid = ENVIRasterToFID(raster1)

    ENVI_FILE_QUERY, fid, file_type=file_type, nl=nl, ns=ns,dims=dims,nb=nb


    shapefile = Filepath('xxx.shp',ROOT_DIR=shp_dir) ;Shapefile for mask


    if strlen(shapefile) eq 0 then return

    oshp = OBJ_NEW('IDLffshape',shapefile)

    oshp->Getproperty,n_entities=n_ent,Attribute_info=attr_info,$

      n_attributes=n_attr,Entity_type=ent_type

    roi_shp = LONARR(n_ent)

    FOR ishp = 0,(n_ent-1) DO BEGIN

      entitie = oshp->Getentity(ishp) ;point


      IF entitie.SHAPE_TYPE EQ 5 THEN BEGIN ;polygon

        record = *(entitie.vertices)

        ENVI_CONVERT_FILE_COORDINATES,fid,xmap,ymap,record[0,*],record[1,*]

        roi_shp[ishp] = ENVI_CREATE_ROI(ns=ns,nl=nl)

        ENVI_DEFINE_ROI,roi_shp[ishp],/polygon,xpts=REFORM(xmap),ypts=REFORM(ymap)

        ;recode the range of X,Y

        IF ishp EQ 0 THEN BEGIN

          xMin = ROUND(MIN(xMap,max = xMax))

          yMin = ROUND(MIN(yMap,max = yMax))

        ENDIF ELSE BEGIN

          xMin = xMin < ROUND(MIN(xMap))

          xMax = xMax > ROUND(MAX(xMap))

          yMin = yMin < ROUND(MIN(yMap))

          yMax = yMax > ROUND(MAX(yMap))

        ENDELSE

      ENDIF

      oshp->Destroyentity,entitie

      xMin = xMin >0

      xMax = xMax < ns-1

      yMin = yMin >0

      yMax = yMax < nl-1

    ENDFOR;ishp

    out_name = output_path+'\'+file_baseName(image_files[i],'.hdr')+'_xxx';add the postfix

    out_dims = [-1,xMin,xMax,yMin,yMax]

    pos = INDGEN(nb)

    ENVI_DOIT,'ENVI_SUBSET_VIA_ROI_DOIT',background=0,fid=fid,dims=out_dims,out_name=out_name,$

      ns = ns, nl = nl,pos=pos,roi_ids=roi_shp

    OBJ_Destroy,oshp

  endfor

  print,'finished'

  e.close

end