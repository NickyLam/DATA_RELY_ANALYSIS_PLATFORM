/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_pir_adm_pay_ele_sys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_pir_adm_pay_ele_sys
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_sys purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_pir_adm_pay_ele_sys(
    data_dt varchar2(15) -- 数据日期
    ,org_num varchar2(18) -- 机构号
    ,ele_pay_typ varchar2(2) -- 支付载体
    ,tran_num number(18,0) -- 交易笔数
    ,tran_amt number(18,4) -- 交易金额
    ,payment_order varchar2(2) -- 支付指令载体
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_sys to ${iml_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_sys to ${icl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_sys to ${idl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_sys to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_pir_adm_pay_ele_sys is '电子支付系统交易汇总表';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.data_dt is '数据日期';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.org_num is '机构号';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.ele_pay_typ is '支付载体';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.tran_num is '交易笔数';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.tran_amt is '交易金额';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.payment_order is '支付指令载体';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_sys.etl_timestamp is 'ETL处理时间戳';
