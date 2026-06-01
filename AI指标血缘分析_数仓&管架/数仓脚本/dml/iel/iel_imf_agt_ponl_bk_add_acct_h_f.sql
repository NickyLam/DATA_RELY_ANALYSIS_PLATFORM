: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_ponl_bk_add_acct_h_f
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_ponl_bk_add_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.open_prvlg_flg_comb,chr(13),''),chr(10),'') as open_prvlg_flg_comb
,acct_in_tm
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_org_name,chr(13),''),chr(10),'') as open_acct_org_name
,replace(replace(t1.add_org_id,chr(13),''),chr(10),'') as add_org_id
,replace(replace(t1.add_org_name,chr(13),''),chr(10),'') as add_org_name
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.acct_alias,chr(13),''),chr(10),'') as acct_alias
,replace(replace(t1.sign_way_cd,chr(13),''),chr(10),'') as sign_way_cd
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,replace(replace(t1.acct_pause_rs_descb,chr(13),''),chr(10),'') as acct_pause_rs_descb
,replace(replace(t1.co_card_type_cd,chr(13),''),chr(10),'') as co_card_type_cd

from ${iml_schema}.agt_ponl_bk_add_acct_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ponl_bk_add_acct_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
