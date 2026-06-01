: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_fund_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ast_col_fund_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fund_cd,chr(13),''),chr(10),'') as fund_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,begin_dt
,closing_dt
,replace(replace(t1.fund_name,chr(13),''),chr(10),'') as fund_name
,replace(replace(t1.fund_type_cd,chr(13),''),chr(10),'') as fund_type_cd
,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg
,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'') as tranbl_flg
,replace(replace(t1.invest_underly_cd,chr(13),''),chr(10),'') as invest_underly_cd
,replace(replace(t1.public_quot_flg,chr(13),''),chr(10),'') as public_quot_flg
,inpwn_lot
,corp_nv
,inpwn_tot_val
,replace(replace(t1.issuer_brwer_flg,chr(13),''),chr(10),'') as issuer_brwer_flg
,replace(replace(t1.descb,chr(13),''),chr(10),'') as descb
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_fund_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_fund_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
