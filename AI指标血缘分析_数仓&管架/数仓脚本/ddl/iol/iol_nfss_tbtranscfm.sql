/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbtranscfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbtranscfm
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbtranscfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtranscfm(
    ta_code varchar2(18) -- ta代码
    ,cfm_date number(22,0) -- 确认日期
    ,cfm_no varchar2(48) -- ta确认流水号
    ,ori_cfm_no varchar2(48) -- 原确认流水号
    ,from_flag varchar2(2) -- 发起方
    ,trans_date number(22,0) -- 交易日期
    ,trans_time number(22,0) -- 交易时间
    ,clear_date number(22,0) -- 清算日期
    ,serial_no varchar2(48) -- 流水号
    ,trans_code varchar2(32) -- 交易代码
    ,busin_code varchar2(9) -- 业务代码
    ,branch_no varchar2(24) -- 交易机构
    ,open_branch varchar2(80) -- 交易所属机构
    ,channel varchar2(2) -- 交易渠道
    ,term_no varchar2(24) -- 终端编号
    ,oper_no varchar2(48) -- 交易柜员
    ,in_client_no varchar2(30) -- 内部客户编号
    ,client_type varchar2(2) -- 客户类型
    ,asset_acc varchar2(30) -- 理财帐号
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户编号
    ,client_name varchar2(375) -- 客户名称
    ,bank_acc varchar2(64) -- 银行帐号
    ,ta_client varchar2(48) -- ta交易账号
    ,trans_account_type varchar2(2) -- 交易介质类型
    ,trans_account varchar2(48) -- 交易介质
    ,cash_flag varchar2(2) -- 钞汇标志
    ,prd_code varchar2(32) -- 产品代码
    ,share_class varchar2(3) -- 收费类别
    ,nav number(18,8) -- 产品净值
    ,price number(26,12) -- 交易价格
    ,amt number(18,2) -- 交易金额
    ,curr_type varchar2(5) -- 结算币种
    ,cfm_amt number(18,2) -- 确认金额
    ,vol number(18,3) -- 交易份额
    ,cfm_vol number(18,3) -- 确认份额
    ,larg_red_flag varchar2(2) -- 巨额赎回处理标志
    ,red_cause varchar2(2) -- 强行赎回原因
    ,agio number(5,4) -- 佣金折扣
    ,tot_fee number(18,2) -- 总费用
    ,charge number(18,2) -- 手续费
    ,stamp_tax number(18,2) -- 印花税
    ,interest_tax number(18,2) -- 利息税
    ,transfer_fee number(18,2) -- 过户费
    ,agency_fee number(18,2) -- 代理费
    ,back_fee number(18,2) -- 后端收费
    ,other_fee1 number(18,2) -- 其他费用1
    ,other_fee2 number(18,2) -- 其他费用2
    ,cfm_income number(18,2) -- 确认收益
    ,manage_fee number(18,2) -- 管理费金额#
    ,cont_frozen_amt number(18,2) -- 继续冻结金额#
    ,vol_cumulate number(18,3) -- 份额累积积数#
    ,detail_flag varchar2(2) -- 明细标志
    ,finish_flag varchar2(2) -- 结束标识
    ,frozen_cause varchar2(2) -- 冻结原因
    ,conv_dir varchar2(2) -- 转换方向
    ,targ_prd_code varchar2(32) -- 目标产品代码
    ,targ_nav number(18,8) -- 目标产品净值
    ,targ_price number(18,8) -- 目标产品价格
    ,targ_cfm_vol number(18,3) -- 目标产品确认份额
    ,targ_seller_code varchar2(14) -- 对方销售商代码
    ,targ_branch varchar2(24) -- 对方网点号
    ,targ_asset_acc varchar2(48) -- 对方理财帐号
    ,targ_bank_acc varchar2(48) -- 目标银行帐号
    ,interest number(18,2) -- 利息金额
    ,vol_of_int number(18,3) -- 利息转份额
    ,div_mode varchar2(2) -- 分红方式
    ,div_rate number(9,8) -- 红利比例
    ,summary varchar2(375) -- 摘要说明
    ,err_code varchar2(12) -- 返回码
    ,err_msg varchar2(512) -- 错误信息
    ,status varchar2(2) -- 交易状态
    ,client_manager varchar2(48) -- 客户经理
    ,asso_date number(22,0) -- 关联日期
    ,asso_serial varchar2(48) -- 关联流水号
    ,bank_charge number(18,2) -- 银行手续费
    ,ex_serial varchar2(48) -- 发起方流水号
    ,contract_no varchar2(48) -- 合约编号
    ,manage_charge number(18,2) -- 外收手续费
    ,host_trans_code varchar2(9) -- 主机交易码
    ,host_date number(22,0) -- 主机日期
    ,host_serial varchar2(48) -- 主机流水号
    ,post_vol number(18,3) -- 交易后份额
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,amt3 number(18,2) -- 备用金额3
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用2
    ,reserve3 varchar2(375) -- 备用3
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
grant select on ${iol_schema}.nfss_tbtranscfm to ${iml_schema};
grant select on ${iol_schema}.nfss_tbtranscfm to ${icl_schema};
grant select on ${iol_schema}.nfss_tbtranscfm to ${idl_schema};
grant select on ${iol_schema}.nfss_tbtranscfm to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbtranscfm is '交易类确认表';
comment on column ${iol_schema}.nfss_tbtranscfm.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbtranscfm.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_tbtranscfm.cfm_no is 'ta确认流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.ori_cfm_no is '原确认流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.from_flag is '发起方';
comment on column ${iol_schema}.nfss_tbtranscfm.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_tbtranscfm.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_tbtranscfm.clear_date is '清算日期';
comment on column ${iol_schema}.nfss_tbtranscfm.serial_no is '流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_tbtranscfm.busin_code is '业务代码';
comment on column ${iol_schema}.nfss_tbtranscfm.branch_no is '交易机构';
comment on column ${iol_schema}.nfss_tbtranscfm.open_branch is '交易所属机构';
comment on column ${iol_schema}.nfss_tbtranscfm.channel is '交易渠道';
comment on column ${iol_schema}.nfss_tbtranscfm.term_no is '终端编号';
comment on column ${iol_schema}.nfss_tbtranscfm.oper_no is '交易柜员';
comment on column ${iol_schema}.nfss_tbtranscfm.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tbtranscfm.client_type is '客户类型';
comment on column ${iol_schema}.nfss_tbtranscfm.asset_acc is '理财帐号';
comment on column ${iol_schema}.nfss_tbtranscfm.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbtranscfm.client_no is '客户编号';
comment on column ${iol_schema}.nfss_tbtranscfm.client_name is '客户名称';
comment on column ${iol_schema}.nfss_tbtranscfm.bank_acc is '银行帐号';
comment on column ${iol_schema}.nfss_tbtranscfm.ta_client is 'ta交易账号';
comment on column ${iol_schema}.nfss_tbtranscfm.trans_account_type is '交易介质类型';
comment on column ${iol_schema}.nfss_tbtranscfm.trans_account is '交易介质';
comment on column ${iol_schema}.nfss_tbtranscfm.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tbtranscfm.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbtranscfm.share_class is '收费类别';
comment on column ${iol_schema}.nfss_tbtranscfm.nav is '产品净值';
comment on column ${iol_schema}.nfss_tbtranscfm.price is '交易价格';
comment on column ${iol_schema}.nfss_tbtranscfm.amt is '交易金额';
comment on column ${iol_schema}.nfss_tbtranscfm.curr_type is '结算币种';
comment on column ${iol_schema}.nfss_tbtranscfm.cfm_amt is '确认金额';
comment on column ${iol_schema}.nfss_tbtranscfm.vol is '交易份额';
comment on column ${iol_schema}.nfss_tbtranscfm.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_tbtranscfm.larg_red_flag is '巨额赎回处理标志';
comment on column ${iol_schema}.nfss_tbtranscfm.red_cause is '强行赎回原因';
comment on column ${iol_schema}.nfss_tbtranscfm.agio is '佣金折扣';
comment on column ${iol_schema}.nfss_tbtranscfm.tot_fee is '总费用';
comment on column ${iol_schema}.nfss_tbtranscfm.charge is '手续费';
comment on column ${iol_schema}.nfss_tbtranscfm.stamp_tax is '印花税';
comment on column ${iol_schema}.nfss_tbtranscfm.interest_tax is '利息税';
comment on column ${iol_schema}.nfss_tbtranscfm.transfer_fee is '过户费';
comment on column ${iol_schema}.nfss_tbtranscfm.agency_fee is '代理费';
comment on column ${iol_schema}.nfss_tbtranscfm.back_fee is '后端收费';
comment on column ${iol_schema}.nfss_tbtranscfm.other_fee1 is '其他费用1';
comment on column ${iol_schema}.nfss_tbtranscfm.other_fee2 is '其他费用2';
comment on column ${iol_schema}.nfss_tbtranscfm.cfm_income is '确认收益';
comment on column ${iol_schema}.nfss_tbtranscfm.manage_fee is '管理费金额#';
comment on column ${iol_schema}.nfss_tbtranscfm.cont_frozen_amt is '继续冻结金额#';
comment on column ${iol_schema}.nfss_tbtranscfm.vol_cumulate is '份额累积积数#';
comment on column ${iol_schema}.nfss_tbtranscfm.detail_flag is '明细标志';
comment on column ${iol_schema}.nfss_tbtranscfm.finish_flag is '结束标识';
comment on column ${iol_schema}.nfss_tbtranscfm.frozen_cause is '冻结原因';
comment on column ${iol_schema}.nfss_tbtranscfm.conv_dir is '转换方向';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_prd_code is '目标产品代码';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_nav is '目标产品净值';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_price is '目标产品价格';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_cfm_vol is '目标产品确认份额';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_seller_code is '对方销售商代码';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_branch is '对方网点号';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_asset_acc is '对方理财帐号';
comment on column ${iol_schema}.nfss_tbtranscfm.targ_bank_acc is '目标银行帐号';
comment on column ${iol_schema}.nfss_tbtranscfm.interest is '利息金额';
comment on column ${iol_schema}.nfss_tbtranscfm.vol_of_int is '利息转份额';
comment on column ${iol_schema}.nfss_tbtranscfm.div_mode is '分红方式';
comment on column ${iol_schema}.nfss_tbtranscfm.div_rate is '红利比例';
comment on column ${iol_schema}.nfss_tbtranscfm.summary is '摘要说明';
comment on column ${iol_schema}.nfss_tbtranscfm.err_code is '返回码';
comment on column ${iol_schema}.nfss_tbtranscfm.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_tbtranscfm.status is '交易状态';
comment on column ${iol_schema}.nfss_tbtranscfm.client_manager is '客户经理';
comment on column ${iol_schema}.nfss_tbtranscfm.asso_date is '关联日期';
comment on column ${iol_schema}.nfss_tbtranscfm.asso_serial is '关联流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.bank_charge is '银行手续费';
comment on column ${iol_schema}.nfss_tbtranscfm.ex_serial is '发起方流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.contract_no is '合约编号';
comment on column ${iol_schema}.nfss_tbtranscfm.manage_charge is '外收手续费';
comment on column ${iol_schema}.nfss_tbtranscfm.host_trans_code is '主机交易码';
comment on column ${iol_schema}.nfss_tbtranscfm.host_date is '主机日期';
comment on column ${iol_schema}.nfss_tbtranscfm.host_serial is '主机流水号';
comment on column ${iol_schema}.nfss_tbtranscfm.post_vol is '交易后份额';
comment on column ${iol_schema}.nfss_tbtranscfm.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbtranscfm.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbtranscfm.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_tbtranscfm.reserve1 is '备用1';
comment on column ${iol_schema}.nfss_tbtranscfm.reserve2 is '备用2';
comment on column ${iol_schema}.nfss_tbtranscfm.reserve3 is '备用3';
comment on column ${iol_schema}.nfss_tbtranscfm.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbtranscfm.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbtranscfm.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbtranscfm.etl_timestamp is 'ETL处理时间戳';
