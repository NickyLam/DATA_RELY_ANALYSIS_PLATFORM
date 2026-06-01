/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fdps_batch_process
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fdps_batch_process
whenever sqlerror continue none;
drop table ${iol_schema}.fdps_batch_process purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_batch_process(
    batch_id varchar2(60) -- 批次编号
    ,batch_name varchar2(765) -- 批次名称
    ,third_batch_id varchar2(180) -- 第三方批次编号
    ,parent_merchant_id varchar2(60) -- 银行合作商编号
    ,check_date varchar2(60) -- 对账日期
    ,batch_type varchar2(180) -- 批次类型
    ,deal_option varchar2(1) -- 文件处理选项
    ,old_req_seq_no varchar2(180) -- 第三方流水
    ,submit_file varchar2(765) -- 提交数据文件名
    ,result_file varchar2(765) -- 结果数据文件名
    ,submit_count number(18,2) -- 提交数据总笔数
    ,submit_sum number(18,2) -- 提交数据总金额
    ,result_count number(18,2) -- 结果数据总笔数
    ,result_sum number(18,2) -- 结果数据总金额
    ,deposit_count number(18,2) -- 入金提交总笔数
    ,deposit_sum number(18,2) -- 入金提交总金额
    ,withdraw_count number(18,2) -- 出金提交总笔数
    ,withdraw_sum number(18,2) -- 出金提交总金额
    ,success_count number(18,2) -- 成功笔数
    ,success_amount number(18,2) -- 成功金额
    ,fail_count number(18,2) -- 失败笔数
    ,fail_amount number(18,2) -- 失败金额
    ,submit_gua_amount number(18,2) -- 提交数据总担保金额
    ,success_gua_amount number(18,2) -- 成功担保金额
    ,tran_branch_id varchar2(180) -- 交易机构
    ,tran_teller_no varchar2(30) -- 交易柜员
    ,transaction_date timestamp -- 交易日期
    ,resp_code varchar2(180) -- 响应码
    ,resp_msg varchar2(4000) -- 响应信息
    ,has_detal_flag varchar2(180) -- 是否有明细
    ,batch_status varchar2(180) -- 批次结果
    ,amt_source varchar2(32) -- 资金来源
    ,remark varchar2(765) -- 备注
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.fdps_batch_process to ${iml_schema};
grant select on ${iol_schema}.fdps_batch_process to ${icl_schema};
grant select on ${iol_schema}.fdps_batch_process to ${idl_schema};
grant select on ${iol_schema}.fdps_batch_process to ${iel_schema};

-- comment
comment on table ${iol_schema}.fdps_batch_process is '批次事务处理表';
comment on column ${iol_schema}.fdps_batch_process.batch_id is '批次编号';
comment on column ${iol_schema}.fdps_batch_process.batch_name is '批次名称';
comment on column ${iol_schema}.fdps_batch_process.third_batch_id is '第三方批次编号';
comment on column ${iol_schema}.fdps_batch_process.parent_merchant_id is '银行合作商编号';
comment on column ${iol_schema}.fdps_batch_process.check_date is '对账日期';
comment on column ${iol_schema}.fdps_batch_process.batch_type is '批次类型';
comment on column ${iol_schema}.fdps_batch_process.deal_option is '文件处理选项';
comment on column ${iol_schema}.fdps_batch_process.old_req_seq_no is '第三方流水';
comment on column ${iol_schema}.fdps_batch_process.submit_file is '提交数据文件名';
comment on column ${iol_schema}.fdps_batch_process.result_file is '结果数据文件名';
comment on column ${iol_schema}.fdps_batch_process.submit_count is '提交数据总笔数';
comment on column ${iol_schema}.fdps_batch_process.submit_sum is '提交数据总金额';
comment on column ${iol_schema}.fdps_batch_process.result_count is '结果数据总笔数';
comment on column ${iol_schema}.fdps_batch_process.result_sum is '结果数据总金额';
comment on column ${iol_schema}.fdps_batch_process.deposit_count is '入金提交总笔数';
comment on column ${iol_schema}.fdps_batch_process.deposit_sum is '入金提交总金额';
comment on column ${iol_schema}.fdps_batch_process.withdraw_count is '出金提交总笔数';
comment on column ${iol_schema}.fdps_batch_process.withdraw_sum is '出金提交总金额';
comment on column ${iol_schema}.fdps_batch_process.success_count is '成功笔数';
comment on column ${iol_schema}.fdps_batch_process.success_amount is '成功金额';
comment on column ${iol_schema}.fdps_batch_process.fail_count is '失败笔数';
comment on column ${iol_schema}.fdps_batch_process.fail_amount is '失败金额';
comment on column ${iol_schema}.fdps_batch_process.submit_gua_amount is '提交数据总担保金额';
comment on column ${iol_schema}.fdps_batch_process.success_gua_amount is '成功担保金额';
comment on column ${iol_schema}.fdps_batch_process.tran_branch_id is '交易机构';
comment on column ${iol_schema}.fdps_batch_process.tran_teller_no is '交易柜员';
comment on column ${iol_schema}.fdps_batch_process.transaction_date is '交易日期';
comment on column ${iol_schema}.fdps_batch_process.resp_code is '响应码';
comment on column ${iol_schema}.fdps_batch_process.resp_msg is '响应信息';
comment on column ${iol_schema}.fdps_batch_process.has_detal_flag is '是否有明细';
comment on column ${iol_schema}.fdps_batch_process.batch_status is '批次结果';
comment on column ${iol_schema}.fdps_batch_process.amt_source is '资金来源';
comment on column ${iol_schema}.fdps_batch_process.remark is '备注';
comment on column ${iol_schema}.fdps_batch_process.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.fdps_batch_process.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.fdps_batch_process.created_stamp is '创建时间';
comment on column ${iol_schema}.fdps_batch_process.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.fdps_batch_process.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fdps_batch_process.etl_timestamp is 'ETL处理时间戳';
