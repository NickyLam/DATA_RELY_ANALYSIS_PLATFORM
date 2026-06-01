: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_check_conf_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_check_conf_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,t1.open_acct_dt as open_acct_dt
,t1.acct_start_use_dt as acct_start_use_dt
,t1.acct_wrtoff_dt as acct_wrtoff_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.brac_id,chr(13),''),chr(10),'') as brac_id
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cotas_addr,chr(13),''),chr(10),'') as cotas_addr
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.unite_acct_flg,chr(13),''),chr(10),'') as unite_acct_flg
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.pt_type_cd,chr(13),''),chr(10),'') as pt_type_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.long_hang_acct_flg,chr(13),''),chr(10),'') as long_hang_acct_flg
,replace(replace(t1.main_acct_sign_flow_num,chr(13),''),chr(10),'') as main_acct_sign_flow_num
,replace(replace(t1.main_acct_acct_id,chr(13),''),chr(10),'') as main_acct_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.general_exch_flg_cd,chr(13),''),chr(10),'') as general_exch_flg_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_check_conf_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_check_conf_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes