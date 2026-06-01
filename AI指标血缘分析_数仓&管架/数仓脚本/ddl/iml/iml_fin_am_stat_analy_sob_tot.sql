/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_stat_analy_sob_tot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_stat_analy_sob_tot
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_stat_analy_sob_tot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_stat_analy_sob_tot(
    sob_id varchar2(100) -- 账套编号
    ,lp_id varchar2(60) -- 法人编号
    ,happ_dt date -- 发生日期
    ,enter_acct_dt date -- 入账日期
    ,layered_id varchar2(100) -- 分层编号
    ,sub_prod_flg varchar2(10) -- 子产品标志
    ,sob_dt date -- 账套日期
    ,prft_mode_cd varchar2(30) -- 收益模式代码
    ,paid_in_capital number(30,2) -- 实收资本
    ,td_paybl_margin number(30,2) -- 当日应付利润
    ,acm_paybl_margin number(30,2) -- 累计应付利润
    ,provi_int_rat number(30,14) -- 计提利率
    ,fee_bf_asset_nv number(30,2) -- 费前资产净值
    ,asset_nv number(30,2) -- 资产净值
    ,fee_f_unit_nv number(30,14) -- 费前单位净值
    ,corp_nv number(30,14) -- 单位净值
    ,bf_ten_thous_prft number(30,14) -- 费前万份收益
    ,ten_thous_prft number(30,14) -- 万份收益
    ,bf_td_aual_yld number(30,14) -- 费前当日年化收益率
    ,td_aual_yld number(30,14) -- 当日年化收益率
    ,fee_ped_aual_yld number(30,14) -- 费用周期年化收益率
    ,ped_aual_yld number(30,14) -- 周期年化收益率
    ,bf_sevn_aual_yld number(30,14) -- 费前七日年化收益率
    ,sevn_aual_yld number(30,14) -- 七日年化收益率
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
grant select on ${iml_schema}.fin_am_stat_analy_sob_tot to ${icl_schema};
grant select on ${iml_schema}.fin_am_stat_analy_sob_tot to ${idl_schema};
grant select on ${iml_schema}.fin_am_stat_analy_sob_tot to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_stat_analy_sob_tot is '资管统计分析账套汇总';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.sob_id is '账套编号';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.happ_dt is '发生日期';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.enter_acct_dt is '入账日期';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.layered_id is '分层编号';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.sub_prod_flg is '子产品标志';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.sob_dt is '账套日期';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.prft_mode_cd is '收益模式代码';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.paid_in_capital is '实收资本';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.td_paybl_margin is '当日应付利润';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.acm_paybl_margin is '累计应付利润';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.provi_int_rat is '计提利率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.fee_bf_asset_nv is '费前资产净值';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.asset_nv is '资产净值';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.fee_f_unit_nv is '费前单位净值';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.corp_nv is '单位净值';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.bf_ten_thous_prft is '费前万份收益';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.ten_thous_prft is '万份收益';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.bf_td_aual_yld is '费前当日年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.td_aual_yld is '当日年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.fee_ped_aual_yld is '费用周期年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.ped_aual_yld is '周期年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.bf_sevn_aual_yld is '费前七日年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_stat_analy_sob_tot.etl_timestamp is 'ETL处理时间戳';
