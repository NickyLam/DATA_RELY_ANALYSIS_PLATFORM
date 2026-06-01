: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_wfi_accept_approve_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_wfi_accept_approve.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
    ,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.is_bank_rel,chr(13),''),chr(10),'') as is_bank_rel
    ,replace(replace(t.is_specail_loan,chr(13),''),chr(10),'') as is_specail_loan
    ,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
    ,replace(replace(t.loan_form,chr(13),''),chr(10),'') as loan_form
    ,t.apply_amount as apply_amount
    ,replace(replace(t.approve_status,chr(13),''),chr(10),'') as approve_status
    ,replace(replace(t.actorname,chr(13),''),chr(10),'') as actorname
    ,replace(replace(t.organname,chr(13),''),chr(10),'') as organname
    ,replace(replace(t.wfname,chr(13),''),chr(10),'') as wfname
    ,replace(replace(t.operate_time,chr(13),''),chr(10),'') as operate_time
    ,replace(replace(t.term,chr(13),''),chr(10),'') as term
    ,replace(replace(t.assure_means_main,chr(13),''),chr(10),'') as assure_means_main
    ,replace(replace(t.suporgname,chr(13),''),chr(10),'') as suporgname
    ,replace(replace(t.acceptname,chr(13),''),chr(10),'') as acceptname
    ,replace(replace(t.is_online,chr(13),''),chr(10),'') as is_online
    ,replace(replace(t.head_examiner,chr(13),''),chr(10),'') as head_examiner
    ,replace(replace(t.app_user,chr(13),''),chr(10),'') as app_user
    ,t.approve_num as approve_num
    ,replace(replace(t.firstbranchname,chr(13),''),chr(10),'') as firstbranchname
    ,replace(replace(t.firstbranchtime,chr(13),''),chr(10),'') as firstbranchtime
    ,replace(replace(t.zjgaccepttime,chr(13),''),chr(10),'') as zjgaccepttime
    ,t.first_approve_num as first_approve_num
from iol.rcrs_wfi_accept_approve t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_wfi_accept_approve.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes