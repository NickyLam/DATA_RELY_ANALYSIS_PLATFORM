/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_quota_adjust_back
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_quota_adjust_back
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_quota_adjust_back purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_quota_adjust_back(
    assetid varchar2(64) -- 授信流水号
    ,businesssum varchar2(200) -- 原授信额度
    ,applycreditamount varchar2(200) -- 申请调整后额度
    ,realcreditamount varchar2(20) -- 实际调整后额度
    ,expiredate varchar2(20) -- 额度失效日期，日期格式：YYYY-MM-DD
    ,lmtadstatus varchar2(20) -- 调额状态0：成功；1:失败
    ,increasefailreason varchar2(2000) -- 调额失败原因
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_lx_quota_adjust_back to ${iml_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust_back to ${icl_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust_back to ${idl_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust_back to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_quota_adjust_back is '乐信额度变更结果表';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.assetid is '授信流水号';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.businesssum is '原授信额度';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.applycreditamount is '申请调整后额度';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.realcreditamount is '实际调整后额度';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.expiredate is '额度失效日期，日期格式：YYYY-MM-DD';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.lmtadstatus is '调额状态0：成功；1:失败';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.increasefailreason is '调额失败原因';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_quota_adjust_back.etl_timestamp is 'ETL处理时间戳';
