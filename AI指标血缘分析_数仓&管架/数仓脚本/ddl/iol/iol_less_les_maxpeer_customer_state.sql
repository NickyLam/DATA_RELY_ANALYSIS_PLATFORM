/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_les_maxpeer_customer_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_les_maxpeer_customer_state
whenever sqlerror continue none;
drop table ${iol_schema}.less_les_maxpeer_customer_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_les_maxpeer_customer_state(
    datadate varchar2(8) -- 数据日期
    ,seqitem number(22) -- 序号
    ,collcustomername varchar2(200) -- 客户名称
    ,collcertnum varchar2(60) -- 客户代码
    ,lacibank number(38,6) -- 拆放同业-合计
    ,ibank_offer number(38,6) -- 拆放同业-其中：同业拆借
    ,ibankbrw_money number(38,6) -- 拆放同业-其中：同业借款
    ,trusibankera_pay number(38,6) -- 拆放同业-其中：受托方同业代付
    ,storibank number(38,6) -- 拆放同业-合计
    ,buyresale number(38,6) -- 存放同业
    ,othibank number(38,6) -- 买入返售
    ,sumbank number(38,6) -- 其他同业融出
    ,sumbankpt number(38,6) -- 同业融出合计
    ,rtratio number(38,6) -- 扣除结算性同业存款和风险权重为零资产后的融出余额
    ,stlibankdpst number(38,6) -- 占一级资本净额比例%
    ,riskwghtzeroast number(38,6) -- 风险权重为零的资产
    ,notst number(38,6) -- 同业投资业务
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
grant select on ${iol_schema}.less_les_maxpeer_customer_state to ${iml_schema};
grant select on ${iol_schema}.less_les_maxpeer_customer_state to ${icl_schema};
grant select on ${iol_schema}.less_les_maxpeer_customer_state to ${idl_schema};
grant select on ${iol_schema}.less_les_maxpeer_customer_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_les_maxpeer_customer_state is '最大单家及全部同业融资业务情况表';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.datadate is '数据日期';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.seqitem is '序号';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.collcustomername is '客户名称';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.collcertnum is '客户代码';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.lacibank is '拆放同业-合计';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.ibank_offer is '拆放同业-其中：同业拆借';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.ibankbrw_money is '拆放同业-其中：同业借款';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.trusibankera_pay is '拆放同业-其中：受托方同业代付';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.storibank is '拆放同业-合计';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.buyresale is '存放同业';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.othibank is '买入返售';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.sumbank is '其他同业融出';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.sumbankpt is '同业融出合计';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.rtratio is '扣除结算性同业存款和风险权重为零资产后的融出余额';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.stlibankdpst is '占一级资本净额比例%';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.riskwghtzeroast is '风险权重为零的资产';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.notst is '同业投资业务';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.less_les_maxpeer_customer_state.etl_timestamp is 'ETL处理时间戳';
