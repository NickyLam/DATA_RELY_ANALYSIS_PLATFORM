/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_cus_indiv_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_cus_indiv_apply
whenever sqlerror continue none;
drop table ${iol_schema}.heps_cus_indiv_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_cus_indiv_apply(
    flow_no varchar2(50) -- 业务流水号
    ,cus_id varchar2(30) -- 客户代码
    ,cus_name varchar2(90) -- 客户姓名
    ,indiv_sex varchar2(2) -- 性别
    ,cert_type varchar2(2) -- 证件类型
    ,cert_code varchar2(20) -- 证件号码
    ,indiv_brt_place varchar2(90) -- 籍贯
    ,indiv_heal_st varchar2(2) -- 健康状况
    ,indiv_mar_st varchar2(2) -- 婚姻状况
    ,indiv_rsd_addr varchar2(300) -- 居住地址
    ,indiv_rsd_st varchar2(2) -- 居住状况
    ,indiv_rsd_year varchar2(4) -- 居住年限
    ,phone varchar2(35) -- 联系电话
    ,indiv_com_name varchar2(120) -- 工作单位
    ,indiv_com_addr varchar2(300) -- 单位地址
    ,main_brid varchar2(50) -- 主管机构
    ,cust_mgr varchar2(20) -- 客户经理编号
    ,indiv_sps_name varchar2(52) -- 配偶姓名
    ,indiv_sps_id_typ varchar2(2) -- 配偶证件类型
    ,indiv_sps_id_code varchar2(20) -- 配偶证件号码
    ,loan_amount number(16,2) -- 申请额度
    ,loan_term varchar2(2) -- 申请期数
    ,cert_st_time varchar2(20) -- 证件起始日
    ,cert_ed_time varchar2(20) -- 证件到期日
    ,create_time date -- 创建时间
    ,update_time date -- 更新时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_cus_indiv_apply to ${iml_schema};
grant select on ${iol_schema}.heps_cus_indiv_apply to ${icl_schema};
grant select on ${iol_schema}.heps_cus_indiv_apply to ${idl_schema};
grant select on ${iol_schema}.heps_cus_indiv_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_cus_indiv_apply is '赎楼借款人信息';
comment on column ${iol_schema}.heps_cus_indiv_apply.flow_no is '业务流水号';
comment on column ${iol_schema}.heps_cus_indiv_apply.cus_id is '客户代码';
comment on column ${iol_schema}.heps_cus_indiv_apply.cus_name is '客户姓名';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_sex is '性别';
comment on column ${iol_schema}.heps_cus_indiv_apply.cert_type is '证件类型';
comment on column ${iol_schema}.heps_cus_indiv_apply.cert_code is '证件号码';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_brt_place is '籍贯';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_heal_st is '健康状况';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_mar_st is '婚姻状况';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_rsd_addr is '居住地址';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_rsd_st is '居住状况';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_rsd_year is '居住年限';
comment on column ${iol_schema}.heps_cus_indiv_apply.phone is '联系电话';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_com_name is '工作单位';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_com_addr is '单位地址';
comment on column ${iol_schema}.heps_cus_indiv_apply.main_brid is '主管机构';
comment on column ${iol_schema}.heps_cus_indiv_apply.cust_mgr is '客户经理编号';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_sps_name is '配偶姓名';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_sps_id_typ is '配偶证件类型';
comment on column ${iol_schema}.heps_cus_indiv_apply.indiv_sps_id_code is '配偶证件号码';
comment on column ${iol_schema}.heps_cus_indiv_apply.loan_amount is '申请额度';
comment on column ${iol_schema}.heps_cus_indiv_apply.loan_term is '申请期数';
comment on column ${iol_schema}.heps_cus_indiv_apply.cert_st_time is '证件起始日';
comment on column ${iol_schema}.heps_cus_indiv_apply.cert_ed_time is '证件到期日';
comment on column ${iol_schema}.heps_cus_indiv_apply.create_time is '创建时间';
comment on column ${iol_schema}.heps_cus_indiv_apply.update_time is '更新时间';
comment on column ${iol_schema}.heps_cus_indiv_apply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_cus_indiv_apply.etl_timestamp is 'ETL处理时间戳';
