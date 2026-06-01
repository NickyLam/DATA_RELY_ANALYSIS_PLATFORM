: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_cont_csner_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_cont_csner_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,replace(replace(t.brwer_id,chr(13),''),chr(10),'') as brwer_id
    ,replace(replace(t.brwer_name,chr(13),''),chr(10),'') as brwer_name
    ,replace(replace(t.csner_id,chr(13),''),chr(10),'') as csner_id
    ,replace(replace(t.csner_type_cd,chr(13),''),chr(10),'') as csner_type_cd
    ,replace(replace(t.contri_acct_id,chr(13),''),chr(10),'') as contri_acct_id
    ,replace(replace(t.contri_acct_name,chr(13),''),chr(10),'') as contri_acct_name
    ,replace(replace(t.contri_acct_pt_type_cd,chr(13),''),chr(10),'') as contri_acct_pt_type_cd
    ,replace(replace(t.pric_enter_acct_id,chr(13),''),chr(10),'') as pric_enter_acct_id
    ,replace(replace(t.pric_enter_acct_name,chr(13),''),chr(10),'') as pric_enter_acct_name
    ,replace(replace(t.pric_acct_pt_type_cd,chr(13),''),chr(10),'') as pric_acct_pt_type_cd
    ,replace(replace(t.int_enter_acct_id,chr(13),''),chr(10),'') as int_enter_acct_id
    ,replace(replace(t.int_enter_acct_name,chr(13),''),chr(10),'') as int_enter_acct_name
    ,replace(replace(t.int_acct_pt_type_cd,chr(13),''),chr(10),'') as int_acct_pt_type_cd
    ,replace(replace(t.comm_fee_coll_acct_num,chr(13),''),chr(10),'') as comm_fee_coll_acct_num
    ,replace(replace(t.comm_fee_coll_acct_name,chr(13),''),chr(10),'') as comm_fee_coll_acct_name
    ,replace(replace(t.comm_fee_acct_pt_type_cd,chr(13),''),chr(10),'') as comm_fee_acct_pt_type_cd
    ,replace(replace(t.stamp_tax_acct_num,chr(13),''),chr(10),'') as stamp_tax_acct_num
    ,replace(replace(t.stamp_tax_acct_name,chr(13),''),chr(10),'') as stamp_tax_acct_name
    ,replace(replace(t.stamp_tax_acct_pt_type_cd,chr(13),''),chr(10),'') as stamp_tax_acct_pt_type_cd
    ,replace(replace(t.entr_dep_acct_id,chr(13),''),chr(10),'') as entr_dep_acct_id
    ,replace(replace(t.entr_dep_acct_name,chr(13),''),chr(10),'') as entr_dep_acct_name
    ,replace(replace(t.entr_dep_acct_pt_type_cd,chr(13),''),chr(10),'') as entr_dep_acct_pt_type_cd
    ,replace(replace(t.entr_dep_acct_open_bank_num,chr(13),''),chr(10),'') as entr_dep_acct_open_bank_num
    ,replace(replace(t.entr_dep_acct_open_bank_name,chr(13),''),chr(10),'') as entr_dep_acct_open_bank_name
    ,replace(replace(t.csner_name,chr(13),''),chr(10),'') as csner_name
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_retl_cont_csner_rela_h t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_cont_csner_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes