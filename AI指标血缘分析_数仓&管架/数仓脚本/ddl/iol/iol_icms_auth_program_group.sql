/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_auth_program_group
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_auth_program_group
whenever sqlerror continue none;
drop table ${iol_schema}.icms_auth_program_group purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_program_group(
    groupid varchar2(32) -- 方案组编号
    ,updateorgid varchar2(32) -- 更新机构
    ,authortype varchar2(32) -- 授权种类
    ,updatedate date -- 更新日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,isinuse varchar2(18) -- 有效状态
    ,remark varchar2(1000) -- 备注
    ,updateuserid varchar2(32) -- 更新人
    ,corporgid varchar2(32) -- 法人机构编号
    ,groupname varchar2(80) -- 方案组名称
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_auth_program_group to ${iml_schema};
grant select on ${iol_schema}.icms_auth_program_group to ${icl_schema};
grant select on ${iol_schema}.icms_auth_program_group to ${idl_schema};
grant select on ${iol_schema}.icms_auth_program_group to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_auth_program_group is '授权方案组授权方案组';
comment on column ${iol_schema}.icms_auth_program_group.groupid is '方案组编号';
comment on column ${iol_schema}.icms_auth_program_group.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_auth_program_group.authortype is '授权种类';
comment on column ${iol_schema}.icms_auth_program_group.updatedate is '更新日期';
comment on column ${iol_schema}.icms_auth_program_group.inputuserid is '登记人';
comment on column ${iol_schema}.icms_auth_program_group.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_auth_program_group.isinuse is '有效状态';
comment on column ${iol_schema}.icms_auth_program_group.remark is '备注';
comment on column ${iol_schema}.icms_auth_program_group.updateuserid is '更新人';
comment on column ${iol_schema}.icms_auth_program_group.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_auth_program_group.groupname is '方案组名称';
comment on column ${iol_schema}.icms_auth_program_group.inputdate is '登记日期';
comment on column ${iol_schema}.icms_auth_program_group.start_dt is '开始时间';
comment on column ${iol_schema}.icms_auth_program_group.end_dt is '结束时间';
comment on column ${iol_schema}.icms_auth_program_group.id_mark is '增删标志';
comment on column ${iol_schema}.icms_auth_program_group.etl_timestamp is 'ETL处理时间戳';
