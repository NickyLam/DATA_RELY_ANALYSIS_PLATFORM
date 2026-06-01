: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_sob_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/fin_sob_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_name,chr(13),''),chr(10),'') as sob_name
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.start_use_duran,chr(13),''),chr(10),'') as start_use_duran
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.curr_acctnt_duran,chr(13),''),chr(10),'') as curr_acctnt_duran
,aldy_stl_perds
,gl_dt
,replace(replace(t1.realtm_calc_bal_flg,chr(13),''),chr(10),'') as realtm_calc_bal_flg
,replace(replace(t1.balc_check_flg,chr(13),''),chr(10),'') as balc_check_flg
,replace(replace(t1.need_entry_flg,chr(13),''),chr(10),'') as need_entry_flg
,replace(replace(t1.sob_status_cd,chr(13),''),chr(10),'') as sob_status_cd
,bus_dt
,acct_dt
,replace(replace(t1.open_invoice_curr_cd,chr(13),''),chr(10),'') as open_invoice_curr_cd
,replace(replace(t1.sob_type_cd,chr(13),''),chr(10),'') as sob_type_cd

from ${iml_schema}.fin_sob_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_sob_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
