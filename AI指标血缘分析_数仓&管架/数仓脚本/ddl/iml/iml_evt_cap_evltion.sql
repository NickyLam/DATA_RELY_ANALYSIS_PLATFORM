/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_evltion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_evltion
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_evltion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_evltion(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,evltion_dt date -- 估值日期
    ,asset_bal_id varchar2(60) -- 资产余额编号
    ,post_qtty number(18,0) -- 持仓数量
    ,book_evltion number(30,2) -- 账面估值
    ,market_evltion number(30,2) -- 市场估值
    ,evha_val_chag number(30,2) -- 公允价值变动
    ,fair_price_dt date -- 公允价格日期
    ,fair_price number(18,12) -- 公允价格
    ,price_src_cd varchar2(10) -- 价格来源代码
    ,acct_b_id varchar2(60) -- 账簿编号
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,main_asset_id varchar2(60) -- 主资产编号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_cap_evltion to ${icl_schema};
grant select on ${iml_schema}.evt_cap_evltion to ${idl_schema};
grant select on ${iml_schema}.evt_cap_evltion to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_evltion is '资金估值事件';
comment on column ${iml_schema}.evt_cap_evltion.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_evltion.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_evltion.bus_id is '业务编号';
comment on column ${iml_schema}.evt_cap_evltion.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_cap_evltion.dept_id is '部门编号';
comment on column ${iml_schema}.evt_cap_evltion.evltion_dt is '估值日期';
comment on column ${iml_schema}.evt_cap_evltion.asset_bal_id is '资产余额编号';
comment on column ${iml_schema}.evt_cap_evltion.post_qtty is '持仓数量';
comment on column ${iml_schema}.evt_cap_evltion.book_evltion is '账面估值';
comment on column ${iml_schema}.evt_cap_evltion.market_evltion is '市场估值';
comment on column ${iml_schema}.evt_cap_evltion.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.evt_cap_evltion.fair_price_dt is '公允价格日期';
comment on column ${iml_schema}.evt_cap_evltion.fair_price is '公允价格';
comment on column ${iml_schema}.evt_cap_evltion.price_src_cd is '价格来源代码';
comment on column ${iml_schema}.evt_cap_evltion.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_cap_evltion.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.evt_cap_evltion.main_asset_id is '主资产编号';
comment on column ${iml_schema}.evt_cap_evltion.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cap_evltion.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_evltion.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_evltion.etl_timestamp is 'ETL处理时间戳';
