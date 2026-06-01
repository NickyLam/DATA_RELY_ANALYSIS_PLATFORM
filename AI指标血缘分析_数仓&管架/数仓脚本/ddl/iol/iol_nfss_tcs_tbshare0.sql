/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbshare0
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbshare0
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbshare0 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbshare0(
    in_client_no varchar2(30) -- 内部客户编号
    ,seller_code varchar2(14) -- 销售商代码
    ,bank_no varchar2(3) -- 银行编号
    ,client_no varchar2(36) -- 银行客户号
    ,bank_acc varchar2(48) -- 银行账号
    ,ta_client varchar2(48) -- ta交易帐号
    ,cash_flag varchar2(2) -- 钞汇标志
    ,trans_account_type varchar2(2) -- 交易介质类型
    ,trans_account varchar2(48) -- 交易介质
    ,ta_code varchar2(14) -- ta代码
    ,asset_acc varchar2(30) -- 理财帐号
    ,prd_code varchar2(30) -- 产品代码
    ,contract_no varchar2(48) -- 合约编号
    ,last_date number(22,0) -- 最后变动日期
    ,tot_vol number(18,3) -- 份额总数
    ,frozen_vol number(18,3) -- 交易冻结份额
    ,long_frozen_vol number(18,3) -- 长期冻结份额
    ,group_vol number(18,3) -- 组合投资份额
    ,div_mode varchar2(2) -- 当前分红方式
    ,old_div_mode varchar2(2) -- 原分红方式
    ,div_rate number(5,4) -- 红利比例
    ,ystdy_tot_vol number(18,3) -- 昨日总份额
    ,open_branch varchar2(24) -- 份额所属机构
    ,client_type varchar2(2) -- 客户类别
    ,append_flag varchar2(2) -- 追加投资标志
    ,other_frozen number(18,3) -- 本地冻结份额
    ,income number(18,2) -- 本期收益
    ,income_rate number(9,8) -- 收益客户比例
    ,cost number(18,2) -- 买入成本
    ,tot_income number(18,2) -- 累计收入
    ,income_onway number(18,2) -- 未付收益#
    ,income_frozen number(18,2) -- 冻结的未付收益#
    ,income_new number(18,2) -- 当天新分配收益#
    ,manage_agio number(5,4) -- 管理费折扣率#
    ,tot_manage_fee number(18,2) -- 管理费总额#
    ,manage_fee number(18,2) -- 最新结转管理费#
    ,manage_date number(22,0) -- 管理费计算日期#
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用2
    ,reserve3 varchar2(375) -- 备用3
    ,reserve4 varchar2(375) -- 备用4
    ,reserve5 varchar2(375) -- 备用5
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
grant select on ${iol_schema}.nfss_tcs_tbshare0 to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbshare0 to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbshare0 to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbshare0 to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbshare0 is '信托份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.seller_code is '销售商代码';
comment on column ${iol_schema}.nfss_tcs_tbshare0.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.client_no is '银行客户号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.bank_acc is '银行账号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.ta_client is 'ta交易帐号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tcs_tbshare0.trans_account_type is '交易介质类型';
comment on column ${iol_schema}.nfss_tcs_tbshare0.trans_account is '交易介质';
comment on column ${iol_schema}.nfss_tcs_tbshare0.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tcs_tbshare0.asset_acc is '理财帐号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tcs_tbshare0.contract_no is '合约编号';
comment on column ${iol_schema}.nfss_tcs_tbshare0.last_date is '最后变动日期';
comment on column ${iol_schema}.nfss_tcs_tbshare0.tot_vol is '份额总数';
comment on column ${iol_schema}.nfss_tcs_tbshare0.frozen_vol is '交易冻结份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.long_frozen_vol is '长期冻结份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.group_vol is '组合投资份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.div_mode is '当前分红方式';
comment on column ${iol_schema}.nfss_tcs_tbshare0.old_div_mode is '原分红方式';
comment on column ${iol_schema}.nfss_tcs_tbshare0.div_rate is '红利比例';
comment on column ${iol_schema}.nfss_tcs_tbshare0.ystdy_tot_vol is '昨日总份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.open_branch is '份额所属机构';
comment on column ${iol_schema}.nfss_tcs_tbshare0.client_type is '客户类别';
comment on column ${iol_schema}.nfss_tcs_tbshare0.append_flag is '追加投资标志';
comment on column ${iol_schema}.nfss_tcs_tbshare0.other_frozen is '本地冻结份额';
comment on column ${iol_schema}.nfss_tcs_tbshare0.income is '本期收益';
comment on column ${iol_schema}.nfss_tcs_tbshare0.income_rate is '收益客户比例';
comment on column ${iol_schema}.nfss_tcs_tbshare0.cost is '买入成本';
comment on column ${iol_schema}.nfss_tcs_tbshare0.tot_income is '累计收入';
comment on column ${iol_schema}.nfss_tcs_tbshare0.income_onway is '未付收益#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.income_frozen is '冻结的未付收益#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.income_new is '当天新分配收益#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.manage_agio is '管理费折扣率#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.tot_manage_fee is '管理费总额#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.manage_fee is '最新结转管理费#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.manage_date is '管理费计算日期#';
comment on column ${iol_schema}.nfss_tcs_tbshare0.reserve1 is '备用1';
comment on column ${iol_schema}.nfss_tcs_tbshare0.reserve2 is '备用2';
comment on column ${iol_schema}.nfss_tcs_tbshare0.reserve3 is '备用3';
comment on column ${iol_schema}.nfss_tcs_tbshare0.reserve4 is '备用4';
comment on column ${iol_schema}.nfss_tcs_tbshare0.reserve5 is '备用5';
comment on column ${iol_schema}.nfss_tcs_tbshare0.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbshare0.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbshare0.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbshare0.etl_timestamp is 'ETL处理时间戳';
