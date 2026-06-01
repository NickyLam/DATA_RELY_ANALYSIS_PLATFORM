: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ibank_cntpty_acct_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_ibank_cntpty_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.bank_acct_name,chr(13),''),chr(10),'') as bank_acct_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.mdl_bank_acct_id,chr(13),''),chr(10),'') as mdl_bank_acct_id
,replace(replace(t1.mdl_bank_name,chr(13),''),chr(10),'') as mdl_bank_name
,replace(replace(t1.mdl_bank_swift_cd,chr(13),''),chr(10),'') as mdl_bank_swift_cd
,replace(replace(t1.open_bank_acct_id,chr(13),''),chr(10),'') as open_bank_acct_id
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.open_bank_swift_cd,chr(13),''),chr(10),'') as open_bank_swift_cd
,replace(replace(t1.ghb_recv_bank_acct_name,chr(13),''),chr(10),'') as ghb_recv_bank_acct_name
,replace(replace(t1.ghb_recv_bank_acct_swift_cd,chr(13),''),chr(10),'') as ghb_recv_bank_acct_swift_cd
,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd
,replace(replace(t1.dlvy_msg_cd,chr(13),''),chr(10),'') as dlvy_msg_cd

from ${iml_schema}.agt_ibank_cntpty_acct_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ibank_cntpty_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
