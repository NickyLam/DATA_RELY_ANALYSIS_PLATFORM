: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_overduesum_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_overduesum.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.odst_btp,chr(13),''),chr(10),'') as odst_btp
    ,t.acc_num as acc_num
    ,t.cr_ln_odue_mo_num as cr_ln_odue_mo_num
    ,t.crlnodueblmhtoduetamt as crlnodueblmhtoduetamt
    ,t.cr_lgst_odue_monum as cr_lgst_odue_monum
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_overduesum t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_overduesum.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes