/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_linkman
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_linkman
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_linkman(
    creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,email varchar2(75) -- 电子邮件
    ,fax varchar2(45) -- 传真
    ,homephone varchar2(45) -- 家庭电话
    ,ismain varchar2(2) -- 是否主要联系人
    ,lastflag varchar2(2) -- 最近记录标志
    ,linkaddr varchar2(576) -- 联系地址
    ,linkman varchar2(450) -- 联系人
    ,mobile varchar2(45) -- 手机
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,officephone varchar2(45) -- 办公电话
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,pk_psnorg varchar2(30) -- 组织关系主键
    ,postalcode varchar2(30) -- 邮政编码
    ,recordnum number(38,0) -- 记录序号
    ,relation varchar2(288) -- 与联系人关系
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
grant select on ${iol_schema}.nhrs_hi_psndoc_linkman to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_linkman to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_linkman to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_linkman to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_linkman is '紧急联系人';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.email is '电子邮件';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.fax is '传真';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.homephone is '家庭电话';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.ismain is '是否主要联系人';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.linkaddr is '联系地址';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.linkman is '联系人';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.mobile is '手机';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.officephone is '办公电话';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.postalcode is '邮政编码';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.relation is '与联系人关系';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_linkman.etl_timestamp is 'ETL处理时间戳';
