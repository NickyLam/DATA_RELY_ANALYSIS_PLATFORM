: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_indv_pty_phys_loc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_indv_pty_phys_loc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt 
,t1.last_update_dt as last_update_dt 
,replace(replace(t1.phys_loc_typ_cd,chr(13),''),chr(10),'') as phys_loc_typ_cd 
,replace(replace(t1.phys_loc_cty_cd,chr(13),''),chr(10),'') as phys_loc_cty_cd 
,replace(replace(t1.phys_loc_prov_cd,chr(13),''),chr(10),'') as phys_loc_prov_cd 
,replace(replace(t1.phys_loc_city_cd,chr(13),''),chr(10),'') as phys_loc_city_cd 
,replace(replace(t1.phys_loc_cuty_cd,chr(13),''),chr(10),'') as phys_loc_cuty_cd 
,replace(replace(t1.phys_dtl_loc,chr(13),''),chr(10),'') as phys_dtl_loc 
,replace(replace(t1.phys_loc_pst_encd,chr(13),''),chr(10),'') as phys_loc_pst_encd 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,NVL2(T1.DATA_SRC_CD,'PTY_INDV_PTY_PHYS_LOC_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_INDV_PTY_PHYS_LOC_INFO') AS ETL_TASK_NAME  
,replace(replace(t1.stre,chr(13),''),chr(10),'') as stre 
,replace(replace(t1.regn,chr(13),''),chr(10),'') as regn 
,replace(replace(t1.bld_nbr,chr(13),''),chr(10),'') as bld_nbr 
,replace(replace(t1.floor,chr(13),''),chr(10),'') as floor 
,replace(replace(t1.rom_nbr,chr(13),''),chr(10),'') as rom_nbr 
from ${idl_schema}.hdws_iml_pty_indv_pty_phys_loc_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_indv_pty_phys_loc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes