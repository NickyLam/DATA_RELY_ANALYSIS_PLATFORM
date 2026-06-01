/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_provi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_provi
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_provi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_provi(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,provi_dt date -- 计提日期
    ,init_asset_bal_id varchar2(60) -- 原资产余额编号
    ,post_qtty number(18,0) -- 持仓数量
    ,currt_int_recvbl number(30,8) -- 当期应收利息
    ,ld_int_recvbl number(30,8) -- 上日应收利息
    ,today_provi_int number(30,8) -- 本日计提利息
    ,currt_acru_int number(30,8) -- 当期应计利息
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
grant select on ${iml_schema}.evt_cap_provi to ${icl_schema};
grant select on ${iml_schema}.evt_cap_provi to ${idl_schema};
grant select on ${iml_schema}.evt_cap_provi to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_provi is '资金计提事件';
comment on column ${iml_schema}.evt_cap_provi.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_provi.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_provi.bus_id is '业务编号';
comment on column ${iml_schema}.evt_cap_provi.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_cap_provi.dept_id is '部门编号';
comment on column ${iml_schema}.evt_cap_provi.provi_dt is '计提日期';
comment on column ${iml_schema}.evt_cap_provi.init_asset_bal_id is '原资产余额编号';
comment on column ${iml_schema}.evt_cap_provi.post_qtty is '持仓数量';
comment on column ${iml_schema}.evt_cap_provi.currt_int_recvbl is '当期应收利息';
comment on column ${iml_schema}.evt_cap_provi.ld_int_recvbl is '上日应收利息';
comment on column ${iml_schema}.evt_cap_provi.today_provi_int is '本日计提利息';
comment on column ${iml_schema}.evt_cap_provi.currt_acru_int is '当期应计利息';
comment on column ${iml_schema}.evt_cap_provi.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_cap_provi.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.evt_cap_provi.main_asset_id is '主资产编号';
comment on column ${iml_schema}.evt_cap_provi.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cap_provi.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_provi.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_provi.etl_timestamp is 'ETL处理时间戳';
