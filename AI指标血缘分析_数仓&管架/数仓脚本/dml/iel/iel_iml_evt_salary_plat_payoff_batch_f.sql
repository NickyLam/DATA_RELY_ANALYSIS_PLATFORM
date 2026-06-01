: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_salary_plat_payoff_batch_f
CreateDate: 20250709
FileName:   ${iel_data_path}/evt_salary_plat_payoff_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.batch_caption,chr(13),''),chr(10),'') as batch_caption
,replace(replace(t1.batch_flow_cd,chr(13),''),chr(10),'') as batch_flow_cd
,replace(replace(t1.batch_status_cd,chr(13),''),chr(10),'') as batch_status_cd
,batch_dt
,batch_cmplt_dt
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.payoff_src_cd,chr(13),''),chr(10),'') as payoff_src_cd
,replace(replace(t1.payoff_kind_cd,chr(13),''),chr(10),'') as payoff_kind_cd
,payoff_year
,payoff_mon
,tot_number
,tot
,tot_amt
,avg_amt
,sucs_tot_amt
,fail_tot_amt
,sucs_cnt
,fail_cnt
,tran_status_union_qtty
,replace(replace(t1.apv_ser_num,chr(13),''),chr(10),'') as apv_ser_num
,replace(replace(t1.salary_group_id,chr(13),''),chr(10),'') as salary_group_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.diplay_payoff_dtl_flg,chr(13),''),chr(10),'') as diplay_payoff_dtl_flg
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,batch_create_dt
,batch_update_dt

from ${iml_schema}.evt_salary_plat_payoff_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_salary_plat_payoff_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
