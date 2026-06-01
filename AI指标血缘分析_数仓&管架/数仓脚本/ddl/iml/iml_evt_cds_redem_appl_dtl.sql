/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cds_redem_appl_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cds_redem_appl_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cds_redem_appl_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cds_redem_appl_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,issue_year varchar2(60) -- 发行年度
    ,prod_id varchar2(100) -- 产品编号
    ,pd_cd varchar2(30) -- 期次代码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_dt date -- 交易日期
    ,redem_int_rat number(18,8) -- 赎回利率
    ,tran_redem_status_cd varchar2(30) -- 交易赎回状态代码
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,redem_dt date -- 赎回日期
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,appl_dt date -- 申请日期
    ,applit_name varchar2(500) -- 申请人名称
    ,apv_form_id varchar2(100) -- 审批单编号
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
grant select on ${iml_schema}.evt_cds_redem_appl_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_cds_redem_appl_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_cds_redem_appl_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cds_redem_appl_dtl is '大额存单赎回申请明细';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.issue_year is '发行年度';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.pd_cd is '期次代码';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.redem_int_rat is '赎回利率';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.tran_redem_status_cd is '交易赎回状态代码';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.redem_dt is '赎回日期';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.applit_name is '申请人名称';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.apv_form_id is '审批单编号';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cds_redem_appl_dtl.etl_timestamp is 'ETL处理时间戳';
