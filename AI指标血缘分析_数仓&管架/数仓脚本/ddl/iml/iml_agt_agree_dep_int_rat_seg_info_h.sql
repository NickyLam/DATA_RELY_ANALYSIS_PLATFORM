/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_agree_dep_int_rat_seg_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_agree_dep_int_rat_seg_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_agree_dep_int_rat_seg_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agree_dep_int_rat_seg_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,fee_rat_id varchar2(100) -- 费率编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,seg_calc_start_dt date -- 分段计算开始日期
    ,seg_ped number(10) -- 分段周期
    ,seg_ped_type_cd varchar2(30) -- 分段周期类型代码
    ,bus_start_dt date -- 业务开始日期
    ,bus_end_dt date -- 业务结束日期
    ,provi_days number(10) -- 计提天数
    ,provi_amt number(30,2) -- 计提金额
    ,file_amt number(30,2) -- 靠档金额
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
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
grant select on ${iml_schema}.agt_agree_dep_int_rat_seg_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_agree_dep_int_rat_seg_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_agree_dep_int_rat_seg_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_agree_dep_int_rat_seg_info_h is '协定存款利率分段信息历史';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.fee_rat_id is '费率编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.seg_calc_start_dt is '分段计算开始日期';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.seg_ped is '分段周期';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.seg_ped_type_cd is '分段周期类型代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.bus_start_dt is '业务开始日期';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.bus_end_dt is '业务结束日期';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.provi_days is '计提天数';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.provi_amt is '计提金额';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.file_amt is '靠档金额';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_agree_dep_int_rat_seg_info_h.etl_timestamp is 'ETL处理时间戳';
