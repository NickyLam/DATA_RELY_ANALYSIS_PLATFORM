/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_guartor_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_guartor_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_guartor_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_guartor_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,org_id varchar2(100) -- 机构编号
    ,cert_no varchar2(60) -- 证件号码
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,guar_amt_uplmi number(30,2) -- 担保金额上限
    ,net_asset number(30,2) -- 净资产
    ,guar_amt number(30,2) -- 担保金额
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wyd_guartor_h to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_guartor_h to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_guartor_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_guartor_h is '微业贷担保人信息历史';
comment on column ${iml_schema}.agt_wyd_guartor_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_guartor_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_wyd_guartor_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_guartor_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_wyd_guartor_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_wyd_guartor_h.guar_amt_uplmi is '担保金额上限';
comment on column ${iml_schema}.agt_wyd_guartor_h.net_asset is '净资产';
comment on column ${iml_schema}.agt_wyd_guartor_h.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_wyd_guartor_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_guartor_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_guartor_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_guartor_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_guartor_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_guartor_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_guartor_h.etl_timestamp is 'ETL处理时间戳';
