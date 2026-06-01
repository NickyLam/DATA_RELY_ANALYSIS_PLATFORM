/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_detail_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_detail_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_detail_attach(
    client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,float_amount number(17,2) -- 折溢价总额
    ,float_int number(17,2) -- 折溢价利息
    ,float_pri number(17,2) -- 折溢价本金
    ,loan_no varchar2(50) -- 贷款号
    ,pack_int number(17,2) -- 起算日应计利息
    ,pack_intp number(17,2) -- 起算日应收利息
    ,pack_odi number(17,2) -- 起算日应计复利
    ,pack_odip number(17,2) -- 起算日应收复利
    ,pack_odp number(17,2) -- 起算日应计罚息
    ,pack_odpp number(17,2) -- 起算日应收罚息
    ,pack_out_int number(17,2) -- 起算日表外应计利息
    ,pack_out_intp number(17,2) -- 起算日表外应收利息
    ,pack_out_odi number(17,2) -- 起算日表外应计复利
    ,pack_out_odip number(17,2) -- 起算日表外应收复利
    ,pack_out_odp number(17,2) -- 起算日表外应计罚息
    ,pack_out_odpp number(17,2) -- 起算日表外应收罚息
    ,pack_pri number(17,2) -- 起算日本金
    ,settle_amt number(17,2) -- 结算金额
    ,asset_detail_seq_no varchar2(50) -- 资产包合同明细序号
    ,asset_contract_seq_no varchar2(50) -- 资产包合同序号
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
grant select on ${iol_schema}.ncbs_cl_transfer_detail_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_detail_attach is '资产转让合同明细关联表';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.float_amount is '折溢价总额';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.float_int is '折溢价利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.float_pri is '折溢价本金';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_int is '起算日应计利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_intp is '起算日应收利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_odi is '起算日应计复利';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_odip is '起算日应收复利';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_odp is '起算日应计罚息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_odpp is '起算日应收罚息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_int is '起算日表外应计利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_intp is '起算日表外应收利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_odi is '起算日表外应计复利';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_odip is '起算日表外应收复利';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_odp is '起算日表外应计罚息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_out_odpp is '起算日表外应收罚息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.pack_pri is '起算日本金';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.asset_detail_seq_no is '资产包合同明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.asset_contract_seq_no is '资产包合同序号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_detail_attach.etl_timestamp is 'ETL处理时间戳';
