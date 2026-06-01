: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_forceexecution_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_forceexecution.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.exec_court_nm,chr(13),''),chr(10),'') as exec_court_nm
    ,replace(replace(t.crefrcexe_exec_cs_rsn,chr(13),''),chr(10),'') as crefrcexe_exec_cs_rsn
    ,t.cr_jdgmt_putonrcrd_dt as cr_jdgmt_putonrcrd_dt
    ,replace(replace(t.crefrcexe_endcs_mtdcd,chr(13),''),chr(10),'') as crefrcexe_endcs_mtdcd
    ,replace(replace(t.cr_efrcexe_cs_st,chr(13),''),chr(10),'') as cr_efrcexe_cs_st
    ,t.endcs_dt as endcs_dt
    ,replace(replace(t.cr_efrcexe_ayexc_obj,chr(13),''),chr(10),'') as cr_efrcexe_ayexc_obj
    ,t.crefrcexeayexcobj_amt as crefrcexeayexcobj_amt
    ,replace(replace(t.crefrcexealrdyexecobj,chr(13),''),chr(10),'') as crefrcexealrdyexecobj
    ,t.crefrcexeayexecobjamt as crefrcexeayexecobjamt
    ,t.annttn_and_sttmnt_num as annttn_and_sttmnt_num
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_forceexecution t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_forceexecution.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes