: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_teller_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_teller_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(teller_id,chr(13),''),chr(10),'')
,replace(replace(teller_name,chr(13),''),chr(10),'')
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(teller_status_cd,chr(13),''),chr(10),'')
,replace(replace(teller_type_cd,chr(13),''),chr(10),'')
,replace(replace(emply_id,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_id,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_flg,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_lev_cd,chr(13),''),chr(10),'')
,replace(replace(teller_lev_cd,chr(13),''),chr(10),'')
,replace(replace(teller_director_id,chr(13),''),chr(10),'')
,replace(replace(high_teller_flg,chr(13),''),chr(10),'')
,teller_create_dt
,logon_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_teller_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_teller_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
