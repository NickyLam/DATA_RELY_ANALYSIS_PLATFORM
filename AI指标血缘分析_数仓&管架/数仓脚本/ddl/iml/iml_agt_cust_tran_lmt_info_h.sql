/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cust_tran_lmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cust_tran_lmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_tran_lmt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_id varchar2(100) -- 客户编号
    ,lmt_code varchar2(1000) -- 限额编码
    ,lmt_cate_cd varchar2(30) -- 限额类别代码
    ,lmt_set_rs_cd varchar2(30) -- 限额设置原因代码
    ,tran_lmt_valid_dt date -- 交易限额有效日期
    ,seq_num varchar2(60) -- 序号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,amt_uplmi number(30,2) -- 金额上限
    ,amt_lolmi number(30,2) -- 金额下限
    ,cnt_limit number(30,2) -- 笔数上限
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.agt_cust_tran_lmt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_cust_tran_lmt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_cust_tran_lmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cust_tran_lmt_info_h is '客户交易限额信息历史';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.lmt_code is '限额编码';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.lmt_cate_cd is '限额类别代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.lmt_set_rs_cd is '限额设置原因代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.tran_lmt_valid_dt is '交易限额有效日期';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.seq_num is '序号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.amt_uplmi is '金额上限';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.amt_lolmi is '金额下限';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.cnt_limit is '笔数上限';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cust_tran_lmt_info_h.etl_timestamp is 'ETL处理时间戳';
