/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_shet_info_cond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_shet_info_cond
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_shet_info_cond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_info_cond(
    shetcd varchar2(16) -- 报表编码
    ,condcd varchar2(16) -- 条件代码
    ,sortno number -- 显示顺序
    ,cddfvl varchar2(20) -- 默认值
    ,iscdrq varchar2(1) -- 是否必输(0否，1是)
    ,stacid number(9) -- 帐套id
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
grant select on ${iol_schema}.tgls_cbrc_shet_info_cond to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info_cond to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info_cond to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_info_cond to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_shet_info_cond is '报表模板条件';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.condcd is '条件代码';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.sortno is '显示顺序';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.cddfvl is '默认值';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.iscdrq is '是否必输(0否，1是)';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.stacid is '帐套id';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_shet_info_cond.etl_timestamp is 'ETL处理时间戳';
