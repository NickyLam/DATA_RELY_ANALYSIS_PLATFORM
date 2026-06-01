/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_open_dct_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_open_dct_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_open_dct_details(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,withdrawal_type varchar2(1) -- 支取方式
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_nature varchar2(10) -- 存款账户类型
    ,auto_renew_rollover varchar2(1) -- 自动转存方式
    ,bal_type varchar2(2) -- 余额类型
    ,batch_no varchar2(50) -- 批次号
    ,batch_open_status varchar2(1) -- 批量开立状态
    ,card_pb_ind varchar2(1) -- 卡/折标志
    ,cash_item varchar2(10) -- 现金项目
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,contact_type varchar2(20) -- 联系类型	
    ,copr_name varchar2(200) -- 单位名称
    ,email varchar2(200) -- 电子邮件
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,inland_offshore varchar2(1) -- 境内境外标志
    ,job_run_id varchar2(50) -- 批处理任务id
    ,location varchar2(200) -- 客户地址
    ,mobile_no varchar2(30) -- 电话号码
    ,occupation_code varchar2(5) -- 职业
    ,oth_bal_type varchar2(2) -- 对方余额类型
    ,oth_prefix varchar2(10) -- 对方票据前缀
    ,phone_no varchar2(20) -- 固定电话
    ,prefix varchar2(10) -- 前缀
    ,print_cnt number(5) -- 打印次数
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,seq_no varchar2(50) -- 序号
    ,sex varchar2(1) -- 性别
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,birthday date -- 生日
    ,document_expiry_date date -- 证件失效日期
    ,effect_date date -- 产品生效日期
    ,sign_time varchar2(26) -- 登记时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,contact_address varchar2(400) -- 公司联系地址
    ,open_branch varchar2(12) -- 开立机构
    ,open_ccy varchar2(3) -- 批量开户币种
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_no varchar2(50) -- 对方账号
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_doc_type varchar2(10) -- 对方凭证类型
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_voucher_no varchar2(50) -- 对方票据号码
    ,tran_amt number(17,2) -- 交易金额
    ,deposit_nature varchar2(10) -- 核心存款性质
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
grant select on ${iol_schema}.ncbs_rb_batch_open_dct_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_dct_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_dct_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_dct_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_open_dct_details is '批量开立存单客户登记表';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.term is '存期';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.auto_renew_rollover is '自动转存方式';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.batch_open_status is '批量开立状态';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.card_pb_ind is '卡/折标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.contact_type is '联系类型	';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.copr_name is '单位名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.email is '电子邮件';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.inland_offshore is '境内境外标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.location is '客户地址';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.occupation_code is '职业';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_bal_type is '对方余额类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_prefix is '对方票据前缀';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.phone_no is '固定电话';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.sex is '性别';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.birthday is '生日';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.document_expiry_date is '证件失效日期';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.sign_time is '登记时间';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.contact_address is '公司联系地址';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.open_ccy is '批量开户币种';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_acct_no is '对方账号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_doc_type is '对方凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.oth_voucher_no is '对方票据号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.deposit_nature is '核心存款性质';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_dct_details.etl_timestamp is 'ETL处理时间戳';
