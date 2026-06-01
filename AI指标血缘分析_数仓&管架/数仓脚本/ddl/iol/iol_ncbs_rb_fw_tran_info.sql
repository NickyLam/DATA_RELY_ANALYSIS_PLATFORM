/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fw_tran_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fw_tran_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fw_tran_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fw_tran_info(
    service_id varchar2(400) -- 服务id
    ,service_no varchar2(800) -- 服务唯一识别号
    ,tran_date varchar2(80) -- 交易日期
    ,tran_time varchar2(120) -- 交易时间
    ,response_type varchar2(400) -- 输出响应类型
    ,end_time varchar2(120) -- 交易完成时间
    ,source_type varchar2(40) -- 渠道类型
    ,seq_no varchar2(200) -- 渠道流水号
    ,program_id varchar2(80) -- 交易屏幕标识
    ,status varchar2(4) -- 状态
    ,reference varchar2(200) -- 业务参考号
    ,platform_id varchar2(128) -- 平台流水号
    ,user_id varchar2(120) -- 操作柜员
    ,ip_address varchar2(120) -- ip地址
    ,branch_id varchar2(80) -- 网点
    ,compensate_service_no varchar2(800) -- 待补偿原交易唯一识别号
    ,week_day number(1,0) -- 日期
    ,create_date date -- 记录创建日期
    ,bus_seq_no varchar2(132) -- 业务流水号
    ,run_date date -- 会计日期
    ,inner_service_flag varchar2(1) -- 内部服务标识（y:是，n:否）
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,acct_no varchar2(200) -- 账号
    ,acct_seq_no varchar2(20) -- 子序号
    ,tran_amt number(17,2) -- 交易金额
    ,ccy varchar2(12) -- 交易币种
    ,auth_user_id varchar2(120) -- 授权柜员
    ,oth_acct_no varchar2(200) -- 对手账号
    ,oth_acct_seq_no varchar2(20) -- 对手子序号
    ,voucher_no varchar2(200) -- 开户凭证
    ,doc_type varchar2(40) -- 开户凭证类型
    ,prefix varchar2(40) -- 开户凭证前缀
    ,cheque_voucher_no varchar2(200) -- 支票凭证
    ,cheque_doc_type varchar2(200) -- 支票凭证类型
    ,cheque_prefix varchar2(200) -- 支票凭证前缀
    ,remark varchar2(800) -- 附言
    ,tran_name varchar2(800) -- 交易名称
    ,inner_flag varchar2(4) -- 内部调用标识，y-是；n-否
    ,source_model varchar2(12) -- 源模块
    ,base_acct_no varchar2(200) -- 卡号
    ,sub_seq_no varchar2(400) -- 子流水号
    ,financial_flag varchar2(4) -- 金融标志: y-是，n-否
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
grant select on ${iol_schema}.ncbs_rb_fw_tran_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fw_tran_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fw_tran_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fw_tran_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fw_tran_info is '交易流水表';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.service_id is '服务id';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.service_no is '服务唯一识别号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.tran_time is '交易时间';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.response_type is '输出响应类型';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.end_time is '交易完成时间';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.source_type is '渠道类型';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.seq_no is '渠道流水号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.program_id is '交易屏幕标识';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.status is '状态';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.reference is '业务参考号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.platform_id is '平台流水号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.ip_address is 'ip地址';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.branch_id is '网点';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.compensate_service_no is '待补偿原交易唯一识别号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.week_day is '日期';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.create_date is '记录创建日期';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.run_date is '会计日期';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.inner_service_flag is '内部服务标识（y:是，n:否）';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.acct_no is '账号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.acct_seq_no is '子序号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.ccy is '交易币种';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.oth_acct_no is '对手账号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.oth_acct_seq_no is '对手子序号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.voucher_no is '开户凭证';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.doc_type is '开户凭证类型';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.prefix is '开户凭证前缀';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.cheque_voucher_no is '支票凭证';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.cheque_doc_type is '支票凭证类型';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.cheque_prefix is '支票凭证前缀';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.remark is '附言';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.tran_name is '交易名称';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.inner_flag is '内部调用标识，y-是；n-否';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.source_model is '源模块';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.base_acct_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.sub_seq_no is '子流水号';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.financial_flag is '金融标志: y-是，n-否';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_fw_tran_info.etl_timestamp is 'ETL处理时间戳';
