/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mercht_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mercht_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mercht_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_tran_dtl(
    card_no varchar2(60) -- 卡号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_tm timestamp -- 交易时间
    ,tran_dt date -- 交易日期
    ,retriv_ref_id varchar2(100) -- 检索参考编号
    ,tran_type_descb varchar2(150) -- 交易类型描述
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,mercht_no varchar2(100) -- 商户号
    ,mercht_name varchar2(150) -- 商户名称
    ,unionpay_mercht_cate_cd varchar2(30) -- 银联商户类别代码
    ,mercht_comm_fee number(30,2) -- 商户手续费
    ,int_paybl_amt number(30,2) -- 应付金额
    ,recvbl_amt number(30,2) -- 应收金额
    ,debit_crdt_flg varchar2(10) -- 借贷标志
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
grant select on ${iml_schema}.evt_mercht_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_mercht_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_mercht_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mercht_tran_dtl is '商户交易明细表';
comment on column ${iml_schema}.evt_mercht_tran_dtl.card_no is '卡号';
comment on column ${iml_schema}.evt_mercht_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mercht_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_mercht_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_mercht_tran_dtl.retriv_ref_id is '检索参考编号';
comment on column ${iml_schema}.evt_mercht_tran_dtl.tran_type_descb is '交易类型描述';
comment on column ${iml_schema}.evt_mercht_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_mercht_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_mercht_tran_dtl.mercht_no is '商户号';
comment on column ${iml_schema}.evt_mercht_tran_dtl.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_mercht_tran_dtl.unionpay_mercht_cate_cd is '银联商户类别代码';
comment on column ${iml_schema}.evt_mercht_tran_dtl.mercht_comm_fee is '商户手续费';
comment on column ${iml_schema}.evt_mercht_tran_dtl.int_paybl_amt is '应付金额';
comment on column ${iml_schema}.evt_mercht_tran_dtl.recvbl_amt is '应收金额';
comment on column ${iml_schema}.evt_mercht_tran_dtl.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_mercht_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_mercht_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mercht_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mercht_tran_dtl.etl_timestamp is 'ETL处理时间戳';
