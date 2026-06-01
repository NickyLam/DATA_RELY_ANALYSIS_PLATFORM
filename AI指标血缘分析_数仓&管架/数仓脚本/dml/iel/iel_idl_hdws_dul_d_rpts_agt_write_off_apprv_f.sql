: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_write_off_apprv_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_write_off_apprv.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,etl_dt
      ,replace(replace(aprv_id,chr(10),''),chr(13),'') as aprv_id
      ,replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(aprv_status_cd,chr(10),''),chr(13),'') as aprv_status_cd
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,apprv_write_off_prcp
      ,apprv_write_off_int
      ,apprv_write_off_on_int
      ,apprv_write_off_off_int
      ,write_off_adv_cost
      ,replace(replace(write_off_categ_cd,chr(10),''),chr(13),'') as write_off_categ_cd
      ,aprv_dt
      ,reg_dt
      ,replace(replace(reg_emp_id,chr(10),''),chr(13),'') as reg_emp_id
      ,replace(replace(reg_org_id,chr(10),''),chr(13),'') as reg_org_id
      ,replace(replace(operr_emp_id,chr(10),''),chr(13),'') as operr_emp_id
      ,replace(replace(oper_org_id,chr(10),''),chr(13),'') as oper_org_id
      ,replace(replace(resv_recs_flg,chr(10),''),chr(13),'') as resv_recs_flg
      ,replace(replace(court_final_judge_num,chr(10),''),chr(13),'') as court_final_judge_num
      ,court_final_judge_dt 
from idl.hdws_dul_d_rpts_agt_write_off_apprv 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_write_off_apprv.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes