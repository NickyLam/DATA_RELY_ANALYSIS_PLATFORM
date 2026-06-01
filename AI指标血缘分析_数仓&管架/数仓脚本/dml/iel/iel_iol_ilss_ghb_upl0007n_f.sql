: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_upl0007n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_upl0007n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t.biz_typ_encd,chr(13),''),chr(10),'') as biz_typ_encd
,t.start_loan_day as start_loan_day
,t.due_day as due_day
,t.loan_amt as loan_amt
from iol.ilss_ghb_upl0007n t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_upl0007n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes