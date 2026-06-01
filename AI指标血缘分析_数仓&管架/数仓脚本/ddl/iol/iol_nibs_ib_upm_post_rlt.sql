/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_post_rlt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_post_rlt
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_post_rlt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_post_rlt(
    usernum varchar2(255) -- 用户号
    ,branchnum varchar2(255) -- 机构号
    ,postnum varchar2(255) -- 岗位编号
    ,ustatu varchar2(255) -- 使用状态【0-未使用 1-在用】
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
grant select on ${iol_schema}.nibs_ib_upm_post_rlt to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_rlt to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_rlt to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_rlt to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_post_rlt is '用户岗位关联表';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.usernum is '用户号';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.branchnum is '机构号';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.postnum is '岗位编号';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.ustatu is '使用状态【0-未使用 1-在用】';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_post_rlt.etl_timestamp is 'ETL处理时间戳';
