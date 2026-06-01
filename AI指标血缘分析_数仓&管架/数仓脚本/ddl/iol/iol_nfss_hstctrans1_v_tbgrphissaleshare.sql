/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans1_v_tbgrphissaleshare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare(
    import_date number(38) -- 导入日期
    ,seller_code varchar2(14) -- 销售商代码
    ,bank_no varchar2(48) -- 银行代码:租户编号(多租户模式用)
    ,client_no varchar2(36) -- 银行客户号
    ,bank_acc varchar2(96) -- 资金账号
    ,virtual_bank_acc varchar2(48) -- 虚拟银行账号
    ,ta_client varchar2(48) -- ta交易账号
    ,prd_type varchar2(2) -- 产品类型:1-基金
    ,cash_flag varchar2(2) -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type varchar2(2) -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account varchar2(48) -- 交易账号:交易介质
    ,ta_code varchar2(27) -- ta代码
    ,asset_acc varchar2(30) -- 理财账号
    ,prd_code varchar2(48) -- 产品代码
    ,tot_vol number(18,3) -- 总份额
    ,frozen_vol number(18,3) -- 冻结份额
    ,long_frozen_vol number(18,3) -- 长期冻结份额
    ,group_vol number(18,3) -- 组合投资份额
    ,div_mode varchar2(2) -- 分红方式:0红利再投资,1现金红利
    ,old_div_mode varchar2(2) -- 原分红方式:[k_fhfs] 0-红利转投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,div_rate number(9,8) -- 分红比例
    ,ystdy_tot_vol number(18,3) -- 昨日总份额
    ,open_branch varchar2(120) -- 所属机构
    ,client_type varchar2(2) -- 客户类型:k_khlx 0-机构 1-个人
    ,other_frozen number(18,3) -- 本地冻结份额
    ,cost number(18,2) -- 成本:本金
    ,prd_value number(18,2) -- 产品市值
    ,tot_income number(18,2) -- 累计收入
    ,onway_amt number(18,2) -- 在途资金:接口用标准字段
    ,profit_loss number(22,8) -- 浮动盈亏
    ,income_onway number(18,2) -- 未付收益
    ,income_frozen number(18,2) -- 冻结的未付收益
    ,income_new number(18,2) -- 当天新增未付收益
    ,tot_amt number(18,2) -- 总金额
    ,use_amt number(18,2) -- 当前可用额度:接口用标准字段
    ,income_date number(38) -- 收益日期
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
    ,reserve4 varchar2(375) -- 保留字段4
    ,reserve5 varchar2(375) -- 保留字段5
    ,in_client_no varchar2(30) -- 内部客户编号
    ,modify_timestamp number(14,0) -- 修改时间戳
    ,group_code varchar2(48) -- 分组代码
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
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare is '历史持仓（收益）表';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.import_date is '导入日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.seller_code is '销售商代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.bank_no is '银行代码:租户编号(多租户模式用)';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.client_no is '银行客户号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.bank_acc is '资金账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.virtual_bank_acc is '虚拟银行账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.ta_client is 'ta交易账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.prd_type is '产品类型:1-基金';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.cash_flag is '钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.trans_account_type is '交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.trans_account is '交易账号:交易介质';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.asset_acc is '理财账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.tot_vol is '总份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.frozen_vol is '冻结份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.long_frozen_vol is '长期冻结份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.group_vol is '组合投资份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.div_mode is '分红方式:0红利再投资,1现金红利';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.old_div_mode is '原分红方式:[k_fhfs] 0-红利转投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.div_rate is '分红比例';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.ystdy_tot_vol is '昨日总份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.open_branch is '所属机构';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.client_type is '客户类型:k_khlx 0-机构 1-个人';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.other_frozen is '本地冻结份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.cost is '成本:本金';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.prd_value is '产品市值';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.tot_income is '累计收入';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.onway_amt is '在途资金:接口用标准字段';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.profit_loss is '浮动盈亏';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.income_onway is '未付收益';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.income_frozen is '冻结的未付收益';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.income_new is '当天新增未付收益';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.tot_amt is '总金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.use_amt is '当前可用额度:接口用标准字段';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.income_date is '收益日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.reserve1 is '保留字段1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.reserve2 is '保留字段2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.reserve3 is '保留字段3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.reserve4 is '保留字段4';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.reserve5 is '保留字段5';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.modify_timestamp is '修改时间戳';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.group_code is '分组代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare.etl_timestamp is 'ETL处理时间戳';
