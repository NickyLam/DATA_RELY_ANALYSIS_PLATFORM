/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cust_tran_lmt_modif_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cust_tran_lmt_modif_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cust_tran_lmt_modif_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_tran_lmt_modif_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_id varchar2(100) -- 账户编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,chn_id varchar2(100) -- 渠道编号
    ,lmt_cate_cd varchar2(30) -- 限额类别代码
    ,lmt_set_rs_cd varchar2(30) -- 限额设置原因代码
    ,single_day_lmt number(30,2) -- 单日限额
    ,init_single_day_lmt number(30,2) -- 原单日限额
    ,single_day_lmt_cnt number(10) -- 单日限制笔数
    ,init_single_day_lmt_cnt number(10) -- 原单日限制笔数
    ,sig_lmt number(30,2) -- 单笔限额
    ,init_sig_lmt number(30,2) -- 原单笔限额
    ,year_lmt number(30,2) -- 年度限额
    ,init_year_lmt number(30,2) -- 原年度限额
    ,tran_lmt_valid_dt date -- 交易限额有效日期
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_dt date -- 交易日期
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
grant select on ${iml_schema}.agt_cust_tran_lmt_modif_h to ${icl_schema};
grant select on ${iml_schema}.agt_cust_tran_lmt_modif_h to ${idl_schema};
grant select on ${iml_schema}.agt_cust_tran_lmt_modif_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cust_tran_lmt_modif_h is '客户交易限额变更历史';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.lmt_cate_cd is '限额类别代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.lmt_set_rs_cd is '限额设置原因代码';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.single_day_lmt is '单日限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.init_single_day_lmt is '原单日限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.single_day_lmt_cnt is '单日限制笔数';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.init_single_day_lmt_cnt is '原单日限制笔数';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.sig_lmt is '单笔限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.init_sig_lmt is '原单笔限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.year_lmt is '年度限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.init_year_lmt is '原年度限额';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.tran_lmt_valid_dt is '交易限额有效日期';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cust_tran_lmt_modif_h.etl_timestamp is 'ETL处理时间戳';
