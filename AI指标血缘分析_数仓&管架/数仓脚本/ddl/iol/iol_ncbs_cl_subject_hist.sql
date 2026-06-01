/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_subject_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_subject_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_subject_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_subject_hist(
    amt_type varchar2(10) -- 金额类型
    ,branch varchar2(12) -- 机构编号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,country varchar2(3) -- 国家
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,br_seq_no varchar2(50) -- 前端流水号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,company varchar2(20) -- 法人
    ,conv_base varchar2(10) -- 转换基础
    ,cr_dr_maint_ind varchar2(1) -- 借贷标识
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,main_seq_no varchar2(50) -- 主流水号
    ,narrative varchar2(400) -- 摘要
    ,prefix varchar2(10) -- 前缀
    ,primary_event_type varchar2(5) -- 主事件类型
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,program_id varchar2(20) -- 交易代码
    ,rate_type varchar2(10) -- 汇率类型
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,reversal varchar2(1) -- 是否冲正标志
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,serv_charge varchar2(1) -- 服务费标识
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,trace_id varchar2(200) -- 跟踪id
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_hist_seq_no varchar2(33) -- 交易流水号
    ,tran_status varchar2(1) -- 冲补抹标志
    ,accounting_status varchar2(3) -- 核算状态
    ,effect_date date -- 产品生效日期
    ,post_date date -- 入账日期
    ,reversal_tran_date date -- 冲正交易日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,base_equiv_amt number(17,2) -- 基础等值金额
    ,contra_acct_ccy varchar2(3) -- 对方币种
    ,contra_equiv_amt number(17,2) -- 对方等值金额
    ,cross_rate number(15,8) -- 交叉汇率
    ,float_days number(5) -- 浮动天数
    ,tfr_branch varchar2(12) -- 对方交易机构
    ,tran_amt number(17,2) -- 交易金额
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_cl_subject_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_subject_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_subject_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_subject_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_subject_hist is '总账记账流水表';
comment on column ${iol_schema}.ncbs_cl_subject_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_subject_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_subject_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_cl_subject_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.country is '国家';
comment on column ${iol_schema}.ncbs_cl_subject_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_cl_subject_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_cl_subject_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.br_seq_no is '前端流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_subject_hist.conv_base is '转换基础';
comment on column ${iol_schema}.ncbs_cl_subject_hist.cr_dr_maint_ind is '借贷标识';
comment on column ${iol_schema}.ncbs_cl_subject_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_subject_hist.main_seq_no is '主流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_subject_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_cl_subject_hist.primary_event_type is '主事件类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_cl_subject_hist.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_cl_subject_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.serv_charge is '服务费标识';
comment on column ${iol_schema}.ncbs_cl_subject_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_subject_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.trace_id is '跟踪id';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_hist_seq_no is '交易流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_subject_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_subject_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_subject_hist.post_date is '入账日期';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reversal_tran_date is '冲正交易日期';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_subject_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_subject_hist.base_equiv_amt is '基础等值金额';
comment on column ${iol_schema}.ncbs_cl_subject_hist.contra_acct_ccy is '对方币种';
comment on column ${iol_schema}.ncbs_cl_subject_hist.contra_equiv_amt is '对方等值金额';
comment on column ${iol_schema}.ncbs_cl_subject_hist.cross_rate is '交叉汇率';
comment on column ${iol_schema}.ncbs_cl_subject_hist.float_days is '浮动天数';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tfr_branch is '对方交易机构';
comment on column ${iol_schema}.ncbs_cl_subject_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cl_subject_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_subject_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_cl_subject_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_subject_hist.etl_timestamp is 'ETL处理时间戳';
