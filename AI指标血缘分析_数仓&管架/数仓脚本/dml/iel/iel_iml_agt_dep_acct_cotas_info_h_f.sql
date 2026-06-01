: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_cotas_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_acct_cotas_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cotas_tel_num_one,chr(13),''),chr(10),'') as cotas_tel_num_one
,replace(replace(t1.cotas_type_id,chr(13),''),chr(10),'') as cotas_type_id
,replace(replace(t1.cotas_type_descb,chr(13),''),chr(10),'') as cotas_type_descb
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cotas_cert_no,chr(13),''),chr(10),'') as cotas_cert_no
,replace(replace(t1.cotas_cert_type_cd,chr(13),''),chr(10),'') as cotas_cert_type_cd
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cotas_tel_num_two,chr(13),''),chr(10),'') as cotas_tel_num_two
,replace(replace(t1.data_valid_flg,chr(13),''),chr(10),'') as data_valid_flg
,replace(replace(t1.checker_seq_num,chr(13),''),chr(10),'') as checker_seq_num
,replace(replace(t1.spec_cap_checker_flg,chr(13),''),chr(10),'') as spec_cap_checker_flg
,t1.final_modif_dt as final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,t1.tran_tm as tran_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.cotas_cls_cd,chr(13),''),chr(10),'') as cotas_cls_cd
from ${iml_schema}.agt_dep_acct_cotas_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_cotas_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes