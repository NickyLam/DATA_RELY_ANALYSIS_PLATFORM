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
infile '${data_path}/orws_t_ghbr_bv_statistics.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,id char(4000) nullif id=blanks 
    ,data_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif data_date=blanks 
    ,data_type char(4000) nullif data_type=blanks 
    ,is_shield char(4000) nullif is_shield=blanks 
    ,hb_num char(4000) nullif hb_num=blanks 
    ,hb_name char(4000) nullif hb_name=blanks 
    ,bb_num char(4000) nullif bb_num=blanks 
    ,bb_name char(4000) nullif bb_name=blanks 
    ,sb_num char(4000) nullif sb_num=blanks 
    ,sb_name char(4000) nullif sb_name=blanks 
    ,organ_num char(4000) nullif organ_num=blanks 
    ,organ_name char(4000) nullif organ_name=blanks 
    ,display_num char(4000) nullif display_num=blanks 
    ,display_name char(4000) nullif display_name=blanks 
    ,total_txnvol char(4000) nullif total_txnvol=blanks 
    ,total_weight_txnvol char(4000) nullif total_weight_txnvol=blanks 
    ,cbss_txnvol char(4000) nullif cbss_txnvol=blanks 
    ,cbss_weight_txnvol char(4000) nullif cbss_weight_txnvol=blanks 
    ,pwbs_txnvol char(4000) nullif pwbs_txnvol=blanks 
    ,pwbs_weight_txnvol char(4000) nullif pwbs_weight_txnvol=blanks 
    ,ifms_txnvol char(4000) nullif ifms_txnvol=blanks 
    ,ifms_weight_txnvol char(4000) nullif ifms_weight_txnvol=blanks 
    ,pbss_txnvol char(4000) nullif pbss_txnvol=blanks 
    ,pbss_weight_txnvol char(4000) nullif pbss_weight_txnvol=blanks 
    ,isbs_txnvol char(4000) nullif isbs_txnvol=blanks 
    ,isbs_weight_txnvol char(4000) nullif isbs_weight_txnvol=blanks 
    ,crss_txnvol char(4000) nullif crss_txnvol=blanks 
    ,crss_weight_txnvol char(4000) nullif crss_weight_txnvol=blanks 
    ,svss_txnvol char(4000) nullif svss_txnvol=blanks 
    ,svss_weight_txnvol char(4000) nullif svss_weight_txnvol=blanks 
    ,amls_txnvol char(4000) nullif amls_txnvol=blanks 
    ,amls_weight_txnvol char(4000) nullif amls_weight_txnvol=blanks 
    ,bdms_txnvol char(4000) nullif bdms_txnvol=blanks 
    ,bdms_weight_txnvol char(4000) nullif bdms_weight_txnvol=blanks 
    ,mpcs_txnvol char(4000) nullif mpcs_txnvol=blanks 
    ,mpcs_weight_txnvol char(4000) nullif mpcs_weight_txnvol=blanks 
    ,ma_txnvol char(4000) nullif ma_txnvol=blanks 
    ,ma_weight_txnvol char(4000) nullif ma_weight_txnvol=blanks 
    ,period_type char(4000) nullif period_type=blanks 
    ,teller_type char(4000) nullif teller_type=blanks 
    ,auto_txnvol char(4000) nullif auto_txnvol=blanks 
    ,auto_weight_txnvol char(4000) nullif auto_weight_txnvol=blanks 
)