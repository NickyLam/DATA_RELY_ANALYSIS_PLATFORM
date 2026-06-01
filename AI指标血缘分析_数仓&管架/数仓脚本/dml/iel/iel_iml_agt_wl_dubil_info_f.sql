: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_dubil_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_dubil_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.init_dubil_id,chr(13),''),chr(10),'') as init_dubil_id
    ,replace(replace(t.intnal_dubil_id,chr(13),''),chr(10),'') as intnal_dubil_id
    ,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.cont_agt_id,chr(13),''),chr(10),'') as cont_agt_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,t.dubil_amt as dubil_amt
    ,t.exec_int_rat as exec_int_rat
    ,t.tenor as tenor
    ,replace(replace(t.spec_repay_day,chr(13),''),chr(10),'') as spec_repay_day
    ,t.value_dt as value_dt
    ,t.exp_dt as exp_dt
    ,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
    ,t.int_rat_fl_rt as int_rat_fl_rt
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
    ,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
    ,replace(replace(t.co_proj_id,chr(13),''),chr(10),'') as co_proj_id
    ,replace(replace(t.coprator_acct_id,chr(13),''),chr(10),'') as coprator_acct_id
    ,t.create_tm as create_tm
    ,replace(replace(t.int_rat_cfg_id,chr(13),''),chr(10),'') as int_rat_cfg_id
    ,t.base_rat as base_rat
    ,t.up_lower_bp as up_lower_bp
    ,replace(replace(t.co_org_id,chr(13),''),chr(10),'') as co_org_id
    ,replace(replace(t.ovdue_comp_mode_flg,chr(13),''),chr(10),'') as ovdue_comp_mode_flg
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.brw_new_return_old_cd,chr(13),''),chr(10),'') as brw_new_return_old_cd
    ,replace(replace(t.comb_repay_flg,chr(13),''),chr(10),'') as comb_repay_flg
    ,replace(replace(t.rela_repay_princ,chr(13),''),chr(10),'') as rela_repay_princ
    ,replace(replace(t.rela_repay_princ_cert_type_cd,chr(13),''),chr(10),'') as rela_repay_princ_cert_type_cd
    ,replace(replace(t.rela_repay_princ_id_card_num,chr(13),''),chr(10),'') as rela_repay_princ_id_card_num
    ,replace(replace(t.core_corp_cust_no,chr(13),''),chr(10),'') as core_corp_cust_no
    ,replace(replace(t.rela_repay_princ_idti_type_cd,chr(13),''),chr(10),'') as rela_repay_princ_idti_type_cd
    ,replace(replace(t.rela_repay_princ_type_cd,chr(13),''),chr(10),'') as rela_repay_princ_type_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_wl_dubil_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_dubil_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes