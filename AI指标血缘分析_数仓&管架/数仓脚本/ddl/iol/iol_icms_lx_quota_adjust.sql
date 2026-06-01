/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_quota_adjust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_quota_adjust
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_quota_adjust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_quota_adjust(
    assetid varchar2(64) -- 授信流水号
    ,businesssum varchar2(200) -- 原授信额度
    ,presentcreditamount varchar2(200) -- 现调整额度
    ,effectdate varchar2(20) -- 额度生效日期
    ,expiredate varchar2(20) -- 额度失效日期
    ,increasereason varchar2(2000) -- 调额原因
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
grant select on ${iol_schema}.icms_lx_quota_adjust to ${iml_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust to ${icl_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust to ${idl_schema};
grant select on ${iol_schema}.icms_lx_quota_adjust to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_quota_adjust is '乐信额度变更表';
comment on column ${iol_schema}.icms_lx_quota_adjust.assetid is '授信流水号';
comment on column ${iol_schema}.icms_lx_quota_adjust.businesssum is '原授信额度';
comment on column ${iol_schema}.icms_lx_quota_adjust.presentcreditamount is '现调整额度';
comment on column ${iol_schema}.icms_lx_quota_adjust.effectdate is '额度生效日期';
comment on column ${iol_schema}.icms_lx_quota_adjust.expiredate is '额度失效日期';
comment on column ${iol_schema}.icms_lx_quota_adjust.increasereason is '调额原因';
comment on column ${iol_schema}.icms_lx_quota_adjust.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_quota_adjust.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_quota_adjust.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_quota_adjust.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_quota_adjust.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_quota_adjust.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_quota_adjust.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_quota_adjust.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_quota_adjust.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_quota_adjust.etl_timestamp is 'ETL处理时间戳';
