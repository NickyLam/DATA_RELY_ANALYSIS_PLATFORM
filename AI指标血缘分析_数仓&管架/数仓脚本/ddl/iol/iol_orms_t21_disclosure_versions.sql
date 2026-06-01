/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_t21_disclosure_versions
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_t21_disclosure_versions
whenever sqlerror continue none;
drop table ${iol_schema}.orms_t21_disclosure_versions purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_disclosure_versions(
    id varchar2(15) -- id，主键
    ,type varchar2(2) -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
    ,name varchar2(48) -- 名称
    ,seq varchar2(15) -- 序号
    ,deleteflag varchar2(2) -- 删除标识：0：删除，1：未删除
    ,creator varchar2(48) -- 创建人
    ,createdate varchar2(48) -- 创建时间
    ,modifier varchar2(48) -- 修改人
    ,modifydate varchar2(48) -- 修改时间
    ,amount varchar2(48) -- 计算起点金额
    ,startdate varchar2(48) -- 披露报表最近一年-开始时间
    ,enddate varchar2(48) -- 披露报表最近一年-结束时间
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
grant select on ${iol_schema}.orms_t21_disclosure_versions to ${iml_schema};
grant select on ${iol_schema}.orms_t21_disclosure_versions to ${icl_schema};
grant select on ${iol_schema}.orms_t21_disclosure_versions to ${idl_schema};
grant select on ${iol_schema}.orms_t21_disclosure_versions to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_t21_disclosure_versions is '披露报表版本管理表';
comment on column ${iol_schema}.orms_t21_disclosure_versions.id is 'id，主键';
comment on column ${iol_schema}.orms_t21_disclosure_versions.type is '类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计';
comment on column ${iol_schema}.orms_t21_disclosure_versions.name is '名称';
comment on column ${iol_schema}.orms_t21_disclosure_versions.seq is '序号';
comment on column ${iol_schema}.orms_t21_disclosure_versions.deleteflag is '删除标识：0：删除，1：未删除';
comment on column ${iol_schema}.orms_t21_disclosure_versions.creator is '创建人';
comment on column ${iol_schema}.orms_t21_disclosure_versions.createdate is '创建时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.modifier is '修改人';
comment on column ${iol_schema}.orms_t21_disclosure_versions.modifydate is '修改时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.amount is '计算起点金额';
comment on column ${iol_schema}.orms_t21_disclosure_versions.startdate is '披露报表最近一年-开始时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.enddate is '披露报表最近一年-结束时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.start_dt is '开始时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.end_dt is '结束时间';
comment on column ${iol_schema}.orms_t21_disclosure_versions.id_mark is '增删标志';
comment on column ${iol_schema}.orms_t21_disclosure_versions.etl_timestamp is 'ETL处理时间戳';
