/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_bank_int_ladr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_bank_int_ladr_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_bank_int_ladr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_bank_int_ladr_h(
    ladr_seq_num varchar2(60) -- 阶梯序号
    ,lp_id varchar2(100) -- 法人编号
    ,org_id varchar2(100) -- 机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,bank_int_int_rat_type_cd varchar2(30) -- 行内利率类型代码
    ,year_base_days varchar2(30) -- 年计息基准代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,base_rat_type_id varchar2(100) -- 基准利率类型编号
    ,base_exch_rat varchar2(500) -- 基础汇率
    ,ped_freq_cd varchar2(30) -- 周期频率代码
    ,eh_issue_days number(10) -- 每期天数
    ,ladr_amt number(30,2) -- 阶梯金额
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,int_rat_discnt number(18,8) -- 利率折扣
    ,float_ratio number(18,6) -- 浮动比例
    ,float_point number(18,8) -- 浮动点数
    ,max_cu_ratio number(18,8) -- 最大上浮比例
    ,min_cu_ratio number(18,8) -- 浮动比例上限
    ,min_int_rat number(18,8) -- 最小利率
    ,max_int_rat number(18,8) -- 最大利率
    ,max_float_point number(4) -- 浮动点差上限
    ,min_float_point number(4) -- 浮动点差下限
    ,max_float_ratio number(18,8) -- 最大下浮比例
    ,min_float_ratio number(18,8) -- 最小下浮比例
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
grant select on ${iml_schema}.ref_bank_int_ladr_h to ${icl_schema};
grant select on ${iml_schema}.ref_bank_int_ladr_h to ${idl_schema};
grant select on ${iml_schema}.ref_bank_int_ladr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_bank_int_ladr_h is '行内利率阶梯历史';
comment on column ${iml_schema}.ref_bank_int_ladr_h.ladr_seq_num is '阶梯序号';
comment on column ${iml_schema}.ref_bank_int_ladr_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_bank_int_ladr_h.org_id is '机构编号';
comment on column ${iml_schema}.ref_bank_int_ladr_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_bank_int_ladr_h.bank_int_int_rat_type_cd is '行内利率类型代码';
comment on column ${iml_schema}.ref_bank_int_ladr_h.year_base_days is '年计息基准代码';
comment on column ${iml_schema}.ref_bank_int_ladr_h.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_bank_int_ladr_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_bank_int_ladr_h.base_rat_type_id is '基准利率类型编号';
comment on column ${iml_schema}.ref_bank_int_ladr_h.base_exch_rat is '基础汇率';
comment on column ${iml_schema}.ref_bank_int_ladr_h.ped_freq_cd is '周期频率代码';
comment on column ${iml_schema}.ref_bank_int_ladr_h.eh_issue_days is '每期天数';
comment on column ${iml_schema}.ref_bank_int_ladr_h.ladr_amt is '阶梯金额';
comment on column ${iml_schema}.ref_bank_int_ladr_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.ref_bank_int_ladr_h.int_rat_discnt is '利率折扣';
comment on column ${iml_schema}.ref_bank_int_ladr_h.float_ratio is '浮动比例';
comment on column ${iml_schema}.ref_bank_int_ladr_h.float_point is '浮动点数';
comment on column ${iml_schema}.ref_bank_int_ladr_h.max_cu_ratio is '最大上浮比例';
comment on column ${iml_schema}.ref_bank_int_ladr_h.min_cu_ratio is '浮动比例上限';
comment on column ${iml_schema}.ref_bank_int_ladr_h.min_int_rat is '最小利率';
comment on column ${iml_schema}.ref_bank_int_ladr_h.max_int_rat is '最大利率';
comment on column ${iml_schema}.ref_bank_int_ladr_h.max_float_point is '浮动点差上限';
comment on column ${iml_schema}.ref_bank_int_ladr_h.min_float_point is '浮动点差下限';
comment on column ${iml_schema}.ref_bank_int_ladr_h.max_float_ratio is '最大下浮比例';
comment on column ${iml_schema}.ref_bank_int_ladr_h.min_float_ratio is '最小下浮比例';
comment on column ${iml_schema}.ref_bank_int_ladr_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_bank_int_ladr_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_bank_int_ladr_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_bank_int_ladr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_bank_int_ladr_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_bank_int_ladr_h.etl_timestamp is 'ETL处理时间戳';
