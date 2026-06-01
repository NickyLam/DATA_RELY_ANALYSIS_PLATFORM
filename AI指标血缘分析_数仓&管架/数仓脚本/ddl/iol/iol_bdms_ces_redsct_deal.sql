/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_ces_redsct_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_ces_redsct_deal
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_ces_redsct_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_ces_redsct_deal(
    id varchar2(60) -- ID
    ,dealed_no varchar2(24) -- 成交单编号
    ,busi_type varchar2(8) -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,quote_no varchar2(26) -- 报价单编号
    ,buss_contract_id varchar2(60) -- 业务批次表ID
    ,trade_type varchar2(6) -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,trade_date varchar2(12) -- 成交日期
    ,trade_time varchar2(21) -- 成交时间
    ,trade_status varchar2(6) -- 成交状态： DS01 已成交 DS02 已撤销
    ,settle_status varchar2(6) -- 清算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,due_settle_status varchar2(6) -- 到期结算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,approve_result varchar2(6) -- 审批结果： SU00 同意 SU01 拒绝
    ,brh_no varchar2(14) -- 机构代码
    ,product_no varchar2(14) -- 非法人产品
    ,trader_id varchar2(15) -- 交易员ID
    ,cfm_trader_id varchar2(15) -- 确认人ID
    ,pbc_brh_no varchar2(14) -- 人行机构代码
    ,acpt_user_id varchar2(15) -- 人行机构受理人用户ID
    ,acpt_user_name varchar2(150) -- 人行机构受理人名称
    ,acpt_user_note varchar2(450) -- 受理审核人审批意见
    ,complete_user_id varchar2(15) -- 人行机构复核人用户ID
    ,complete_user_name varchar2(150) -- 人行机构复核人名称
    ,complete_user_note varchar2(450) -- 复核人审批意见
    ,approval_user_id varchar2(15) -- 人行机构审批人用户ID
    ,approval_user_name varchar2(150) -- 人行机构审批人名称
    ,approval_user_note varchar2(450) -- 审批人审批意见
    ,quote_status varchar2(6) -- 报价单状态： QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常
    ,lock_flag varchar2(2) -- 锁定标识： 0 否 1 是
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_ces_redsct_deal to ${iml_schema};
grant select on ${iol_schema}.bdms_ces_redsct_deal to ${icl_schema};
grant select on ${iol_schema}.bdms_ces_redsct_deal to ${idl_schema};
grant select on ${iol_schema}.bdms_ces_redsct_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_ces_redsct_deal is '再贴现成交单信息表';
comment on column ${iol_schema}.bdms_ces_redsct_deal.id is 'ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_ces_redsct_deal.busi_type is '业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断';
comment on column ${iol_schema}.bdms_ces_redsct_deal.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_ces_redsct_deal.buss_contract_id is '业务批次表ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.trade_type is '成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交';
comment on column ${iol_schema}.bdms_ces_redsct_deal.trade_date is '成交日期';
comment on column ${iol_schema}.bdms_ces_redsct_deal.trade_time is '成交时间';
comment on column ${iol_schema}.bdms_ces_redsct_deal.trade_status is '成交状态： DS01 已成交 DS02 已撤销';
comment on column ${iol_schema}.bdms_ces_redsct_deal.settle_status is '清算状态： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_ces_redsct_deal.due_settle_status is '到期结算状态： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_ces_redsct_deal.approve_result is '审批结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_ces_redsct_deal.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_ces_redsct_deal.product_no is '非法人产品';
comment on column ${iol_schema}.bdms_ces_redsct_deal.trader_id is '交易员ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.cfm_trader_id is '确认人ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.pbc_brh_no is '人行机构代码';
comment on column ${iol_schema}.bdms_ces_redsct_deal.acpt_user_id is '人行机构受理人用户ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.acpt_user_name is '人行机构受理人名称';
comment on column ${iol_schema}.bdms_ces_redsct_deal.acpt_user_note is '受理审核人审批意见';
comment on column ${iol_schema}.bdms_ces_redsct_deal.complete_user_id is '人行机构复核人用户ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.complete_user_name is '人行机构复核人名称';
comment on column ${iol_schema}.bdms_ces_redsct_deal.complete_user_note is '复核人审批意见';
comment on column ${iol_schema}.bdms_ces_redsct_deal.approval_user_id is '人行机构审批人用户ID';
comment on column ${iol_schema}.bdms_ces_redsct_deal.approval_user_name is '人行机构审批人名称';
comment on column ${iol_schema}.bdms_ces_redsct_deal.approval_user_note is '审批人审批意见';
comment on column ${iol_schema}.bdms_ces_redsct_deal.quote_status is '报价单状态： QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常';
comment on column ${iol_schema}.bdms_ces_redsct_deal.lock_flag is '锁定标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_ces_redsct_deal.misc is '备注';
comment on column ${iol_schema}.bdms_ces_redsct_deal.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_ces_redsct_deal.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_ces_redsct_deal.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_ces_redsct_deal.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_ces_redsct_deal.create_time is '创建时间';
comment on column ${iol_schema}.bdms_ces_redsct_deal.create_by is '创建人';
comment on column ${iol_schema}.bdms_ces_redsct_deal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_ces_redsct_deal.etl_timestamp is 'ETL处理时间戳';
