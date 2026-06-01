/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_rbch_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_rbch_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_rbch_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_rbch_detl(
    brchcd varchar2(12) -- 父级机构编号
    ,fromcd varchar2(12) -- 开始机构编号
    ,overcd varchar2(12) -- 结束机构编号
    ,isused number(1) -- 是否使用
    ,fromdt varchar2(8) -- 生效日期
    ,overdt varchar2(8) -- 失效日期
    ,stacid number(9) -- 账套_x0013_
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
grant select on ${iol_schema}.tgls_com_rbch_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_com_rbch_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_com_rbch_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_com_rbch_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_rbch_detl is '报表机构明细表';
comment on column ${iol_schema}.tgls_com_rbch_detl.brchcd is '父级机构编号';
comment on column ${iol_schema}.tgls_com_rbch_detl.fromcd is '开始机构编号';
comment on column ${iol_schema}.tgls_com_rbch_detl.overcd is '结束机构编号';
comment on column ${iol_schema}.tgls_com_rbch_detl.isused is '是否使用';
comment on column ${iol_schema}.tgls_com_rbch_detl.fromdt is '生效日期';
comment on column ${iol_schema}.tgls_com_rbch_detl.overdt is '失效日期';
comment on column ${iol_schema}.tgls_com_rbch_detl.stacid is '账套_x0013_';
comment on column ${iol_schema}.tgls_com_rbch_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_rbch_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_rbch_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_rbch_detl.etl_timestamp is 'ETL处理时间戳';
