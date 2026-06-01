/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khdx_jgcy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khdx_jgcy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khdx_jgcy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_jgcy(
    khdxdh number(22,0) -- 考核对象代号
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,hydh varchar2(18) -- 行员代号
    ,jgdh varchar2(15) -- 机构代号
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
grant select on ${iol_schema}.pams_khdx_jgcy to ${iml_schema};
grant select on ${iol_schema}.pams_khdx_jgcy to ${icl_schema};
grant select on ${iol_schema}.pams_khdx_jgcy to ${idl_schema};
grant select on ${iol_schema}.pams_khdx_jgcy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khdx_jgcy is '考核对象-机构成员';
comment on column ${iol_schema}.pams_khdx_jgcy.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_khdx_jgcy.qsrq is '起始日期';
comment on column ${iol_schema}.pams_khdx_jgcy.jsrq is '结束日期';
comment on column ${iol_schema}.pams_khdx_jgcy.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_khdx_jgcy.hydh is '行员代号';
comment on column ${iol_schema}.pams_khdx_jgcy.jgdh is '机构代号';
comment on column ${iol_schema}.pams_khdx_jgcy.start_dt is '开始时间';
comment on column ${iol_schema}.pams_khdx_jgcy.end_dt is '结束时间';
comment on column ${iol_schema}.pams_khdx_jgcy.id_mark is '增删标志';
comment on column ${iol_schema}.pams_khdx_jgcy.etl_timestamp is 'ETL处理时间戳';
