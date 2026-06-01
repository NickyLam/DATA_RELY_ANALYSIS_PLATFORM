/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareequitypledgeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareequitypledgeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareequitypledgeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareequitypledgeinfo(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,s_pledge_bgdate varchar2(12) -- 质押起始时间
    ,s_pledge_enddate varchar2(12) -- 质押结束时间
    ,s_holder_name varchar2(300) -- 股东名称
    ,s_pledge_shares number(20,4) -- 质押数量(万股)
    ,s_pledgor varchar2(300) -- 质押方
    ,s_discharge_date varchar2(12) -- 解押日期
    ,s_remark varchar2(3000) -- 备注
    ,is_discharge number(1,0) -- 是否解押
    ,s_holder_type_code number(9,0) -- 股东类型代码
    ,s_holder_id varchar2(15) -- 股东ID
    ,s_pledgor_type_code number(9,0) -- 质押方类型代码
    ,s_pledgor_id varchar2(15) -- 质押方ID
    ,s_shr_category_code number(9,0) -- 股份性质类别代码
    ,s_total_holding_shr number(20,4) -- 持股总数
    ,s_total_pledge_shr number(20,4) -- 累计质押股数
    ,s_pledge_shr_ratio number(20,4) -- 本次质押股数占公司总股本比例
    ,s_total_holding_shr_ratio number(20,4) -- 持股总数占公司总股本比例
    ,is_equity_pledge_repo number(1,0) -- 是否股权质押回购
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
grant select on ${iol_schema}.wind_ashareequitypledgeinfo to ${iml_schema};
grant select on ${iol_schema}.wind_ashareequitypledgeinfo to ${icl_schema};
grant select on ${iol_schema}.wind_ashareequitypledgeinfo to ${idl_schema};
grant select on ${iol_schema}.wind_ashareequitypledgeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareequitypledgeinfo is '中国A股股权质押信息';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledge_bgdate is '质押起始时间';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledge_enddate is '质押结束时间';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_holder_name is '股东名称';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledge_shares is '质押数量(万股)';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledgor is '质押方';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_discharge_date is '解押日期';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_remark is '备注';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.is_discharge is '是否解押';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_holder_type_code is '股东类型代码';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_holder_id is '股东ID';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledgor_type_code is '质押方类型代码';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledgor_id is '质押方ID';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_shr_category_code is '股份性质类别代码';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_total_holding_shr is '持股总数';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_total_pledge_shr is '累计质押股数';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_pledge_shr_ratio is '本次质押股数占公司总股本比例';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.s_total_holding_shr_ratio is '持股总数占公司总股本比例';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.is_equity_pledge_repo is '是否股权质押回购';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareequitypledgeinfo.etl_timestamp is 'ETL处理时间戳';
