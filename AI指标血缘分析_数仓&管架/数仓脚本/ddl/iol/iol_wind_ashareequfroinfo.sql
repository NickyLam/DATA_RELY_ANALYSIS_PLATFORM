/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareequfroinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareequfroinfo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareequfroinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareequfroinfo(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,ann_date varchar2(12) -- 公告日期
    ,s_fro_bgdate varchar2(12) -- 冻结起始时间
    ,s_fro_enddate varchar2(12) -- 冻结结束时间
    ,s_holder_name varchar2(300) -- 股东名称
    ,s_fro_shares number(20,4) -- 冻结数量(万股)
    ,frozen_institution varchar2(300) -- 执行冻结机构
    ,disfrozen_time varchar2(12) -- 解冻日期
    ,s_holder_type_code number(9,0) -- 股东类型代码
    ,s_holder_id varchar2(15) -- 股东ID
    ,shr_category_code number(9,0) -- 股份性质类别代码
    ,is_turn_frozen number(1,0) -- 是否轮候冻结
    ,is_disfrozen number(1,0) -- 是否解冻
    ,s_total_holding_shr number(20,4) -- 持股总数（万股）
    ,s_fro_shr_ratio number(20,4) -- 本次冻结股数占公司总股本比例
    ,s_total_holding_shr_ratio number(20,4) -- 持股总数占公司总股本比例
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
grant select on ${iol_schema}.wind_ashareequfroinfo to ${iml_schema};
grant select on ${iol_schema}.wind_ashareequfroinfo to ${icl_schema};
grant select on ${iol_schema}.wind_ashareequfroinfo to ${idl_schema};
grant select on ${iol_schema}.wind_ashareequfroinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareequfroinfo is '中国A股股权冻结信息';
comment on column ${iol_schema}.wind_ashareequfroinfo.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_ashareequfroinfo.ann_date is '公告日期';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_fro_bgdate is '冻结起始时间';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_fro_enddate is '冻结结束时间';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_holder_name is '股东名称';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_fro_shares is '冻结数量(万股)';
comment on column ${iol_schema}.wind_ashareequfroinfo.frozen_institution is '执行冻结机构';
comment on column ${iol_schema}.wind_ashareequfroinfo.disfrozen_time is '解冻日期';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_holder_type_code is '股东类型代码';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_holder_id is '股东ID';
comment on column ${iol_schema}.wind_ashareequfroinfo.shr_category_code is '股份性质类别代码';
comment on column ${iol_schema}.wind_ashareequfroinfo.is_turn_frozen is '是否轮候冻结';
comment on column ${iol_schema}.wind_ashareequfroinfo.is_disfrozen is '是否解冻';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_total_holding_shr is '持股总数（万股）';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_fro_shr_ratio is '本次冻结股数占公司总股本比例';
comment on column ${iol_schema}.wind_ashareequfroinfo.s_total_holding_shr_ratio is '持股总数占公司总股本比例';
comment on column ${iol_schema}.wind_ashareequfroinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareequfroinfo.etl_timestamp is 'ETL处理时间戳';
