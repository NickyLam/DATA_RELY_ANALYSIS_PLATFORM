/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_bond_fair_price
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_bond_fair_price
whenever sqlerror continue none;
drop table ${iml_schema}.prd_bond_fair_price purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_fair_price(
    bond_id varchar2(60) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,price_dt date -- 价格日期
    ,tran_market_name varchar2(150) -- 交易市场名称
    ,surp_tenor number(18,6) -- 剩余期限
    ,recmd_flg varchar2(10) -- 推荐标志
    ,full_price number(30,8) -- 全价
    ,net_price number(30,8) -- 净价
    ,exp_yld_rat number(18,6) -- 到期收益率
    ,duran number(18,10) -- 久期
    ,coret_duran number(18,10) -- 修正久期
    ,valid_flg varchar2(10) -- 有效标志
    ,end_day_full_price number(30,8) -- 日终全价
    ,estim_yld_rat number(18,6) -- 估价收益率
    ,estim_coret_duran number(18,6) -- 估价修正久期
    ,estim_cvty number(18,6) -- 估价凸性
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
grant select on ${iml_schema}.prd_bond_fair_price to ${icl_schema};
grant select on ${iml_schema}.prd_bond_fair_price to ${idl_schema};
grant select on ${iml_schema}.prd_bond_fair_price to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_bond_fair_price is '债券公允价格';
comment on column ${iml_schema}.prd_bond_fair_price.bond_id is '债券编号';
comment on column ${iml_schema}.prd_bond_fair_price.lp_id is '法人编号';
comment on column ${iml_schema}.prd_bond_fair_price.price_dt is '价格日期';
comment on column ${iml_schema}.prd_bond_fair_price.tran_market_name is '交易市场名称';
comment on column ${iml_schema}.prd_bond_fair_price.surp_tenor is '剩余期限';
comment on column ${iml_schema}.prd_bond_fair_price.recmd_flg is '推荐标志';
comment on column ${iml_schema}.prd_bond_fair_price.full_price is '全价';
comment on column ${iml_schema}.prd_bond_fair_price.net_price is '净价';
comment on column ${iml_schema}.prd_bond_fair_price.exp_yld_rat is '到期收益率';
comment on column ${iml_schema}.prd_bond_fair_price.duran is '久期';
comment on column ${iml_schema}.prd_bond_fair_price.coret_duran is '修正久期';
comment on column ${iml_schema}.prd_bond_fair_price.valid_flg is '有效标志';
comment on column ${iml_schema}.prd_bond_fair_price.end_day_full_price is '日终全价';
comment on column ${iml_schema}.prd_bond_fair_price.estim_yld_rat is '估价收益率';
comment on column ${iml_schema}.prd_bond_fair_price.estim_coret_duran is '估价修正久期';
comment on column ${iml_schema}.prd_bond_fair_price.estim_cvty is '估价凸性';
comment on column ${iml_schema}.prd_bond_fair_price.start_dt is '开始时间';
comment on column ${iml_schema}.prd_bond_fair_price.end_dt is '结束时间';
comment on column ${iml_schema}.prd_bond_fair_price.id_mark is '增删标志';
comment on column ${iml_schema}.prd_bond_fair_price.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_bond_fair_price.job_cd is '任务编码';
comment on column ${iml_schema}.prd_bond_fair_price.etl_timestamp is 'ETL处理时间戳';
