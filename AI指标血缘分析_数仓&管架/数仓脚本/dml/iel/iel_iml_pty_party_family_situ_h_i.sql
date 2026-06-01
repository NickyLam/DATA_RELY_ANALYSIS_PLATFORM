: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_family_situ_h_i
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_family_situ_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,loc_resd_years
,replace(replace(local_estate_flg,chr(13),''),chr(10),'')
,replace(replace(local_soci_secu_flg,chr(13),''),chr(10),'')
,replace(replace(house_val_cd,chr(13),''),chr(10),'')
,replace(replace(prov_pulation_type_cd,chr(13),''),chr(10),'')
,replace(replace(rpr_char_cd,chr(13),''),chr(10),'')
,replace(replace(resdnt_status_cd,chr(13),''),chr(10),'')
,replace(replace(child_number_cd,chr(13),''),chr(10),'')
,replace(replace(free_car_situ_cd,chr(13),''),chr(10),'')
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_family_situ_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_family_situ_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
