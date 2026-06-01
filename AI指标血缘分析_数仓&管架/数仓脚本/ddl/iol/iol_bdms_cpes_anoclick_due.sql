/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_anoclick_due
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_anoclick_due
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_anoclick_due purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_due(
    id varchar2(60) -- ID
    ,contract_no varchar2(60) -- 协议号
    ,busi_date varchar2(12) -- 业务日期
    ,org_cpes_match_contract_id varchar2(60) -- 原匹配批次ID
    ,product_no varchar2(12) -- 产品号
    ,busi_type varchar2(6) -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,deal_no varchar2(30) -- 成交单编号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 买入 TDD02 卖出
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,facct_no varchar2(48) -- 资金账号
    ,acct_branch_no varchar2(15) -- 账务机构号
    ,user_id varchar2(15) -- 交易员ID
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,last_upd_opr varchar2(45) -- 最后操作员
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
grant select on ${iol_schema}.bdms_cpes_anoclick_due to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_due to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_due to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_due to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_anoclick_due is '匿名点击到期';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.contract_no is '协议号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.busi_date is '业务日期';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.org_cpes_match_contract_id is '原匹配批次ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.busi_type is '业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.deal_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.trade_direct is '交易方向： TDD01 买入 TDD02 卖出';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.facct_no is '资金账号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.user_id is '交易员ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_anoclick_due.etl_timestamp is 'ETL处理时间戳';
