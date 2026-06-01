/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_trade_draft
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_trade_draft
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_trade_draft purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_trade_draft(
    trade_draft_id varchar2(60) -- 记账票据信息表ID
    ,top_branch_no varchar2(60) -- 所属总行机构号
    ,trans_branch_no varchar2(30) -- 交易机构号
    ,trade_no varchar2(60) -- 记账交易号
    ,trade_attr_str varchar2(150) -- 交易属性字符串
    ,product_no varchar2(23) -- 产品号
    ,in_product_no varchar2(23) -- 买入时产品号
    ,contract_id varchar2(60) -- 协议ID
    ,protocol_no varchar2(60) -- 协议号
    ,detail_id varchar2(60) -- 业务明细ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,draft_attr varchar2(6) -- 票据属性： 1 纸票 2 电票
    ,payment_date varchar2(12) -- 计息到期日
    ,payment_days number(22,0) -- 计息天数
    ,interest number(16,2) -- 利息
    ,adjust_interest number(16,2) -- 调整后利息
    ,draft_amount number(18,2) -- 票面金额
    ,payer_amount number(16,2) -- 买方付息金额
    ,real_amount number(16,2) -- 实收金额
    ,pay_amount number(16,2) -- 实付金额
    ,charge number(16,2) -- 手续费
    ,expenses number(16,2) -- 工本费
    ,amount_reserve1 number(16,2) -- 扩展金额1
    ,amount_reserve2 number(16,2) -- 扩展金额2
    ,amount_reserve3 number(16,2) -- 扩展金额3
    ,request_no varchar2(150) -- 交易请求号
    ,trade_seq_no varchar2(150) -- 交易流水号
    ,recode varchar2(60) -- 接口返回码
    ,restatus varchar2(60) -- 接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中
    ,remessage varchar2(300) -- 接口消息
    ,status varchar2(3) -- 记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 创建时间
    ,last_upd_oper_no varchar2(45) -- 最后修改操作员号
    ,draft_reserve1 varchar2(150) -- 备注1
    ,draft_reserve2 varchar2(150) -- 备注2
    ,draft_reserve3 varchar2(150) -- 备注3
    ,acct_date varchar2(12) -- 会计日期
    ,trans_id varchar2(60) -- 登记中心TRANS_ID
    ,bank_seq_no varchar2(150) -- 银行核心记账流水号
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,bms_draft_id varchar2(60) -- 原票据系统的登记中心ID
    ,cd_range varchar2(38) -- 子票区间
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,org_draft_id varchar2(60) -- 原始票据ID
    ,split_draft_id varchar2(60) -- 实际拆前票据ID
    ,src_type varchar2(60) -- 
    ,maturity_date varchar2(60) -- 
    ,settle_status varchar2(60) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_bms_trade_draft to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_trade_draft to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_trade_draft to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_trade_draft to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_trade_draft is '记账票据信息';
comment on column ${iol_schema}.bdms_bms_trade_draft.trade_draft_id is '记账票据信息表ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.top_branch_no is '所属总行机构号';
comment on column ${iol_schema}.bdms_bms_trade_draft.trans_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_bms_trade_draft.trade_no is '记账交易号';
comment on column ${iol_schema}.bdms_bms_trade_draft.trade_attr_str is '交易属性字符串';
comment on column ${iol_schema}.bdms_bms_trade_draft.product_no is '产品号';
comment on column ${iol_schema}.bdms_bms_trade_draft.in_product_no is '买入时产品号';
comment on column ${iol_schema}.bdms_bms_trade_draft.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.protocol_no is '协议号';
comment on column ${iol_schema}.bdms_bms_trade_draft.detail_id is '业务明细ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_trade_draft.payment_date is '计息到期日';
comment on column ${iol_schema}.bdms_bms_trade_draft.payment_days is '计息天数';
comment on column ${iol_schema}.bdms_bms_trade_draft.interest is '利息';
comment on column ${iol_schema}.bdms_bms_trade_draft.adjust_interest is '调整后利息';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_trade_draft.payer_amount is '买方付息金额';
comment on column ${iol_schema}.bdms_bms_trade_draft.real_amount is '实收金额';
comment on column ${iol_schema}.bdms_bms_trade_draft.pay_amount is '实付金额';
comment on column ${iol_schema}.bdms_bms_trade_draft.charge is '手续费';
comment on column ${iol_schema}.bdms_bms_trade_draft.expenses is '工本费';
comment on column ${iol_schema}.bdms_bms_trade_draft.amount_reserve1 is '扩展金额1';
comment on column ${iol_schema}.bdms_bms_trade_draft.amount_reserve2 is '扩展金额2';
comment on column ${iol_schema}.bdms_bms_trade_draft.amount_reserve3 is '扩展金额3';
comment on column ${iol_schema}.bdms_bms_trade_draft.request_no is '交易请求号';
comment on column ${iol_schema}.bdms_bms_trade_draft.trade_seq_no is '交易流水号';
comment on column ${iol_schema}.bdms_bms_trade_draft.recode is '接口返回码';
comment on column ${iol_schema}.bdms_bms_trade_draft.restatus is '接口返回类型： SUCCESS 成功 FAIL 失败 PROCESS 处理中';
comment on column ${iol_schema}.bdms_bms_trade_draft.remessage is '接口消息';
comment on column ${iol_schema}.bdms_bms_trade_draft.status is '记账状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败';
comment on column ${iol_schema}.bdms_bms_trade_draft.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_draft.update_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_draft.last_upd_oper_no is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_trade_draft.draft_reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_trade_draft.acct_date is '会计日期';
comment on column ${iol_schema}.bdms_bms_trade_draft.trans_id is '登记中心TRANS_ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.bank_seq_no is '银行核心记账流水号';
comment on column ${iol_schema}.bdms_bms_trade_draft.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_trade_draft.bms_draft_id is '原票据系统的登记中心ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_trade_draft.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_trade_draft.org_draft_id is '原始票据ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.split_draft_id is '实际拆前票据ID';
comment on column ${iol_schema}.bdms_bms_trade_draft.src_type is '';
comment on column ${iol_schema}.bdms_bms_trade_draft.maturity_date is '';
comment on column ${iol_schema}.bdms_bms_trade_draft.settle_status is '';
comment on column ${iol_schema}.bdms_bms_trade_draft.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_trade_draft.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_trade_draft.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_trade_draft.etl_timestamp is 'ETL处理时间戳';
