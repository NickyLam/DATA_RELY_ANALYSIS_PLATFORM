: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cust_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.stand_b_type_cd,chr(13),''),chr(10),'') as stand_b_type_cd
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
    ,replace(replace(t.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.max_sub_acct_num,chr(13),''),chr(10),'') as max_sub_acct_num
    ,t.sub_acct_num_cnt as sub_acct_num_cnt
    ,t.open_acct_dt as open_acct_dt
    ,replace(replace(t.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
    ,t.clos_acct_dt as clos_acct_dt
    ,replace(replace(t.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
    ,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
    ,replace(replace(t.acct_draw_way_status_cd,chr(13),''),chr(10),'') as acct_draw_way_status_cd
    ,replace(replace(t.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg
    ,replace(replace(t.draw_way_cd,chr(13),''),chr(10),'') as draw_way_cd
    ,replace(replace(t.pwd_way_cd,chr(13),''),chr(10),'') as pwd_way_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_cust_acct t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes