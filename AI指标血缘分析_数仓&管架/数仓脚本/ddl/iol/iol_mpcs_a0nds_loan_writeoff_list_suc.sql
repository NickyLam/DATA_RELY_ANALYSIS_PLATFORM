/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0nds_loan_writeoff_list_suc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc(
    writeoff_date varchar2(15) -- 核销日期
    ,name varchar2(300) -- 姓名
    ,cust_id varchar2(30) -- 客户号
    ,bank_no varchar2(30) -- 银行号
    ,bank_group_id varchar2(8) -- 银团号
    ,product_cd varchar2(9) -- 产品号
    ,logical_card_no varchar2(29) -- 卡号
    ,ref_nbr varchar2(35) -- 参考号
    ,writeoff_proc_status varchar2(30) -- 核销状态
    ,loan_init_prin number(15,2) -- 本金
    ,loan_intr_penalty number(15,2) -- 利息罚息
    ,bank_proportion number(15,2) -- 银团比例
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc is '已核销借据清单表';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.writeoff_date is '核销日期';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.name is '姓名';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.cust_id is '客户号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.bank_no is '银行号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.bank_group_id is '银团号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.product_cd is '产品号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.logical_card_no is '卡号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.ref_nbr is '参考号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.writeoff_proc_status is '核销状态';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.loan_init_prin is '本金';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.loan_intr_penalty is '利息罚息';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.bank_proportion is '银团比例';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc.etl_timestamp is 'ETL处理时间戳';
