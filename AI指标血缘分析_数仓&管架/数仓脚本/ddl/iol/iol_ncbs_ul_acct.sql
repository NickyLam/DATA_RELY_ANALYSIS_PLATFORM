/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_acct(
    cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,batch_no varchar2(50) -- 批次号|批次号
    ,loan_no varchar2(50) -- 贷款号|贷款号
    ,dd_no number(5,0) -- 发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据
    ,prod_type varchar2(12) -- 产品编号|产品编号
    ,ccy varchar2(3) -- 币种|币种
    ,branch varchar2(12) -- 交易机构编号|机构代码
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,acct_open_date date -- 账户开户日期|账户开户日期
    ,effect_date date -- 产品生效日期|产品生效日期
    ,open_tran_date date -- 开户后首次交易日期|开户后首次交易日期
    ,dd_amt number(17,2) -- 发放金额|发放金额
    ,acct_status varchar2(1) -- 账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-正常,d-不动户,s-久悬户,o-转营业外,p-逾期,c-关闭,i-预开户,r-预销户
    ,acct_status_prev varchar2(1) -- 账户上一状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除
    ,acct_status_upd_date date -- 账户状态变更日期|账户状态变更日期
    ,accounting_status varchar2(3) -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_prev varchar2(3) -- 上次核算状态|上次核算状态|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,accounting_status_upd_date date -- 核算状态变更日期|核算状态变更日期
    ,acct_close_date date -- 销户日期|账户销户日期
    ,acct_close_reason varchar2(300) -- 关闭原因|账户销户原因，一般由渠道上送
    ,orig_acct_open_date date -- 账户原始开立日期|账户原始开立日期，即第一次开立日期，未进行过转存的首次开立日期
    ,ori_maturity_date date -- 账户原始到期日期|账户原始到期日期，即第一次开立时的到期日期，未进行期限变更时的到期日
    ,acct_name varchar2(200) -- 账户名称|账户名称，一般指中文账户名称
    ,term varchar2(5) -- 存期|存款期限
    ,term_type varchar2(1) -- 期限单位|期限单位|y-年,q-季,m-月,w-周,d-日
    ,maturity_date date -- 到期日期|到期日期
    ,apply_branch varchar2(12) -- 申请机构|申请机构
    ,home_branch varchar2(12) -- 客户管理行|客户管理行
    ,last_change_date date -- 最后修改日期|最后修改日期
    ,lender varchar2(100) -- 贷款人|贷款人
    ,five_category varchar2(2) -- 贷款五级分类|贷款五级分类|10-正常,20-关注,30-次级,40-可疑,50-损失
    ,sched_mode varchar2(2) -- 还款方式|还款方式|1-等额本息,2-等额本金,3-一次性还本付息前收息,4-按频率付息一次还本,5-按频率付息任意本金,6-气球贷,7-等额累进,8-等比累进,9-等本等息,10-组合贷,11-按比例还本,15-自定义还款方式
    ,source_type varchar2(6) -- 渠道编号|渠道类型
    ,source_module varchar2(3) -- 源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有
    ,client_type varchar2(3) -- 客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type
    ,is_individual varchar2(1) -- 个体客户标志|是否个体客户|y-是,n-否
    ,int_ind_flag varchar2(1) -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
    ,cur_stage_no number(4,0) -- 当前期数|当前期次
    ,acct_type varchar2(1) -- 账户类型|账户类型|a-aio账户,c-结算账户,d-垫款,e-委托贷款,l-转让贷款,m-普通贷款,s-储蓄账户,t-定期账户,u-贴现贷款,y-银团贷款,z-资产证券化
    ,last_tran_date date -- 最后交易日期|最后交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,first_overdue_date date -- 最早逾期日期 |最早逾期日期
    ,manual_change_schedule_flag varchar2(1) -- 是否需要手工录入还款计划 |是否需要手工录入还款计划|y-是,n-否
    ,ssi_end_date date -- 贴息截止日期 |贴息截止日期
    ,fta_acct_flag varchar2(1) -- 是否自贸区账户标识|是否自贸区账户标识|y-是,n-否
    ,marketing_prod varchar2(12) -- 营销产品|营销产品
    ,marketing_prod_desc varchar2(200) -- 营销产品名称|营销产品名称
    ,formula_amt number(17,2) -- 每期计划还款额|每期计划还款额
    ,purpose varchar2(6) -- 贷款用途  |贷款用途
    ,profit_center varchar2(20) -- 利润中心 |利润中心
    ,belong_branch varchar2(12) -- 归属机构  |归属机构
    ,internal_key number(15,0) -- 账户内部键值|账户内部键值
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
grant select on ${iol_schema}.ncbs_ul_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_acct is '联合贷账户基本信息表';
comment on column ${iol_schema}.ncbs_ul_acct.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_acct.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_acct.loan_no is '贷款号|贷款号';
comment on column ${iol_schema}.ncbs_ul_acct.dd_no is '发放号|贷款发放号，采用顺序数字，表示在同一贷款号、贷款账户类型、币种下的不同借据';
comment on column ${iol_schema}.ncbs_ul_acct.prod_type is '产品编号|产品编号';
comment on column ${iol_schema}.ncbs_ul_acct.ccy is '币种|币种';
comment on column ${iol_schema}.ncbs_ul_acct.branch is '交易机构编号|机构代码';
comment on column ${iol_schema}.ncbs_ul_acct.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_acct.acct_open_date is '账户开户日期|账户开户日期';
comment on column ${iol_schema}.ncbs_ul_acct.effect_date is '产品生效日期|产品生效日期';
comment on column ${iol_schema}.ncbs_ul_acct.open_tran_date is '开户后首次交易日期|开户后首次交易日期';
comment on column ${iol_schema}.ncbs_ul_acct.dd_amt is '发放金额|发放金额';
comment on column ${iol_schema}.ncbs_ul_acct.acct_status is '账户状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-正常,d-不动户,s-久悬户,o-转营业外,p-逾期,c-关闭,i-预开户,r-预销户';
comment on column ${iol_schema}.ncbs_ul_acct.acct_status_prev is '账户上一状态|描述账户生命周期不同阶段的划分|n-新建,h-待激活,a-活动,d-睡眠,s-久悬,o-转营业外,p-逾期,c-关闭,u-手工解除';
comment on column ${iol_schema}.ncbs_ul_acct.acct_status_upd_date is '账户状态变更日期|账户状态变更日期';
comment on column ${iol_schema}.ncbs_ul_acct.accounting_status is '核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止';
comment on column ${iol_schema}.ncbs_ul_acct.accounting_status_prev is '上次核算状态|上次核算状态|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止';
comment on column ${iol_schema}.ncbs_ul_acct.accounting_status_upd_date is '核算状态变更日期|核算状态变更日期';
comment on column ${iol_schema}.ncbs_ul_acct.acct_close_date is '销户日期|账户销户日期';
comment on column ${iol_schema}.ncbs_ul_acct.acct_close_reason is '关闭原因|账户销户原因，一般由渠道上送';
comment on column ${iol_schema}.ncbs_ul_acct.orig_acct_open_date is '账户原始开立日期|账户原始开立日期，即第一次开立日期，未进行过转存的首次开立日期';
comment on column ${iol_schema}.ncbs_ul_acct.ori_maturity_date is '账户原始到期日期|账户原始到期日期，即第一次开立时的到期日期，未进行期限变更时的到期日';
comment on column ${iol_schema}.ncbs_ul_acct.acct_name is '账户名称|账户名称，一般指中文账户名称';
comment on column ${iol_schema}.ncbs_ul_acct.term is '存期|存款期限';
comment on column ${iol_schema}.ncbs_ul_acct.term_type is '期限单位|期限单位|y-年,q-季,m-月,w-周,d-日';
comment on column ${iol_schema}.ncbs_ul_acct.maturity_date is '到期日期|到期日期';
comment on column ${iol_schema}.ncbs_ul_acct.apply_branch is '申请机构|申请机构';
comment on column ${iol_schema}.ncbs_ul_acct.home_branch is '客户管理行|客户管理行';
comment on column ${iol_schema}.ncbs_ul_acct.last_change_date is '最后修改日期|最后修改日期';
comment on column ${iol_schema}.ncbs_ul_acct.lender is '贷款人|贷款人';
comment on column ${iol_schema}.ncbs_ul_acct.five_category is '贷款五级分类|贷款五级分类|10-正常,20-关注,30-次级,40-可疑,50-损失';
comment on column ${iol_schema}.ncbs_ul_acct.sched_mode is '还款方式|还款方式|1-等额本息,2-等额本金,3-一次性还本付息前收息,4-按频率付息一次还本,5-按频率付息任意本金,6-气球贷,7-等额累进,8-等比累进,9-等本等息,10-组合贷,11-按比例还本,15-自定义还款方式';
comment on column ${iol_schema}.ncbs_ul_acct.source_type is '渠道编号|渠道类型';
comment on column ${iol_schema}.ncbs_ul_acct.source_module is '源模块|源模块|rb-存款,cl-贷款,gl-总账,all-所有';
comment on column ${iol_schema}.ncbs_ul_acct.client_type is '客户类型|客户大类，目前一般分为个人，公司，金融机构和内部客户。取之于cif_client_type,client_type';
comment on column ${iol_schema}.ncbs_ul_acct.is_individual is '个体客户标志|是否个体客户|y-是,n-否';
comment on column ${iol_schema}.ncbs_ul_acct.int_ind_flag is '计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息';
comment on column ${iol_schema}.ncbs_ul_acct.cur_stage_no is '当前期数|当前期次';
comment on column ${iol_schema}.ncbs_ul_acct.acct_type is '账户类型|账户类型|a-aio账户,c-结算账户,d-垫款,e-委托贷款,l-转让贷款,m-普通贷款,s-储蓄账户,t-定期账户,u-贴现贷款,y-银团贷款,z-资产证券化';
comment on column ${iol_schema}.ncbs_ul_acct.last_tran_date is '最后交易日期|最后交易日期';
comment on column ${iol_schema}.ncbs_ul_acct.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_ul_acct.first_overdue_date is '最早逾期日期 |最早逾期日期';
comment on column ${iol_schema}.ncbs_ul_acct.manual_change_schedule_flag is '是否需要手工录入还款计划 |是否需要手工录入还款计划|y-是,n-否';
comment on column ${iol_schema}.ncbs_ul_acct.ssi_end_date is '贴息截止日期 |贴息截止日期';
comment on column ${iol_schema}.ncbs_ul_acct.fta_acct_flag is '是否自贸区账户标识|是否自贸区账户标识|y-是,n-否';
comment on column ${iol_schema}.ncbs_ul_acct.marketing_prod is '营销产品|营销产品';
comment on column ${iol_schema}.ncbs_ul_acct.marketing_prod_desc is '营销产品名称|营销产品名称';
comment on column ${iol_schema}.ncbs_ul_acct.formula_amt is '每期计划还款额|每期计划还款额';
comment on column ${iol_schema}.ncbs_ul_acct.purpose is '贷款用途  |贷款用途';
comment on column ${iol_schema}.ncbs_ul_acct.profit_center is '利润中心 |利润中心';
comment on column ${iol_schema}.ncbs_ul_acct.belong_branch is '归属机构  |归属机构';
comment on column ${iol_schema}.ncbs_ul_acct.internal_key is '账户内部键值|账户内部键值';
comment on column ${iol_schema}.ncbs_ul_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_acct.etl_timestamp is 'ETL处理时间戳';
