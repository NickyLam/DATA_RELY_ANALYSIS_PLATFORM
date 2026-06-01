-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/cmm_self_equip_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_self_equip_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,equip_id char(4000) nullif equip_id=blanks 
    ,equip_ip_addr_id char(4000) nullif equip_ip_addr_id=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,in_bank_flg char(4000) nullif in_bank_flg=blanks 
    ,self_equip_model char(4000) nullif self_equip_model=blanks 
    ,self_equip_type_cd char(4000) nullif self_equip_type_cd=blanks 
    ,equip_type_name char(4000) nullif equip_type_name=blanks 
    ,equip_type_name_cn_descb char(4000) nullif equip_type_name_cn_descb=blanks 
    ,equip_status_cd char(4000) nullif equip_status_cd=blanks 
    ,equip_matnce_id char(4000) nullif equip_matnce_id=blanks 
    ,equip_install_dt date "yyyy-mm-dd hh24:mi:ss" nullif equip_install_dt=blanks 
    ,cash_flg char(4000) nullif cash_flg=blanks 
    ,install_way_cd char(4000) nullif install_way_cd=blanks 
    ,dist_cd char(4000) nullif dist_cd=blanks 
    ,chn_id char(4000) nullif chn_id=blanks 
    ,equip_install_addr char(4000) nullif equip_install_addr=blanks 
    ,equip_kind_name char(4000) nullif equip_kind_name=blanks 
)