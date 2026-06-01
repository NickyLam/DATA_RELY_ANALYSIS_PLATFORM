/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_fomu_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_fomu_info
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_fomu_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_fomu_info(
    fomucd varchar2(30) -- 公式指标编码
    ,status varchar2(1) -- 公式指标启用状态（1启用，0未启用）
    ,excode varchar2(4000) -- 公式指标执行sql语句
    ,remark varchar2(2000) -- 备注
    ,fomutp varchar2(1) -- 类型0-自定义,1-系统函数
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
grant select on ${iol_schema}.tgls_cbrc_fomu_info to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_info to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_info to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_fomu_info is '公式指标定义表';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.fomucd is '公式指标编码';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.status is '公式指标启用状态（1启用，0未启用）';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.excode is '公式指标执行sql语句';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.remark is '备注';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.fomutp is '类型0-自定义,1-系统函数';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_fomu_info.etl_timestamp is 'ETL处理时间戳';
