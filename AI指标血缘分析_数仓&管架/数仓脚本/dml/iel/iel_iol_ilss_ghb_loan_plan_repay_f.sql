: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_loan_plan_repay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_loan_plan_repay.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lncfno,chr(13),''),chr(10),'') as lncfno
,t.termno as termno
,replace(replace(t.bgindt,chr(13),''),chr(10),'') as bgindt
,replace(replace(t.schedt,chr(13),''),chr(10),'') as schedt
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.intrst as intrst
,t.accrbl as accrbl
,t.corpam as corpam
,t.instam as instam
,t.instdd as instdd
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.rpaysts,chr(13),''),chr(10),'') as rpaysts
,t.delay_prin as delay_prin
,t.dull_prin as dull_prin
,t.raccr_int as raccr_int
,t.obs_cal_int as obs_cal_int
,t.raccr_arr_int as raccr_arr_int
,t.obs_debt_int as obs_debt_int
,t.raccr_pnty_int as raccr_pnty_int
,t.obs_pun_int as obs_pun_int
,t.rcbl_pnty_int as rcbl_pnty_int
,t.obs_pnsh_int as obs_pnsh_int
,t.raccr_comp_int as raccr_comp_int
,t.ret_int as ret_int
,t.delay_days as delay_days
,t.ctermno as ctermno
from iol.ilss_ghb_loan_plan_repay t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_loan_plan_repay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes