/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharepledgeproportion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharepledgeproportion
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharepledgeproportion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharepledgeproportion(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_enddate varchar2(12) -- 截止日期
    ,s_pledge_num number(20,0) -- 质押笔数
    ,s_share_unrestricted_num number(20,4) -- 无限售股份质押数量
    ,s_share_restricted_num number(20,4) -- 有限售股份质押数量
    ,s_tot_shr number(20,4) -- A股总股本
    ,s_pledge_ratio number(20,4) -- 质押比例
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
grant select on ${iol_schema}.wind_asharepledgeproportion to ${iml_schema};
grant select on ${iol_schema}.wind_asharepledgeproportion to ${icl_schema};
grant select on ${iol_schema}.wind_asharepledgeproportion to ${idl_schema};
grant select on ${iol_schema}.wind_asharepledgeproportion to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharepledgeproportion is '中国A股股票质押比例';
comment on column ${iol_schema}.wind_asharepledgeproportion.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_enddate is '截止日期';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_pledge_num is '质押笔数';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_share_unrestricted_num is '无限售股份质押数量';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_share_restricted_num is '有限售股份质押数量';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_tot_shr is 'A股总股本';
comment on column ${iol_schema}.wind_asharepledgeproportion.s_pledge_ratio is '质押比例';
comment on column ${iol_schema}.wind_asharepledgeproportion.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharepledgeproportion.etl_timestamp is 'ETL处理时间戳';
