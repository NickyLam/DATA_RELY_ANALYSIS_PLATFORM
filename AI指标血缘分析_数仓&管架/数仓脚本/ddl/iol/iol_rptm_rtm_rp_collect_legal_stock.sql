/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_collect_legal_stock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_collect_legal_stock
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_collect_legal_stock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_collect_legal_stock(
    rp_name varchar2(2700) -- 
    ,card_type varchar2(36) -- 
    ,card_no varchar2(2700) -- 
    ,domestic_state varchar2(18) -- 
    ,cust_no varchar2(900) -- 
    ,company_type varchar2(18) -- 
    ,economic_nature varchar2(450) -- 
    ,business_state varchar2(2700) -- 
    ,registered_capital number(22,6) -- 
    ,representative varchar2(2700) -- 
    ,registered varchar2(4000) -- 
    ,economic_scope varchar2(4000) -- 
    ,stock_name varchar2(2700) -- 
    ,stock_id varchar2(900) -- 
    ,stock_type varchar2(2700) -- 
    ,stock_type_code varchar2(450) -- 
    ,entity_type varchar2(2700) -- 
    ,identify_type varchar2(2700) -- 
    ,stock_percent number(38,8) -- 
    ,etl_dt date -- 
    ,stock_card_no varchar2(2700) -- 
    ,stock_economic_nature varchar2(450) -- 
    ,stock_business_state varchar2(2700) -- 
    ,stock_registered_capital number(22,6) -- 
    ,stock_representative varchar2(2700) -- 
    ,stock_economic_scope varchar2(4000) -- 
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
grant select on ${iol_schema}.rptm_rtm_rp_collect_legal_stock to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_collect_legal_stock to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_collect_legal_stock to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_collect_legal_stock to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_collect_legal_stock is '疑似关联方采集法人与股东表';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.domestic_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.cust_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.company_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.economic_nature is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.business_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.registered_capital is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.representative is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.registered is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.economic_scope is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_name is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_id is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_type_code is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.entity_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.identify_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_percent is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_card_no is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_economic_nature is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_business_state is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_registered_capital is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_representative is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.stock_economic_scope is '';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_rp_collect_legal_stock.etl_timestamp is 'ETL处理时间戳';
