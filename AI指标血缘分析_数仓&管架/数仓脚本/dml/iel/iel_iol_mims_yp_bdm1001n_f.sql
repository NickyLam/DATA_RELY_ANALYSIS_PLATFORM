: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_yp_bdm1001n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_yp_bdm1001n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t.bil_num,chr(13),''),chr(10),'') as bil_num
,replace(replace(t.bil_amt,chr(13),''),chr(10),'') as bil_amt
,replace(replace(t.due_day,chr(13),''),chr(10),'') as due_day
,replace(replace(t.acpt_row_num,chr(13),''),chr(10),'') as acpt_row_num
,replace(replace(t.acpt_row_bnk_nm,chr(13),''),chr(10),'') as acpt_row_bnk_nm
,replace(replace(t.impa_dt,chr(13),''),chr(10),'') as impa_dt
,replace(replace(t.impa_fname,chr(13),''),chr(10),'') as impa_fname
,replace(replace(t.impa_acct_num,chr(13),''),chr(10),'') as impa_acct_num
,replace(replace(t.impa_open_bk_num,chr(13),''),chr(10),'') as impa_open_bk_num
,replace(replace(t.impa_open_bk_name,chr(13),''),chr(10),'') as impa_open_bk_name
,replace(replace(t.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd
,replace(replace(t.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t.pawn_open_bk_name,chr(13),''),chr(10),'') as pawn_open_bk_name
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_yp_bdm1001n t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_yp_bdm1001n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes