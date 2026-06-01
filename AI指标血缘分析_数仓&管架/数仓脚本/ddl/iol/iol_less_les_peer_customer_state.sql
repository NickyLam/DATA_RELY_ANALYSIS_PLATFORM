/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_les_peer_customer_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_les_peer_customer_state
whenever sqlerror continue none;
drop table ${iol_schema}.less_les_peer_customer_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_les_peer_customer_state(
    datadate varchar2(8) -- 数据日期
    ,seqitem number(22) -- 序号
    ,customertype varchar2(100) -- 客户类型
    ,customername varchar2(200) -- 客户名称
    ,customercode varchar2(60) -- 客户代码
    ,sumexpse number(38,6) -- 风险暴露总和-合计
    ,unexemptriskexpse number(38,6) -- 风险暴露总和-其中：不可豁免风险暴露
    ,firstcapnarat number(38,6) -- 占一级资本净额比例-合计
    ,unexemptriskexpseprop number(38,6) -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse number(38,6) -- 一般风险暴露-合计
    ,lacibank number(38,6) -- 一般风险暴露-其中：拆放同业
    ,ibank_offer number(38,6) -- 拆放同业-其中：同业拆借
    ,ibankbrw_money number(38,6) -- 拆放同业-其中：同业借款
    ,storibank number(38,6) -- 一般风险暴露-其中：存放同业
    ,buyresalezy number(38,6) -- 一般风险暴露-其中：买入返售(质押式)
    ,ibankbond number(38,6) -- 一般风险暴露-其中：同业债券
    ,policyfidebt number(38,6) -- 同业债券-其中：政策性金融债
    ,ibankreceipt number(38,6) -- 一般风险暴露-其中：同业存单
    ,sumprod number(38,6) -- 特定风险暴露-合计
    ,glprod number(38,6) -- 特定风险暴露-资产管理产品
    ,trustprod number(38,6) -- 资产管理产品-其中：信托产品
    ,nbrk_evnchrem number(38,6) -- 资产管理产品-其中：非保本理财
    ,secuastmgmtprod number(38,6) -- 资产管理产品-其中：证券业资管产品
    ,zqprod number(38,6) -- 特定风险暴露-资产证券化产品
    ,aftradeacctriskexpse number(38,6) -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse number(38,6) -- 交易对手信用风险暴露-合计
    ,courtdertool number(38,6) -- 交易对手信用风险暴露-其中：场外衍生工具
    ,secufinancetrade number(38,6) -- 交易对手信用风险暴露-其中：证券融资交易
    ,afptentriskexpse number(38,6) -- 潜在风险暴露
    ,afothriskexpse number(38,6) -- 其他风险暴露
    ,moveriskexpse number(38,6) -- 风险缓释转出的风险暴露（转入为负数）
    ,summoverisk number(38,6) -- 不考虑风险缓释作用的风险暴露总和
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
grant select on ${iol_schema}.less_les_peer_customer_state to ${iml_schema};
grant select on ${iol_schema}.less_les_peer_customer_state to ${icl_schema};
grant select on ${iol_schema}.less_les_peer_customer_state to ${idl_schema};
grant select on ${iol_schema}.less_les_peer_customer_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_les_peer_customer_state is '同业单一客户大额风险暴露情况表';
comment on column ${iol_schema}.less_les_peer_customer_state.datadate is '数据日期';
comment on column ${iol_schema}.less_les_peer_customer_state.seqitem is '序号';
comment on column ${iol_schema}.less_les_peer_customer_state.customertype is '客户类型';
comment on column ${iol_schema}.less_les_peer_customer_state.customername is '客户名称';
comment on column ${iol_schema}.less_les_peer_customer_state.customercode is '客户代码';
comment on column ${iol_schema}.less_les_peer_customer_state.sumexpse is '风险暴露总和-合计';
comment on column ${iol_schema}.less_les_peer_customer_state.unexemptriskexpse is '风险暴露总和-其中：不可豁免风险暴露';
comment on column ${iol_schema}.less_les_peer_customer_state.firstcapnarat is '占一级资本净额比例-合计';
comment on column ${iol_schema}.less_les_peer_customer_state.unexemptriskexpseprop is '占一级资本净额比例-其中：不可豁免风险暴露';
comment on column ${iol_schema}.less_les_peer_customer_state.afcomnriskexpse is '一般风险暴露-合计';
comment on column ${iol_schema}.less_les_peer_customer_state.lacibank is '一般风险暴露-其中：拆放同业';
comment on column ${iol_schema}.less_les_peer_customer_state.ibank_offer is '拆放同业-其中：同业拆借';
comment on column ${iol_schema}.less_les_peer_customer_state.ibankbrw_money is '拆放同业-其中：同业借款';
comment on column ${iol_schema}.less_les_peer_customer_state.storibank is '一般风险暴露-其中：存放同业';
comment on column ${iol_schema}.less_les_peer_customer_state.buyresalezy is '一般风险暴露-其中：买入返售(质押式)';
comment on column ${iol_schema}.less_les_peer_customer_state.ibankbond is '一般风险暴露-其中：同业债券';
comment on column ${iol_schema}.less_les_peer_customer_state.policyfidebt is '同业债券-其中：政策性金融债';
comment on column ${iol_schema}.less_les_peer_customer_state.ibankreceipt is '一般风险暴露-其中：同业存单';
comment on column ${iol_schema}.less_les_peer_customer_state.sumprod is '特定风险暴露-合计';
comment on column ${iol_schema}.less_les_peer_customer_state.glprod is '特定风险暴露-资产管理产品';
comment on column ${iol_schema}.less_les_peer_customer_state.trustprod is '资产管理产品-其中：信托产品';
comment on column ${iol_schema}.less_les_peer_customer_state.nbrk_evnchrem is '资产管理产品-其中：非保本理财';
comment on column ${iol_schema}.less_les_peer_customer_state.secuastmgmtprod is '资产管理产品-其中：证券业资管产品';
comment on column ${iol_schema}.less_les_peer_customer_state.zqprod is '特定风险暴露-资产证券化产品';
comment on column ${iol_schema}.less_les_peer_customer_state.aftradeacctriskexpse is '交易账簿风险暴露';
comment on column ${iol_schema}.less_les_peer_customer_state.aftradecpcrdtriskexpse is '交易对手信用风险暴露-合计';
comment on column ${iol_schema}.less_les_peer_customer_state.courtdertool is '交易对手信用风险暴露-其中：场外衍生工具';
comment on column ${iol_schema}.less_les_peer_customer_state.secufinancetrade is '交易对手信用风险暴露-其中：证券融资交易';
comment on column ${iol_schema}.less_les_peer_customer_state.afptentriskexpse is '潜在风险暴露';
comment on column ${iol_schema}.less_les_peer_customer_state.afothriskexpse is '其他风险暴露';
comment on column ${iol_schema}.less_les_peer_customer_state.moveriskexpse is '风险缓释转出的风险暴露（转入为负数）';
comment on column ${iol_schema}.less_les_peer_customer_state.summoverisk is '不考虑风险缓释作用的风险暴露总和';
comment on column ${iol_schema}.less_les_peer_customer_state.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.less_les_peer_customer_state.etl_timestamp is 'ETL处理时间戳';
