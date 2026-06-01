: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_credittradecue_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_credittradecue.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.crln_txn_btp,chr(13),''),chr(10),'') as crln_txn_btp
    ,replace(replace(t.crln_txn_bsn_lrgclss,chr(13),''),chr(10),'') as crln_txn_bsn_lrgclss
    ,t.acc_num as acc_num
    ,replace(replace(t.cr_int_ln_dstr_yrmo,chr(13),''),chr(10),'') as cr_int_ln_dstr_yrmo
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_credittradecue t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_credittradecue.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes