/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_audit_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_audit_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_audit_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_audit_detail(
    doc_type varchar2(10) -- 凭证类型
    ,voucher_status varchar2(3) -- 凭证状态
    ,audit_id varchar2(50) -- 查库编号
    ,cash_flag varchar2(1) -- 现金标志
    ,cash_par varchar2(10) -- 现金尾箱券别
    ,cash_sum number(10) -- 现金总数
    ,cash_sum_flag varchar2(1) -- 现金汇总标志
    ,company varchar2(20) -- 法人
    ,custody_flag varchar2(1) -- 代保管品标志
    ,custody_sum number(5) -- 代保管品数量
    ,custody_type varchar2(150) -- 代保管品种类
    ,item_flag varchar2(1) -- 重要物品标志
    ,item_id varchar2(50) -- 物品编号
    ,item_subtype varchar2(10) -- 重要物品子类型
    ,item_sum number(5) -- 重要物品数量
    ,item_type varchar2(10) -- 重要物品类型
    ,voucher_flag varchar2(1) -- 凭证标志
    ,voucher_sum number(5) -- 凭证合计数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cash_amt number(17,2) -- 现金尾箱金额
    ,cash_ccy varchar2(3) -- 现金尾箱币种
    ,cash_sum_amt number(17,2) -- 现金汇总金额
    ,cash_sum_ccy varchar2(3) -- 现金汇总币种
    ,custody_amt number(17,2) -- 代保管品金额
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,audit_detail_id varchar2(50) -- 查库详情编号
    ,custody_sub_type varchar2(10) -- 代保管物品大类
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
grant select on ${iol_schema}.ncbs_tb_audit_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_audit_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_audit_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_audit_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_audit_detail is '审计查库详细信息';
comment on column ${iol_schema}.ncbs_tb_audit_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_audit_detail.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_tb_audit_detail.audit_id is '查库编号';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_flag is '现金标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_par is '现金尾箱券别';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_sum is '现金总数';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_sum_flag is '现金汇总标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_audit_detail.custody_flag is '代保管品标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.custody_sum is '代保管品数量';
comment on column ${iol_schema}.ncbs_tb_audit_detail.custody_type is '代保管品种类';
comment on column ${iol_schema}.ncbs_tb_audit_detail.item_flag is '重要物品标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.item_id is '物品编号';
comment on column ${iol_schema}.ncbs_tb_audit_detail.item_subtype is '重要物品子类型';
comment on column ${iol_schema}.ncbs_tb_audit_detail.item_sum is '重要物品数量';
comment on column ${iol_schema}.ncbs_tb_audit_detail.item_type is '重要物品类型';
comment on column ${iol_schema}.ncbs_tb_audit_detail.voucher_flag is '凭证标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.voucher_sum is '凭证合计数';
comment on column ${iol_schema}.ncbs_tb_audit_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_amt is '现金尾箱金额';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_ccy is '现金尾箱币种';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_sum_amt is '现金汇总金额';
comment on column ${iol_schema}.ncbs_tb_audit_detail.cash_sum_ccy is '现金汇总币种';
comment on column ${iol_schema}.ncbs_tb_audit_detail.custody_amt is '代保管品金额';
comment on column ${iol_schema}.ncbs_tb_audit_detail.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_audit_detail.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_audit_detail.audit_detail_id is '查库详情编号';
comment on column ${iol_schema}.ncbs_tb_audit_detail.custody_sub_type is '代保管物品大类';
comment on column ${iol_schema}.ncbs_tb_audit_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_audit_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_audit_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_audit_detail.etl_timestamp is 'ETL处理时间戳';
