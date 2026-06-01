: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_wrnttxnclsmyinf_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_wrnttxnclsmyinf.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.smy_tp,chr(13),''),chr(10),'') as smy_tp
    ,replace(replace(t.entp_wrnt_txn_btp,chr(13),''),chr(10),'') as entp_wrnt_txn_btp
    ,replace(replace(t.ast_qly_cl,chr(13),''),chr(10),'') as ast_qly_cl
    ,t.acc_num as acc_num
    ,t.bal as bal
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_wrnttxnclsmyinf t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrnttxnclsmyinf.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes