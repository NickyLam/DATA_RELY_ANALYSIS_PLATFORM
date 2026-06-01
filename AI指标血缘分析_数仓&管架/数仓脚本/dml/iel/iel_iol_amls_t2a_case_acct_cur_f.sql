: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_case_acct_cur_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_case_acct_cur.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
    ,t.open_dt as open_dt
    ,replace(replace(t.acct_type,chr(13),''),chr(10),'') as acct_type
    ,replace(replace(t.open_tm,chr(13),''),chr(10),'') as open_tm
    ,replace(replace(t.oth_card_style,chr(13),''),chr(10),'') as oth_card_style
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
    ,replace(replace(t.close_tm,chr(13),''),chr(10),'') as close_tm
    ,replace(replace(t.bs_valid,chr(13),''),chr(10),'') as bs_valid
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,t.close_dt as close_dt
    ,replace(replace(t.card_style,chr(13),''),chr(10),'') as card_style
    ,replace(replace(t.card_no,chr(13),''),chr(10),'') as card_no
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.data_src,chr(13),''),chr(10),'') as data_src
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
 from iol.amls_t2a_case_acct_cur t
where etl_dt = to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_case_acct_cur.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes