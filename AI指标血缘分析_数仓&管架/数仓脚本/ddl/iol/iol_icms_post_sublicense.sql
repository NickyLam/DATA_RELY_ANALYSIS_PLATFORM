/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_post_sublicense
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_post_sublicense
whenever sqlerror continue none;
drop table ${iol_schema}.icms_post_sublicense purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_post_sublicense(
    serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,isauthorizeruserid varchar2(32) -- 被授权用户
    ,corporgid varchar2(64) -- 法人机构编号
    ,remark varchar2(2000) -- 备注
    ,authorizerroleid varchar2(64) -- 授权角色
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,sublicenseeffectivedate date -- 转授权生效日
    ,sublicensereason varchar2(2000) -- 转授权原因
    ,inputuserid varchar2(64) -- 登记人
    ,sublicenseinvaliddate date -- 转授权失效日
    ,inputdate date -- 登记日期
    ,authorizeruserid varchar2(32) -- 授权用户
    ,isauthorizerroleid varchar2(64) -- 被授权角色
    ,inputorgid varchar2(64) -- 登记机构
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
grant select on ${iol_schema}.icms_post_sublicense to ${iml_schema};
grant select on ${iol_schema}.icms_post_sublicense to ${icl_schema};
grant select on ${iol_schema}.icms_post_sublicense to ${idl_schema};
grant select on ${iol_schema}.icms_post_sublicense to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_post_sublicense is '岗位转授权';
comment on column ${iol_schema}.icms_post_sublicense.serialno is '流水号';
comment on column ${iol_schema}.icms_post_sublicense.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_post_sublicense.isauthorizeruserid is '被授权用户';
comment on column ${iol_schema}.icms_post_sublicense.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_post_sublicense.remark is '备注';
comment on column ${iol_schema}.icms_post_sublicense.authorizerroleid is '授权角色';
comment on column ${iol_schema}.icms_post_sublicense.updatedate is '更新日期';
comment on column ${iol_schema}.icms_post_sublicense.updateuserid is '更新人';
comment on column ${iol_schema}.icms_post_sublicense.sublicenseeffectivedate is '转授权生效日';
comment on column ${iol_schema}.icms_post_sublicense.sublicensereason is '转授权原因';
comment on column ${iol_schema}.icms_post_sublicense.inputuserid is '登记人';
comment on column ${iol_schema}.icms_post_sublicense.sublicenseinvaliddate is '转授权失效日';
comment on column ${iol_schema}.icms_post_sublicense.inputdate is '登记日期';
comment on column ${iol_schema}.icms_post_sublicense.authorizeruserid is '授权用户';
comment on column ${iol_schema}.icms_post_sublicense.isauthorizerroleid is '被授权角色';
comment on column ${iol_schema}.icms_post_sublicense.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_post_sublicense.start_dt is '开始时间';
comment on column ${iol_schema}.icms_post_sublicense.end_dt is '结束时间';
comment on column ${iol_schema}.icms_post_sublicense.id_mark is '增删标志';
comment on column ${iol_schema}.icms_post_sublicense.etl_timestamp is 'ETL处理时间戳';
