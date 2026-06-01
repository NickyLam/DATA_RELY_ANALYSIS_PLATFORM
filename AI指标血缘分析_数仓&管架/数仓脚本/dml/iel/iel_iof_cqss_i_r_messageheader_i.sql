: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_i_r_messageheader_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_messageheader.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.idv_cr_rpt_file_id,chr(13),''),chr(10),'') as idv_cr_rpt_file_id
,t1.msgrp_gen_tm as msgrp_gen_tm
,replace(replace(t1.cr_enqd_ppl_nm,chr(13),''),chr(10),'') as cr_enqd_ppl_nm
,replace(replace(t1.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
,replace(replace(t1.crrptenqd_psn_crdt_no,chr(13),''),chr(10),'') as crrptenqd_psn_crdt_no
,replace(replace(t1.cr_enqd_insid,chr(13),''),chr(10),'') as cr_enqd_insid
,replace(replace(t1.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
,t1.crdt_inf_rcrd_num as crdt_inf_rcrd_num
,replace(replace(t1.cht_ind,chr(13),''),chr(10),'') as cht_ind
,replace(replace(t1.ctc_tel,chr(13),''),chr(10),'') as ctc_tel
,t1.afrd_strtg_rlsdt_prd as afrd_strtg_rlsdt_prd
,t1.afrd_strtg_expdt as afrd_strtg_expdt
,t1.cr_objtn_num as cr_objtn_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t1.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_messageheader t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_messageheader.i.${batch_date}.dat" \
        charset=utf8
        safe=yes