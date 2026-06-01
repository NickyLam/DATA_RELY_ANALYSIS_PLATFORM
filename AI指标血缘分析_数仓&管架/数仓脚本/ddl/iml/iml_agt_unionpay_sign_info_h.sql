/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_unionpay_sign_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_unionpay_sign_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_unionpay_sign_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_unionpay_sign_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,sign_agt_id varchar2(100) -- 签约协议编号
    ,sign_dt date -- 签约日期
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,sign_acct_unionpay_org_id varchar2(100) -- 签约账户银联机构编号
    ,sign_acct_type_cd varchar2(30) -- 签约账户类型代码
    ,sign_acct_id varchar2(100) -- 签约账户编号
    ,sign_acct_name varchar2(500) -- 签约账户名称
    ,sign_acct_level_cd varchar2(30) -- 签约账户等级代码
    ,sign_type_cd varchar2(30) -- 签约类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,mobile_no varchar2(60) -- 手机号码
    ,agt_invalid_dt date -- 协议失效日期
    ,init_bus_kind_id varchar2(100) -- 原业务种类编号
    ,init_acct_id varchar2(100) -- 发起账户编号
    ,intior_belong_org_id varchar2(100) -- 发起方所属机构编号
    ,init_acct_unionpay_org_id varchar2(100) -- 发起账户银联机构编号
    ,intior_unionpay_org_id varchar2(100) -- 发起方银联机构编号
    ,init_org_name varchar2(500) -- 发起机构名称
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,vtual_teller_id varchar2(100) -- 虚拟柜员编号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,create_date date -- 创建日期
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_unionpay_sign_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_unionpay_sign_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_unionpay_sign_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_unionpay_sign_info_h is '银联签约信息历史';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_acct_unionpay_org_id is '签约账户银联机构编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_acct_type_cd is '签约账户类型代码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_acct_id is '签约账户编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_acct_name is '签约账户名称';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_acct_level_cd is '签约账户等级代码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.sign_type_cd is '签约类型代码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.agt_invalid_dt is '协议失效日期';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.init_bus_kind_id is '原业务种类编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.init_acct_id is '发起账户编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.intior_belong_org_id is '发起方所属机构编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.init_acct_unionpay_org_id is '发起账户银联机构编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.intior_unionpay_org_id is '发起方银联机构编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.init_org_name is '发起机构名称';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.vtual_teller_id is '虚拟柜员编号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.create_date is '创建日期';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_unionpay_sign_info_h.etl_timestamp is 'ETL处理时间戳';
