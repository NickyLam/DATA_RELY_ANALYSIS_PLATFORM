/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_e_txn_collection
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_e_txn_collection
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_e_txn_collection purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_txn_collection(
    sys_id varchar2(34) -- 系统流水
    ,sys_date varchar2(10) -- 交易日期
    ,trx_id varchar2(32) -- 交易流水号
    ,batch_id varchar2(32) -- 网联批次号
    ,r_p_flg varchar2(10) -- 收／付标识
    ,trx_curry varchar2(20) -- 交易币种
    ,trx_amt_d number -- 交易金额
    ,trx_ctgy varchar2(20) -- 交易类别
    ,biz_tp varchar2(16) -- 业务种类
    ,pyer_acct_issr_id varchar2(28) -- 付款方账户所属标识
    ,pyer_acct_tp varchar2(4) -- 付款方账户类型
    ,sgn_no varchar2(68) -- 付款方协议号
    ,pyer_acct_no varchar2(60) -- 付款方账号
    ,pyer_acct_nm varchar2(256) -- 付款方名称
    ,pyee_acct_issr_id varchar2(28) -- 收款方账户所属标识
    ,pyee_acct_tp varchar2(4) -- 收款方账户类型
    ,pyee_acct_id varchar2(60) -- 收款方账号
    ,pyee_nm varchar2(256) -- 收款方名称
    ,instg_acct_id varchar2(68) -- 备付金账户编号
    ,instg_acct_nm varchar2(180) -- 备付金账户名称
    ,resfd_acct_issr_id varchar2(28) -- 备付金所属机构标识
    ,trx_status varchar2(8) -- 交易状态
    ,trx_dt_tm varchar2(20) -- 交易日期时间
    ,biz_sts_cd varchar2(20) -- 业务返回码
    ,biz_sts_desc varchar2(385) -- 业务返回说明
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(256) -- 系统返回说明
    ,host_id varchar2(34) -- 核心流水
    ,host_date varchar2(20) -- 核心日期
    ,host_revert_id varchar2(34) -- 冲正流水
    ,host_revert_date varchar2(10) -- 冲正日期
    ,host_status varchar2(15) -- 核心状态
    ,repayment_amt_d number -- 已退款金额
    ,repayment_cnt number(11) -- 已退款次数
    ,create_time date -- 创建时间
    ,update_time date -- 最后更新时间
    ,ordr_id varchar2(40) -- 订单编码
    ,ordr_desc varchar2(1850) -- 订单详情
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
    ,txn_no varchar2(30) -- 平台交易流水号
    ,txn_date varchar2(20) -- 平台交易日期
    ,txn_time varchar2(20) -- 平台交易时间
    ,status varchar2(10) -- 状态
    ,biz_date varchar2(8) -- 网联平台业务时间
    ,global_seq_no varchar2(60) -- 全局流水号
    ,host_req_no varchar2(40) -- 核心请求流水号
    ,host_ret_code varchar2(13) -- 核心响应码
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
grant select on ${iol_schema}.ppps_e_txn_collection to ${iml_schema};
grant select on ${iol_schema}.ppps_e_txn_collection to ${icl_schema};
grant select on ${iol_schema}.ppps_e_txn_collection to ${idl_schema};
grant select on ${iol_schema}.ppps_e_txn_collection to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_e_txn_collection is '协议支付流水表';
comment on column ${iol_schema}.ppps_e_txn_collection.sys_id is '系统流水';
comment on column ${iol_schema}.ppps_e_txn_collection.sys_date is '交易日期';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_id is '交易流水号';
comment on column ${iol_schema}.ppps_e_txn_collection.batch_id is '网联批次号';
comment on column ${iol_schema}.ppps_e_txn_collection.r_p_flg is '收／付标识';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_curry is '交易币种';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_amt_d is '交易金额';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_ctgy is '交易类别';
comment on column ${iol_schema}.ppps_e_txn_collection.biz_tp is '业务种类';
comment on column ${iol_schema}.ppps_e_txn_collection.pyer_acct_issr_id is '付款方账户所属标识';
comment on column ${iol_schema}.ppps_e_txn_collection.pyer_acct_tp is '付款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_collection.sgn_no is '付款方协议号';
comment on column ${iol_schema}.ppps_e_txn_collection.pyer_acct_no is '付款方账号';
comment on column ${iol_schema}.ppps_e_txn_collection.pyer_acct_nm is '付款方名称';
comment on column ${iol_schema}.ppps_e_txn_collection.pyee_acct_issr_id is '收款方账户所属标识';
comment on column ${iol_schema}.ppps_e_txn_collection.pyee_acct_tp is '收款方账户类型';
comment on column ${iol_schema}.ppps_e_txn_collection.pyee_acct_id is '收款方账号';
comment on column ${iol_schema}.ppps_e_txn_collection.pyee_nm is '收款方名称';
comment on column ${iol_schema}.ppps_e_txn_collection.instg_acct_id is '备付金账户编号';
comment on column ${iol_schema}.ppps_e_txn_collection.instg_acct_nm is '备付金账户名称';
comment on column ${iol_schema}.ppps_e_txn_collection.resfd_acct_issr_id is '备付金所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_status is '交易状态';
comment on column ${iol_schema}.ppps_e_txn_collection.trx_dt_tm is '交易日期时间';
comment on column ${iol_schema}.ppps_e_txn_collection.biz_sts_cd is '业务返回码';
comment on column ${iol_schema}.ppps_e_txn_collection.biz_sts_desc is '业务返回说明';
comment on column ${iol_schema}.ppps_e_txn_collection.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_e_txn_collection.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_e_txn_collection.host_id is '核心流水';
comment on column ${iol_schema}.ppps_e_txn_collection.host_date is '核心日期';
comment on column ${iol_schema}.ppps_e_txn_collection.host_revert_id is '冲正流水';
comment on column ${iol_schema}.ppps_e_txn_collection.host_revert_date is '冲正日期';
comment on column ${iol_schema}.ppps_e_txn_collection.host_status is '核心状态';
comment on column ${iol_schema}.ppps_e_txn_collection.repayment_amt_d is '已退款金额';
comment on column ${iol_schema}.ppps_e_txn_collection.repayment_cnt is '已退款次数';
comment on column ${iol_schema}.ppps_e_txn_collection.create_time is '创建时间';
comment on column ${iol_schema}.ppps_e_txn_collection.update_time is '最后更新时间';
comment on column ${iol_schema}.ppps_e_txn_collection.ordr_id is '订单编码';
comment on column ${iol_schema}.ppps_e_txn_collection.ordr_desc is '订单详情';
comment on column ${iol_schema}.ppps_e_txn_collection.sys_type is '系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心';
comment on column ${iol_schema}.ppps_e_txn_collection.epcc_chk is '网联对账状态';
comment on column ${iol_schema}.ppps_e_txn_collection.host_check is '核心对账状态';
comment on column ${iol_schema}.ppps_e_txn_collection.adjust_flag is '调账标识   0-未调账 1-已调账';
comment on column ${iol_schema}.ppps_e_txn_collection.liqu_flag is '清算标识 0-未清算 1-已清算';
comment on column ${iol_schema}.ppps_e_txn_collection.transfer_flag is '转移标识 0-未转移 1-已转移';
comment on column ${iol_schema}.ppps_e_txn_collection.chk_status is '对账状态';
comment on column ${iol_schema}.ppps_e_txn_collection.chk_desc is '对账描述';
comment on column ${iol_schema}.ppps_e_txn_collection.trans_type is '交易类型';
comment on column ${iol_schema}.ppps_e_txn_collection.adj_mtd is '调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)';
comment on column ${iol_schema}.ppps_e_txn_collection.txn_no is '平台交易流水号';
comment on column ${iol_schema}.ppps_e_txn_collection.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_e_txn_collection.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_e_txn_collection.status is '状态';
comment on column ${iol_schema}.ppps_e_txn_collection.biz_date is '网联平台业务时间';
comment on column ${iol_schema}.ppps_e_txn_collection.global_seq_no is '全局流水号';
comment on column ${iol_schema}.ppps_e_txn_collection.host_req_no is '核心请求流水号';
comment on column ${iol_schema}.ppps_e_txn_collection.host_ret_code is '核心响应码';
comment on column ${iol_schema}.ppps_e_txn_collection.host_ret_msg is '核心响应信息';
comment on column ${iol_schema}.ppps_e_txn_collection.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_e_txn_collection.etl_timestamp is 'ETL处理时间戳';
