/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_scss_tbl_n_txn
CreateDate: 20220512
FileType:   DML
Logs:
    sundexin
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.scss_tbl_n_txn drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.scss_tbl_n_txn add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.scss_tbl_n_txn (
      etl_dt      -- 数据日期
     ,sys_date
     ,sys_seq_num
     ,msg_src_id
     ,msg_dest_id
     ,log_unistamp
     ,org_biz_txn
     ,txn_num
     ,trans_state
     ,resp_code
     ,resp_desc
     ,revsal_flag
     ,revsal_ssn
     ,cancel_flag
     ,cancel_ssn
     ,key_rsp
     ,key_revsal
     ,key_cancel
     ,chann_num
     ,org_chann_num
     ,transnum
     ,transtyp
     ,chaldate
     ,checkcode
     ,mchnt_type
     ,mchnt_id
     ,mchnt_name
     ,termnl_id
     ,acqinsid
     ,acq_inst_id_code
     ,txn_acct_num
     ,txn_card_seqid
     ,txn_acct_isscode
     ,txn_acct_name
     ,txn_acc_type
     ,card_level
     ,txn_acc_spec
     ,acc_status
     ,date_expr
     ,vrf_flg
     ,drw_mode
     ,drw_mode_status
     ,sett_card_flag
     ,sett_card_name
     ,cash_can
     ,currcy_code_stlm
     ,amt_trans
     ,cert_type
     ,cert_id
     ,res_ceph_num
     ,out_acct_id
     ,out_acct_name
     ,out_acct_issid
     ,in_acct_id
     ,in_acct_name
     ,in_acct_issid
     ,pye_acct_id1
     ,pye_acctname1
     ,pyr_acctid1
     ,pyr_acctname1
     ,pye2pyr_amt1
     ,pye_acct_id2
     ,pye_acct_name2
     ,pyr_acct_id2
     ,pyr_acct_name2
     ,pye2pyr_amt2
     ,pye_acct_id3
     ,pye_acct_name3
     ,pyr_acct_id3
     ,pyr_acct_name3
     ,pye2pyr_amt3
     ,pye_acct_id4
     ,pye_acct_name4
     ,pyr_acct_id4
     ,pyr_acct_name4
     ,pye2pyr_amt4
     ,pye_fee_acct_id
     ,pye_fee_acct_name
     ,pyr_fee_acct_id
     ,pyr_fee_acct_name
     ,tran_fee_amt
     ,scs_ctl_flg
     ,f55_9a
     ,f55_9c
     ,f55_9f1a
     ,f55_95
     ,f55_9f37
     ,f55_82
     ,f55_9f36
     ,f55_9f10
     ,f55_5f34
     ,f55_5f2a
     ,f55_9f26
     ,f55_9f02
     ,f55_9f03
     ,f55_df31
     ,f55_91
     ,f55_72
     ,srv_src_sysid
     ,srv_dest_sysid
     ,srv_msgid
     ,srv_cllpty_sysid
     ,svr_glob_seqno
     ,svr_sou_seqno
     ,svr_sou_date
     ,svr_sou_time
     ,svr_src_name
     ,svr_src_num
     ,svr_src_msgt
     ,svr_src_pri
     ,tell_no
     ,city_code
     ,ptyid
     ,ptybrno
     ,outnum
     ,authtelid
     ,chktelid
     ,authseqno
     ,authpwd
     ,prcscd
     ,orisouseqno
     ,orisoudate
     ,orisoutime
     ,oriuppno
     ,oriuppdate
     ,uppno
     ,uppdate
     ,uppcode
     ,upptxt
     ,authcode
     ,colddate
     ,coldnum
     ,oricolddate
     ,oricoldnum
     ,onlnbal
     ,acctbal
     ,msgtype
     ,miscflag
     ,misc1
     ,misc2
     ,misc3
     ,misc4
     ,misc5
     ,misc6
     ,resv1
     ,resv2
     ,inst_date
     ,updt_date
     ,etl_timestamp  -- 数据处理时间
)
select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sys_date,chr(13),''),chr(10),'') as sys_date
    ,replace(replace(t.sys_seq_num,chr(13),''),chr(10),'') as sys_seq_num
    ,replace(replace(t.msg_src_id,chr(13),''),chr(10),'') as msg_src_id
    ,replace(replace(t.msg_dest_id,chr(13),''),chr(10),'') as msg_dest_id
    ,replace(replace(t.log_unistamp,chr(13),''),chr(10),'') as log_unistamp
    ,replace(replace(t.org_biz_txn,chr(13),''),chr(10),'') as org_biz_txn
    ,replace(replace(t.txn_num,chr(13),''),chr(10),'') as txn_num
    ,replace(replace(t.trans_state,chr(13),''),chr(10),'') as trans_state
    ,replace(replace(t.resp_code,chr(13),''),chr(10),'') as resp_code
    ,replace(replace(t.resp_desc,chr(13),''),chr(10),'') as resp_desc
    ,replace(replace(t.revsal_flag,chr(13),''),chr(10),'') as revsal_flag
    ,replace(replace(t.revsal_ssn,chr(13),''),chr(10),'') as revsal_ssn
    ,replace(replace(t.cancel_flag,chr(13),''),chr(10),'') as cancel_flag
    ,replace(replace(t.cancel_ssn,chr(13),''),chr(10),'') as cancel_ssn
    ,replace(replace(t.key_rsp,chr(13),''),chr(10),'') as key_rsp
    ,replace(replace(t.key_revsal,chr(13),''),chr(10),'') as key_revsal
    ,replace(replace(t.key_cancel,chr(13),''),chr(10),'') as key_cancel
    ,replace(replace(t.chann_num,chr(13),''),chr(10),'') as chann_num
    ,replace(replace(t.org_chann_num,chr(13),''),chr(10),'') as org_chann_num
    ,replace(replace(t.transnum,chr(13),''),chr(10),'') as transnum
    ,replace(replace(t.transtyp,chr(13),''),chr(10),'') as transtyp
    ,replace(replace(t.chaldate,chr(13),''),chr(10),'') as chaldate
    ,replace(replace(t.checkcode,chr(13),''),chr(10),'') as checkcode
    ,replace(replace(t.mchnt_type,chr(13),''),chr(10),'') as mchnt_type
    ,replace(replace(t.mchnt_id,chr(13),''),chr(10),'') as mchnt_id
    ,replace(replace(t.mchnt_name,chr(13),''),chr(10),'') as mchnt_name
    ,replace(replace(t.termnl_id,chr(13),''),chr(10),'') as termnl_id
    ,replace(replace(t.acqinsid,chr(13),''),chr(10),'') as acqinsid
    ,replace(replace(t.acq_inst_id_code,chr(13),''),chr(10),'') as acq_inst_id_code
    ,replace(replace(t.txn_acct_num,chr(13),''),chr(10),'') as txn_acct_num
    ,replace(replace(t.txn_card_seqid,chr(13),''),chr(10),'') as txn_card_seqid
    ,replace(replace(t.txn_acct_isscode,chr(13),''),chr(10),'') as txn_acct_isscode
    ,replace(replace(t.txn_acct_name,chr(13),''),chr(10),'') as txn_acct_name
    ,replace(replace(t.txn_acc_type,chr(13),''),chr(10),'') as txn_acc_type
    ,replace(replace(t.card_level,chr(13),''),chr(10),'') as card_level
    ,replace(replace(t.txn_acc_spec,chr(13),''),chr(10),'') as txn_acc_spec
    ,replace(replace(t.acc_status,chr(13),''),chr(10),'') as acc_status
    ,replace(replace(t.date_expr,chr(13),''),chr(10),'') as date_expr
    ,replace(replace(t.vrf_flg,chr(13),''),chr(10),'') as vrf_flg
    ,replace(replace(t.drw_mode,chr(13),''),chr(10),'') as drw_mode
    ,replace(replace(t.drw_mode_status,chr(13),''),chr(10),'') as drw_mode_status
    ,replace(replace(t.sett_card_flag,chr(13),''),chr(10),'') as sett_card_flag
    ,replace(replace(t.sett_card_name,chr(13),''),chr(10),'') as sett_card_name
    ,replace(replace(t.cash_can,chr(13),''),chr(10),'') as cash_can
    ,replace(replace(t.currcy_code_stlm,chr(13),''),chr(10),'') as currcy_code_stlm
    ,replace(replace(t.amt_trans,chr(13),''),chr(10),'') as amt_trans
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id
    ,replace(replace(t.res_ceph_num,chr(13),''),chr(10),'') as res_ceph_num
    ,replace(replace(t.out_acct_id,chr(13),''),chr(10),'') as out_acct_id
    ,replace(replace(t.out_acct_name,chr(13),''),chr(10),'') as out_acct_name
    ,replace(replace(t.out_acct_issid,chr(13),''),chr(10),'') as out_acct_issid
    ,replace(replace(t.in_acct_id,chr(13),''),chr(10),'') as in_acct_id
    ,replace(replace(t.in_acct_name,chr(13),''),chr(10),'') as in_acct_name
    ,replace(replace(t.in_acct_issid,chr(13),''),chr(10),'') as in_acct_issid
    ,replace(replace(t.pye_acct_id1,chr(13),''),chr(10),'') as pye_acct_id1
    ,replace(replace(t.pye_acctname1,chr(13),''),chr(10),'') as pye_acctname1
    ,replace(replace(t.pyr_acctid1,chr(13),''),chr(10),'') as pyr_acctid1
    ,replace(replace(t.pyr_acctname1,chr(13),''),chr(10),'') as pyr_acctname1
    ,replace(replace(t.pye2pyr_amt1,chr(13),''),chr(10),'') as pye2pyr_amt1
    ,replace(replace(t.pye_acct_id2,chr(13),''),chr(10),'') as pye_acct_id2
    ,replace(replace(t.pye_acct_name2,chr(13),''),chr(10),'') as pye_acct_name2
    ,replace(replace(t.pyr_acct_id2,chr(13),''),chr(10),'') as pyr_acct_id2
    ,replace(replace(t.pyr_acct_name2,chr(13),''),chr(10),'') as pyr_acct_name2
    ,replace(replace(t.pye2pyr_amt2,chr(13),''),chr(10),'') as pye2pyr_amt2
    ,replace(replace(t.pye_acct_id3,chr(13),''),chr(10),'') as pye_acct_id3
    ,replace(replace(t.pye_acct_name3,chr(13),''),chr(10),'') as pye_acct_name3
    ,replace(replace(t.pyr_acct_id3,chr(13),''),chr(10),'') as pyr_acct_id3
    ,replace(replace(t.pyr_acct_name3,chr(13),''),chr(10),'') as pyr_acct_name3
    ,replace(replace(t.pye2pyr_amt3,chr(13),''),chr(10),'') as pye2pyr_amt3
    ,replace(replace(t.pye_acct_id4,chr(13),''),chr(10),'') as pye_acct_id4
    ,replace(replace(t.pye_acct_name4,chr(13),''),chr(10),'') as pye_acct_name4
    ,replace(replace(t.pyr_acct_id4,chr(13),''),chr(10),'') as pyr_acct_id4
    ,replace(replace(t.pyr_acct_name4,chr(13),''),chr(10),'') as pyr_acct_name4
    ,replace(replace(t.pye2pyr_amt4,chr(13),''),chr(10),'') as pye2pyr_amt4
    ,replace(replace(t.pye_fee_acct_id,chr(13),''),chr(10),'') as pye_fee_acct_id
    ,replace(replace(t.pye_fee_acct_name,chr(13),''),chr(10),'') as pye_fee_acct_name
    ,replace(replace(t.pyr_fee_acct_id,chr(13),''),chr(10),'') as pyr_fee_acct_id
    ,replace(replace(t.pyr_fee_acct_name,chr(13),''),chr(10),'') as pyr_fee_acct_name
    ,replace(replace(t.tran_fee_amt,chr(13),''),chr(10),'') as tran_fee_amt
    ,replace(replace(t.scs_ctl_flg,chr(13),''),chr(10),'') as scs_ctl_flg
    ,replace(replace(t.f55_9a,chr(13),''),chr(10),'') as f55_9a
    ,replace(replace(t.f55_9c,chr(13),''),chr(10),'') as f55_9c
    ,replace(replace(t.f55_9f1a,chr(13),''),chr(10),'') as f55_9f1a
    ,replace(replace(t.f55_95,chr(13),''),chr(10),'') as f55_95
    ,replace(replace(t.f55_9f37,chr(13),''),chr(10),'') as f55_9f37
    ,replace(replace(t.f55_82,chr(13),''),chr(10),'') as f55_82
    ,replace(replace(t.f55_9f36,chr(13),''),chr(10),'') as f55_9f36
    ,replace(replace(t.f55_9f10,chr(13),''),chr(10),'') as f55_9f10
    ,replace(replace(t.f55_5f34,chr(13),''),chr(10),'') as f55_5f34
    ,replace(replace(t.f55_5f2a,chr(13),''),chr(10),'') as f55_5f2a
    ,replace(replace(t.f55_9f26,chr(13),''),chr(10),'') as f55_9f26
    ,replace(replace(t.f55_9f02,chr(13),''),chr(10),'') as f55_9f02
    ,replace(replace(t.f55_9f03,chr(13),''),chr(10),'') as f55_9f03
    ,replace(replace(t.f55_df31,chr(13),''),chr(10),'') as f55_df31
    ,replace(replace(t.f55_91,chr(13),''),chr(10),'') as f55_91
    ,replace(replace(t.f55_72,chr(13),''),chr(10),'') as f55_72
    ,replace(replace(t.srv_src_sysid,chr(13),''),chr(10),'') as srv_src_sysid
    ,replace(replace(t.srv_dest_sysid,chr(13),''),chr(10),'') as srv_dest_sysid
    ,replace(replace(t.srv_msgid,chr(13),''),chr(10),'') as srv_msgid
    ,replace(replace(t.srv_cllpty_sysid,chr(13),''),chr(10),'') as srv_cllpty_sysid
    ,replace(replace(t.svr_glob_seqno,chr(13),''),chr(10),'') as svr_glob_seqno
    ,replace(replace(t.svr_sou_seqno,chr(13),''),chr(10),'') as svr_sou_seqno
    ,replace(replace(t.svr_sou_date,chr(13),''),chr(10),'') as svr_sou_date
    ,replace(replace(t.svr_sou_time,chr(13),''),chr(10),'') as svr_sou_time
    ,replace(replace(t.svr_src_name,chr(13),''),chr(10),'') as svr_src_name
    ,replace(replace(t.svr_src_num,chr(13),''),chr(10),'') as svr_src_num
    ,replace(replace(t.svr_src_msgt,chr(13),''),chr(10),'') as svr_src_msgt
    ,replace(replace(t.svr_src_pri,chr(13),''),chr(10),'') as svr_src_pri
    ,replace(replace(t.tell_no,chr(13),''),chr(10),'') as tell_no
    ,replace(replace(t.city_code,chr(13),''),chr(10),'') as city_code
    ,replace(replace(t.ptyid,chr(13),''),chr(10),'') as ptyid
    ,replace(replace(t.ptybrno,chr(13),''),chr(10),'') as ptybrno
    ,replace(replace(t.outnum,chr(13),''),chr(10),'') as outnum
    ,replace(replace(t.authtelid,chr(13),''),chr(10),'') as authtelid
    ,replace(replace(t.chktelid,chr(13),''),chr(10),'') as chktelid
    ,replace(replace(t.authseqno,chr(13),''),chr(10),'') as authseqno
    ,replace(replace(t.authpwd,chr(13),''),chr(10),'') as authpwd
    ,replace(replace(t.prcscd,chr(13),''),chr(10),'') as prcscd
    ,replace(replace(t.orisouseqno,chr(13),''),chr(10),'') as orisouseqno
    ,replace(replace(t.orisoudate,chr(13),''),chr(10),'') as orisoudate
    ,replace(replace(t.orisoutime,chr(13),''),chr(10),'') as orisoutime
    ,replace(replace(t.oriuppno,chr(13),''),chr(10),'') as oriuppno
    ,replace(replace(t.oriuppdate,chr(13),''),chr(10),'') as oriuppdate
    ,replace(replace(t.uppno,chr(13),''),chr(10),'') as uppno
    ,replace(replace(t.uppdate,chr(13),''),chr(10),'') as uppdate
    ,replace(replace(t.uppcode,chr(13),''),chr(10),'') as uppcode
    ,replace(replace(t.upptxt,chr(13),''),chr(10),'') as upptxt
    ,replace(replace(t.authcode,chr(13),''),chr(10),'') as authcode
    ,replace(replace(t.colddate,chr(13),''),chr(10),'') as colddate
    ,replace(replace(t.coldnum,chr(13),''),chr(10),'') as coldnum
    ,replace(replace(t.oricolddate,chr(13),''),chr(10),'') as oricolddate
    ,replace(replace(t.oricoldnum,chr(13),''),chr(10),'') as oricoldnum
    ,replace(replace(t.onlnbal,chr(13),''),chr(10),'') as onlnbal
    ,replace(replace(t.acctbal,chr(13),''),chr(10),'') as acctbal
    ,replace(replace(t.msgtype,chr(13),''),chr(10),'') as msgtype
    ,replace(replace(t.miscflag,chr(13),''),chr(10),'') as miscflag
    ,replace(replace(t.misc1,chr(13),''),chr(10),'') as misc1
    ,replace(replace(t.misc2,chr(13),''),chr(10),'') as misc2
    ,replace(replace(t.misc3,chr(13),''),chr(10),'') as misc3
    ,replace(replace(t.misc4,chr(13),''),chr(10),'') as misc4
    ,replace(replace(t.misc5,chr(13),''),chr(10),'') as misc5
    ,replace(replace(t.misc6,chr(13),''),chr(10),'') as misc6
    ,replace(replace(t.resv1,chr(13),''),chr(10),'') as resv1
    ,replace(replace(t.resv2,chr(13),''),chr(10),'') as resv2
    ,replace(replace(t.inst_date,chr(13),''),chr(10),'') as inst_date
    ,replace(replace(t.updt_date,chr(13),''),chr(10),'') as updt_date
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
from ${iol_schema}.scss_tbl_n_txn t    --小额交易流水表
where sys_date='${batch_date}' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'scss_tbl_n_txn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);