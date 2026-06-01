/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_family
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_family
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_family purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_family(
    approveflag number(38,0) -- 审批标志
    ,begindate varchar2(15) -- 起始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 终止日期
    ,lastflag varchar2(2) -- 最近记录标志
    ,mem_birthday varchar2(15) -- 出生日期
    ,mem_corp varchar2(1350) -- 工作单位
    ,mem_job varchar2(1350) -- 职务
    ,mem_name varchar2(113) -- 家庭成员姓名
    ,mem_relation varchar2(30) -- 与本人关系
    ,memo varchar2(2304) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,period varchar2(15) -- 期间
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,politics varchar2(30) -- 政治面貌
    ,profession varchar2(1350) -- 职业
    ,recordnum number(38,0) -- 记录序号
    ,relaaddr varchar2(1350) -- 联系地址
    ,relaphone varchar2(30) -- 联系电话
    ,ts varchar2(29) -- 时间戳
    ,glbdef1 number(22,0) -- 性别
    ,glbdef2 varchar2(30) -- 状态
    ,glbdef3 varchar2(192) -- 备用glbdef3
    ,glbdef4 varchar2(192) -- 学校/工作单位及职务
    ,glbdef5 varchar2(192) -- 户籍所在地
    ,glbdef7 varchar2(30) -- 备用glbdef7
    ,glbdef8 varchar2(192) -- 学历及学位
    ,glbdef6 varchar2(192) -- 证件号码
    ,glbdef9 varchar2(192) -- 备用glbdef9
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
grant select on ${iol_schema}.nhrs_hi_psndoc_family to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_family to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_family to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_family to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_family is '家庭信息';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.approveflag is '审批标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.begindate is '起始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.enddate is '终止日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.mem_birthday is '出生日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.mem_corp is '工作单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.mem_job is '职务';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.mem_name is '家庭成员姓名';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.mem_relation is '与本人关系';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.period is '期间';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.politics is '政治面貌';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.profession is '职业';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.relaaddr is '联系地址';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.relaphone is '联系电话';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef1 is '性别';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef2 is '状态';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef3 is '备用glbdef3';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef4 is '学校/工作单位及职务';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef5 is '户籍所在地';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef7 is '备用glbdef7';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef8 is '学历及学位';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef6 is '证件号码';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.glbdef9 is '备用glbdef9';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_family.etl_timestamp is 'ETL处理时间戳';
