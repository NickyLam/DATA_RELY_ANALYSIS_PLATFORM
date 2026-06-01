: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_owintrtinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_owintrtinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
    ,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
    ,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
    ,replace(replace(t.ccycd,chr(13),''),chr(10),'') as ccycd
    ,t.ow_intrt_bal as ow_intrt_bal
    ,t.bal_chg_dt as bal_chg_dt
    ,replace(replace(t.ow_intrt_tp,chr(13),''),chr(10),'') as ow_intrt_tp
    ,t.infrpt_dt as infrpt_dt
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_owintrtinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_owintrtinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes