/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_and_cap_prod_evltion_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_dt date -- 跑批日期
    ,comb_prod_cd_descb varchar2(60) -- 组合产品代码描述
    ,fin_prod_cd_descb varchar2(100) -- 金融产品代码描述
    ,invest_aim_cd varchar2(100) -- 投资目的代码
    ,curr_cd varchar2(100) -- 币种代码
    ,asset_qtty number(30,8) -- 资产数量
    ,evha_val_chag number(30,8) -- 公允价值变动
    ,amort_tot_cost number(30,8) -- 摊销总成本
    ,amort_cost_net_price number(30,14) -- 摊销成本净价
    ,td_acru_int number(30,8) -- 当日应计利息
    ,create_tm timestamp -- 创建时间
    ,update_tm timestamp -- 更新时间
    ,amort_actl_day_int_rat number(30,14) -- 摊销实际日利率
    ,secu_acct_id varchar2(50) -- 证券账户编号
    ,ovdue_asset_prep_clear_cap number(30,8) -- 逾期资产待清算资金
    ,surp_tenor number(20,2) -- 剩余期限
    ,surp_surviv_tenor number(20,2) -- 剩余存续期限
    ,provi_int_rat number(30,14) -- 计提利率
    ,td_spd_inco number(30,8) -- 当日价差收入
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
grant select on ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h is '理财与资金产品估值信息历史';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.batch_dt is '跑批日期';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.comb_prod_cd_descb is '组合产品代码描述';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.fin_prod_cd_descb is '金融产品代码描述';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.invest_aim_cd is '投资目的代码';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.asset_qtty is '资产数量';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.amort_tot_cost is '摊销总成本';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.amort_cost_net_price is '摊销成本净价';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.td_acru_int is '当日应计利息';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.amort_actl_day_int_rat is '摊销实际日利率';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.secu_acct_id is '证券账户编号';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.ovdue_asset_prep_clear_cap is '逾期资产待清算资金';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.surp_tenor is '剩余期限';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.surp_surviv_tenor is '剩余存续期限';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.provi_int_rat is '计提利率';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.td_spd_inco is '当日价差收入';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h.etl_timestamp is 'ETL处理时间戳';
