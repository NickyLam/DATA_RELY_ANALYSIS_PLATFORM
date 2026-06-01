/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_redem_cost_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_redem_cost_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_redem_cost_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_redem_cost_info_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,cfm_dt date -- 确认日期
    ,cfm_flow_num varchar2(60) -- 确认流水号
    ,init_tot_lot number(30,2) -- 原总份额
    ,acm_flow_contri_gold_cors_cost number(30,2) -- 累计流出资金对应成本
    ,acm_put_into_cost number(30,2) -- 累计投入成本
    ,redem_or_exp_cost number(30,2) -- 赎回或到期成本
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
grant select on ${iml_schema}.evt_finc_redem_cost_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_finc_redem_cost_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_finc_redem_cost_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_redem_cost_info_h is '理财赎回成本信息历史';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.cfm_flow_num is '确认流水号';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.init_tot_lot is '原总份额';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.acm_flow_contri_gold_cors_cost is '累计流出资金对应成本';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.acm_put_into_cost is '累计投入成本';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.redem_or_exp_cost is '赎回或到期成本';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_redem_cost_info_h.etl_timestamp is 'ETL处理时间戳';
