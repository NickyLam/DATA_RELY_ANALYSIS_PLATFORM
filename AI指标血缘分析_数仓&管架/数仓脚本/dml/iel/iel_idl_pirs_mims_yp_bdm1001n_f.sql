: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_yp_bdm1001n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_yp_bdm1001n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.bil_num,chr(13),''),chr(10),'') as bil_num
,replace(replace(t1.bil_amt,chr(13),''),chr(10),'') as bil_amt
,replace(replace(t1.due_day,chr(13),''),chr(10),'') as due_day
,replace(replace(t1.acpt_row_num,chr(13),''),chr(10),'') as acpt_row_num
,replace(replace(t1.acpt_row_bnk_nm,chr(13),''),chr(10),'') as acpt_row_bnk_nm
,replace(replace(t1.impa_dt,chr(13),''),chr(10),'') as impa_dt
,replace(replace(t1.impa_fname,chr(13),''),chr(10),'') as impa_fname
,replace(replace(t1.impa_acct_num,chr(13),''),chr(10),'') as impa_acct_num
,replace(replace(t1.impa_open_bk_num,chr(13),''),chr(10),'') as impa_open_bk_num
,replace(replace(t1.impa_open_bk_name,chr(13),''),chr(10),'') as impa_open_bk_name
,replace(replace(t1.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.pawn_open_bk_name,chr(13),''),chr(10),'') as pawn_open_bk_name
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,'' as data_date
from ${iol_schema}.mims_yp_bdm1001n t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_yp_bdm1001n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes