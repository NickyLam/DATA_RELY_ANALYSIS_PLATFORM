: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_renew_info_h_f
CreateDate: 20240903
FileName:   ${iel_data_path}/agt_loan_renew_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.renew_flow_num,chr(13),''),chr(10),'') as renew_flow_num
,replace(replace(t1.rela_dubil_id,chr(13),''),chr(10),'') as rela_dubil_id
,replace(replace(t1.renew_status_cd,chr(13),''),chr(10),'') as renew_status_cd
,happ_dt
,init_int_rat
,init_exp_dt
,renew_amt
,b_renew_amt
,renew_year_tenor
,renew_mon_tenor
,renew_day_tenor
,a_renew_int_rat
,a_renew_exp_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.update_flg,chr(13),''),chr(10),'') as update_flg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.precon_id,chr(13),''),chr(10),'') as precon_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,entr_pay_dt
,renew_effect_dt

from ${iml_schema}.agt_loan_renew_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_renew_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
