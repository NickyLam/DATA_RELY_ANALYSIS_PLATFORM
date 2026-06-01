/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_trade_record_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_trade_record_order
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_trade_record_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_trade_record_order(
    order_id varchar2(60) -- 记账交易订单记录表ID
    ,order_no varchar2(150) -- 订单号
    ,request_no varchar2(150) -- 交易请求号
    ,trade_seq_no varchar2(150) -- 交易流水号
    ,top_branch_no varchar2(60) -- 所属总行机构号
    ,trans_branch_no varchar2(30) -- 交易机构号
    ,trade_no varchar2(60) -- 记账交易号
    ,trade_attr_str varchar2(150) -- 交易属性字符串
    ,product_no varchar2(23) -- 产品号
    ,contract_id varchar2(60) -- 协议ID
    ,protocol_no varchar2(60) -- 协议号
    ,detail_id varchar2(150) -- 明细ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_amount number(18,2) -- 票面金额
    ,amount_reserve1 number(18,2) -- 扩展金额1
    ,amount_reserve2 number(18,2) -- 扩展金额2
    ,amount_reserve3 number(18,2) -- 扩展金额3
    ,recode varchar2(60) -- 接口返回码
    ,restatus varchar2(60) -- 接口返回类型
    ,remessage varchar2(300) -- 接口消息
    ,trade_date timestamp -- 交易时间
    ,is_batch_acct varchar2(3) -- 是否批次记账  1:是 0:否
    ,status varchar2(3) -- 订单请求状态 -- 0:记账失败 1:记账成功 2-记账处理中 3:冲正处理中 4:冲正成功 5:冲正失败
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 创建时间
    ,last_upd_oper_no varchar2(45) -- 最后修改操作员号
    ,acct_date varchar2(12) -- 记账日期
    ,acct_scene varchar2(750) -- 记账扩展场景
    ,extension varchar2(300) -- 参与方扩展
    ,reserve1 varchar2(150) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,reserve3 varchar2(150) -- 备注3
    ,reserve4 varchar2(150) -- 备注4
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,bank_seq_no varchar2(150) -- 银行核心记账流水号
    ,sys_code varchar2(30) -- 系统编码  BMS:票据4.0  CPES:票交所
    ,bms_draft_id varchar2(150) -- 传统票据登记表ID
    ,acct_timestamp varchar2(60) -- 记账时间戳
    ,cd_range varchar2(38) -- 子票区间
    ,cd_split varchar2(2) -- 是否允许分包流转:0-否,1-是
    ,org_draft_id varchar2(60) -- 原始票据ID
    ,split_draft_id varchar2(60) -- 实际拆前票据ID
    ,src_type varchar2(9) -- 票据来源
    ,is_busi_interface varchar2(3) -- 是否业务类核心接口：0 否 1 是
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
grant select on ${iol_schema}.bdms_bms_trade_record_order to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_trade_record_order to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_trade_record_order to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_trade_record_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_trade_record_order is '记账交易订单记录表';
comment on column ${iol_schema}.bdms_bms_trade_record_order.order_id is '记账交易订单记录表ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.order_no is '订单号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.request_no is '交易请求号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.trade_seq_no is '交易流水号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.top_branch_no is '所属总行机构号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.trans_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.trade_no is '记账交易号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.trade_attr_str is '交易属性字符串';
comment on column ${iol_schema}.bdms_bms_trade_record_order.product_no is '产品号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.protocol_no is '协议号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.detail_id is '明细ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_trade_record_order.amount_reserve1 is '扩展金额1';
comment on column ${iol_schema}.bdms_bms_trade_record_order.amount_reserve2 is '扩展金额2';
comment on column ${iol_schema}.bdms_bms_trade_record_order.amount_reserve3 is '扩展金额3';
comment on column ${iol_schema}.bdms_bms_trade_record_order.recode is '接口返回码';
comment on column ${iol_schema}.bdms_bms_trade_record_order.restatus is '接口返回类型';
comment on column ${iol_schema}.bdms_bms_trade_record_order.remessage is '接口消息';
comment on column ${iol_schema}.bdms_bms_trade_record_order.trade_date is '交易时间';
comment on column ${iol_schema}.bdms_bms_trade_record_order.is_batch_acct is '是否批次记账  1:是 0:否';
comment on column ${iol_schema}.bdms_bms_trade_record_order.status is '订单请求状态 -- 0:记账失败 1:记账成功 2-记账处理中 3:冲正处理中 4:冲正成功 5:冲正失败';
comment on column ${iol_schema}.bdms_bms_trade_record_order.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_record_order.update_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_record_order.last_upd_oper_no is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.acct_date is '记账日期';
comment on column ${iol_schema}.bdms_bms_trade_record_order.acct_scene is '记账扩展场景';
comment on column ${iol_schema}.bdms_bms_trade_record_order.extension is '参与方扩展';
comment on column ${iol_schema}.bdms_bms_trade_record_order.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_trade_record_order.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_trade_record_order.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_trade_record_order.reserve4 is '备注4';
comment on column ${iol_schema}.bdms_bms_trade_record_order.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.bank_seq_no is '银行核心记账流水号';
comment on column ${iol_schema}.bdms_bms_trade_record_order.sys_code is '系统编码  BMS:票据4.0  CPES:票交所';
comment on column ${iol_schema}.bdms_bms_trade_record_order.bms_draft_id is '传统票据登记表ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.acct_timestamp is '记账时间戳';
comment on column ${iol_schema}.bdms_bms_trade_record_order.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_trade_record_order.cd_split is '是否允许分包流转:0-否,1-是';
comment on column ${iol_schema}.bdms_bms_trade_record_order.org_draft_id is '原始票据ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.split_draft_id is '实际拆前票据ID';
comment on column ${iol_schema}.bdms_bms_trade_record_order.src_type is '票据来源';
comment on column ${iol_schema}.bdms_bms_trade_record_order.is_busi_interface is '是否业务类核心接口：0 否 1 是';
comment on column ${iol_schema}.bdms_bms_trade_record_order.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bms_trade_record_order.etl_timestamp is 'ETL处理时间戳';
