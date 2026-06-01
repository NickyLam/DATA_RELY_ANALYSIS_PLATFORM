/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_family_trust_prod_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_family_trust_prod_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_family_trust_prod_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_family_trust_prod_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,init_prod_id varchar2(100) -- 原产品编号
    ,prod_name varchar2(750) -- 产品名称
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,acvmnt_base number(30,2) -- 业绩基准
    ,found_dt date -- 成立日期
    ,termnt_dt date -- 终止日期
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,star_amt number(30,2) -- 起购金额
    ,coll_start_dt date -- 募集开始日期
    ,coll_end_dt date -- 募集结束日期
    ,init_setup_amt number(30,2) -- 初始创立金额
    ,lot number(30,2) -- 份额
    ,cost number(30,2) -- 成本
    ,init_mk_val number(30,2) -- 初始市值
    ,trust_corp_cd varchar2(30) -- 信托公司代码
    ,trust_corp_name varchar2(750) -- 信托公司名称
    ,update_remark varchar2(3000) -- 更新备注
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
grant select on ${iml_schema}.prd_family_trust_prod_h to ${icl_schema};
grant select on ${iml_schema}.prd_family_trust_prod_h to ${idl_schema};
grant select on ${iml_schema}.prd_family_trust_prod_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_family_trust_prod_h is '家族信托产品';
comment on column ${iml_schema}.prd_family_trust_prod_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_family_trust_prod_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_family_trust_prod_h.init_prod_id is '原产品编号';
comment on column ${iml_schema}.prd_family_trust_prod_h.prod_name is '产品名称';
comment on column ${iml_schema}.prd_family_trust_prod_h.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.prd_family_trust_prod_h.acvmnt_base is '业绩基准';
comment on column ${iml_schema}.prd_family_trust_prod_h.found_dt is '成立日期';
comment on column ${iml_schema}.prd_family_trust_prod_h.termnt_dt is '终止日期';
comment on column ${iml_schema}.prd_family_trust_prod_h.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_family_trust_prod_h.star_amt is '起购金额';
comment on column ${iml_schema}.prd_family_trust_prod_h.coll_start_dt is '募集开始日期';
comment on column ${iml_schema}.prd_family_trust_prod_h.coll_end_dt is '募集结束日期';
comment on column ${iml_schema}.prd_family_trust_prod_h.init_setup_amt is '初始创立金额';
comment on column ${iml_schema}.prd_family_trust_prod_h.lot is '份额';
comment on column ${iml_schema}.prd_family_trust_prod_h.cost is '成本';
comment on column ${iml_schema}.prd_family_trust_prod_h.init_mk_val is '初始市值';
comment on column ${iml_schema}.prd_family_trust_prod_h.trust_corp_cd is '信托公司代码';
comment on column ${iml_schema}.prd_family_trust_prod_h.trust_corp_name is '信托公司名称';
comment on column ${iml_schema}.prd_family_trust_prod_h.update_remark is '更新备注';
comment on column ${iml_schema}.prd_family_trust_prod_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_family_trust_prod_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_family_trust_prod_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_family_trust_prod_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_family_trust_prod_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_family_trust_prod_h.etl_timestamp is 'ETL处理时间戳';
