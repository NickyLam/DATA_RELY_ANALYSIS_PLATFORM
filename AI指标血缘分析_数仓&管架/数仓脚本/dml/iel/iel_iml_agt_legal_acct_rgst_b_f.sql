: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_legal_acct_rgst_b_f
CreateDate: 20221114
FileName:   ${iel_data_path}/agt_legal_acct_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.legal_flg,chr(13),''),chr(10),'') as legal_flg
,replace(replace(t1.vrif_status_cd,chr(13),''),chr(10),'') as vrif_status_cd
,replace(replace(t1.unvrif_rs_cd,chr(13),''),chr(10),'') as unvrif_rs_cd
,replace(replace(t1.vrif_org_id,chr(13),''),chr(10),'') as vrif_org_id
,vrif_dt
,replace(replace(t1.disp_method_cd_comb,chr(13),''),chr(10),'') as disp_method_cd_comb
,replace(replace(t1.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,rgst_dt
,froz_dt
,replace(replace(t1.froz_flow_num,chr(13),''),chr(10),'') as froz_flow_num
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_legal_acct_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_legal_acct_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
