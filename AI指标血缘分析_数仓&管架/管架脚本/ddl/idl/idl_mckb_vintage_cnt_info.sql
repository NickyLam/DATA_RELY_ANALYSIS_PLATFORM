/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_vintage_cnt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_vintage_cnt_info
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_vintage_cnt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_vintage_cnt_info(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,month_due varchar2(10) -- 统计月
    ,vintage3plus_mob1_cnt number(20) -- Mob1_vintage3+逾期人数
    ,vintage3plus_mob2_cnt number(20) -- Mob2_vintage3+逾期人数
    ,vintage3plus_mob3_cnt number(20) -- Mob3_vintage3+逾期人数
    ,vintage7plus_mob1_cnt number(20) -- Mob1_vintage7+逾期人数
    ,vintage7plus_mob2_cnt number(20) -- Mob2_vintage7+逾期人数
    ,vintage7plus_mob3_cnt number(20) -- Mob3_vintage7+逾期人数
    ,vintage30plus_mob1_cnt number(20) -- Mob1_vintage30+逾期人数
    ,vintage30plus_mob2_cnt number(20) -- Mob2_vintage30+逾期人数
    ,vintage30plus_mob3_cnt number(20) -- Mob3_vintage30+逾期人数
    ,prod_cls_name varchar2(150) -- 产品分类(易贷，字节)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_vintage_cnt_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_vintage_cnt_info is 'vintage_笔数维度';
comment on column ${idl_schema}.mckb_vintage_cnt_info.org_id is '机构编号';
comment on column ${idl_schema}.mckb_vintage_cnt_info.org_name is '机构名称';
comment on column ${idl_schema}.mckb_vintage_cnt_info.month_due is '统计月';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage3plus_mob1_cnt is 'Mob1_vintage3+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage3plus_mob2_cnt is 'Mob2_vintage3+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage3plus_mob3_cnt is 'Mob3_vintage3+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage7plus_mob1_cnt is 'Mob1_vintage7+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage7plus_mob2_cnt is 'Mob2_vintage7+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage7plus_mob3_cnt is 'Mob3_vintage7+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage30plus_mob1_cnt is 'Mob1_vintage30+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage30plus_mob2_cnt is 'Mob2_vintage30+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.vintage30plus_mob3_cnt is 'Mob3_vintage30+逾期人数';
comment on column ${idl_schema}.mckb_vintage_cnt_info.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_vintage_cnt_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_vintage_cnt_info.etl_timestamp is 'ETL处理时间戳';