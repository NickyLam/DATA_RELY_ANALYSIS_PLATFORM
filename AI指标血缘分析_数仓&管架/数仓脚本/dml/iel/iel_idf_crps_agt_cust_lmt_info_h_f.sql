: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_agt_cust_lmt_info_h_f
CreateDate: 20250620
FileName:   ${iel_data_path}/crps_agt_cust_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.lmt_type_cd,chr(13),''),chr(10),'') as lmt_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,dep_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.acct_lmt_status_cd,chr(13),''),chr(10),'') as acct_lmt_status_cd
,effect_dt
,invalid_dt
,tran_dt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.sign_chn_id,chr(13),''),chr(10),'') as sign_chn_id
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,rels_tm
,replace(replace(t1.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,tran_timestamp
,t1.actl_effect_dt as actl_effect_dt

from iml.agt_cust_lmt_info_h t1 
where 1 = 1; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_agt_cust_lmt_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
