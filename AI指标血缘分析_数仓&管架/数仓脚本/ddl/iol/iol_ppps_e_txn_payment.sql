/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_e_txn_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_e_txn_payment
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_e_txn_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_txn_payment(
    chnl_no varchar2(8) -- 渠道号标识
    ,tran_no varchar2(64) -- 渠道交易流水号
    ,sys_id varchar2(34) -- 系统流水
    ,sys_date varchar2(10) -- 交易日期
    ,trx_id varchar2(32) -- 交易流水号
    ,batch_id varchar2(60) -- 网联批次号
    ,r_p_flg varchar2(10) -- 收／付标识
    ,trx_curry varchar2(20) -- 交易币种
    ,trx_amt_d number -- 交易金额
    ,trx_ctgy varchar2(20) -- 交易类别
    ,biz_tp varchar2(8) -- 业务种类
    ,pyer_bk_no varchar2(40) -- 备付金账户编号
    ,pyer_bk_nm varchar2(180) -- 备付金账户名称
    ,pyer_bk_id varchar2(28) -- 备付金所属机构标识
    ,pyer_acct_issr_id varchar2(28) -- 付款方账户所属标识
    ,pyer_acct_tp varchar2(4) -- 付款方账户类型
    ,pyer_acct_no_de varchar2(60) -- 付款方账号
    ,pyer_acct_nm_de varchar2(256) -- 付款方名称
    ,pyer_mrchnt_no varchar2(68) -- 付款商户编号
    ,pyer_mrchnt_nm varchar2(256) -- 付款商户名称
    ,pyer_mrchnt_shrt_nm varchar2(60) -- 付款商户简称
    ,pyee_acct_tp varchar2(4) -- 收款方账户类型
    ,pyee_bk_id varchar2(28) -- 收款方账户所属标识
    ,pyee_bk_no_de varchar2(60) -- 收款方账号
    ,pyee_bk_nm_de varchar2(256) -- 收款方名称
    ,pyee_sgn_no varchar2(68) -- 收款方协议编号
    ,cdtr_bank_id varchar2(128) -- 收款方交易流水号
    ,trx_status varchar2(8) -- 交易状态
    ,trx_dt_tm varchar2(20) -- 交易日期时间
    ,biz_sts_cd varchar2(20) -- 业务返回码
    ,biz_sts_desc varchar2(385) -- 业务返回说明
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(256) -- 系统返回说明
    ,host_id varchar2(34) -- 核心流水
    ,host_date varchar2(20) -- 核心日期
    ,host_revert_id varchar2(32) -- 冲正流水
    ,host_revert_date varchar2(10) -- 冲正日期
    ,host_status varchar2(16) -- 核心状态
    ,trx_smmry varchar2(192) -- 交易摘要
    ,trx_prps varchar2(8) -- 交易用途
    ,sys_type varchar2(2) -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,epcc_chk varchar2(2) -- 网联对账状态
    ,host_check varchar2(2) -- 核心对账状态
    ,adjust_flag varchar2(1) -- 调账标识   0-未调账 1-已调账
    ,liqu_flag varchar2(1) -- 清算标识 0-未清算 1-已清算
    ,transfer_flag varchar2(1) -- 转移标识 0-未转移 1-已转移
    ,chk_status varchar2(64) -- 对账状态
    ,chk_desc varchar2(64) -- 对账描述
    ,trans_type varchar2(64) -- 交易类型
    ,adj_mtd varchar2(2) -- 调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)
    ,trx_ustrd varchar2(1920) -- 交易备注
    ,trx_trm_tp varchar2(2) -- 交易终端类型
    ,trx_trm_no varchar2(64) -- 交易终端编码
    ,trx_devc_info varchar2(380) -- 交易设备信息
    ,create_time date -- 创建时间
    ,update_time date -- 最后更新时间
    ,src_zone varchar2(10) -- 原渠道编码
    ,biz_date varchar2(8) -- 
    ,txn_no varchar2(30) -- 平台交易流水号
    ,txn_date varchar2(20) -- 平台交易日期
    ,txn_time varchar2(20) -- 平台交易时间
    ,status varchar2(10) -- 状态
    ,global_seq_no varchar2(60) -- 
    ,host_req_no varchar2(40) -- 核心请求流水号
    ,host_ret_code varchar2(10) -- 核心响应码
    ,host_ret_msg varchar2(768) -- 核心响应信息
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
grant select on ${iol_schema}.ppps_e_txn_payment to ${iml_schema};
grant select on ${iol_schema}.ppps_e_txn_payment to ${icl_schema};
grant select on ${iol_schema}.ppps_e_txn_payment to ${idl_schema};
grant select on ${iol_schema}.ppps_e_txn_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_e_txn_payment is '付款流水表';
comment on column ${iol_schema}.ppps_e_txn_payment.chnl_no is '渠道号标识';
comment on column ${iol_schema}.ppps_e_txn_payment.tran_no is '渠道交易流水号';
comment on column ${iol_schema}.ppps_e_txn_payment.sys_id is '系统流水';
comment on column ${iol_schema}.ppps_e_txn_payment.sys_date is '交易日期';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_id is '交易流水号';
comment on column ${iol_schema}.ppps_e_txn_payment.batch_id is '网联批次号';
comment on column ${iol_schema}.ppps_e_txn_payment.r_p_flg is '收／付标识';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_curry is '交易币种';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_amt_d is '交易金额';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_ctgy is '交易类别';
comment on column ${iol_schema}.ppps_e_txn_payment.biz_tp is '业务种类';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_bk_no is '备付金账户编号';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_bk_nm is '备付金账户名称';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_bk_id is '备付金所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_acct_issr_id is '付款方账户所属标识';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_acct_tp is '付款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_acct_no_de is '付款方账号';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_acct_nm_de is '付款方名称';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_mrchnt_no is '付款商户编号';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_mrchnt_nm is '付款商户名称';
comment on column ${iol_schema}.ppps_e_txn_payment.pyer_mrchnt_shrt_nm is '付款商户简称';
comment on column ${iol_schema}.ppps_e_txn_payment.pyee_acct_tp is '收款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_payment.pyee_bk_id is '收款方账户所属标识';
comment on column ${iol_schema}.ppps_e_txn_payment.pyee_bk_no_de is '收款方账号';
comment on column ${iol_schema}.ppps_e_txn_payment.pyee_bk_nm_de is '收款方名称';
comment on column ${iol_schema}.ppps_e_txn_payment.pyee_sgn_no is '收款方协议编号';
comment on column ${iol_schema}.ppps_e_txn_payment.cdtr_bank_id is '收款方交易流水号';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_status is '交易状态';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_dt_tm is '交易日期时间';
comment on column ${iol_schema}.ppps_e_txn_payment.biz_sts_cd is '业务返回码';
comment on column ${iol_schema}.ppps_e_txn_payment.biz_sts_desc is '业务返回说明';
comment on column ${iol_schema}.ppps_e_txn_payment.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_e_txn_payment.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_e_txn_payment.host_id is '核心流水';
comment on column ${iol_schema}.ppps_e_txn_payment.host_date is '核心日期';
comment on column ${iol_schema}.ppps_e_txn_payment.host_revert_id is '冲正流水';
comment on column ${iol_schema}.ppps_e_txn_payment.host_revert_date is '冲正日期';
comment on column ${iol_schema}.ppps_e_txn_payment.host_status is '核心状态';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_smmry is '交易摘要';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_prps is '交易用途';
comment on column ${iol_schema}.ppps_e_txn_payment.sys_type is '系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心';
comment on column ${iol_schema}.ppps_e_txn_payment.epcc_chk is '网联对账状态';
comment on column ${iol_schema}.ppps_e_txn_payment.host_check is '核心对账状态';
comment on column ${iol_schema}.ppps_e_txn_payment.adjust_flag is '调账标识   0-未调账 1-已调账';
comment on column ${iol_schema}.ppps_e_txn_payment.liqu_flag is '清算标识 0-未清算 1-已清算';
comment on column ${iol_schema}.ppps_e_txn_payment.transfer_flag is '转移标识 0-未转移 1-已转移';
comment on column ${iol_schema}.ppps_e_txn_payment.chk_status is '对账状态';
comment on column ${iol_schema}.ppps_e_txn_payment.chk_desc is '对账描述';
comment on column ${iol_schema}.ppps_e_txn_payment.trans_type is '交易类型';
comment on column ${iol_schema}.ppps_e_txn_payment.adj_mtd is '调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_ustrd is '交易备注';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_trm_tp is '交易终端类型';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_trm_no is '交易终端编码';
comment on column ${iol_schema}.ppps_e_txn_payment.trx_devc_info is '交易设备信息';
comment on column ${iol_schema}.ppps_e_txn_payment.create_time is '创建时间';
comment on column ${iol_schema}.ppps_e_txn_payment.update_time is '最后更新时间';
comment on column ${iol_schema}.ppps_e_txn_payment.src_zone is '原渠道编码';
comment on column ${iol_schema}.ppps_e_txn_payment.biz_date is '';
comment on column ${iol_schema}.ppps_e_txn_payment.txn_no is '平台交易流水号';
comment on column ${iol_schema}.ppps_e_txn_payment.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_e_txn_payment.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_e_txn_payment.status is '状态';
comment on column ${iol_schema}.ppps_e_txn_payment.global_seq_no is '';
comment on column ${iol_schema}.ppps_e_txn_payment.host_req_no is '核心请求流水号';
comment on column ${iol_schema}.ppps_e_txn_payment.host_ret_code is '核心响应码';
comment on column ${iol_schema}.ppps_e_txn_payment.host_ret_msg is '核心响应信息';
comment on column ${iol_schema}.ppps_e_txn_payment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_e_txn_payment.etl_timestamp is 'ETL处理时间戳';
