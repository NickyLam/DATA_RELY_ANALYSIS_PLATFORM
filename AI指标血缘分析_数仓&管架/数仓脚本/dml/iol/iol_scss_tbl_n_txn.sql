/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scss_tbl_n_txn
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scss_tbl_n_txn_ex purge;
alter table ${iol_schema}.scss_tbl_n_txn add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scss_tbl_n_txn truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scss_tbl_n_txn_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scss_tbl_n_txn where 0=1;

insert /*+ append */ into ${iol_schema}.scss_tbl_n_txn_ex(
    sys_date -- 
    ,sys_seq_num -- 
    ,msg_src_id -- 
    ,msg_dest_id -- 
    ,log_unistamp -- 
    ,org_biz_txn -- 
    ,txn_num -- 
    ,trans_state -- 
    ,resp_code -- 
    ,resp_desc -- 
    ,revsal_flag -- 
    ,revsal_ssn -- 
    ,cancel_flag -- 
    ,cancel_ssn -- 
    ,key_rsp -- 
    ,key_revsal -- 
    ,key_cancel -- 
    ,chann_num -- 
    ,org_chann_num -- 
    ,transnum -- 
    ,transtyp -- 
    ,chaldate -- 
    ,checkcode -- 
    ,mchnt_type -- 
    ,mchnt_id -- 
    ,mchnt_name -- 
    ,termnl_id -- 
    ,acqinsid -- 
    ,acq_inst_id_code -- 
    ,txn_acct_num -- 
    ,txn_card_seqid -- 
    ,txn_acct_isscode -- 
    ,txn_acct_name -- 
    ,txn_acc_type -- 
    ,card_level -- 
    ,txn_acc_spec -- 
    ,acc_status -- 
    ,date_expr -- 
    ,vrf_flg -- 
    ,drw_mode -- 
    ,drw_mode_status -- 
    ,sett_card_flag -- 
    ,sett_card_name -- 
    ,cash_can -- 
    ,currcy_code_stlm -- 
    ,amt_trans -- 
    ,cert_type -- 
    ,cert_id -- 
    ,res_ceph_num -- 
    ,out_acct_id -- 
    ,out_acct_name -- 
    ,out_acct_issid -- 
    ,in_acct_id -- 
    ,in_acct_name -- 
    ,in_acct_issid -- 
    ,pye_acct_id1 -- 
    ,pye_acctname1 -- 
    ,pyr_acctid1 -- 
    ,pyr_acctname1 -- 
    ,pye2pyr_amt1 -- 
    ,pye_acct_id2 -- 
    ,pye_acct_name2 -- 
    ,pyr_acct_id2 -- 
    ,pyr_acct_name2 -- 
    ,pye2pyr_amt2 -- 
    ,pye_acct_id3 -- 
    ,pye_acct_name3 -- 
    ,pyr_acct_id3 -- 
    ,pyr_acct_name3 -- 
    ,pye2pyr_amt3 -- 
    ,pye_acct_id4 -- 
    ,pye_acct_name4 -- 
    ,pyr_acct_id4 -- 
    ,pyr_acct_name4 -- 
    ,pye2pyr_amt4 -- 
    ,pye_fee_acct_id -- 
    ,pye_fee_acct_name -- 
    ,pyr_fee_acct_id -- 
    ,pyr_fee_acct_name -- 
    ,tran_fee_amt -- 
    ,scs_ctl_flg -- 
    ,f55_9a -- 
    ,f55_9c -- 
    ,f55_9f1a -- 
    ,f55_95 -- 
    ,f55_9f37 -- 
    ,f55_82 -- 
    ,f55_9f36 -- 
    ,f55_9f10 -- 
    ,f55_5f34 -- 
    ,f55_5f2a -- 
    ,f55_9f26 -- 
    ,f55_9f02 -- 
    ,f55_9f03 -- 
    ,f55_df31 -- 
    ,f55_91 -- 
    ,f55_72 -- 
    ,srv_src_sysid -- 
    ,srv_dest_sysid -- 
    ,srv_msgid -- 
    ,srv_cllpty_sysid -- 
    ,svr_glob_seqno -- 
    ,svr_sou_seqno -- 
    ,svr_sou_date -- 
    ,svr_sou_time -- 
    ,svr_src_name -- 
    ,svr_src_num -- 
    ,svr_src_msgt -- 
    ,svr_src_pri -- 
    ,tell_no -- 
    ,city_code -- 
    ,ptyid -- 
    ,ptybrno -- 
    ,outnum -- 
    ,authtelid -- 
    ,chktelid -- 
    ,authseqno -- 
    ,authpwd -- 
    ,prcscd -- 
    ,orisouseqno -- 
    ,orisoudate -- 
    ,orisoutime -- 
    ,oriuppno -- 
    ,oriuppdate -- 
    ,uppno -- 
    ,uppdate -- 
    ,uppcode -- 
    ,upptxt -- 
    ,authcode -- 
    ,colddate -- 
    ,coldnum -- 
    ,oricolddate -- 
    ,oricoldnum -- 
    ,onlnbal -- 
    ,acctbal -- 
    ,msgtype -- 
    ,miscflag -- 
    ,misc1 -- 
    ,misc2 -- 
    ,misc3 -- 
    ,misc4 -- 
    ,misc5 -- 
    ,misc6 -- 
    ,resv1 -- 
    ,resv2 -- 
    ,inst_date -- 
    ,updt_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sys_date -- 
    ,sys_seq_num -- 
    ,msg_src_id -- 
    ,msg_dest_id -- 
    ,log_unistamp -- 
    ,org_biz_txn -- 
    ,txn_num -- 
    ,trans_state -- 
    ,resp_code -- 
    ,resp_desc -- 
    ,revsal_flag -- 
    ,revsal_ssn -- 
    ,cancel_flag -- 
    ,cancel_ssn -- 
    ,key_rsp -- 
    ,key_revsal -- 
    ,key_cancel -- 
    ,chann_num -- 
    ,org_chann_num -- 
    ,transnum -- 
    ,transtyp -- 
    ,chaldate -- 
    ,checkcode -- 
    ,mchnt_type -- 
    ,mchnt_id -- 
    ,mchnt_name -- 
    ,termnl_id -- 
    ,acqinsid -- 
    ,acq_inst_id_code -- 
    ,txn_acct_num -- 
    ,txn_card_seqid -- 
    ,txn_acct_isscode -- 
    ,txn_acct_name -- 
    ,txn_acc_type -- 
    ,card_level -- 
    ,txn_acc_spec -- 
    ,acc_status -- 
    ,date_expr -- 
    ,vrf_flg -- 
    ,drw_mode -- 
    ,drw_mode_status -- 
    ,sett_card_flag -- 
    ,sett_card_name -- 
    ,cash_can -- 
    ,currcy_code_stlm -- 
    ,amt_trans -- 
    ,cert_type -- 
    ,cert_id -- 
    ,res_ceph_num -- 
    ,out_acct_id -- 
    ,out_acct_name -- 
    ,out_acct_issid -- 
    ,in_acct_id -- 
    ,in_acct_name -- 
    ,in_acct_issid -- 
    ,pye_acct_id1 -- 
    ,pye_acctname1 -- 
    ,pyr_acctid1 -- 
    ,pyr_acctname1 -- 
    ,pye2pyr_amt1 -- 
    ,pye_acct_id2 -- 
    ,pye_acct_name2 -- 
    ,pyr_acct_id2 -- 
    ,pyr_acct_name2 -- 
    ,pye2pyr_amt2 -- 
    ,pye_acct_id3 -- 
    ,pye_acct_name3 -- 
    ,pyr_acct_id3 -- 
    ,pyr_acct_name3 -- 
    ,pye2pyr_amt3 -- 
    ,pye_acct_id4 -- 
    ,pye_acct_name4 -- 
    ,pyr_acct_id4 -- 
    ,pyr_acct_name4 -- 
    ,pye2pyr_amt4 -- 
    ,pye_fee_acct_id -- 
    ,pye_fee_acct_name -- 
    ,pyr_fee_acct_id -- 
    ,pyr_fee_acct_name -- 
    ,tran_fee_amt -- 
    ,scs_ctl_flg -- 
    ,f55_9a -- 
    ,f55_9c -- 
    ,f55_9f1a -- 
    ,f55_95 -- 
    ,f55_9f37 -- 
    ,f55_82 -- 
    ,f55_9f36 -- 
    ,f55_9f10 -- 
    ,f55_5f34 -- 
    ,f55_5f2a -- 
    ,f55_9f26 -- 
    ,f55_9f02 -- 
    ,f55_9f03 -- 
    ,f55_df31 -- 
    ,f55_91 -- 
    ,f55_72 -- 
    ,srv_src_sysid -- 
    ,srv_dest_sysid -- 
    ,srv_msgid -- 
    ,srv_cllpty_sysid -- 
    ,svr_glob_seqno -- 
    ,svr_sou_seqno -- 
    ,svr_sou_date -- 
    ,svr_sou_time -- 
    ,svr_src_name -- 
    ,svr_src_num -- 
    ,svr_src_msgt -- 
    ,svr_src_pri -- 
    ,tell_no -- 
    ,city_code -- 
    ,ptyid -- 
    ,ptybrno -- 
    ,outnum -- 
    ,authtelid -- 
    ,chktelid -- 
    ,authseqno -- 
    ,authpwd -- 
    ,prcscd -- 
    ,orisouseqno -- 
    ,orisoudate -- 
    ,orisoutime -- 
    ,oriuppno -- 
    ,oriuppdate -- 
    ,uppno -- 
    ,uppdate -- 
    ,uppcode -- 
    ,upptxt -- 
    ,authcode -- 
    ,colddate -- 
    ,coldnum -- 
    ,oricolddate -- 
    ,oricoldnum -- 
    ,onlnbal -- 
    ,acctbal -- 
    ,msgtype -- 
    ,miscflag -- 
    ,misc1 -- 
    ,misc2 -- 
    ,misc3 -- 
    ,misc4 -- 
    ,misc5 -- 
    ,misc6 -- 
    ,resv1 -- 
    ,resv2 -- 
    ,inst_date -- 
    ,updt_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scss_tbl_n_txn
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scss_tbl_n_txn exchange partition p_${batch_date} with table ${iol_schema}.scss_tbl_n_txn_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scss_tbl_n_txn to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scss_tbl_n_txn_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scss_tbl_n_txn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);