/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_foundation_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_foundation_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_foundation_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_foundation_details(
    client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,restraint_type varchar2(3) -- 限制类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,bal_type varchar2(2) -- 余额类型
    ,batch_no varchar2(50) -- 批次号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_card_pb_ind varchar2(1) -- 转入账户卡折标志
    ,cr_tran_type varchar2(10) -- 转入交易类型
    ,dr_tran_type varchar2(10) -- 转出交易类型
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,frozen_pb_flag varchar2(1) -- 冻结账户卡折标志
    ,frozen_seq_no varchar2(50) -- 冻结流水号
    ,job_run_id varchar2(50) -- 批处理任务id
    ,narrative varchar2(400) -- 摘要
    ,res_flag varchar2(1) -- 冻结标志
    ,ret_code varchar2(50) -- 状态码
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,transfer_flag varchar2(1) -- 转账标志
    ,unfrozen_flag varchar2(1) -- 解冻标志
    ,unfrozen_pb_flag varchar2(1) -- 解冻账户卡折标志
    ,unfrozen_seq_no varchar2(50) -- 解冻流水号
    ,dr_card_pb_ind varchar2(1) -- 借方账户卡折标志
    ,channel varchar2(10) -- 渠道
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cr_acct_ccy varchar2(3) -- 贷方账户币种
    ,cr_acct_type varchar2(1) -- 收款账户类型（行内账户）
    ,cr_base_acct_no varchar2(50) -- 贷方账号
    ,credit_card_no varchar2(50) -- 信用卡号
    ,dr_acct_type varchar2(1) -- 转出账户类型
    ,dr_base_acct_no varchar2(50) -- 借方账号
    ,frozen_acct_type varchar2(1) -- 冻结账户类型
    ,frozen_base_acct_no varchar2(50) -- 冻结账户
    ,frozen_ccy varchar2(3) -- 冻结账户币种
    ,pledged_amt number(17,2) -- 限制金额
    ,remark1 varchar2(600) -- 备注1
    ,remark2 varchar2(600) -- 备注2
    ,remark3 varchar2(600) -- 备注3
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,transfer_amt number(17,2) -- 划转金额
    ,unfrozen_base_acct_no varchar2(50) -- 解冻账户/卡号
    ,unfrozen_ccy varchar2(3) -- 解冻账户币种
    ,narrative_code varchar2(30) -- 摘要码
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
grant select on ${iol_schema}.ncbs_rb_batch_foundation_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_foundation_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_foundation_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_foundation_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_foundation_details is '基金批量交易信息明细登记簿';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.term is '存期';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.cr_card_pb_ind is '转入账户卡折标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.cr_tran_type is '转入交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.dr_tran_type is '转出交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.frozen_pb_flag is '冻结账户卡折标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.frozen_seq_no is '冻结流水号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.res_flag is '冻结标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.ret_code is '状态码';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.transfer_flag is '转账标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.unfrozen_flag is '解冻标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.unfrozen_pb_flag is '解冻账户卡折标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.unfrozen_seq_no is '解冻流水号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.dr_card_pb_ind is '借方账户卡折标志';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.cr_acct_ccy is '贷方账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.cr_acct_type is '收款账户类型（行内账户）';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.cr_base_acct_no is '贷方账号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.credit_card_no is '信用卡号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.dr_acct_type is '转出账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.dr_base_acct_no is '借方账号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.frozen_acct_type is '冻结账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.frozen_base_acct_no is '冻结账户';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.frozen_ccy is '冻结账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.pledged_amt is '限制金额';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.remark2 is '备注2';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.transfer_amt is '划转金额';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.unfrozen_base_acct_no is '解冻账户/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.unfrozen_ccy is '解冻账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_foundation_details.etl_timestamp is 'ETL处理时间戳';
