: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_margin_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_margin.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_acct_num,chr(13),''),chr(10),'') as col_acct_num
,begin_dt
,closing_dt
,acct_bal
,replace(replace(t1.margin_flow_id,chr(13),''),chr(10),'') as margin_flow_id
,replace(replace(t1.is_cmplt_froz_flg,chr(13),''),chr(10),'') as is_cmplt_froz_flg
,margin_froz_amt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.open_acct_org,chr(13),''),chr(10),'') as open_acct_org
,aval_bal
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_margin t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_margin.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
