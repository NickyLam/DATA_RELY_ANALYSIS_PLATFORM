/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_insure_pl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_insure_pl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_insure_pl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_insure_pl(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,insure_pl_id varchar2(100) -- 保险单编号
    ,ta_cd varchar2(30) -- TA代码
    ,prod_id varchar2(100) -- 产品编号
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_id varchar2(100) -- 客户编号
    ,insure_print_id varchar2(100) -- 保险打印单编号
    ,org_id varchar2(100) -- 机构编号
    ,teller_id varchar2(100) -- 柜员编号
    ,tran_dt date -- 交易日期
    ,seq_num varchar2(100) -- 序号
    ,policy_dt date -- 保单日期
    ,cfm_dt date -- 确认日期
    ,policy_effect_dt date -- 保单生效日期
    ,pay_ped varchar2(45) -- 支付周期
    ,insure_ped_type_cd varchar2(30) -- 保险周期类型代码
    ,insure_ped varchar2(45) -- 保险周期
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,pay_ped_type_cd varchar2(30) -- 支付周期类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,insure_fee number(30,2) -- 保险费用
    ,lot number(30,2) -- 份额
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,holder_name varchar2(150) -- 持有人姓名
    ,holder_cert_type_cd varchar2(30) -- 持有人证件类型代码
    ,holder_cert_no varchar2(100) -- 持有人证件号码
    ,rela_type_cd varchar2(30) -- 关系类型代码
    ,insrt_name varchar2(150) -- 被保险人姓名
    ,insrt_cert_type_cd varchar2(30) -- 被保险人证件类型代码
    ,insrt_cert_no varchar2(100) -- 被保险人证件号码
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
grant select on ${iml_schema}.agt_insure_pl to ${icl_schema};
grant select on ${iml_schema}.agt_insure_pl to ${idl_schema};
grant select on ${iml_schema}.agt_insure_pl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_insure_pl is '保险单';
comment on column ${iml_schema}.agt_insure_pl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_insure_pl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_insure_pl.insure_pl_id is '保险单编号';
comment on column ${iml_schema}.agt_insure_pl.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_insure_pl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_insure_pl.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_insure_pl.bank_id is '银行编号';
comment on column ${iml_schema}.agt_insure_pl.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_insure_pl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_insure_pl.insure_print_id is '保险打印单编号';
comment on column ${iml_schema}.agt_insure_pl.org_id is '机构编号';
comment on column ${iml_schema}.agt_insure_pl.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_insure_pl.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_insure_pl.seq_num is '序号';
comment on column ${iml_schema}.agt_insure_pl.policy_dt is '保单日期';
comment on column ${iml_schema}.agt_insure_pl.cfm_dt is '确认日期';
comment on column ${iml_schema}.agt_insure_pl.policy_effect_dt is '保单生效日期';
comment on column ${iml_schema}.agt_insure_pl.pay_ped is '支付周期';
comment on column ${iml_schema}.agt_insure_pl.insure_ped_type_cd is '保险周期类型代码';
comment on column ${iml_schema}.agt_insure_pl.insure_ped is '保险周期';
comment on column ${iml_schema}.agt_insure_pl.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_insure_pl.pay_ped_type_cd is '支付周期类型代码';
comment on column ${iml_schema}.agt_insure_pl.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_insure_pl.insure_fee is '保险费用';
comment on column ${iml_schema}.agt_insure_pl.lot is '份额';
comment on column ${iml_schema}.agt_insure_pl.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_insure_pl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_insure_pl.holder_name is '持有人姓名';
comment on column ${iml_schema}.agt_insure_pl.holder_cert_type_cd is '持有人证件类型代码';
comment on column ${iml_schema}.agt_insure_pl.holder_cert_no is '持有人证件号码';
comment on column ${iml_schema}.agt_insure_pl.rela_type_cd is '关系类型代码';
comment on column ${iml_schema}.agt_insure_pl.insrt_name is '被保险人姓名';
comment on column ${iml_schema}.agt_insure_pl.insrt_cert_type_cd is '被保险人证件类型代码';
comment on column ${iml_schema}.agt_insure_pl.insrt_cert_no is '被保险人证件号码';
comment on column ${iml_schema}.agt_insure_pl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_insure_pl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_insure_pl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_insure_pl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_insure_pl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_insure_pl.etl_timestamp is 'ETL处理时间戳';
