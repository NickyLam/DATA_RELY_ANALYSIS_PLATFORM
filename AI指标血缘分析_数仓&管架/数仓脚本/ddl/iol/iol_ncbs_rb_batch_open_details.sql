/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_open_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_open_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_open_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_open_details(
    client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,reason_code varchar2(10) -- 账户用途
    ,reference varchar2(50) -- 交易参考号
    ,voucher_no varchar2(50) -- 凭证号码
    ,withdrawal_type varchar2(1) -- 支取方式
    ,acct_class varchar2(1) -- 账户等级
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_nature varchar2(10) -- 存款账户类型
    ,all_dep_ind varchar2(1) -- 通存标志
    ,all_dra_ind varchar2(1) -- 通兑标志
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,card_pb_ind varchar2(1) -- 卡/折标志
    ,category_type varchar2(3) -- 存款人类别
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,contact_type varchar2(20) -- 联系类型	
    ,copr_name varchar2(200) -- 单位名称
    ,copr_soc_sec_no varchar2(50) -- 单位社保参保号码
    ,dist_code varchar2(6) -- 发证机关地区代码
    ,education varchar2(3) -- 教育程度编号
    ,email varchar2(200) -- 电子邮件
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,gain_type varchar2(1) -- 卡片领取方式
    ,guardian varchar2(200) -- 监护人名称
    ,guardian_phone varchar2(20) -- 监护人联系电话
    ,guardian_ship varchar2(20) -- 和监护人关系
    ,inland_offshore varchar2(1) -- 境内境外标志
    ,int_ind_flag varchar2(1) -- 是否计息
    ,job_run_id varchar2(50) -- 批处理任务id
    ,local_message varchar2(200) -- 地址说明
    ,location varchar2(200) -- 客户地址
    ,mobile_no varchar2(30) -- 电话号码
    ,occupation_code varchar2(5) -- 职业
    ,phone_no varchar2(20) -- 固定电话
    ,postal_code varchar2(10) -- 邮政编码
    ,prefix varchar2(10) -- 前缀
    ,print_cnt number(5) -- 打印次数
    ,race varchar2(10) -- 种族
    ,resident_flag varchar2(1) -- 居民性质
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,self_statement varchar2(1) -- 取得自证声明标志
    ,seq_no varchar2(50) -- 序号
    ,sex varchar2(1) -- 性别
    ,soc_sec_no varchar2(50) -- 客户社保参保号码
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,tran_note varchar2(1000) -- 交易附言
    ,birthday date -- 生日
    ,document_expiry_date date -- 证件失效日期
    ,iss_date date -- 签发日期
    ,open_date date -- 开立日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,from_card_no varchar2(50) -- 转出卡号
    ,guardian_document_id varchar2(60) -- 监护人身份证号
    ,open_branch varchar2(12) -- 开立机构
    ,open_ccy varchar2(3) -- 批量开户币种
    ,to_card_no varchar2(50) -- 终止卡号
    ,tran_amt number(17,2) -- 交易金额
    ,deposit_nature varchar2(10) -- 核心存款性质
    ,batch_open_type varchar2(3) -- 批量开立类型
    ,is_sell_cheque varchar2(1) -- 是否允许出售支票标识
    ,all_dra_int_branch varchar2(200) -- 通兑机构
    ,narrative_code varchar2(30) -- 摘要码
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
grant select on ${iol_schema}.ncbs_rb_batch_open_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_open_details is '批量开立信息明细登记簿';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.all_dep_ind is '通存标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.all_dra_ind is '通兑标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.card_pb_ind is '卡/折标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.category_type is '存款人类别';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.contact_type is '联系类型	';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.copr_name is '单位名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.copr_soc_sec_no is '单位社保参保号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.dist_code is '发证机关地区代码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.education is '教育程度编号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.email is '电子邮件';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.gain_type is '卡片领取方式';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.guardian is '监护人名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.guardian_phone is '监护人联系电话';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.guardian_ship is '和监护人关系';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.inland_offshore is '境内境外标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.local_message is '地址说明';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.location is '客户地址';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.occupation_code is '职业';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.phone_no is '固定电话';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.postal_code is '邮政编码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.race is '种族';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.resident_flag is '居民性质';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.self_statement is '取得自证声明标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.sex is '性别';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.soc_sec_no is '客户社保参保号码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.birthday is '生日';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.document_expiry_date is '证件失效日期';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.iss_date is '签发日期';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.open_date is '开立日期';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.from_card_no is '转出卡号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.guardian_document_id is '监护人身份证号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.open_ccy is '批量开户币种';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.to_card_no is '终止卡号';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.deposit_nature is '核心存款性质';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.batch_open_type is '批量开立类型';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.is_sell_cheque is '是否允许出售支票标识';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.all_dra_int_branch is '通兑机构';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_open_details.etl_timestamp is 'ETL处理时间戳';
