/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_rate_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_rate_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_rate_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_rate_info(
    rateid varchar2(64) -- 利率代号
    ,status varchar2(12) -- 状态
    ,inputdate date -- 登记日期
    ,termunit varchar2(64) -- 利率周期单位
    ,rate number(15,8) -- 利率
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,ratetype varchar2(160) -- 利率名称
    ,term number(22) -- 利率周期
    ,remark varchar2(1000) -- 备注
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,currency varchar2(3) -- 币种
    ,efficientdate date -- 生效日期
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,rateunit varchar2(64) -- 利率单位
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
grant select on ${iol_schema}.icms_rate_info to ${iml_schema};
grant select on ${iol_schema}.icms_rate_info to ${icl_schema};
grant select on ${iol_schema}.icms_rate_info to ${idl_schema};
grant select on ${iol_schema}.icms_rate_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_rate_info is '利率表';
comment on column ${iol_schema}.icms_rate_info.rateid is '利率代号';
comment on column ${iol_schema}.icms_rate_info.status is '状态';
comment on column ${iol_schema}.icms_rate_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_rate_info.termunit is '利率周期单位';
comment on column ${iol_schema}.icms_rate_info.rate is '利率';
comment on column ${iol_schema}.icms_rate_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_rate_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_rate_info.ratetype is '利率名称';
comment on column ${iol_schema}.icms_rate_info.term is '利率周期';
comment on column ${iol_schema}.icms_rate_info.remark is '备注';
comment on column ${iol_schema}.icms_rate_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_rate_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_rate_info.currency is '币种';
comment on column ${iol_schema}.icms_rate_info.efficientdate is '生效日期';
comment on column ${iol_schema}.icms_rate_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_rate_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_rate_info.rateunit is '利率单位';
comment on column ${iol_schema}.icms_rate_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_rate_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_rate_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_rate_info.etl_timestamp is 'ETL处理时间戳';
