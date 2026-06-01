/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_xtb_zhgxjl_kh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_xtb_zhgxjl_kh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_xtb_zhgxjl_kh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_xtb_zhgxjl_kh(
    jldh number(22,0) -- 记录代号
    ,ggbz varchar2(2) -- 更改标志
    ,khdxdh number(22,0) -- 考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,clje number(25,4) -- 存量金额
    ,clbl number(19,5) -- 存量比例
    ,zlbl number(19,5) -- 增量比例
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
grant select on ${iol_schema}.pams_xtb_zhgxjl_kh to ${iml_schema};
grant select on ${iol_schema}.pams_xtb_zhgxjl_kh to ${icl_schema};
grant select on ${iol_schema}.pams_xtb_zhgxjl_kh to ${idl_schema};
grant select on ${iol_schema}.pams_xtb_zhgxjl_kh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_xtb_zhgxjl_kh is '系统表-账户关系记录-客户';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.jldh is '记录代号';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.ggbz is '更改标志';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.fpjs is '分配角色';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.qsrq is '起始日期';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.jsrq is '结束日期';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.clje is '存量金额';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.clbl is '存量比例';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.zlbl is '增量比例';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_xtb_zhgxjl_kh.etl_timestamp is 'ETL处理时间戳';
