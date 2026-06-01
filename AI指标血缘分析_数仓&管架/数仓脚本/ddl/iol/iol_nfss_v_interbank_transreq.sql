/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_v_interbank_transreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_v_interbank_transreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_v_interbank_transreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_v_interbank_transreq(
    client_no varchar2(72) -- 客户号
    ,client_name varchar2(750) -- 客户名称
    ,serial_no varchar2(105) -- 交易流水
    ,trans_date number -- 交易日期
    ,trans_time number -- 交易时间
    ,trans_code varchar2(32) -- 交易代码
    ,trans_name varchar2(750) -- 交易代码名称
    ,branch_no varchar2(48) -- 机构号
    ,in_client_no varchar2(60) -- 内部客户号
    ,client_type varchar2(3) -- 客户类型
    ,id_type varchar2(90) -- 证件类型
    ,id_code varchar2(120) -- 证件号码
    ,amt number(18,2) -- 交易金额
    ,vol number(18,3) -- 份额
    ,bank_acc varchar2(96) -- 交易账号
    ,bank_name varchar2(750) -- 开户行
    ,cnaps_code varchar2(96) -- 大额行号
    ,channel varchar2(18) -- 渠道
    ,curr_type varchar2(9) -- 币种
    ,status varchar2(3) -- 交易确认状态
    ,busin_code varchar2(18) -- 业务码
    ,cfm_date number -- 确认日期
    ,cfm_amt number(18,2) -- 确认金额
    ,cfm_vol number(18,3) -- 确认份额
    ,repr_name varchar2(2000) -- 法人代表姓名
    ,repr_id_type varchar2(90) -- 法人代表证件类型
    ,repr_id_code varchar2(120) -- 法人代表证件号码
    ,repr_mobile varchar2(72) -- 法人代表手机号
    ,actor_name varchar2(750) -- 经办人姓名
    ,actor_id_type varchar2(90) -- 经办人证件类型
    ,actor_id_code varchar2(120) -- 经办人证件号码
    ,actor_tel varchar2(72) -- 经办人办公电话
    ,actor_mobile varchar2(72) -- 经办人手机号
    ,square_no varchar2(96) -- 清算流水
    ,seq_no number -- 清算序号
    ,square_date number -- 清算日期
    ,old_square_date number -- 旧清算日期
    ,liqu_dir varchar2(3) -- 账务方向
    ,square_amt number(18,2) -- 入账金额
    ,frozen_amt number(18,2) -- 冻结金额
    ,square_status varchar2(3) -- 流水状态
    ,deal_status varchar2(3) -- 账务状态
    ,open_date number -- 开户日期
    ,prd_code varchar2(60) -- 产品代码
    ,debit_account varchar2(96) -- 认申购归集户
    ,debit_account_name varchar2(2000) -- 认申购归集户名
    ,crebit_account varchar2(96) -- 基金赎回户
    ,crebit_account_name varchar2(2000) -- 基金赎回户名
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
grant select on ${iol_schema}.nfss_v_interbank_transreq to ${iml_schema};
grant select on ${iol_schema}.nfss_v_interbank_transreq to ${icl_schema};
grant select on ${iol_schema}.nfss_v_interbank_transreq to ${idl_schema};
grant select on ${iol_schema}.nfss_v_interbank_transreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_v_interbank_transreq is '同业基金流水表';
comment on column ${iol_schema}.nfss_v_interbank_transreq.client_no is '客户号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.client_name is '客户名称';
comment on column ${iol_schema}.nfss_v_interbank_transreq.serial_no is '交易流水';
comment on column ${iol_schema}.nfss_v_interbank_transreq.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_v_interbank_transreq.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.trans_name is '交易代码名称';
comment on column ${iol_schema}.nfss_v_interbank_transreq.branch_no is '机构号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.in_client_no is '内部客户号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.client_type is '客户类型';
comment on column ${iol_schema}.nfss_v_interbank_transreq.id_type is '证件类型';
comment on column ${iol_schema}.nfss_v_interbank_transreq.id_code is '证件号码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.amt is '交易金额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.vol is '份额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.bank_acc is '交易账号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.bank_name is '开户行';
comment on column ${iol_schema}.nfss_v_interbank_transreq.cnaps_code is '大额行号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.channel is '渠道';
comment on column ${iol_schema}.nfss_v_interbank_transreq.curr_type is '币种';
comment on column ${iol_schema}.nfss_v_interbank_transreq.status is '交易确认状态';
comment on column ${iol_schema}.nfss_v_interbank_transreq.busin_code is '业务码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.cfm_amt is '确认金额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.repr_name is '法人代表姓名';
comment on column ${iol_schema}.nfss_v_interbank_transreq.repr_id_type is '法人代表证件类型';
comment on column ${iol_schema}.nfss_v_interbank_transreq.repr_id_code is '法人代表证件号码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.repr_mobile is '法人代表手机号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.actor_name is '经办人姓名';
comment on column ${iol_schema}.nfss_v_interbank_transreq.actor_id_type is '经办人证件类型';
comment on column ${iol_schema}.nfss_v_interbank_transreq.actor_id_code is '经办人证件号码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.actor_tel is '经办人办公电话';
comment on column ${iol_schema}.nfss_v_interbank_transreq.actor_mobile is '经办人手机号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.square_no is '清算流水';
comment on column ${iol_schema}.nfss_v_interbank_transreq.seq_no is '清算序号';
comment on column ${iol_schema}.nfss_v_interbank_transreq.square_date is '清算日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.old_square_date is '旧清算日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.liqu_dir is '账务方向';
comment on column ${iol_schema}.nfss_v_interbank_transreq.square_amt is '入账金额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.frozen_amt is '冻结金额';
comment on column ${iol_schema}.nfss_v_interbank_transreq.square_status is '流水状态';
comment on column ${iol_schema}.nfss_v_interbank_transreq.deal_status is '账务状态';
comment on column ${iol_schema}.nfss_v_interbank_transreq.open_date is '开户日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_v_interbank_transreq.debit_account is '认申购归集户';
comment on column ${iol_schema}.nfss_v_interbank_transreq.debit_account_name is '认申购归集户名';
comment on column ${iol_schema}.nfss_v_interbank_transreq.crebit_account is '基金赎回户';
comment on column ${iol_schema}.nfss_v_interbank_transreq.crebit_account_name is '基金赎回户名';
comment on column ${iol_schema}.nfss_v_interbank_transreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_v_interbank_transreq.etl_timestamp is 'ETL处理时间戳';
