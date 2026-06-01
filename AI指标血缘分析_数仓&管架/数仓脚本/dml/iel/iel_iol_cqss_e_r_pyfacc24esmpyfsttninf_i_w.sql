: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_pyfacc24esmpyfsttninf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_pyfacc24esmpyfsttninf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,replace(replace(t.stat_yrmo,chr(13),''),chr(10),'') as stat_yrmo
,replace(replace(t.pblc_crer_pyf_st,chr(13),''),chr(10),'') as pblc_crer_pyf_st
,t.tm_pbl_amt as tm_pbl_amt
,t.tm_rl_py_amt as tm_rl_py_amt
,t.acm_ow_amt as acm_ow_amt
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_pyfacc24esmpyfsttninf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes