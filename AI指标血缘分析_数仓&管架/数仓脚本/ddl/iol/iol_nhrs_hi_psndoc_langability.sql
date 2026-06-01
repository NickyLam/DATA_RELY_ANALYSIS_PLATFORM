/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_langability
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_langability
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_langability purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_langability(
    certifcode varchar2(63) -- 证书编号
    ,certifdate varchar2(15) -- 获证日期
    ,certifname varchar2(288) -- 证书名称
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,langlev varchar2(192) -- 掌握语种水平的级别
    ,langskill varchar2(30) -- 语种熟练程度
    ,langsort varchar2(30) -- 语种
    ,lastflag varchar2(2) -- 最近记录标志
    ,memo varchar2(2304) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,recordnum number(38,0) -- 记录序号
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.nhrs_hi_psndoc_langability to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_langability to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_langability to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_langability to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_langability is '语言能力';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.certifcode is '证书编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.certifdate is '获证日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.certifname is '证书名称';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.langlev is '掌握语种水平的级别';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.langskill is '语种熟练程度';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.langsort is '语种';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_langability.etl_timestamp is 'ETL处理时间戳';
