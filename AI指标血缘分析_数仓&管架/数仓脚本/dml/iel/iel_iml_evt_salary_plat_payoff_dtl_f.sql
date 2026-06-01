: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_salary_plat_payoff_dtl_f
CreateDate: 20250709
FileName:   ${iel_data_path}/evt_salary_plat_payoff_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,tran_amt
,over_lmt_amt_lmt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id
,replace(replace(t1.emply_name,chr(13),''),chr(10),'') as emply_name
,replace(replace(t1.emply_tel,chr(13),''),chr(10),'') as emply_tel
,replace(replace(t1.staf_cd_piece_no_code,chr(13),''),chr(10),'') as staf_cd_piece_no_code
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,batch_create_dt
,batch_update_dt

from ${iml_schema}.evt_salary_plat_payoff_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_salary_plat_payoff_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
