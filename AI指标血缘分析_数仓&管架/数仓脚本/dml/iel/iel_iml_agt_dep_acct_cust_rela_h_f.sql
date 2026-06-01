: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_cust_rela_h_f
CreateDate: 20231226
FileName:   ${iel_data_path}/agt_dep_acct_cust_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.actl_acct_num,chr(13),''),chr(10),'') as actl_acct_num
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.priv_flg,chr(13),''),chr(10),'') as priv_flg
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.card_flg,chr(13),''),chr(10),'') as card_flg
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.acct_kind_cd,chr(13),''),chr(10),'') as acct_kind_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg
,replace(replace(t1.deflt_stl_acct_num_flg,chr(13),''),chr(10),'') as deflt_stl_acct_num_flg
,replace(replace(t1.main_acct_flg,chr(13),''),chr(10),'') as main_acct_flg
,replace(replace(t1.super_acct_id,chr(13),''),chr(10),'') as super_acct_id
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.supp_card_flg,chr(13),''),chr(10),'') as supp_card_flg
,replace(replace(t1.corp_stl_card_flg,chr(13),''),chr(10),'') as corp_stl_card_flg
,tran_dt

from ${iml_schema}.agt_dep_acct_cust_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_cust_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
