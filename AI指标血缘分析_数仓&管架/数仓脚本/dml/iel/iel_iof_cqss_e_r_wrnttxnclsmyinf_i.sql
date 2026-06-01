: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_wrnttxnclsmyinf_i
CreateDate: 20250703
FileName:   ${iel_data_path}/cqss_e_r_wrnttxnclsmyinf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.smy_tp,chr(13),''),chr(10),'') as smy_tp
,replace(replace(t1.entp_wrnt_txn_btp,chr(13),''),chr(10),'') as entp_wrnt_txn_btp
,replace(replace(t1.ast_qly_cl,chr(13),''),chr(10),'') as ast_qly_cl
,acc_num
,bal
,crt_dt_tm

from ${iol_schema}.cqss_e_r_wrnttxnclsmyinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrnttxnclsmyinf.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
