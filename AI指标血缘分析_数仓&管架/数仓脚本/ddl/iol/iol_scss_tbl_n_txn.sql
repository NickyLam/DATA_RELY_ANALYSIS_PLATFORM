/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scss_tbl_n_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scss_tbl_n_txn
whenever sqlerror continue none;
drop table ${iol_schema}.scss_tbl_n_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scss_tbl_n_txn(
    sys_date varchar2(12) -- 
    ,sys_seq_num varchar2(12) -- 
    ,msg_src_id varchar2(6) -- 
    ,msg_dest_id varchar2(6) -- 
    ,log_unistamp varchar2(42) -- 
    ,org_biz_txn varchar2(15) -- 
    ,txn_num varchar2(6) -- 
    ,trans_state varchar2(2) -- 
    ,resp_code varchar2(18) -- 
    ,resp_desc varchar2(150) -- 
    ,revsal_flag varchar2(2) -- 
    ,revsal_ssn varchar2(12) -- 
    ,cancel_flag varchar2(2) -- 
    ,cancel_ssn varchar2(12) -- 
    ,key_rsp varchar2(72) -- 
    ,key_revsal varchar2(72) -- 
    ,key_cancel varchar2(72) -- 
    ,chann_num varchar2(15) -- 
    ,org_chann_num varchar2(15) -- 
    ,transnum varchar2(15) -- 
    ,transtyp varchar2(30) -- 
    ,chaldate varchar2(12) -- 
    ,checkcode varchar2(30) -- 
    ,mchnt_type varchar2(6) -- 
    ,mchnt_id varchar2(23) -- 
    ,mchnt_name varchar2(150) -- 
    ,termnl_id varchar2(12) -- 
    ,acqinsid varchar2(18) -- 
    ,acq_inst_id_code varchar2(18) -- 
    ,txn_acct_num varchar2(48) -- 
    ,txn_card_seqid varchar2(5) -- 
    ,txn_acct_isscode varchar2(18) -- 
    ,txn_acct_name varchar2(150) -- 
    ,txn_acc_type varchar2(30) -- 
    ,card_level varchar2(6) -- 
    ,txn_acc_spec varchar2(30) -- 
    ,acc_status varchar2(3) -- 
    ,date_expr varchar2(12) -- 
    ,vrf_flg varchar2(3) -- 
    ,drw_mode varchar2(3) -- 
    ,drw_mode_status varchar2(3) -- 
    ,sett_card_flag varchar2(2) -- 
    ,sett_card_name varchar2(180) -- 
    ,cash_can varchar2(2) -- 
    ,currcy_code_stlm varchar2(5) -- 
    ,amt_trans varchar2(23) -- 
    ,cert_type varchar2(6) -- 
    ,cert_id varchar2(30) -- 
    ,res_ceph_num varchar2(17) -- 
    ,out_acct_id varchar2(48) -- 
    ,out_acct_name varchar2(189) -- 
    ,out_acct_issid varchar2(18) -- 
    ,in_acct_id varchar2(48) -- 
    ,in_acct_name varchar2(150) -- 
    ,in_acct_issid varchar2(18) -- 
    ,pye_acct_id1 varchar2(48) -- 
    ,pye_acctname1 varchar2(150) -- 
    ,pyr_acctid1 varchar2(48) -- 
    ,pyr_acctname1 varchar2(150) -- 
    ,pye2pyr_amt1 varchar2(23) -- 
    ,pye_acct_id2 varchar2(48) -- 
    ,pye_acct_name2 varchar2(150) -- 
    ,pyr_acct_id2 varchar2(48) -- 
    ,pyr_acct_name2 varchar2(150) -- 
    ,pye2pyr_amt2 varchar2(23) -- 
    ,pye_acct_id3 varchar2(48) -- 
    ,pye_acct_name3 varchar2(150) -- 
    ,pyr_acct_id3 varchar2(48) -- 
    ,pyr_acct_name3 varchar2(150) -- 
    ,pye2pyr_amt3 varchar2(23) -- 
    ,pye_acct_id4 varchar2(48) -- 
    ,pye_acct_name4 varchar2(150) -- 
    ,pyr_acct_id4 varchar2(48) -- 
    ,pyr_acct_name4 varchar2(150) -- 
    ,pye2pyr_amt4 varchar2(23) -- 
    ,pye_fee_acct_id varchar2(48) -- 
    ,pye_fee_acct_name varchar2(150) -- 
    ,pyr_fee_acct_id varchar2(48) -- 
    ,pyr_fee_acct_name varchar2(150) -- 
    ,tran_fee_amt varchar2(23) -- 
    ,scs_ctl_flg varchar2(12) -- 
    ,f55_9a varchar2(9) -- 
    ,f55_9c varchar2(3) -- 
    ,f55_9f1a varchar2(6) -- 
    ,f55_95 varchar2(15) -- 
    ,f55_9f37 varchar2(12) -- 
    ,f55_82 varchar2(6) -- 
    ,f55_9f36 varchar2(6) -- 
    ,f55_9f10 varchar2(96) -- 
    ,f55_5f34 varchar2(5) -- 
    ,f55_5f2a varchar2(6) -- 
    ,f55_9f26 varchar2(24) -- 
    ,f55_9f02 varchar2(18) -- 
    ,f55_9f03 varchar2(18) -- 
    ,f55_df31 varchar2(36) -- 
    ,f55_91 varchar2(48) -- 
    ,f55_72 varchar2(384) -- 
    ,srv_src_sysid varchar2(6) -- 
    ,srv_dest_sysid varchar2(6) -- 
    ,srv_msgid varchar2(60) -- 
    ,srv_cllpty_sysid varchar2(60) -- 
    ,svr_glob_seqno varchar2(72) -- 
    ,svr_sou_seqno varchar2(72) -- 
    ,svr_sou_date varchar2(12) -- 
    ,svr_sou_time varchar2(14) -- 
    ,svr_src_name varchar2(18) -- 
    ,svr_src_num varchar2(30) -- 
    ,svr_src_msgt varchar2(30) -- 
    ,svr_src_pri varchar2(3) -- 
    ,tell_no varchar2(30) -- 
    ,city_code varchar2(6) -- 
    ,ptyid varchar2(30) -- 
    ,ptybrno varchar2(18) -- 
    ,outnum varchar2(30) -- 
    ,authtelid varchar2(30) -- 
    ,chktelid varchar2(30) -- 
    ,authseqno varchar2(24) -- 
    ,authpwd varchar2(24) -- 
    ,prcscd varchar2(15) -- 
    ,orisouseqno varchar2(48) -- 
    ,orisoudate varchar2(12) -- 
    ,orisoutime varchar2(21) -- 
    ,oriuppno varchar2(60) -- 
    ,oriuppdate varchar2(12) -- 
    ,uppno varchar2(60) -- 
    ,uppdate varchar2(12) -- 
    ,uppcode varchar2(23) -- 
    ,upptxt varchar2(600) -- 
    ,authcode varchar2(12) -- 
    ,colddate varchar2(12) -- 
    ,coldnum varchar2(60) -- 
    ,oricolddate varchar2(12) -- 
    ,oricoldnum varchar2(60) -- 
    ,onlnbal varchar2(27) -- 
    ,acctbal varchar2(27) -- 
    ,msgtype varchar2(24) -- 
    ,miscflag varchar2(24) -- 
    ,misc1 varchar2(48) -- 
    ,misc2 varchar2(48) -- 
    ,misc3 varchar2(48) -- 
    ,misc4 varchar2(48) -- 
    ,misc5 varchar2(96) -- 
    ,misc6 varchar2(96) -- 
    ,resv1 varchar2(192) -- 
    ,resv2 varchar2(192) -- 
    ,inst_date varchar2(21) -- 
    ,updt_date varchar2(21) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scss_tbl_n_txn to ${iml_schema};
grant select on ${iol_schema}.scss_tbl_n_txn to ${icl_schema};
grant select on ${iol_schema}.scss_tbl_n_txn to ${idl_schema};
grant select on ${iol_schema}.scss_tbl_n_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.scss_tbl_n_txn is '银联和ATM交易流水表';
comment on column ${iol_schema}.scss_tbl_n_txn.sys_date is '';
comment on column ${iol_schema}.scss_tbl_n_txn.sys_seq_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.msg_src_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.msg_dest_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.log_unistamp is '';
comment on column ${iol_schema}.scss_tbl_n_txn.org_biz_txn is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.trans_state is '';
comment on column ${iol_schema}.scss_tbl_n_txn.resp_code is '';
comment on column ${iol_schema}.scss_tbl_n_txn.resp_desc is '';
comment on column ${iol_schema}.scss_tbl_n_txn.revsal_flag is '';
comment on column ${iol_schema}.scss_tbl_n_txn.revsal_ssn is '';
comment on column ${iol_schema}.scss_tbl_n_txn.cancel_flag is '';
comment on column ${iol_schema}.scss_tbl_n_txn.cancel_ssn is '';
comment on column ${iol_schema}.scss_tbl_n_txn.key_rsp is '';
comment on column ${iol_schema}.scss_tbl_n_txn.key_revsal is '';
comment on column ${iol_schema}.scss_tbl_n_txn.key_cancel is '';
comment on column ${iol_schema}.scss_tbl_n_txn.chann_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.org_chann_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.transnum is '';
comment on column ${iol_schema}.scss_tbl_n_txn.transtyp is '';
comment on column ${iol_schema}.scss_tbl_n_txn.chaldate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.checkcode is '';
comment on column ${iol_schema}.scss_tbl_n_txn.mchnt_type is '';
comment on column ${iol_schema}.scss_tbl_n_txn.mchnt_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.mchnt_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.termnl_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.acqinsid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.acq_inst_id_code is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_acct_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_card_seqid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_acct_isscode is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_acct_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_acc_type is '';
comment on column ${iol_schema}.scss_tbl_n_txn.card_level is '';
comment on column ${iol_schema}.scss_tbl_n_txn.txn_acc_spec is '';
comment on column ${iol_schema}.scss_tbl_n_txn.acc_status is '';
comment on column ${iol_schema}.scss_tbl_n_txn.date_expr is '';
comment on column ${iol_schema}.scss_tbl_n_txn.vrf_flg is '';
comment on column ${iol_schema}.scss_tbl_n_txn.drw_mode is '';
comment on column ${iol_schema}.scss_tbl_n_txn.drw_mode_status is '';
comment on column ${iol_schema}.scss_tbl_n_txn.sett_card_flag is '';
comment on column ${iol_schema}.scss_tbl_n_txn.sett_card_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.cash_can is '';
comment on column ${iol_schema}.scss_tbl_n_txn.currcy_code_stlm is '';
comment on column ${iol_schema}.scss_tbl_n_txn.amt_trans is '';
comment on column ${iol_schema}.scss_tbl_n_txn.cert_type is '';
comment on column ${iol_schema}.scss_tbl_n_txn.cert_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.res_ceph_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.out_acct_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.out_acct_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.out_acct_issid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.in_acct_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.in_acct_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.in_acct_issid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_id1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acctname1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acctid1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acctname1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye2pyr_amt1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_id2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_name2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_id2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_name2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye2pyr_amt2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_id3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_name3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_id3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_name3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye2pyr_amt3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_id4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_acct_name4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_id4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_acct_name4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye2pyr_amt4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_fee_acct_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pye_fee_acct_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_fee_acct_id is '';
comment on column ${iol_schema}.scss_tbl_n_txn.pyr_fee_acct_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.tran_fee_amt is '';
comment on column ${iol_schema}.scss_tbl_n_txn.scs_ctl_flg is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9a is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9c is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f1a is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_95 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f37 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_82 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f36 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f10 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_5f34 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_5f2a is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f26 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f02 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_9f03 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_df31 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_91 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.f55_72 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.srv_src_sysid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.srv_dest_sysid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.srv_msgid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.srv_cllpty_sysid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_glob_seqno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_sou_seqno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_sou_date is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_sou_time is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_src_name is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_src_num is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_src_msgt is '';
comment on column ${iol_schema}.scss_tbl_n_txn.svr_src_pri is '';
comment on column ${iol_schema}.scss_tbl_n_txn.tell_no is '';
comment on column ${iol_schema}.scss_tbl_n_txn.city_code is '';
comment on column ${iol_schema}.scss_tbl_n_txn.ptyid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.ptybrno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.outnum is '';
comment on column ${iol_schema}.scss_tbl_n_txn.authtelid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.chktelid is '';
comment on column ${iol_schema}.scss_tbl_n_txn.authseqno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.authpwd is '';
comment on column ${iol_schema}.scss_tbl_n_txn.prcscd is '';
comment on column ${iol_schema}.scss_tbl_n_txn.orisouseqno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.orisoudate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.orisoutime is '';
comment on column ${iol_schema}.scss_tbl_n_txn.oriuppno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.oriuppdate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.uppno is '';
comment on column ${iol_schema}.scss_tbl_n_txn.uppdate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.uppcode is '';
comment on column ${iol_schema}.scss_tbl_n_txn.upptxt is '';
comment on column ${iol_schema}.scss_tbl_n_txn.authcode is '';
comment on column ${iol_schema}.scss_tbl_n_txn.colddate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.coldnum is '';
comment on column ${iol_schema}.scss_tbl_n_txn.oricolddate is '';
comment on column ${iol_schema}.scss_tbl_n_txn.oricoldnum is '';
comment on column ${iol_schema}.scss_tbl_n_txn.onlnbal is '';
comment on column ${iol_schema}.scss_tbl_n_txn.acctbal is '';
comment on column ${iol_schema}.scss_tbl_n_txn.msgtype is '';
comment on column ${iol_schema}.scss_tbl_n_txn.miscflag is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc3 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc4 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc5 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.misc6 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.resv1 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.resv2 is '';
comment on column ${iol_schema}.scss_tbl_n_txn.inst_date is '';
comment on column ${iol_schema}.scss_tbl_n_txn.updt_date is '';
comment on column ${iol_schema}.scss_tbl_n_txn.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scss_tbl_n_txn.etl_timestamp is 'ETL处理时间戳';
