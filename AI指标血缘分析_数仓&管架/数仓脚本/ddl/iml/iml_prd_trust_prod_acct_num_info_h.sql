/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_trust_prod_acct_num_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_trust_prod_acct_num_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_trust_prod_acct_num_info_h(
    ta_cd varchar2(30) -- TA代码
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,cap_veri_acct_open_bank_cd varchar2(60) -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd varchar2(60) -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num varchar2(60) -- 上账银行账号
    ,keep_acct_bank_acct_num varchar2(60) -- 下账银行账号
    ,coll_cap_vrfction_acct varchar2(90) -- 募集验资账户
    ,coll_cap_vrfction_acct_name varchar2(375) -- 募集验资账户名称
    ,trust_corp_prod_id varchar2(30) -- 信托公司产品编号
    ,stl_type_cd varchar2(10) -- 结算类型代码
    ,trust_bank_name varchar2(150) -- 托管银行名称
    ,trust_org_name varchar2(375) -- 托管机构名称
    ,prod_name varchar2(750) -- 产品名称
    ,make_acct_bank_acct_num_name varchar2(375) -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name varchar2(375) -- 下账银行账号名称
    ,resv_field_1 varchar2(750) -- 备用字段1
    ,resv_field_2 varchar2(750) -- 备用字段2
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
grant select on ${iml_schema}.prd_trust_prod_acct_num_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_trust_prod_acct_num_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_trust_prod_acct_num_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_trust_prod_acct_num_info_h is '信托产品账号信息历史';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.cap_veri_acct_open_bank_cd is '验资户开户行代码';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.rgst_rgst_acct_open_bank_cd is '注册登记账户开户行代码';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.make_acct_bank_acct_num is '上账银行账号';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.keep_acct_bank_acct_num is '下账银行账号';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.coll_cap_vrfction_acct is '募集验资账户';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.coll_cap_vrfction_acct_name is '募集验资账户名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.trust_corp_prod_id is '信托公司产品编号';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.stl_type_cd is '结算类型代码';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.trust_bank_name is '托管银行名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.trust_org_name is '托管机构名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.make_acct_bank_acct_num_name is '上账银行账号名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.keep_acct_bank_acct_num_name is '下账银行账号名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.resv_field_1 is '备用字段1';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.resv_field_2 is '备用字段2';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_trust_prod_acct_num_info_h.etl_timestamp is 'ETL处理时间戳';
