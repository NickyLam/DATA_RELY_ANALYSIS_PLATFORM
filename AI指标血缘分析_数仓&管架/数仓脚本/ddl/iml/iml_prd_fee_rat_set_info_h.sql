/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fee_rat_set_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fee_rat_set_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fee_rat_set_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fee_rat_set_info_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,fee_type_cd varchar2(30) -- 费用类型代码
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,sell_type_cd varchar2(30) -- 销售类型代码
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,lowt_buy_amt number(30,8) -- 最低购买金额
    ,higt_buy_amt number(30,8) -- 最高购买金额
    ,min_precon_days number(30) -- 最小预约天数
    ,max_precon_days number(30) -- 最大预约天数
    ,min_surviv_days number(30) -- 最小存续天数
    ,max_surviv_days number(30) -- 最大存续天数
    ,fee_ratio number(10,8) -- 费用比例
    ,lowt_fee_amt number(30,6) -- 最低费用金额
    ,higt_fee_amt number(30,6) -- 最高费用金额
    ,cntpty_prod_id varchar2(100) -- 对方产品编号
    ,fee_corp_cd varchar2(30) -- 费用单位代码
    ,fee_corp_name varchar2(750) -- 费用单位名称
    ,return_comm_fee_flg varchar2(10) -- 固定费用模式返回手续费标志
    ,fee_mode_cd varchar2(30) -- 费用模式代码
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
grant select on ${iml_schema}.prd_fee_rat_set_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_fee_rat_set_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_fee_rat_set_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fee_rat_set_info_h is '产品费率设置信息历史';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.fee_type_cd is '费用类型代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.sell_type_cd is '销售类型代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.lowt_buy_amt is '最低购买金额';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.higt_buy_amt is '最高购买金额';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.min_precon_days is '最小预约天数';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.max_precon_days is '最大预约天数';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.min_surviv_days is '最小存续天数';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.max_surviv_days is '最大存续天数';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.fee_ratio is '费用比例';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.lowt_fee_amt is '最低费用金额';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.higt_fee_amt is '最高费用金额';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.cntpty_prod_id is '对方产品编号';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.fee_corp_cd is '费用单位代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.fee_corp_name is '费用单位名称';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.return_comm_fee_flg is '固定费用模式返回手续费标志';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.fee_mode_cd is '费用模式代码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fee_rat_set_info_h.etl_timestamp is 'ETL处理时间戳';
