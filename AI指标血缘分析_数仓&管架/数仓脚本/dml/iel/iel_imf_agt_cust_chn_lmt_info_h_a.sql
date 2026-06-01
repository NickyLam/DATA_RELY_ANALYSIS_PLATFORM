: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cust_chn_lmt_info_h_a
CreateDate: 20240826
FileName:   ${iel_data_path}/agt_cust_chn_lmt_info_h.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ctrl_id,chr(13),''),chr(10),'') as ctrl_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.ctrl_type_cd,chr(13),''),chr(10),'') as ctrl_type_cd
,replace(replace(t1.ctrl_status_cd,chr(13),''),chr(10),'') as ctrl_status_cd
,replace(replace(t1.lmt_lev_cd,chr(13),''),chr(10),'') as lmt_lev_cd
,lmt_effect_dt
,lmt_invalid_dt
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t1.sign_chn_id,chr(13),''),chr(10),'') as sign_chn_id
,replace(replace(t1.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,rels_dt
,final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt

from ${iml_schema}.agt_cust_chn_lmt_info_h t1
where 1 = 1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_chn_lmt_info_h.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
