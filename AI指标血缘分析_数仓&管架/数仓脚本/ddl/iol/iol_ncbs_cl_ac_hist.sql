/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_ac_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_ac_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_ac_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_ac_hist(
    internal_key number(15,0) -- 账户内部键值|账户内部键值
    ,loan_no varchar2(50) -- 贷款号|贷款号
    ,seq_no varchar2(50) -- 序号|序号
    ,dd_no number(5,0) -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,acct_ccy varchar2(3) -- 账户币种|账户币种 对于aio账户和一本通账户
    ,prod_type varchar2(12) -- 产品编号|产品类型
    ,acct_desc varchar2(200) -- 账户描述|账户描述,目前同账户名称
    ,client_no varchar2(16) -- 客户编号|客户号
    ,client_type varchar2(3) -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type
    ,tran_date date -- 交易日期|交易日期
    ,tran_type varchar2(10) -- 交易类型|交易类型
    ,event_type varchar2(20) -- 事件类型|事件类型
    ,ccy varchar2(3) -- 币种|币种
    ,amt_type varchar2(10) -- 金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金
    ,tran_amt number(17,2) -- 交易金额|交易金额
    ,branch varchar2(12) -- 交易机构编号|机构代码
    ,source_type varchar2(6) -- 渠道编号|渠道类型
    ,reference varchar2(50) -- 交易参考号|交易参考号
    ,bank_seq_no varchar2(50) -- 银行交易序号|银行交易序号,单一机构下发生交易序号，按顺序递增 格式为 "机构_序号"
    ,reversal varchar2(1) -- 是否冲正标志|是否冲正标志|y-是,n-否
    ,reversal_tran_type varchar2(10) -- 冲正交易类型|冲正交易类型
    ,reversal_date date -- 冲正日期|冲正日期
    ,narrative varchar2(400) -- 摘要|开户时的账号用途，销户时的销户原因
    ,profit_center varchar2(20) -- 利润中心 |利润中心
    ,business_unit varchar2(10) -- 账套|账套|cbt-综合人民币账套,ubt-综合美元账套,ybt-原币账套
    ,source_module varchar2(3) -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,lender varchar2(100) -- 贷款人|贷款人
    ,acct_status varchar2(1) -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,accounting_status varchar2(3) -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq_逾期,fyj-非应计,fy-手工转非应计,wrn-核销,ter-终止
    ,acct_branch varchar2(12) -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,gl_posted_flag varchar2(1) -- 过账标记|过账标记|y-是,n-否
    ,marketing_prod varchar2(12) -- 营销产品|营销产品
    ,marketing_prod_desc varchar2(500) -- 营销产品名称|营销产品名称
    ,tran_category varchar2(5) -- 交易种类|交易种类
    ,reserve1 varchar2(50) -- 预留字段1|预留字段1
    ,reserve2 varchar2(50) -- 预留字段2|预留字段2
    ,user_id varchar2(8) -- 交易柜员编号|交易柜员
    ,company varchar2(20) -- 法人|法人
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,bus_seq_no varchar2(33) -- 业务流水号|业务流水号
    ,reaccount_cd varchar2(20) -- 对账代码|对账代码
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
grant select on ${iol_schema}.ncbs_cl_ac_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_ac_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_ac_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_ac_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_ac_hist is '账户核算流水表|记录账户变更类核算流水';
comment on column ${iol_schema}.ncbs_cl_ac_hist.internal_key is '账户内部键值|账户内部键值';
comment on column ${iol_schema}.ncbs_cl_ac_hist.loan_no is '贷款号|贷款号';
comment on column ${iol_schema}.ncbs_cl_ac_hist.seq_no is '序号|序号';
comment on column ${iol_schema}.ncbs_cl_ac_hist.dd_no is '发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据';
comment on column ${iol_schema}.ncbs_cl_ac_hist.acct_ccy is '账户币种|账户币种 对于aio账户和一本通账户';
comment on column ${iol_schema}.ncbs_cl_ac_hist.prod_type is '产品编号|产品类型';
comment on column ${iol_schema}.ncbs_cl_ac_hist.acct_desc is '账户描述|账户描述,目前同账户名称';
comment on column ${iol_schema}.ncbs_cl_ac_hist.client_no is '客户编号|客户号';
comment on column ${iol_schema}.ncbs_cl_ac_hist.client_type is '客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type';
comment on column ${iol_schema}.ncbs_cl_ac_hist.tran_date is '交易日期|交易日期';
comment on column ${iol_schema}.ncbs_cl_ac_hist.tran_type is '交易类型|交易类型';
comment on column ${iol_schema}.ncbs_cl_ac_hist.event_type is '事件类型|事件类型';
comment on column ${iol_schema}.ncbs_cl_ac_hist.ccy is '币种|币种';
comment on column ${iol_schema}.ncbs_cl_ac_hist.amt_type is '金额类型|金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金';
comment on column ${iol_schema}.ncbs_cl_ac_hist.tran_amt is '交易金额|交易金额';
comment on column ${iol_schema}.ncbs_cl_ac_hist.branch is '交易机构编号|机构代码';
comment on column ${iol_schema}.ncbs_cl_ac_hist.source_type is '渠道编号|渠道类型';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reference is '交易参考号|交易参考号';
comment on column ${iol_schema}.ncbs_cl_ac_hist.bank_seq_no is '银行交易序号|银行交易序号,单一机构下发生交易序号，按顺序递增 格式为 "机构_序号"';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reversal is '是否冲正标志|是否冲正标志|y-是,n-否';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reversal_tran_type is '冲正交易类型|冲正交易类型';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reversal_date is '冲正日期|冲正日期';
comment on column ${iol_schema}.ncbs_cl_ac_hist.narrative is '摘要|开户时的账号用途，销户时的销户原因';
comment on column ${iol_schema}.ncbs_cl_ac_hist.profit_center is '利润中心 |利润中心';
comment on column ${iol_schema}.ncbs_cl_ac_hist.business_unit is '账套|账套|cbt-综合人民币账套,ubt-综合美元账套,ybt-原币账套';
comment on column ${iol_schema}.ncbs_cl_ac_hist.source_module is '源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有';
comment on column ${iol_schema}.ncbs_cl_ac_hist.lender is '贷款人|贷款人';
comment on column ${iol_schema}.ncbs_cl_ac_hist.acct_status is '账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除';
comment on column ${iol_schema}.ncbs_cl_ac_hist.accounting_status is '核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq_逾期,fyj-非应计,fy-手工转非应计,wrn-核销,ter-终止';
comment on column ${iol_schema}.ncbs_cl_ac_hist.acct_branch is '开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构';
comment on column ${iol_schema}.ncbs_cl_ac_hist.gl_posted_flag is '过账标记|过账标记|y-是,n-否';
comment on column ${iol_schema}.ncbs_cl_ac_hist.marketing_prod is '营销产品|营销产品';
comment on column ${iol_schema}.ncbs_cl_ac_hist.marketing_prod_desc is '营销产品名称|营销产品名称';
comment on column ${iol_schema}.ncbs_cl_ac_hist.tran_category is '交易种类|交易种类';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reserve1 is '预留字段1|预留字段1';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reserve2 is '预留字段2|预留字段2';
comment on column ${iol_schema}.ncbs_cl_ac_hist.user_id is '交易柜员编号|交易柜员';
comment on column ${iol_schema}.ncbs_cl_ac_hist.company is '法人|法人';
comment on column ${iol_schema}.ncbs_cl_ac_hist.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_cl_ac_hist.bus_seq_no is '业务流水号|业务流水号';
comment on column ${iol_schema}.ncbs_cl_ac_hist.reaccount_cd is '对账代码|对账代码';
comment on column ${iol_schema}.ncbs_cl_ac_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_ac_hist.etl_timestamp is 'ETL处理时间戳';
