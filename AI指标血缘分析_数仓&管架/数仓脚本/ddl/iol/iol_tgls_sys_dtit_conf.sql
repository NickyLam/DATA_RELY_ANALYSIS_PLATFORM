/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_dtit_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_dtit_conf
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_dtit_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_dtit_conf(
    stacid number(9) -- 账套
    ,prodcd varchar2(12) -- 产品编号
    ,prodp1 varchar2(1) -- 产品属性组1
    ,prodp2 varchar2(1) -- 产品属性组2
    ,prodp3 varchar2(1) -- 产品属性组3
    ,prodp4 varchar2(1) -- 产品属性组4
    ,prodp5 varchar2(1) -- 产品属性组5
    ,prodp6 varchar2(1) -- 产品属性组6
    ,prodp7 varchar2(1) -- 产品属性组7
    ,prodp8 varchar2(1) -- 产品属性组8
    ,prodp9 varchar2(1) -- 产品属性组9
    ,prodpa varchar2(1) -- 产品属性组10
    ,p1tpkd varchar2(30) -- 产品属性1
    ,p2tpkd varchar2(30) -- 产品属性2
    ,p3tpkd varchar2(30) -- 产品属性3
    ,p4tpkd varchar2(30) -- 产品属性4
    ,p5tpkd varchar2(30) -- 产品属性5
    ,p6tpkd varchar2(30) -- 产品属性6
    ,p7tpkd varchar2(30) -- 产品属性7
    ,p8tpkd varchar2(30) -- 产品属性8
    ,p9tpkd varchar2(30) -- 产品属性9
    ,patpkd varchar2(30) -- 产品属性10
    ,trprgp varchar2(2000) -- 余额类型组
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
grant select on ${iol_schema}.tgls_sys_dtit_conf to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_dtit_conf to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_dtit_conf to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_dtit_conf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_dtit_conf is '产品核算配置表';
comment on column ${iol_schema}.tgls_sys_dtit_conf.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp1 is '产品属性组1';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp2 is '产品属性组2';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp3 is '产品属性组3';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp4 is '产品属性组4';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp5 is '产品属性组5';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp6 is '产品属性组6';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp7 is '产品属性组7';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp8 is '产品属性组8';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodp9 is '产品属性组9';
comment on column ${iol_schema}.tgls_sys_dtit_conf.prodpa is '产品属性组10';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p1tpkd is '产品属性1';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p2tpkd is '产品属性2';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p3tpkd is '产品属性3';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p4tpkd is '产品属性4';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p5tpkd is '产品属性5';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p6tpkd is '产品属性6';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p7tpkd is '产品属性7';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p8tpkd is '产品属性8';
comment on column ${iol_schema}.tgls_sys_dtit_conf.p9tpkd is '产品属性9';
comment on column ${iol_schema}.tgls_sys_dtit_conf.patpkd is '产品属性10';
comment on column ${iol_schema}.tgls_sys_dtit_conf.trprgp is '余额类型组';
comment on column ${iol_schema}.tgls_sys_dtit_conf.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_dtit_conf.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_dtit_conf.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_dtit_conf.etl_timestamp is 'ETL处理时间戳';
