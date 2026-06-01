: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_acct_oc_acct_rgst_b_a
CreateDate: 20231213
FileName:   ${iel_data_path}/evt_dep_acct_oc_acct_rgst_b.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.core_acct_type_cd,chr(13),''),chr(10),'') as core_acct_type_cd
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.rs_descb,chr(13),''),chr(10),'') as rs_descb
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,acct_actv_dt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.advise_pbc_flg,chr(13),''),chr(10),'') as advise_pbc_flg
,replace(replace(t1.oc_acct_oper_way_cd,chr(13),''),chr(10),'') as oc_acct_oper_way_cd
,replace(replace(t1.oc_acct_rgst_type_cd,chr(13),''),chr(10),'') as oc_acct_rgst_type_cd
,replace(replace(t1.soci_unify_crdt_cd_flg,chr(13),''),chr(10),'') as soci_unify_crdt_cd_flg
,replace(replace(t1.regard_same_self_flg,chr(13),''),chr(10),'') as regard_same_self_flg
,replace(replace(t1.cust_cert_no,chr(13),''),chr(10),'') as cust_cert_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.apv_form_id,chr(13),''),chr(10),'') as apv_form_id
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_acct_oc_acct_rgst_b.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
