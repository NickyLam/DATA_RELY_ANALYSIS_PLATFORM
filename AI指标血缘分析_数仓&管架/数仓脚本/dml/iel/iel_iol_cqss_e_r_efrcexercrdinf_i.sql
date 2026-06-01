: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_efrcexercrdinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_efrcexercrdinf.i.${batch_date}.dat
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
    ,replace(replace(t.exec_court_nm,chr(13),''),chr(10),'') as exec_court_nm
    ,replace(replace(t.fileno,chr(13),''),chr(10),'') as fileno
    ,t.putonrcrd_dt as putonrcrd_dt
    ,replace(replace(t.exec_csoatn,chr(13),''),chr(10),'') as exec_csoatn
    ,replace(replace(t.cr_efrcexe_ayexc_obj,chr(13),''),chr(10),'') as cr_efrcexe_ayexc_obj
    ,t.crefrcexeayexcobj_amt as crefrcexeayexcobj_amt
    ,replace(replace(t.cr_efrcexe_cs_st,chr(13),''),chr(10),'') as cr_efrcexe_cs_st
    ,replace(replace(t.crefrcexe_endcs_mtdcd,chr(13),''),chr(10),'') as crefrcexe_endcs_mtdcd
    ,replace(replace(t.crefrcexealrdyexecobj,chr(13),''),chr(10),'') as crefrcexealrdyexecobj
    ,t.crefrcexeayexecobjamt as crefrcexeayexecobjamt
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_efrcexercrdinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_efrcexercrdinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes