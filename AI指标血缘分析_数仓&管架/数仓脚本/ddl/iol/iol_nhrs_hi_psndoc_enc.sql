/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_enc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_enc
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_enc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_enc(
    creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,encourdate varchar2(15) -- 奖惩日期
    ,encourmatter varchar2(576) -- 奖惩事由
    ,encourmeas varchar2(576) -- 奖励措施
    ,encourorg varchar2(225) -- 奖励机构
    ,encourrank varchar2(30) -- 奖励级别
    ,encourtype varchar2(225) -- 奖惩类型
    ,lastflag varchar2(2) -- 最近记录标志
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,recordnum number(38,0) -- 记录序号
    ,ts varchar2(29) -- 时间戳
    ,glbdef1 varchar2(192) -- 文号
    ,glbdef2 varchar2(192) -- 奖惩名称
    ,glbdef3 varchar2(30) -- 备用字段
    ,glbdef4 varchar2(30) -- 奖惩类别
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
grant select on ${iol_schema}.nhrs_hi_psndoc_enc to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_enc to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_enc to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_enc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_enc is '奖惩信息';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourdate is '奖惩日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourmatter is '奖惩事由';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourmeas is '奖励措施';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourorg is '奖励机构';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourrank is '奖励级别';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.encourtype is '奖惩类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.glbdef1 is '文号';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.glbdef2 is '奖惩名称';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.glbdef3 is '备用字段';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.glbdef4 is '奖惩类别';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_enc.etl_timestamp is 'ETL处理时间戳';
