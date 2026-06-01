/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_finc_prod_yld_rat_set
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_finc_prod_yld_rat_set
whenever sqlerror continue none;
drop table ${iml_schema}.ref_finc_prod_yld_rat_set purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_finc_prod_yld_rat_set(
    flow_num varchar2(60) -- 流水号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,vp date -- 有效期
    ,prft_mode_cd varchar2(10) -- 收益模式代码
    ,seller_cd varchar2(10) -- 销售商代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,sell_type_cd varchar2(10) -- 销售类型代码
    ,hold_days number(10) -- 持有天数
    ,hold_min_days number(10) -- 持有最小天数
    ,hold_max_days number(10) -- 持有最大天数
    ,hold_min_amt number(30,2) -- 持有最小金额
    ,hold_max_amt number(30,2) -- 持有最大金额
    ,cust_yld_rat number(18,6) -- 客户收益率
    ,bank_yld_rat number(18,6) -- 银行收益率
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.ref_finc_prod_yld_rat_set to ${icl_schema};
grant select on ${iml_schema}.ref_finc_prod_yld_rat_set to ${idl_schema};
grant select on ${iml_schema}.ref_finc_prod_yld_rat_set to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_finc_prod_yld_rat_set is '理财产品收益率设置表';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.flow_num is '流水号';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.lp_id is '法人编号';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.prod_id is '产品编号';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.vp is '有效期';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.prft_mode_cd is '收益模式代码';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.seller_cd is '销售商代码';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.sell_type_cd is '销售类型代码';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.hold_days is '持有天数';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.hold_min_days is '持有最小天数';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.hold_max_days is '持有最大天数';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.hold_min_amt is '持有最小金额';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.hold_max_amt is '持有最大金额';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.cust_yld_rat is '客户收益率';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.bank_yld_rat is '银行收益率';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.create_dt is '创建日期';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.update_dt is '更新日期';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.id_mark is '增删标志';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.job_cd is '任务编码';
comment on column ${iml_schema}.ref_finc_prod_yld_rat_set.etl_timestamp is 'ETL处理时间戳';
