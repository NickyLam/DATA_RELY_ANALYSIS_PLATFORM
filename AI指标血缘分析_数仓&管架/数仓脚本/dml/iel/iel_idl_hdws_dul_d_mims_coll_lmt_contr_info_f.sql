: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_lmt_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_lmt_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.assoc_appl_id,chr(13),''),chr(10),'') as assoc_appl_id
,replace(replace(t1.crdt_contr_id,chr(13),''),chr(10),'') as crdt_contr_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.appl_amt as appl_amt
,t1.aprv_amt as aprv_amt
,t1.occu_lmt as occu_lmt
,t1.usab_lmt as usab_lmt
,replace(replace(t1.crdt_biz_breed_cd,chr(13),''),chr(10),'') as crdt_biz_breed_cd
,t1.eff_dt as eff_dt
,t1.trmi_dt as trmi_dt
,replace(replace(t1.crdt_type_cd,chr(13),''),chr(10),'') as crdt_type_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.crdt_flow_typ_cd,chr(13),''),chr(10),'') as crdt_flow_typ_cd
,replace(replace(t1.ctr_txt_name,chr(13),''),chr(10),'') as ctr_txt_name
from ${idl_schema}.hdws_dul_d_mims_coll_lmt_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_lmt_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes