/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_am_comb_post_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_am_comb_post_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_am_comb_post_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_comb_post_h(
    inv_port_id varchar2(100) -- 投资组合编号
    ,lp_id varchar2(60) -- 法人编号
    ,secu_acct_id varchar2(100) -- 证券账户编号
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,brch_seq_num number(10) -- 分支序号
    ,invest_aim_cd varchar2(60) -- 投资目的代码
    ,post_type_cd varchar2(60) -- 持仓类型代码
    ,post_lot number(38,8) -- 持仓份额
    ,curr_cd varchar2(60) -- 币种代码
    ,super_prod_id varchar2(100) -- 上级产品编号
    ,bond_fac_val number(38,8) -- 债券面值
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_am_comb_post_h to ${icl_schema};
grant select on ${iml_schema}.prd_am_comb_post_h to ${idl_schema};
grant select on ${iml_schema}.prd_am_comb_post_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_am_comb_post_h is '资管组合持仓历史';
comment on column ${iml_schema}.prd_am_comb_post_h.inv_port_id is '投资组合编号';
comment on column ${iml_schema}.prd_am_comb_post_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_am_comb_post_h.secu_acct_id is '证券账户编号';
comment on column ${iml_schema}.prd_am_comb_post_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_am_comb_post_h.brch_seq_num is '分支序号';
comment on column ${iml_schema}.prd_am_comb_post_h.invest_aim_cd is '投资目的代码';
comment on column ${iml_schema}.prd_am_comb_post_h.post_type_cd is '持仓类型代码';
comment on column ${iml_schema}.prd_am_comb_post_h.post_lot is '持仓份额';
comment on column ${iml_schema}.prd_am_comb_post_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_am_comb_post_h.super_prod_id is '上级产品编号';
comment on column ${iml_schema}.prd_am_comb_post_h.bond_fac_val is '债券面值';
comment on column ${iml_schema}.prd_am_comb_post_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_am_comb_post_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_am_comb_post_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_am_comb_post_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_am_comb_post_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_am_comb_post_h.etl_timestamp is 'ETL处理时间戳';
