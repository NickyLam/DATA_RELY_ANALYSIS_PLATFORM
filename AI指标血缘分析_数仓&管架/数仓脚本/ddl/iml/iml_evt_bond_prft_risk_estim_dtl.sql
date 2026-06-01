/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bond_prft_risk_estim_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bond_prft_risk_estim_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bond_prft_risk_estim_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bond_prft_risk_estim_dtl(
    bond_id varchar2(100) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_bond_id varchar2(30) -- 源债券编号
    ,bond_name varchar2(375) -- 债券名称
    ,bond_cate_cd varchar2(30) -- 债券类别代码
    ,acct_b_id varchar2(60) -- 账簿编号
    ,acct_b_name varchar2(150) -- 账簿名称
    ,estim_dt date -- 评估日期
    ,curr_cd varchar2(30) -- 币种代码
    ,bond_fac_val number(30,2) -- 债券面值
    ,market_net_price number(30,8) -- 市场净价
    ,market_net_price_src_descb varchar2(375) -- 市场净价来源描述
    ,net_price_mk_val number(30,8) -- 净价市值
    ,market_full_price number(30,8) -- 市场全价
    ,full_price_mk_val number(30,8) -- 全价市值
    ,cvty number(18,6) -- 凸性
    ,duran number(18,10) -- 久期
    ,coret_duran number(18,10) -- 修正久期
    ,pvbp number(18,10) -- pvbp
    ,pend_tenor number(18,10) -- 待偿期限
    ,var_val number(30,8) -- var值
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.evt_bond_prft_risk_estim_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_bond_prft_risk_estim_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_bond_prft_risk_estim_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bond_prft_risk_estim_dtl is '债券收益风险评估明细';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.bond_id is '债券编号';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.src_bond_id is '源债券编号';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.bond_name is '债券名称';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.bond_cate_cd is '债券类别代码';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.acct_b_name is '账簿名称';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.estim_dt is '评估日期';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.bond_fac_val is '债券面值';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.market_net_price is '市场净价';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.market_net_price_src_descb is '市场净价来源描述';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.net_price_mk_val is '净价市值';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.market_full_price is '市场全价';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.full_price_mk_val is '全价市值';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.cvty is '凸性';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.duran is '久期';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.coret_duran is '修正久期';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.pvbp is 'pvbp';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.pend_tenor is '待偿期限';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.var_val is 'var值';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bond_prft_risk_estim_dtl.etl_timestamp is 'ETL处理时间戳';
