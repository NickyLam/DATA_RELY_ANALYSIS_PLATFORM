/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_quote_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_quote_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_quote_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_quote_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次ID
    ,draft_id varchar2(60) -- 票据表ID
    ,draft_amount number(18,2) -- 票面金额
    ,maturity_date varchar2(12) -- 票据到期日
    ,real_due_date varchar2(12) -- 实际到期日
    ,tenor_days number(8,0) -- 剩余期限
    ,due_tenor_days number(8,0) -- 到期剩余期限
    ,pay_interest number(18,2) -- 应付利息
    ,due_pay_interest number(18,2) -- 到期应付利息
    ,settle_amt number(18,2) -- 结算金额
    ,due_settle_amt number(18,2) -- 到期结算金额
    ,credit_status varchar2(3) -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,details_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,valid_flag varchar2(2) -- 有效标识： 0 无效 1 有效
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,cpes_lock_flag varchar2(2) -- 票交所锁定标识： 0 未锁定 1 已锁定
    ,credit_type varchar2(5) -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,credit_branch varchar2(14) -- 信用主体
    ,msg_note varchar2(4000) -- 报文备注
    ,standard_amt number(18,2) -- 标准金额
    ,split_range varchar2(38) -- 拆前区间
    ,org_draft_amount number(18,2) -- 原始票据（包）金额
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,draft_number varchar2(45) -- 票据（包）号
    ,cd_range varchar2(38) -- 子票区间
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
grant select on ${iol_schema}.bdms_cpes_quote_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_quote_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_quote_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_quote_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_quote_details is '对话明细表';
comment on column ${iol_schema}.bdms_cpes_quote_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_quote_details.contract_id is '批次ID';
comment on column ${iol_schema}.bdms_cpes_quote_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_quote_details.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpes_quote_details.maturity_date is '票据到期日';
comment on column ${iol_schema}.bdms_cpes_quote_details.real_due_date is '实际到期日';
comment on column ${iol_schema}.bdms_cpes_quote_details.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_cpes_quote_details.due_tenor_days is '到期剩余期限';
comment on column ${iol_schema}.bdms_cpes_quote_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_quote_details.due_pay_interest is '到期应付利息';
comment on column ${iol_schema}.bdms_cpes_quote_details.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_quote_details.due_settle_amt is '到期结算金额';
comment on column ${iol_schema}.bdms_cpes_quote_details.credit_status is '额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败';
comment on column ${iol_schema}.bdms_cpes_quote_details.details_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_quote_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_quote_details.valid_flag is '有效标识： 0 无效 1 有效';
comment on column ${iol_schema}.bdms_cpes_quote_details.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_quote_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_quote_details.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_quote_details.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_quote_details.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_quote_details.cpes_lock_flag is '票交所锁定标识： 0 未锁定 1 已锁定';
comment on column ${iol_schema}.bdms_cpes_quote_details.credit_type is '信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司';
comment on column ${iol_schema}.bdms_cpes_quote_details.credit_branch is '信用主体';
comment on column ${iol_schema}.bdms_cpes_quote_details.msg_note is '报文备注';
comment on column ${iol_schema}.bdms_cpes_quote_details.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_cpes_quote_details.split_range is '拆前区间';
comment on column ${iol_schema}.bdms_cpes_quote_details.org_draft_amount is '原始票据（包）金额';
comment on column ${iol_schema}.bdms_cpes_quote_details.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_quote_details.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cpes_quote_details.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cpes_quote_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_quote_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_quote_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_quote_details.etl_timestamp is 'ETL处理时间戳';
