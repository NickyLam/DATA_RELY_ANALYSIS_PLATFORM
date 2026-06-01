: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_pty_indv_pty_phys_loc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_phys_loc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt
,replace(replace(t1.phys_loc_typ_cd,chr(13),''),chr(10),'') as phys_loc_typ_cd
,replace(replace(t1.phys_loc_cty_cd,chr(13),''),chr(10),'') as phys_loc_cty_cd
,replace(replace(t1.phys_loc_prov_cd,chr(13),''),chr(10),'') as phys_loc_prov_cd
,replace(replace(t1.phys_loc_city_cd,chr(13),''),chr(10),'') as phys_loc_city_cd
,replace(replace(t1.phys_loc_cuty_cd,chr(13),''),chr(10),'') as phys_loc_cuty_cd
,replace(replace(t1.phys_dtl_loc,chr(13),''),chr(10),'') as phys_dtl_loc
,replace(replace(t1.phys_loc_pst_encd,chr(13),''),chr(10),'') as phys_loc_pst_encd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_pty_indv_pty_phys_loc_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_phys_loc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes