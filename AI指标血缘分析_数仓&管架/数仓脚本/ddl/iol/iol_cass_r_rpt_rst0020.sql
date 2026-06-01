/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst0020
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst0020
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst0020 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst0020(
    etl_dt_ora date -- 数据日期
    ,kpi_code varchar2(30) -- 指标编号
    ,kpi_name varchar2(100) -- 指标名称
    ,accts_org_no varchar2(60) -- 账务机构
    ,manager_org varchar2(60) -- 考核机构
    ,curr_cd varchar2(60) -- 币种
    ,kpi_value_m number(38,8) -- 指标值(月)
    ,kpi_value_y number(38,8) -- 指标值(年)
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
grant select on ${iol_schema}.cass_r_rpt_rst0020 to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0020 to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0020 to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0020 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst0020 is '回流绩效指标表';
comment on column ${iol_schema}.cass_r_rpt_rst0020.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst0020.kpi_code is '指标编号';
comment on column ${iol_schema}.cass_r_rpt_rst0020.kpi_name is '指标名称';
comment on column ${iol_schema}.cass_r_rpt_rst0020.accts_org_no is '账务机构';
comment on column ${iol_schema}.cass_r_rpt_rst0020.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst0020.curr_cd is '币种';
comment on column ${iol_schema}.cass_r_rpt_rst0020.kpi_value_m is '指标值(月)';
comment on column ${iol_schema}.cass_r_rpt_rst0020.kpi_value_y is '指标值(年)';
comment on column ${iol_schema}.cass_r_rpt_rst0020.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst0020.etl_timestamp is 'ETL处理时间戳';
