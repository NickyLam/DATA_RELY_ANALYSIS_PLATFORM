: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_family_situ_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_family_situ_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.loc_resd_years as loc_resd_years 
,replace(replace(t1.local_estate_flg,chr(13),''),chr(10),'') as local_estate_flg 
,replace(replace(t1.local_soci_secu_flg,chr(13),''),chr(10),'') as local_soci_secu_flg 
,replace(replace(t1.house_val_cd,chr(13),''),chr(10),'') as house_val_cd 
,replace(replace(t1.prov_pulation_type_cd,chr(13),''),chr(10),'') as prov_pulation_type_cd 
,replace(replace(t1.rpr_char_cd,chr(13),''),chr(10),'') as rpr_char_cd 
,replace(replace(t1.resdnt_status_cd,chr(13),''),chr(10),'') as resdnt_status_cd 
,replace(replace(t1.child_number_cd,chr(13),''),chr(10),'') as child_number_cd 
,replace(replace(t1.free_car_situ_cd,chr(13),''),chr(10),'') as free_car_situ_cd 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_family_situ_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_family_situ_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes