: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_messageheader_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_messageheader_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.idv_cr_rpt_file_id,chr(13),''),chr(10),'') as idv_cr_rpt_file_id
,t.msgrp_gen_tm as msgrp_gen_tm
,replace(replace(t.cr_enqd_ppl_nm,chr(13),''),chr(10),'') as cr_enqd_ppl_nm
,replace(replace(t.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
,replace(replace(t.crrptenqd_psn_crdt_no,chr(13),''),chr(10),'') as crrptenqd_psn_crdt_no
,replace(replace(t.cr_enqd_insid,chr(13),''),chr(10),'') as cr_enqd_insid
,replace(replace(t.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
,t.crdt_inf_rcrd_num as crdt_inf_rcrd_num
,replace(replace(t.cht_ind,chr(13),''),chr(10),'') as cht_ind
,replace(replace(t.ctc_tel,chr(13),''),chr(10),'') as ctc_tel
,t.afrd_strtg_rlsdt_prd as afrd_strtg_rlsdt_prd
,t.afrd_strtg_expdt as afrd_strtg_expdt
,t.cr_objtn_num as cr_objtn_num
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_messageheader t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_messageheader_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes