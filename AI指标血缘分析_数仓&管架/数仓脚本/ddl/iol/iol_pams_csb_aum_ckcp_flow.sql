/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_aum_ckcp_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_aum_ckcp_flow
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_aum_ckcp_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_aum_ckcp_flow(
    tjrq number(38,0) -- 统计日期
    ,cph varchar2(180) -- 标准产品号
    ,cplx varchar2(60) -- 产品类型
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
grant select on ${iol_schema}.pams_csb_aum_ckcp_flow to ${iml_schema};
grant select on ${iol_schema}.pams_csb_aum_ckcp_flow to ${icl_schema};
grant select on ${iol_schema}.pams_csb_aum_ckcp_flow to ${idl_schema};
grant select on ${iol_schema}.pams_csb_aum_ckcp_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_aum_ckcp_flow is 'AUM资产存款产品参数表-回流';
comment on column ${iol_schema}.pams_csb_aum_ckcp_flow.tjrq is '统计日期';
comment on column ${iol_schema}.pams_csb_aum_ckcp_flow.cph is '标准产品号';
comment on column ${iol_schema}.pams_csb_aum_ckcp_flow.cplx is '产品类型';
comment on column ${iol_schema}.pams_csb_aum_ckcp_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_csb_aum_ckcp_flow.etl_timestamp is 'ETL处理时间戳';
