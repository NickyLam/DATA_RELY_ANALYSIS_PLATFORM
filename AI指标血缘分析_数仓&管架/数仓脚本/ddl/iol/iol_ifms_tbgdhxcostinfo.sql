/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgdhxcostinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgdhxcostinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgdhxcostinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgdhxcostinfo(
    ta_code varchar2(14) -- ta代码
    ,cfm_date number(22,0) -- 确认日期
    ,cfm_no varchar2(48) -- 确认流水号
    ,old_tot_vol number(18,2) -- 原总份额
    ,bag_cost number(18,2) -- 累计流出资金对应的成本
    ,total_cost number(18,2) -- 累计投入成本
    ,rest_cost number(18,2) -- 赎回或到期成本=赎回或到期确认的份额*持仓成本/当天确认前客户持有的总份额
    ,amt1 number(18,2) -- 备份金额1
    ,amt2 number(18,2) -- 备份金额2
    ,amt3 number(18,2) -- 备份金额3
    ,reserve1 varchar2(375) -- 备份字段1
    ,reserve2 varchar2(375) -- 备份字段2
    ,reserve3 varchar2(375) -- 备份字段3
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
grant select on ${iol_schema}.ifms_tbgdhxcostinfo to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgdhxcostinfo to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgdhxcostinfo to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgdhxcostinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgdhxcostinfo is '华兴银行赎回成本信息表';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.ta_code is 'ta代码';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.cfm_date is '确认日期';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.cfm_no is '确认流水号';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.old_tot_vol is '原总份额';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.bag_cost is '累计流出资金对应的成本';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.total_cost is '累计投入成本';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.rest_cost is '赎回或到期成本=赎回或到期确认的份额*持仓成本/当天确认前客户持有的总份额';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.amt1 is '备份金额1';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.amt2 is '备份金额2';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.amt3 is '备份金额3';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.reserve1 is '备份字段1';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.reserve2 is '备份字段2';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.reserve3 is '备份字段3';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbgdhxcostinfo.etl_timestamp is 'ETL处理时间戳';
