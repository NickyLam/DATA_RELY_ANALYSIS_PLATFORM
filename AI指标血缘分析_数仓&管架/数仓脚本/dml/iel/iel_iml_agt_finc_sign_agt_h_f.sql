: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_sign_agt_h_f
CreateDate: 20240814
FileName:   ${iel_data_path}/agt_finc_sign_agt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.dep_agt_id,chr(13),''),chr(10),'') as dep_agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_agt_type_cd,chr(13),''),chr(10),'') as sign_agt_type_cd
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t1.finc_prod_type_descb,chr(13),''),chr(10),'') as finc_prod_type_descb
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,effect_dt
,invalid_dt
,finc_amt
,agt_retnd_amt
,replace(replace(t1.auto_delay_flg,chr(13),''),chr(10),'') as auto_delay_flg
,replace(replace(t1.sign_agt_status_cd,chr(13),''),chr(10),'') as sign_agt_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,final_modif_dt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,last_tran_dt
,redt_sucs_tot_cnt
,replace(replace(t1.dep_tenor,chr(13),''),chr(10),'') as dep_tenor
,replace(replace(t1.dep_tenor_type_cd,chr(13),''),chr(10),'') as dep_tenor_type_cd
,min_init_amt
,tran_freq
,replace(replace(t1.tran_freq_cd,chr(13),''),chr(10),'') as tran_freq_cd
,conti_redt_fail_cnt
,conti_redt_sucs_cnt
,replace(replace(t1.last_redt_flow_id,chr(13),''),chr(10),'') as last_redt_flow_id
,finc_fix_amt
,redt_fail_tot_cnt
,curr_mon_acm_end_day_bal

from ${iml_schema}.agt_finc_sign_agt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_sign_agt_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
