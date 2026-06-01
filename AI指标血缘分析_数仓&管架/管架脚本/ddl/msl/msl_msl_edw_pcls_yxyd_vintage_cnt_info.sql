/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_vintage_cnt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info(
    etl_dt date
    ,month_loan varchar2(4000)
    ,vintage3plus_mob1_cnt number(38,6)
    ,vintage3plus_mob2_cnt number(38,6)
    ,vintage3plus_mob3_cnt number(38,6)
    ,vintage7plus_mob1_cnt number(38,6)
    ,vintage7plus_mob2_cnt number(38,6)
    ,vintage7plus_mob3_cnt number(38,6)
    ,vintage30plus_mob1_cnt number(38,6)
    ,vintage30plus_mob2_cnt number(38,6)
    ,vintage30plus_mob3_cnt number(38,6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info is '好易贷人数账龄分析表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.month_loan is '统计月';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage3plus_mob1_cnt is 'Mob1_vintage3+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage3plus_mob2_cnt is 'Mob2_vintage3+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage3plus_mob3_cnt is 'Mob3_vintage3+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage7plus_mob1_cnt is 'Mob1_vintage7+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage7plus_mob2_cnt is 'Mob2_vintage7+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage7plus_mob3_cnt is 'Mob3_vintage7+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage30plus_mob1_cnt is 'Mob1_vintage30+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage30plus_mob2_cnt is 'Mob2_vintage30+逾期人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_vintage_cnt_info.vintage30plus_mob3_cnt is 'Mob3_vintage30+逾期人数';
