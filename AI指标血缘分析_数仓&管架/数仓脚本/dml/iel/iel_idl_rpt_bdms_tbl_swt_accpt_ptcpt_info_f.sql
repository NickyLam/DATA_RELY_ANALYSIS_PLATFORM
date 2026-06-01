: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_bdms_tbl_swt_accpt_ptcpt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_bdms_tbl_swt_accpt_ptcpt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.id as id
,replace(replace(t1.acct_svcr,chr(13),''),chr(10),'') as acct_svcr
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.accss_pt_cd,chr(13),''),chr(10),'') as accss_pt_cd
,replace(replace(t1.accss_pt_nm,chr(13),''),chr(10),'') as accss_pt_nm
,replace(replace(t1.valide_date,chr(13),''),chr(10),'') as valide_date
,replace(replace(t1.invalide_date,chr(13),''),chr(10),'') as invalide_date
,replace(replace(t1.reserve_field1,chr(13),''),chr(10),'') as reserve_field1
,replace(replace(t1.reserve_field2,chr(13),''),chr(10),'') as reserve_field2
,t1.last_upd_oprid as last_upd_oprid
,replace(replace(t1.last_upd_txn_id,chr(13),''),chr(10),'') as last_upd_txn_id
,replace(replace(t1.last_upd_ts,chr(13),''),chr(10),'') as last_upd_ts
from ${iol_schema}.bdms_tbl_swt_accpt_ptcpt_info t1
 WHERE t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_bdms_tbl_swt_accpt_ptcpt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes