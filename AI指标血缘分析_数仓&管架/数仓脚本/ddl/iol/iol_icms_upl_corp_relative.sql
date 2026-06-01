/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_upl_corp_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_upl_corp_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_upl_corp_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_upl_corp_relative(
    orgid varchar2(32) -- 合作公司编码
    ,orgname varchar2(80) -- 合作公司名称
    ,belongorg varchar2(32) -- 所属机构
    ,updatedate varchar2(10) -- 更新日期
    ,inputorg varchar2(32) -- 录入机构
    ,inputdate varchar2(10) -- 录入日期
    ,migtflag varchar2(80) -- 
    ,status varchar2(10) -- 是否有效
    ,inputuser varchar2(32) -- 录入人
    ,updateuser varchar2(20) -- 更新人
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
grant select on ${iol_schema}.icms_upl_corp_relative to ${iml_schema};
grant select on ${iol_schema}.icms_upl_corp_relative to ${icl_schema};
grant select on ${iol_schema}.icms_upl_corp_relative to ${idl_schema};
grant select on ${iol_schema}.icms_upl_corp_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_upl_corp_relative is '微贷合作公司信息用于外数使用';
comment on column ${iol_schema}.icms_upl_corp_relative.orgid is '合作公司编码';
comment on column ${iol_schema}.icms_upl_corp_relative.orgname is '合作公司名称';
comment on column ${iol_schema}.icms_upl_corp_relative.belongorg is '所属机构';
comment on column ${iol_schema}.icms_upl_corp_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_upl_corp_relative.inputorg is '录入机构';
comment on column ${iol_schema}.icms_upl_corp_relative.inputdate is '录入日期';
comment on column ${iol_schema}.icms_upl_corp_relative.migtflag is '';
comment on column ${iol_schema}.icms_upl_corp_relative.status is '是否有效';
comment on column ${iol_schema}.icms_upl_corp_relative.inputuser is '录入人';
comment on column ${iol_schema}.icms_upl_corp_relative.updateuser is '更新人';
comment on column ${iol_schema}.icms_upl_corp_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_upl_corp_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_upl_corp_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_upl_corp_relative.etl_timestamp is 'ETL处理时间戳';
