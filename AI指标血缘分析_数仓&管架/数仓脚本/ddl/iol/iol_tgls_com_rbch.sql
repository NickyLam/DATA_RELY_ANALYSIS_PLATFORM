/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_rbch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_rbch
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_rbch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_rbch(
    brchcd varchar2(10) -- 机构代码
    ,brchna varchar2(180) -- 机构名称
    ,isfatl number(1) -- 是否父级
    ,isstat number(1) -- 是否启用
    ,isused number(1) -- 是否使用
    ,fromdt varchar2(8) -- 生效日期
    ,overdt varchar2(8) -- 失效日期
    ,remark varchar2(1000) -- 备注
    ,stacid number(9) -- 账套
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
grant select on ${iol_schema}.tgls_com_rbch to ${iml_schema};
grant select on ${iol_schema}.tgls_com_rbch to ${icl_schema};
grant select on ${iol_schema}.tgls_com_rbch to ${idl_schema};
grant select on ${iol_schema}.tgls_com_rbch to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_rbch is '报表机构表';
comment on column ${iol_schema}.tgls_com_rbch.brchcd is '机构代码';
comment on column ${iol_schema}.tgls_com_rbch.brchna is '机构名称';
comment on column ${iol_schema}.tgls_com_rbch.isfatl is '是否父级';
comment on column ${iol_schema}.tgls_com_rbch.isstat is '是否启用';
comment on column ${iol_schema}.tgls_com_rbch.isused is '是否使用';
comment on column ${iol_schema}.tgls_com_rbch.fromdt is '生效日期';
comment on column ${iol_schema}.tgls_com_rbch.overdt is '失效日期';
comment on column ${iol_schema}.tgls_com_rbch.remark is '备注';
comment on column ${iol_schema}.tgls_com_rbch.stacid is '账套';
comment on column ${iol_schema}.tgls_com_rbch.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_rbch.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_rbch.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_rbch.etl_timestamp is 'ETL处理时间戳';
