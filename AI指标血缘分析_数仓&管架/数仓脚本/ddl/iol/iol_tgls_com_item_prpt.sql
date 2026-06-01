/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_item_prpt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_item_prpt
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_item_prpt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_item_prpt(
    stacid number(19) -- 账套
    ,systid varchar2(4) -- 系统标识号
    ,itemcd varchar2(30) -- 科目编号
    ,itemna varchar2(200) -- 科目名称
    ,status varchar2(1) -- 状态
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
grant select on ${iol_schema}.tgls_com_item_prpt to ${iml_schema};
grant select on ${iol_schema}.tgls_com_item_prpt to ${icl_schema};
grant select on ${iol_schema}.tgls_com_item_prpt to ${idl_schema};
grant select on ${iol_schema}.tgls_com_item_prpt to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_item_prpt is '总账核对科目配置表';
comment on column ${iol_schema}.tgls_com_item_prpt.stacid is '账套';
comment on column ${iol_schema}.tgls_com_item_prpt.systid is '系统标识号';
comment on column ${iol_schema}.tgls_com_item_prpt.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_com_item_prpt.itemna is '科目名称';
comment on column ${iol_schema}.tgls_com_item_prpt.status is '状态';
comment on column ${iol_schema}.tgls_com_item_prpt.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_item_prpt.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_item_prpt.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_item_prpt.etl_timestamp is 'ETL处理时间戳';
