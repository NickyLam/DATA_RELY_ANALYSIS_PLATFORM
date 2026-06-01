/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_trade_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_trade_detail
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_trade_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_trade_detail(
    trade_detail_id varchar2(60) -- 记账交易订单记录表ID
    ,top_bank_no varchar2(60) -- 所属总行行号
    ,trans_branch_no varchar2(18) -- 交易机构编号
    ,trade_no varchar2(60) -- 记账交易号
    ,trade_attr_str varchar2(150) -- 交易属性字符串
    ,product_no varchar2(23) -- 产品号
    ,contract_id varchar2(60) -- 协议ID
    ,protocol_no varchar2(60) -- 协议号
    ,detail_id varchar2(150) -- 明细ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_amount number(18,2) -- 票面金额
    ,code_no varchar2(3) -- 分录顺序号
    ,take varchar2(75) -- 取值字段
    ,dr_cr varchar2(12) -- 借代方向： D 借 C 贷 R 收 P 付
    ,party_role varchar2(60) -- 参与方角色
    ,amount number(18,2) -- 参与方金额
    ,flag varchar2(3) -- 分录标识
    ,sub_no varchar2(60) -- 科目号
    ,name varchar2(150) -- 科目名称
    ,customer_id varchar2(150) -- 客户号
    ,account_no varchar2(150) -- 目标账户号
    ,account_type varchar2(60) -- 参与方账户类型
    ,inst_code varchar2(45) -- 机构编码
    ,party_type varchar2(30) -- 参与方类型
    ,extension varchar2(300) -- 参与方扩展
    ,amount_reserve1 number(18,2) -- 扩展金额1
    ,amount_reserve2 number(18,2) -- 扩展金额2
    ,amount_reserve3 number(18,2) -- 扩展金额3
    ,is_batch_acct varchar2(3) -- 是否批次记账： 1 是 0 否
    ,status varchar2(3) -- 明细状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 创建时间
    ,last_upd_oper_no varchar2(45) -- 最后修改操作员号
    ,reserve1 varchar2(150) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,reserve3 varchar2(150) -- 备注3
    ,reserve4 varchar2(150) -- 备注4
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,bms_draft_id varchar2(60) -- 原票据系统的登记中心ID
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,cd_range varchar2(38) -- 子票区间
    ,maturity_date varchar2(12) -- 
    ,settle_status varchar2(6) -- 
    ,src_type varchar2(9) -- 鏉ユ簮
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
grant select on ${iol_schema}.bdms_bms_trade_detail to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_trade_detail to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_trade_detail to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_trade_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_trade_detail is '记账分录明细表';
comment on column ${iol_schema}.bdms_bms_trade_detail.trade_detail_id is '记账交易订单记录表ID';
comment on column ${iol_schema}.bdms_bms_trade_detail.top_bank_no is '所属总行行号';
comment on column ${iol_schema}.bdms_bms_trade_detail.trans_branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_bms_trade_detail.trade_no is '记账交易号';
comment on column ${iol_schema}.bdms_bms_trade_detail.trade_attr_str is '交易属性字符串';
comment on column ${iol_schema}.bdms_bms_trade_detail.product_no is '产品号';
comment on column ${iol_schema}.bdms_bms_trade_detail.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_trade_detail.protocol_no is '协议号';
comment on column ${iol_schema}.bdms_bms_trade_detail.detail_id is '明细ID';
comment on column ${iol_schema}.bdms_bms_trade_detail.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_trade_detail.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_trade_detail.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_trade_detail.code_no is '分录顺序号';
comment on column ${iol_schema}.bdms_bms_trade_detail.take is '取值字段';
comment on column ${iol_schema}.bdms_bms_trade_detail.dr_cr is '借代方向： D 借 C 贷 R 收 P 付';
comment on column ${iol_schema}.bdms_bms_trade_detail.party_role is '参与方角色';
comment on column ${iol_schema}.bdms_bms_trade_detail.amount is '参与方金额';
comment on column ${iol_schema}.bdms_bms_trade_detail.flag is '分录标识';
comment on column ${iol_schema}.bdms_bms_trade_detail.sub_no is '科目号';
comment on column ${iol_schema}.bdms_bms_trade_detail.name is '科目名称';
comment on column ${iol_schema}.bdms_bms_trade_detail.customer_id is '客户号';
comment on column ${iol_schema}.bdms_bms_trade_detail.account_no is '目标账户号';
comment on column ${iol_schema}.bdms_bms_trade_detail.account_type is '参与方账户类型';
comment on column ${iol_schema}.bdms_bms_trade_detail.inst_code is '机构编码';
comment on column ${iol_schema}.bdms_bms_trade_detail.party_type is '参与方类型';
comment on column ${iol_schema}.bdms_bms_trade_detail.extension is '参与方扩展';
comment on column ${iol_schema}.bdms_bms_trade_detail.amount_reserve1 is '扩展金额1';
comment on column ${iol_schema}.bdms_bms_trade_detail.amount_reserve2 is '扩展金额2';
comment on column ${iol_schema}.bdms_bms_trade_detail.amount_reserve3 is '扩展金额3';
comment on column ${iol_schema}.bdms_bms_trade_detail.is_batch_acct is '是否批次记账： 1 是 0 否';
comment on column ${iol_schema}.bdms_bms_trade_detail.status is '明细状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败';
comment on column ${iol_schema}.bdms_bms_trade_detail.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_detail.update_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_trade_detail.last_upd_oper_no is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_trade_detail.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_trade_detail.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_trade_detail.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_trade_detail.reserve4 is '备注4';
comment on column ${iol_schema}.bdms_bms_trade_detail.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_trade_detail.bms_draft_id is '原票据系统的登记中心ID';
comment on column ${iol_schema}.bdms_bms_trade_detail.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_trade_detail.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_trade_detail.maturity_date is '';
comment on column ${iol_schema}.bdms_bms_trade_detail.settle_status is '';
comment on column ${iol_schema}.bdms_bms_trade_detail.src_type is '鏉ユ簮';
comment on column ${iol_schema}.bdms_bms_trade_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bms_trade_detail.etl_timestamp is 'ETL处理时间戳';
