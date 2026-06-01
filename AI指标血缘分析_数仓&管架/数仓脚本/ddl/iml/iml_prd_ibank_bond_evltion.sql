/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_bond_evltion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_bond_evltion
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_bond_evltion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_evltion(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,net_price_amt number(30,8) -- 净价金额
    ,acru_int number(30,2) -- 应计利息
    ,estim_yld_rat number(18,6) -- 估价收益率
    ,spread_yld_rat number(18,6) -- 点差收益率
    ,estim_pend_ped number(18,6) -- 估价待偿期
    ,estim_coret_duran number(18,6) -- 估价修正久期
    ,estim_cvty number(18,6) -- 估价凸性
    ,estim_bp_val number(18,6) -- 估价基点价值
    ,estim_spd_duran number(18,6) -- 估价利差久期
    ,estim_spd_cvty number(18,6) -- 估价利差凸性
    ,estim_int_rat_duran number(18,6) -- 估价利率久期
    ,estim_int_rat_cvty number(18,6) -- 估价利率凸性
    ,full_price_amt number(18,6) -- 全价金额
    ,input_dt date -- 录入日期
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
grant select on ${iml_schema}.prd_ibank_bond_evltion to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_bond_evltion to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_bond_evltion to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_bond_evltion is '同业债券估值';
comment on column ${iml_schema}.prd_ibank_bond_evltion.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_ibank_bond_evltion.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_ibank_bond_evltion.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_ibank_bond_evltion.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_bond_evltion.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.net_price_amt is '净价金额';
comment on column ${iml_schema}.prd_ibank_bond_evltion.acru_int is '应计利息';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_yld_rat is '估价收益率';
comment on column ${iml_schema}.prd_ibank_bond_evltion.spread_yld_rat is '点差收益率';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_pend_ped is '估价待偿期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_coret_duran is '估价修正久期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_cvty is '估价凸性';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_bp_val is '估价基点价值';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_spd_duran is '估价利差久期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_spd_cvty is '估价利差凸性';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_int_rat_duran is '估价利率久期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.estim_int_rat_cvty is '估价利率凸性';
comment on column ${iml_schema}.prd_ibank_bond_evltion.full_price_amt is '全价金额';
comment on column ${iml_schema}.prd_ibank_bond_evltion.input_dt is '录入日期';
comment on column ${iml_schema}.prd_ibank_bond_evltion.start_dt is '开始时间';
comment on column ${iml_schema}.prd_ibank_bond_evltion.end_dt is '结束时间';
comment on column ${iml_schema}.prd_ibank_bond_evltion.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_bond_evltion.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_bond_evltion.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_bond_evltion.etl_timestamp is 'ETL处理时间戳';
