/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_lx_quota_adjust_back
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_lx_quota_adjust_back
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_lx_quota_adjust_back purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_lx_quota_adjust_back(
    assetid varchar2(64) -- 授信流水号
    ,businesssum varchar2(200) -- 原授信额度
    ,applycreditamount varchar2(200) -- 申请调整后额度
    ,realcreditamount varchar2(20) -- 实际调整后额度
    ,expiredate varchar2(20) -- 额度失效日期，日期格式：YYYY-MM-DD
    ,lmtadstatus varchar2(20) -- 调额状态0：成功；1:失败
    ,increasefailreason varchar2(2000) -- 调额失败原因
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust_back to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust_back to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust_back to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust_back to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_lx_quota_adjust_back is '乐信额度变更结果中间表';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.assetid is '授信流水号';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.businesssum is '原授信额度';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.applycreditamount is '申请调整后额度';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.realcreditamount is '实际调整后额度';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.expiredate is '额度失效日期，日期格式：YYYY-MM-DD';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.lmtadstatus is '调额状态0：成功；1:失败';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.increasefailreason is '调额失败原因';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust_back.etl_timestamp is 'ETL处理时间戳';
