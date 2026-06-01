/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_post_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_post_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_post_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_post_info(
    postseq varchar2(255) -- 岗位序号
    ,posttype varchar2(2) -- 岗位类型 1-总行，2-分行，3-支行，9-全行
    ,postnum varchar2(100) -- 岗位代码
    ,postname varchar2(255) -- 岗位名称
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
grant select on ${iol_schema}.nibs_ib_upm_post_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_post_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_post_info is '岗位信息表';
comment on column ${iol_schema}.nibs_ib_upm_post_info.postseq is '岗位序号';
comment on column ${iol_schema}.nibs_ib_upm_post_info.posttype is '岗位类型 1-总行，2-分行，3-支行，9-全行';
comment on column ${iol_schema}.nibs_ib_upm_post_info.postnum is '岗位代码';
comment on column ${iol_schema}.nibs_ib_upm_post_info.postname is '岗位名称';
comment on column ${iol_schema}.nibs_ib_upm_post_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_post_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_post_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_post_info.etl_timestamp is 'ETL处理时间戳';
