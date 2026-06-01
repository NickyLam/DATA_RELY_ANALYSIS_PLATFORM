/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst0018
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst0018
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst0018 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst0018(
    etl_dt_ora date -- 数据日期
    ,index_name varchar2(60) -- 指标名称
    ,curr_cd varchar2(45) -- 币种
    ,curr_name varchar2(60) -- 币种名称
    ,manager_org varchar2(60) -- 考核机构
    ,manager_org_name varchar2(300) -- 考核机构名称
    ,kpi_value_mm number(38,8) -- 当月值_分子
    ,kpi_value_mom number(38,8) -- 当月值_分母
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
grant select on ${iol_schema}.cass_r_rpt_rst0018 to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0018 to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0018 to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst0018 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst0018 is '管会存贷款成本明细表';
comment on column ${iol_schema}.cass_r_rpt_rst0018.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst0018.index_name is '指标名称';
comment on column ${iol_schema}.cass_r_rpt_rst0018.curr_cd is '币种';
comment on column ${iol_schema}.cass_r_rpt_rst0018.curr_name is '币种名称';
comment on column ${iol_schema}.cass_r_rpt_rst0018.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst0018.manager_org_name is '考核机构名称';
comment on column ${iol_schema}.cass_r_rpt_rst0018.kpi_value_mm is '当月值_分子';
comment on column ${iol_schema}.cass_r_rpt_rst0018.kpi_value_mom is '当月值_分母';
comment on column ${iol_schema}.cass_r_rpt_rst0018.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst0018.etl_timestamp is 'ETL处理时间戳';
