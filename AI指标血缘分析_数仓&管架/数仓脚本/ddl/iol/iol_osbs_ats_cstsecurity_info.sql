/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ats_cstsecurity_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ats_cstsecurity_info
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ats_cstsecurity_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_cstsecurity_info(
    aci_cstno varchar2(32) -- 客户号
    ,aci_userno varchar2(32) -- 用户号
    ,aci_securityno varchar2(12) -- 安全工具编号
    ,aci_securityname varchar2(30) -- 安全工具名称
    ,aci_security varchar2(1) -- 安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)
    ,aci_securitylevel varchar2(1) -- 安全等级
    ,aci_status varchar2(1) -- 状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)
    ,aci_createtime varchar2(14) -- 创建时间
    ,aci_updatetime varchar2(14) -- 修改时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_ats_cstsecurity_info to ${iml_schema};
grant select on ${iol_schema}.osbs_ats_cstsecurity_info to ${icl_schema};
grant select on ${iol_schema}.osbs_ats_cstsecurity_info to ${idl_schema};
grant select on ${iol_schema}.osbs_ats_cstsecurity_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ats_cstsecurity_info is '客户安全工具信息表';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_cstno is '客户号';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_userno is '用户号';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_securityno is '安全工具编号';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_securityname is '安全工具名称';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_security is '安全工具(1:华兴U盾,2:手机短信密码,5:人脸识别,6:短信+人脸识别,7:手机云盾)';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_securitylevel is '安全等级';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_status is '状态(0:正常,1:注销,2:已下载,3:未绑定,4:冻结,5:未下载,6:不可用)';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_createtime is '创建时间';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.aci_updatetime is '修改时间';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_ats_cstsecurity_info.etl_timestamp is 'ETL处理时间戳';
