/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_ces_quote_details_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_ces_quote_details_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_ces_quote_details_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_ces_quote_details_info(
    id varchar2(60) -- ID
    ,deal_id varchar2(60) -- 成交表ID
    ,draft_id varchar2(60) -- 票据表ID
    ,quote_id varchar2(60) -- 报价信息表ID
    ,del_quote_id varchar2(60) -- 删除此票据的报价信息表ID
    ,del_flag varchar2(2) -- 删除标志： 0 否 1 是
    ,draft_amount number(18,2) -- 票面金额
    ,maturity_date varchar2(12) -- 票据到期日
    ,real_due_date varchar2(12) -- 实际到期日
    ,tenor_days number(8,0) -- 剩余期限
    ,due_tenor_days number(8,0) -- 到期剩余期限
    ,pay_interest number(18,2) -- 应付利息
    ,due_pay_interest number(18,2) -- 到期应付利息
    ,settle_amt number(18,2) -- 结算金额
    ,due_settle_amt number(18,2) -- 到期结算金额
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,credit_type varchar2(5) -- 信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,credit_branch varchar2(14) -- 信用主体
    ,is_approve varchar2(3) -- 是否成交标识： 1 是 0 否
    ,msg_note varchar2(4000) -- 报文备注
    ,cd_range varchar2(38) -- 子票区间
    ,standard_amt number(18,2) -- 标准金额
    ,split_range varchar2(38) -- 拆前区间
    ,org_draft_amount number(18,2) -- 原始票据（包）金额
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,draft_number varchar2(45) -- 票据（包）号
    ,create_time varchar2(21) -- 鍒涘缓鏃堕棿
    ,create_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_ces_quote_details_info to ${iml_schema};
grant select on ${iol_schema}.bdms_ces_quote_details_info to ${icl_schema};
grant select on ${iol_schema}.bdms_ces_quote_details_info to ${idl_schema};
grant select on ${iol_schema}.bdms_ces_quote_details_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_ces_quote_details_info is '对话报价单明细信息表';
comment on column ${iol_schema}.bdms_ces_quote_details_info.id is 'ID';
comment on column ${iol_schema}.bdms_ces_quote_details_info.deal_id is '成交表ID';
comment on column ${iol_schema}.bdms_ces_quote_details_info.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_ces_quote_details_info.quote_id is '报价信息表ID';
comment on column ${iol_schema}.bdms_ces_quote_details_info.del_quote_id is '删除此票据的报价信息表ID';
comment on column ${iol_schema}.bdms_ces_quote_details_info.del_flag is '删除标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_ces_quote_details_info.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_ces_quote_details_info.maturity_date is '票据到期日';
comment on column ${iol_schema}.bdms_ces_quote_details_info.real_due_date is '实际到期日';
comment on column ${iol_schema}.bdms_ces_quote_details_info.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_ces_quote_details_info.due_tenor_days is '到期剩余期限';
comment on column ${iol_schema}.bdms_ces_quote_details_info.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_ces_quote_details_info.due_pay_interest is '到期应付利息';
comment on column ${iol_schema}.bdms_ces_quote_details_info.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_ces_quote_details_info.due_settle_amt is '到期结算金额';
comment on column ${iol_schema}.bdms_ces_quote_details_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_ces_quote_details_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_ces_quote_details_info.misc is '备注';
comment on column ${iol_schema}.bdms_ces_quote_details_info.credit_type is '信用主体类型： 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司';
comment on column ${iol_schema}.bdms_ces_quote_details_info.credit_branch is '信用主体';
comment on column ${iol_schema}.bdms_ces_quote_details_info.is_approve is '是否成交标识： 1 是 0 否';
comment on column ${iol_schema}.bdms_ces_quote_details_info.msg_note is '报文备注';
comment on column ${iol_schema}.bdms_ces_quote_details_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_ces_quote_details_info.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_ces_quote_details_info.split_range is '拆前区间';
comment on column ${iol_schema}.bdms_ces_quote_details_info.org_draft_amount is '原始票据（包）金额';
comment on column ${iol_schema}.bdms_ces_quote_details_info.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_ces_quote_details_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_ces_quote_details_info.create_time is '鍒涘缓鏃堕棿';
comment on column ${iol_schema}.bdms_ces_quote_details_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_ces_quote_details_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_ces_quote_details_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_ces_quote_details_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_ces_quote_details_info.etl_timestamp is 'ETL处理时间戳';
