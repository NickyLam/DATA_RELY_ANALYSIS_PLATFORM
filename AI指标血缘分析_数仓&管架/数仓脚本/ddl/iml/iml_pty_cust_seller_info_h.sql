/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_seller_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_seller_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_seller_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_seller_info_h(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,bank_id varchar2(100) -- 银行编号
    ,seller_cd varchar2(30) -- 销售商代码
    ,sys_src_abbr varchar2(150) -- 系统来源简称
    ,bank_cust_id varchar2(100) -- 银行客户编号
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,sign_dt date -- 签约日期
    ,rels_dt date -- 解约日期
    ,ta_cust_tran_acct_num varchar2(100) -- TA客户交易账号
    ,rels_flg varchar2(30) -- 解约标志
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
grant select on ${iml_schema}.pty_cust_seller_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_cust_seller_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_cust_seller_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_seller_info_h is '客户签约信息历史';
comment on column ${iml_schema}.pty_cust_seller_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_seller_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_seller_info_h.bank_id is '银行编号';
comment on column ${iml_schema}.pty_cust_seller_info_h.seller_cd is '销售商代码';
comment on column ${iml_schema}.pty_cust_seller_info_h.sys_src_abbr is '系统来源简称';
comment on column ${iml_schema}.pty_cust_seller_info_h.bank_cust_id is '银行客户编号';
comment on column ${iml_schema}.pty_cust_seller_info_h.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.pty_cust_seller_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.pty_cust_seller_info_h.rels_dt is '解约日期';
comment on column ${iml_schema}.pty_cust_seller_info_h.ta_cust_tran_acct_num is 'TA客户交易账号';
comment on column ${iml_schema}.pty_cust_seller_info_h.rels_flg is '解约标志';
comment on column ${iml_schema}.pty_cust_seller_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_cust_seller_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_cust_seller_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cust_seller_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_seller_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_seller_info_h.etl_timestamp is 'ETL处理时间戳';
