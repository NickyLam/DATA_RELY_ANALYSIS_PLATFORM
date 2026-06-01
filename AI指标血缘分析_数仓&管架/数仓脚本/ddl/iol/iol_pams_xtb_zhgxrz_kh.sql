/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_xtb_zhgxrz_kh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_xtb_zhgxrz_kh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_xtb_zhgxrz_kh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_xtb_zhgxrz_kh(
    jldh number(22,0) -- 记录代号
    ,jlsj timestamp -- 记录时间
    ,czlx varchar2(3) -- 操作类型
    ,xgrdh number(22,0) -- 修改人代号
    ,jxdxdh number(22,0) -- 绩效对象代号
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
grant select on ${iol_schema}.pams_xtb_zhgxrz_kh to ${iml_schema};
grant select on ${iol_schema}.pams_xtb_zhgxrz_kh to ${icl_schema};
grant select on ${iol_schema}.pams_xtb_zhgxrz_kh to ${idl_schema};
grant select on ${iol_schema}.pams_xtb_zhgxrz_kh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_xtb_zhgxrz_kh is '系统表-账户关系日志-客户';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.jldh is '记录代号';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.jlsj is '记录时间';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.czlx is '操作类型';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.xgrdh is '修改人代号';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_xtb_zhgxrz_kh.etl_timestamp is 'ETL处理时间戳';
