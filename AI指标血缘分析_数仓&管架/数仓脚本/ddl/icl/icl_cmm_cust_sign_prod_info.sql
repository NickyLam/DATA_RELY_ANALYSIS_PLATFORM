/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_cust_sign_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_cust_sign_prod_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_cust_sign_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cust_sign_prod_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,sign_agt_id varchar2(60) -- 签约协议编号
    ,cust_id varchar2(60) -- 客户编号
    ,sign_acct_id varchar2(250) -- 签约账户编号
    ,sign_org_id varchar2(60) -- 签约机构编号
    ,sign_teller_id varchar2(60) -- 签约柜员编号
    ,sign_org_name varchar2(300) -- 签约机构名称
    ,sign_prod_type_cd varchar2(10) -- 签约产品类型代码
    ,sign_prod_status_cd varchar2(10) -- 签约产品状态代码
    ,sign_dt date -- 签约日期
    ,rels_dt date -- 解约日期
    ,rels_org_id varchar2(60) -- 解约机构编号
    ,rels_teller_id varchar2(60) -- 解约柜员编号
    ,rels_org_name varchar2(300) -- 解约机构名称
    ,sign_mobile_no varchar2(60) -- 签约手机号
    ,sign_chn_id varchar2(60) -- 签约渠道编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_cust_sign_prod_info to ${idl_schema};
grant select on ${icl_schema}.cmm_cust_sign_prod_info to ${iel_schema};
grant select on ${icl_schema}.cmm_cust_sign_prod_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_cust_sign_prod_info is '客户签约产品信息';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_agt_id is '签约协议编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_acct_id is '签约账户编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_org_id is '签约机构编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_teller_id is '签约柜员编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_org_name is '签约机构名称';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_prod_type_cd is '签约产品类型代码';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_prod_status_cd is '签约产品状态代码';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_dt is '签约日期';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.rels_dt is '解约日期';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.rels_org_id is '解约机构编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.rels_teller_id is '解约柜员编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.rels_org_name is '解约机构名称';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_mobile_no is '签约手机号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.sign_chn_id is '签约渠道编号';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_cust_sign_prod_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_cust_sign_prod_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_cust_sign_prod_info.etl_timestamp is 'ETL处理时间戳';
