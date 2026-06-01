/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_lx_quota_adjust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_lx_quota_adjust
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_lx_quota_adjust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_lx_quota_adjust(
    assetid varchar2(64) -- 授信流水号
    ,businesssum varchar2(200) -- 原授信额度
    ,presentcreditamount varchar2(200) -- 现调整额度
    ,effectdate varchar2(20) -- 额度生效日期
    ,expiredate varchar2(20) -- 额度失效日期
    ,increasereason varchar2(2000) -- 调额原因
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
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_lx_quota_adjust to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_lx_quota_adjust is '乐信额度变更中间表';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.assetid is '授信流水号';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.businesssum is '原授信额度';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.presentcreditamount is '现调整额度';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.effectdate is '额度生效日期';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.expiredate is '额度失效日期';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.increasereason is '调额原因';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_lx_quota_adjust.etl_timestamp is 'ETL处理时间戳';
