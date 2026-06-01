/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_redsct_due
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_redsct_due
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_redsct_due purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_due(
    id varchar2(60) -- 
    ,org_contract_id varchar2(60) -- 原业务批次表ID
    ,contract_no varchar2(60) -- 批次号
    ,busi_date varchar2(12) -- 业务日期
    ,busi_type varchar2(8) -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,settle_type varchar2(9) -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,product_no varchar2(12) -- 产品号
    ,deal_no varchar2(30) -- 成交单编号
    ,busi_branch_no varchar2(18) -- 业务机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,facct_no varchar2(75) -- 资金账号
    ,acct_branch_no varchar2(15) -- 账务机构号
    ,user_id varchar2(15) -- 交易员ID
    ,real_settle_amount number(18,2) -- 实际结算金额
    ,settle_draft_num number(8,0) -- 结算票据张数
    ,settle_pay_interest number(18,2) -- 结算应付利息
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_status varchar2(6) -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
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
grant select on ${iol_schema}.bdms_cpes_redsct_due to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_due to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_due to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_due to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_redsct_due is '再贴现到期批次表';
comment on column ${iol_schema}.bdms_cpes_redsct_due.id is '';
comment on column ${iol_schema}.bdms_cpes_redsct_due.org_contract_id is '原业务批次表ID';
comment on column ${iol_schema}.bdms_cpes_redsct_due.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.busi_date is '业务日期';
comment on column ${iol_schema}.bdms_cpes_redsct_due.busi_type is '业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断';
comment on column ${iol_schema}.bdms_cpes_redsct_due.settle_type is '清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回';
comment on column ${iol_schema}.bdms_cpes_redsct_due.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.deal_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.facct_no is '资金账号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_due.user_id is '交易员ID';
comment on column ${iol_schema}.bdms_cpes_redsct_due.real_settle_amount is '实际结算金额';
comment on column ${iol_schema}.bdms_cpes_redsct_due.settle_draft_num is '结算票据张数';
comment on column ${iol_schema}.bdms_cpes_redsct_due.settle_pay_interest is '结算应付利息';
comment on column ${iol_schema}.bdms_cpes_redsct_due.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_redsct_due.settle_status is '清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_redsct_due.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_redsct_due.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_redsct_due.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_redsct_due.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_redsct_due.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_redsct_due.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_redsct_due.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_redsct_due.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_redsct_due.etl_timestamp is 'ETL处理时间戳';
