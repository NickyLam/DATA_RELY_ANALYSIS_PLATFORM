/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_e_txn_refund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_e_txn_refund
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_e_txn_refund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_txn_refund(
    sys_id varchar2(34) -- 系统流水
    ,sys_date varchar2(10) -- 系统日期
    ,trx_id varchar2(32) -- 退款流水号
    ,batch_id varchar2(32) -- 网联批次号
    ,r_p_flg varchar2(1) -- 收／付标识
    ,ori_biz_tp varchar2(8) -- 原业务种类
    ,ori_trx_id varchar2(32) -- 原交易流水号
    ,ori_dbtr_bank_id varchar2(128) -- 原付款行交易流水
    ,ori_trx_amt_d number -- 原订单金额
    ,trx_curry varchar2(20) -- 退款币种
    ,trx_amt_d number -- 退款金额
    ,pyer_acct_issr_id varchar2(28) -- 退款方账户所属机构标识
    ,pyer_acct_id varchar2(60) -- 退款方账户编号
    ,pyer_acct_tp varchar2(4) -- 退款方账户类型
    ,pyee_acct_issr_id varchar2(28) -- 收款方账户所属机构标识
    ,pyee_acct_tp varchar2(4) -- 收款方账户类型
    ,sgn_no varchar2(68) -- 收款方账户签约协议号
    ,pyee_acct_id varchar2(60) -- 收款方账户编号
    ,pyee_acct_nm varchar2(256) -- 收款方账户名称
    ,instg_acct_id varchar2(68) -- 备付金账户编号
    ,instg_acct_nm varchar2(180) -- 备付金账户名称
    ,resfd_acct_issr_id varchar2(28) -- 备付金所属机构标识
    ,trx_status varchar2(8) -- 交易状态
    ,trx_ctgy varchar2(8) -- 交易类别
    ,trx_dt_tm varchar2(20) -- 网联交易日期时间
    ,biz_sts_cd varchar2(20) -- 业务返回码
    ,biz_sts_desc varchar2(385) -- 业务返回说明
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(256) -- 系统返回说明
    ,host_id varchar2(34) -- 核心流水
    ,host_date varchar2(20) -- 核心日期
    ,host_status varchar2(20) -- 核心状态
    ,create_time date -- 创建时间
    ,update_time date -- 最后更新时间
    ,sys_type varchar2(2) -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,epcc_chk varchar2(2) -- 网联状态
    ,host_check varchar2(2) -- 核心对账状态
    ,adjust_flag varchar2(1) -- 调账标识   0-未调账 1-已调账
    ,liqu_flag varchar2(1) -- 清算标识 0-未清算 1-已清算
    ,transfer_flag varchar2(1) -- 转移标识 0-未转移 1-已转移
    ,chk_status varchar2(64) -- 对账状态
    ,chk_desc varchar2(64) -- 对账描述
    ,trans_type varchar2(64) -- 交易类型
    ,adj_mtd varchar2(2) -- 调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)
    ,biz_date varchar2(8) -- 网联平台业务时间
    ,global_seq_no varchar2(60) -- 全局流水号
    ,host_req_no varchar2(40) -- 核心请求流水号
    ,host_ret_code varchar2(13) -- 核心响应码
    ,host_ret_msg varchar2(768) -- 核心响应信息
    ,txn_date varchar2(20) -- 平台交易日期
    ,txn_time varchar2(20) -- 平台交易时间
    ,status varchar2(10) -- 状态
    ,host_revert_date date -- 核心冲正日期
    ,host_revert_id varchar2(32) -- 核心冲正流水号
    ,txn_no varchar2(30) -- 平台流水号
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
grant select on ${iol_schema}.ppps_e_txn_refund to ${iml_schema};
grant select on ${iol_schema}.ppps_e_txn_refund to ${icl_schema};
grant select on ${iol_schema}.ppps_e_txn_refund to ${idl_schema};
grant select on ${iol_schema}.ppps_e_txn_refund to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_e_txn_refund is '退款流水表';
comment on column ${iol_schema}.ppps_e_txn_refund.sys_id is '系统流水';
comment on column ${iol_schema}.ppps_e_txn_refund.sys_date is '系统日期';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_id is '退款流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.batch_id is '网联批次号';
comment on column ${iol_schema}.ppps_e_txn_refund.r_p_flg is '收／付标识';
comment on column ${iol_schema}.ppps_e_txn_refund.ori_biz_tp is '原业务种类';
comment on column ${iol_schema}.ppps_e_txn_refund.ori_trx_id is '原交易流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.ori_dbtr_bank_id is '原付款行交易流水';
comment on column ${iol_schema}.ppps_e_txn_refund.ori_trx_amt_d is '原订单金额';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_curry is '退款币种';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_amt_d is '退款金额';
comment on column ${iol_schema}.ppps_e_txn_refund.pyer_acct_issr_id is '退款方账户所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_refund.pyer_acct_id is '退款方账户编号';
comment on column ${iol_schema}.ppps_e_txn_refund.pyer_acct_tp is '退款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_refund.pyee_acct_issr_id is '收款方账户所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_refund.pyee_acct_tp is '收款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_refund.sgn_no is '收款方账户签约协议号';
comment on column ${iol_schema}.ppps_e_txn_refund.pyee_acct_id is '收款方账户编号';
comment on column ${iol_schema}.ppps_e_txn_refund.pyee_acct_nm is '收款方账户名称';
comment on column ${iol_schema}.ppps_e_txn_refund.instg_acct_id is '备付金账户编号';
comment on column ${iol_schema}.ppps_e_txn_refund.instg_acct_nm is '备付金账户名称';
comment on column ${iol_schema}.ppps_e_txn_refund.resfd_acct_issr_id is '备付金所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_status is '交易状态';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_ctgy is '交易类别';
comment on column ${iol_schema}.ppps_e_txn_refund.trx_dt_tm is '网联交易日期时间';
comment on column ${iol_schema}.ppps_e_txn_refund.biz_sts_cd is '业务返回码';
comment on column ${iol_schema}.ppps_e_txn_refund.biz_sts_desc is '业务返回说明';
comment on column ${iol_schema}.ppps_e_txn_refund.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_e_txn_refund.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_e_txn_refund.host_id is '核心流水';
comment on column ${iol_schema}.ppps_e_txn_refund.host_date is '核心日期';
comment on column ${iol_schema}.ppps_e_txn_refund.host_status is '核心状态';
comment on column ${iol_schema}.ppps_e_txn_refund.create_time is '创建时间';
comment on column ${iol_schema}.ppps_e_txn_refund.update_time is '最后更新时间';
comment on column ${iol_schema}.ppps_e_txn_refund.sys_type is '系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心';
comment on column ${iol_schema}.ppps_e_txn_refund.epcc_chk is '网联状态';
comment on column ${iol_schema}.ppps_e_txn_refund.host_check is '核心对账状态';
comment on column ${iol_schema}.ppps_e_txn_refund.adjust_flag is '调账标识   0-未调账 1-已调账';
comment on column ${iol_schema}.ppps_e_txn_refund.liqu_flag is '清算标识 0-未清算 1-已清算';
comment on column ${iol_schema}.ppps_e_txn_refund.transfer_flag is '转移标识 0-未转移 1-已转移';
comment on column ${iol_schema}.ppps_e_txn_refund.chk_status is '对账状态';
comment on column ${iol_schema}.ppps_e_txn_refund.chk_desc is '对账描述';
comment on column ${iol_schema}.ppps_e_txn_refund.trans_type is '交易类型';
comment on column ${iol_schema}.ppps_e_txn_refund.adj_mtd is '调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)';
comment on column ${iol_schema}.ppps_e_txn_refund.biz_date is '网联平台业务时间';
comment on column ${iol_schema}.ppps_e_txn_refund.global_seq_no is '全局流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.host_req_no is '核心请求流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.host_ret_code is '核心响应码';
comment on column ${iol_schema}.ppps_e_txn_refund.host_ret_msg is '核心响应信息';
comment on column ${iol_schema}.ppps_e_txn_refund.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_e_txn_refund.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_e_txn_refund.status is '状态';
comment on column ${iol_schema}.ppps_e_txn_refund.host_revert_date is '核心冲正日期';
comment on column ${iol_schema}.ppps_e_txn_refund.host_revert_id is '核心冲正流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.txn_no is '平台流水号';
comment on column ${iol_schema}.ppps_e_txn_refund.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_e_txn_refund.etl_timestamp is 'ETL处理时间戳';
