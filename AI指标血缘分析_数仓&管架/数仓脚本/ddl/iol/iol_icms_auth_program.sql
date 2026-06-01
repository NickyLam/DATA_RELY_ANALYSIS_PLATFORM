/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_auth_program
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_auth_program
whenever sqlerror continue none;
drop table ${iol_schema}.icms_auth_program purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_program(
    programid varchar2(32) -- 方案编号
    ,corporgid varchar2(32) -- 法人机构编号
    ,programstartdate date -- 方案起始日
    ,inputorgid varchar2(32) -- 登记机构
    ,flows varchar2(2000) -- 流程
    ,groupid varchar2(32) -- 方案组编号
    ,inputuserid varchar2(32) -- 登记人
    ,authorizetype varchar2(18) -- 授权类型
    ,programenddate date -- 方案到期日
    ,programname varchar2(80) -- 方案名称
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,isinuse varchar2(32) -- 有效状态
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,orglevel varchar2(18) -- 机构类型
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
grant select on ${iol_schema}.icms_auth_program to ${iml_schema};
grant select on ${iol_schema}.icms_auth_program to ${icl_schema};
grant select on ${iol_schema}.icms_auth_program to ${idl_schema};
grant select on ${iol_schema}.icms_auth_program to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_auth_program is '授权方案授权方案';
comment on column ${iol_schema}.icms_auth_program.programid is '方案编号';
comment on column ${iol_schema}.icms_auth_program.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_auth_program.programstartdate is '方案起始日';
comment on column ${iol_schema}.icms_auth_program.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_auth_program.flows is '流程';
comment on column ${iol_schema}.icms_auth_program.groupid is '方案组编号';
comment on column ${iol_schema}.icms_auth_program.inputuserid is '登记人';
comment on column ${iol_schema}.icms_auth_program.authorizetype is '授权类型';
comment on column ${iol_schema}.icms_auth_program.programenddate is '方案到期日';
comment on column ${iol_schema}.icms_auth_program.programname is '方案名称';
comment on column ${iol_schema}.icms_auth_program.remark is '备注';
comment on column ${iol_schema}.icms_auth_program.inputdate is '登记日期';
comment on column ${iol_schema}.icms_auth_program.updateuserid is '更新人';
comment on column ${iol_schema}.icms_auth_program.isinuse is '有效状态';
comment on column ${iol_schema}.icms_auth_program.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_auth_program.updatedate is '更新日期';
comment on column ${iol_schema}.icms_auth_program.orglevel is '机构类型';
comment on column ${iol_schema}.icms_auth_program.start_dt is '开始时间';
comment on column ${iol_schema}.icms_auth_program.end_dt is '结束时间';
comment on column ${iol_schema}.icms_auth_program.id_mark is '增删标志';
comment on column ${iol_schema}.icms_auth_program.etl_timestamp is 'ETL处理时间戳';
