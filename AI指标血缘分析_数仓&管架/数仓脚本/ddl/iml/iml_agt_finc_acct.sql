/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_acct(
    agt_id varchar2(60) -- 协议编号
    ,intnal_cust_acct varchar2(90) -- 内部客户账户
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,open_acct_way_cd varchar2(10) -- 开户方式代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,bus_cate_cd varchar2(10) -- 业务类别代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,open_dt date -- 开通日期
    ,sign_acct_id varchar2(60) -- 签约账户编号
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
grant select on ${iml_schema}.agt_finc_acct to ${icl_schema};
grant select on ${iml_schema}.agt_finc_acct to ${idl_schema};
grant select on ${iml_schema}.agt_finc_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_acct is '理财账户';
comment on column ${iml_schema}.agt_finc_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_acct.intnal_cust_acct is '内部客户账户';
comment on column ${iml_schema}.agt_finc_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_acct.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_finc_acct.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_finc_acct.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_finc_acct.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_finc_acct.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_finc_acct.open_acct_way_cd is '开户方式代码';
comment on column ${iml_schema}.agt_finc_acct.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_finc_acct.bus_cate_cd is '业务类别代码';
comment on column ${iml_schema}.agt_finc_acct.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_finc_acct.open_dt is '开通日期';
comment on column ${iml_schema}.agt_finc_acct.sign_acct_id is '签约账户编号';
comment on column ${iml_schema}.agt_finc_acct.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_acct.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_acct.etl_timestamp is 'ETL处理时间戳';
