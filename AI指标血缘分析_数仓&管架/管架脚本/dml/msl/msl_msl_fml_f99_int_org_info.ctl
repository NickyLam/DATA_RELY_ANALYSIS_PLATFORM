-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose: Sqlldr Control File
-- Author: Sunline
-- Createdate "yyyy-mm-dd hh24:mi:ss": 20190705
-- FileType: Control-File
-- Logs:
-- luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/mcs_org_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_fml_f99_int_org_info
fields terminated by x'1b' 
trailing nullcols
(
     etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks
    ,lp_id char(4000) nullif lp_id=blanks
    ,org_id char(4000) nullif org_id=blanks
    ,org_name char(4000) nullif org_name=blanks
    ,org_abbr char(4000) nullif org_abbr=blanks
    ,princ_emply_id char(4000) nullif princ_emply_id=blanks
    ,cbrc_fin_inst_id char(4000) nullif cbrc_fin_inst_id=blanks
    ,unionpay_fin_inst_id char(4000) nullif unionpay_fin_inst_id=blanks
    ,fin_inst_idf_code char(4000) nullif fin_inst_idf_code=blanks
    ,bus_lics_num char(4000) nullif bus_lics_num=blanks
    ,fin_lics_num char(4000) nullif fin_lics_num=blanks
    ,pbc_pay_bank_no char(4000) nullif pbc_pay_bank_no=blanks
    ,fin_inst_code char(4000) nullif fin_inst_code=blanks
    ,hq_org_id char(4000) nullif hq_org_id=blanks
    ,hq_org_name char(4000) nullif hq_org_name=blanks
    ,brch_id char(4000) nullif brch_id=blanks
    ,brch_name char(4000) nullif brch_name=blanks
    ,subrch_id char(4000) nullif subrch_id=blanks
    ,subrch_name char(4000) nullif subrch_name=blanks
    ,org_type_cd char(4000) nullif org_type_cd=blanks
    ,org_lev_cd char(4000) nullif org_lev_cd=blanks
    ,org_hibchy_cd char(4000) nullif org_hibchy_cd=blanks
    ,org_status_cd char(4000) nullif org_status_cd=blanks
    ,bus_status_cd char(4000) nullif bus_status_cd=blanks
    ,bus_org_flg char(4000) nullif bus_org_flg=blanks
    ,enty_org_flg char(4000) nullif enty_org_flg=blanks
    ,accti_org_flg char(4000) nullif accti_org_flg=blanks
    ,admin_org_flg char(4000) nullif admin_org_flg=blanks
    ,acct_instit_flg char(4000) nullif acct_instit_flg=blanks
    ,vtual_accti_org_flg char(4000) nullif vtual_accti_org_flg=blanks
    ,admin_super_org_id char(4000) nullif admin_super_org_id=blanks
    ,acct_super_org_id char(4000) nullif acct_super_org_id=blanks
    ,accti_super_org_id char(4000) nullif accti_super_org_id=blanks
    ,func_org_id char(4000) nullif func_org_id=blanks
    ,func_dept_id char(4000) nullif func_dept_id=blanks
    ,cty_rg_cd char(4000) nullif cty_rg_cd=blanks
    ,prov_cd char(4000) nullif prov_cd=blanks
    ,city_cd char(4000) nullif city_cd=blanks
    ,county_cd char(4000) nullif county_cd=blanks
    ,phys_addr char(4000) nullif phys_addr=blanks
    ,ddd_area_cd char(4000) nullif ddd_area_cd=blanks
    ,phone char(4000) nullif phone=blanks
    ,zip_cd char(4000) nullif zip_cd=blanks
    ,org_found_dt date "yyyy-mm-dd hh24:mi:ss" nullif org_found_dt=blanks
    ,org_revo_dt date "yyyy-mm-dd hh24:mi:ss" nullif org_revo_dt=blanks
    ,org_start_bus_tm char(4000) nullif org_start_bus_tm=blanks
    ,org_end_bus_tm char(4000) nullif org_end_bus_tm=blanks
)