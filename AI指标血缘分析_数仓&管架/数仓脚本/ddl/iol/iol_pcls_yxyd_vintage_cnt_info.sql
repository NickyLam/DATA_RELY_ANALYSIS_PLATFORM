/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_yxyd_vintage_cnt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_yxyd_vintage_cnt_info
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_yxyd_vintage_cnt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_yxyd_vintage_cnt_info(
    month_loan varchar2(4000) -- 统计月
    ,vintage3plus_mob1_cnt number(38,6) -- Mob1_vintage3+逾期人数
    ,vintage3plus_mob2_cnt number(38,6) -- Mob2_vintage3+逾期人数
    ,vintage3plus_mob3_cnt number(38,6) -- Mob3_vintage3+逾期人数
    ,vintage7plus_mob1_cnt number(38,6) -- Mob1_vintage7+逾期人数
    ,vintage7plus_mob2_cnt number(38,6) -- Mob2_vintage7+逾期人数
    ,vintage7plus_mob3_cnt number(38,6) -- Mob3_vintage7+逾期人数
    ,vintage30plus_mob1_cnt number(38,6) -- Mob1_vintage30+逾期人数
    ,vintage30plus_mob2_cnt number(38,6) -- Mob2_vintage30+逾期人数
    ,vintage30plus_mob3_cnt number(38,6) -- Mob3_vintage30+逾期人数
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
grant select on ${iol_schema}.pcls_yxyd_vintage_cnt_info to ${iml_schema};
grant select on ${iol_schema}.pcls_yxyd_vintage_cnt_info to ${icl_schema};
grant select on ${iol_schema}.pcls_yxyd_vintage_cnt_info to ${idl_schema};
grant select on ${iol_schema}.pcls_yxyd_vintage_cnt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_yxyd_vintage_cnt_info is '好易贷人数账龄分析表';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.month_loan is '统计月';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage3plus_mob1_cnt is 'Mob1_vintage3+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage3plus_mob2_cnt is 'Mob2_vintage3+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage3plus_mob3_cnt is 'Mob3_vintage3+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage7plus_mob1_cnt is 'Mob1_vintage7+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage7plus_mob2_cnt is 'Mob2_vintage7+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage7plus_mob3_cnt is 'Mob3_vintage7+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage30plus_mob1_cnt is 'Mob1_vintage30+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage30plus_mob2_cnt is 'Mob2_vintage30+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.vintage30plus_mob3_cnt is 'Mob3_vintage30+逾期人数';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_yxyd_vintage_cnt_info.etl_timestamp is 'ETL处理时间戳';
