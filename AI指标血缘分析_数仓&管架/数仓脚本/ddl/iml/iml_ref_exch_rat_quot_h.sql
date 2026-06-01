/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_exch_rat_quot_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_exch_rat_quot_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_exch_rat_quot_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_exch_rat_quot_h(
    exch_rat_type_cd varchar2(30) -- 汇率类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,org_id varchar2(100) -- 机构编号
    ,effect_dt date -- 生效日期
    ,effect_tm timestamp -- 生效时间
    ,lp_id varchar2(100) -- 法人编号
    ,quot_type_cd varchar2(30) -- 牌价类型代码
    ,realtm_exch_rat_exch_buy_price number(18,8) -- 实时汇率汇买价
    ,realtm_exch_rat_exch_sell_price number(18,8) -- 实时汇率汇卖价
    ,exch_rat_mdl_price number(18,8) -- 汇率中间价
    ,fcurr_cash_buy_price number(18,8) -- 外币钞买价
    ,fcurr_cash_sell_price number(18,8) -- 外币钞卖价
    ,max_float_point number(18,8) -- 最大浮动点数
    ,base_exch_rat number(18,8) -- 央行参考汇率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_exch_rat_quot_h to ${icl_schema};
grant select on ${iml_schema}.ref_exch_rat_quot_h to ${idl_schema};
grant select on ${iml_schema}.ref_exch_rat_quot_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_exch_rat_quot_h is '汇率牌价历史';
comment on column ${iml_schema}.ref_exch_rat_quot_h.exch_rat_type_cd is '汇率类型代码';
comment on column ${iml_schema}.ref_exch_rat_quot_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_exch_rat_quot_h.org_id is '机构编号';
comment on column ${iml_schema}.ref_exch_rat_quot_h.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_exch_rat_quot_h.effect_tm is '生效时间';
comment on column ${iml_schema}.ref_exch_rat_quot_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_exch_rat_quot_h.quot_type_cd is '牌价类型代码';
comment on column ${iml_schema}.ref_exch_rat_quot_h.realtm_exch_rat_exch_buy_price is '实时汇率汇买价';
comment on column ${iml_schema}.ref_exch_rat_quot_h.realtm_exch_rat_exch_sell_price is '实时汇率汇卖价';
comment on column ${iml_schema}.ref_exch_rat_quot_h.exch_rat_mdl_price is '汇率中间价';
comment on column ${iml_schema}.ref_exch_rat_quot_h.fcurr_cash_buy_price is '外币钞买价';
comment on column ${iml_schema}.ref_exch_rat_quot_h.fcurr_cash_sell_price is '外币钞卖价';
comment on column ${iml_schema}.ref_exch_rat_quot_h.max_float_point is '最大浮动点数';
comment on column ${iml_schema}.ref_exch_rat_quot_h.base_exch_rat is '央行参考汇率';
comment on column ${iml_schema}.ref_exch_rat_quot_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_exch_rat_quot_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_exch_rat_quot_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_exch_rat_quot_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_exch_rat_quot_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_exch_rat_quot_h.etl_timestamp is 'ETL处理时间戳';
