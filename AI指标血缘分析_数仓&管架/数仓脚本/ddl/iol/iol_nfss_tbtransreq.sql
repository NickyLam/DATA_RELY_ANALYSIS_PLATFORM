/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbtransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbtransreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbtransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtransreq(
    serial_no varchar2(48) -- 流水号
    ,ex_serial varchar2(48) -- 发起方流水号
    ,contract_no varchar2(48) -- 合约编号
    ,trans_date number(22,0) -- 交易日期
    ,trans_time number(22,0) -- 交易时间
    ,occur_init_date number(22,0) -- 发生交易时的系统日期
    ,seller_code varchar2(14) -- 销售商代码
    ,trans_code varchar2(32) -- 交易代码
    ,control_flag varchar2(512) -- 控制标志
    ,branch_no varchar2(24) -- 交易机构
    ,open_branch varchar2(80) -- 交易所属机构
    ,ta_code varchar2(18) -- ta代码
    ,asset_acc varchar2(30) -- 理财帐号
    ,in_client_no varchar2(30) -- 内部客户编号
    ,client_type varchar2(2) -- 客户类型
    ,id_type varchar2(3) -- 证件类型
    ,id_code varchar2(50) -- 证件号码
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户编号
    ,bank_acc varchar2(64) -- 银行帐号
    ,cash_flag varchar2(2) -- 钞汇标志
    ,trans_account_type varchar2(2) -- 交易介质类型
    ,trans_account varchar2(48) -- 交易介质
    ,channel varchar2(2) -- 交易渠道
    ,term_no varchar2(24) -- 终端编号
    ,oper_no varchar2(48) -- 交易柜员
    ,auth_oper varchar2(48) -- 授权柜员
    ,prd_code varchar2(32) -- 产品代码
    ,curr_type varchar2(5) -- 产品币种
    ,prd_type varchar2(2) -- 产品类别
    ,share_class varchar2(3) -- 收费方式
    ,asso_date number(22,0) -- 关联日期
    ,asso_serial varchar2(48) -- 关联流水号
    ,asso_serial2 varchar2(48) -- 协议关联流水号2
    ,asso_serial3 varchar2(48) -- 协议关联流水号3
    ,amt number(18,2) -- 交易金额
    ,manage_charge number(18,2) -- 外收手续费
    ,manage_charge2 number(18,2) -- 撤单外收费金额
    ,agio number(5,4) -- 佣金折扣
    ,client_group varchar2(10) -- 客户分组
    ,liqu_status varchar2(2) -- 账务状态
    ,ori_channel varchar2(2) -- 原流水交易渠道
    ,ori_branch_no varchar2(24) -- 原流水交易机构
    ,vol number(18,3) -- 交易份额
    ,larg_red_flag varchar2(2) -- 巨额赎回处理标志
    ,red_mode varchar2(2) -- 赎回模式
    ,prd_price number(22,8) -- 产品价格
    ,amt_ratio number(9,8) -- 金额比例
    ,div_mode varchar2(2) -- 分红方式
    ,div_rate number(9,8) -- 红利比例
    ,frozen_cause varchar2(2) -- 冻结原因
    ,transfer_cause varchar2(3) -- 过户原因
    ,conv_dir varchar2(2) -- 转换方向
    ,targ_prd_code varchar2(32) -- 目标产品代码
    ,targ_seller_code varchar2(14) -- 对方销售商代码
    ,targ_asset_acc varchar2(30) -- 对方理财账号
    ,targ_branch varchar2(24) -- 对方网点号
    ,targ_bank_acc varchar2(48) -- 目标银行帐号
    ,client_risk number(22,0) -- 客户风险等级
    ,product_risk number(22,0) -- 产品风险等级
    ,cfm_date number(22,0) -- 确认日期
    ,cfm_no varchar2(48) -- ta确认流水号
    ,cfm_vol number(18,3) -- 确认份额
    ,to_host_serial varchar2(48) -- 发送主机流水号
    ,host_check_date number(22,0) -- 主机对帐日期
    ,ori_host_chk_date number(22,0) -- 原交易主机对帐日期
    ,host_trans_code varchar2(9) -- 主机交易码
    ,host_date number(22,0) -- 主机日期
    ,host_serial varchar2(48) -- 主机流水号
    ,monitor_flag varchar2(2) -- 监管标志
    ,client_manager varchar2(48) -- 客户经理
    ,err_code varchar2(12) -- 返回码
    ,err_msg varchar2(512) -- 错误信息
    ,status varchar2(2) -- 交易状态
    ,deal_mode varchar2(2) -- 受理方式
    ,summary varchar2(375) -- 摘要说明
    ,debit_account varchar2(48) -- 认申购账号
    ,fee_account varchar2(48) -- 外收费账号
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(22,4) -- 备用金额2
    ,reserve1 varchar2(375) -- 保留域1
    ,reserve2 varchar2(375) -- 保留域2
    ,reserve3 varchar2(375) -- 保留域3
    ,reserve4 varchar2(375) -- 保留域4
    ,reserve5 varchar2(375) -- 保留域5
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
grant select on ${iol_schema}.nfss_tbtransreq to ${iml_schema};
grant select on ${iol_schema}.nfss_tbtransreq to ${icl_schema};
grant select on ${iol_schema}.nfss_tbtransreq to ${idl_schema};
grant select on ${iol_schema}.nfss_tbtransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbtransreq is '委托类请求流水表';
comment on column ${iol_schema}.nfss_tbtransreq.serial_no is '流水号';
comment on column ${iol_schema}.nfss_tbtransreq.ex_serial is '发起方流水号';
comment on column ${iol_schema}.nfss_tbtransreq.contract_no is '合约编号';
comment on column ${iol_schema}.nfss_tbtransreq.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_tbtransreq.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_tbtransreq.occur_init_date is '发生交易时的系统日期';
comment on column ${iol_schema}.nfss_tbtransreq.seller_code is '销售商代码';
comment on column ${iol_schema}.nfss_tbtransreq.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_tbtransreq.control_flag is '控制标志';
comment on column ${iol_schema}.nfss_tbtransreq.branch_no is '交易机构';
comment on column ${iol_schema}.nfss_tbtransreq.open_branch is '交易所属机构';
comment on column ${iol_schema}.nfss_tbtransreq.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbtransreq.asset_acc is '理财帐号';
comment on column ${iol_schema}.nfss_tbtransreq.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tbtransreq.client_type is '客户类型';
comment on column ${iol_schema}.nfss_tbtransreq.id_type is '证件类型';
comment on column ${iol_schema}.nfss_tbtransreq.id_code is '证件号码';
comment on column ${iol_schema}.nfss_tbtransreq.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbtransreq.client_no is '客户编号';
comment on column ${iol_schema}.nfss_tbtransreq.bank_acc is '银行帐号';
comment on column ${iol_schema}.nfss_tbtransreq.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tbtransreq.trans_account_type is '交易介质类型';
comment on column ${iol_schema}.nfss_tbtransreq.trans_account is '交易介质';
comment on column ${iol_schema}.nfss_tbtransreq.channel is '交易渠道';
comment on column ${iol_schema}.nfss_tbtransreq.term_no is '终端编号';
comment on column ${iol_schema}.nfss_tbtransreq.oper_no is '交易柜员';
comment on column ${iol_schema}.nfss_tbtransreq.auth_oper is '授权柜员';
comment on column ${iol_schema}.nfss_tbtransreq.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbtransreq.curr_type is '产品币种';
comment on column ${iol_schema}.nfss_tbtransreq.prd_type is '产品类别';
comment on column ${iol_schema}.nfss_tbtransreq.share_class is '收费方式';
comment on column ${iol_schema}.nfss_tbtransreq.asso_date is '关联日期';
comment on column ${iol_schema}.nfss_tbtransreq.asso_serial is '关联流水号';
comment on column ${iol_schema}.nfss_tbtransreq.asso_serial2 is '协议关联流水号2';
comment on column ${iol_schema}.nfss_tbtransreq.asso_serial3 is '协议关联流水号3';
comment on column ${iol_schema}.nfss_tbtransreq.amt is '交易金额';
comment on column ${iol_schema}.nfss_tbtransreq.manage_charge is '外收手续费';
comment on column ${iol_schema}.nfss_tbtransreq.manage_charge2 is '撤单外收费金额';
comment on column ${iol_schema}.nfss_tbtransreq.agio is '佣金折扣';
comment on column ${iol_schema}.nfss_tbtransreq.client_group is '客户分组';
comment on column ${iol_schema}.nfss_tbtransreq.liqu_status is '账务状态';
comment on column ${iol_schema}.nfss_tbtransreq.ori_channel is '原流水交易渠道';
comment on column ${iol_schema}.nfss_tbtransreq.ori_branch_no is '原流水交易机构';
comment on column ${iol_schema}.nfss_tbtransreq.vol is '交易份额';
comment on column ${iol_schema}.nfss_tbtransreq.larg_red_flag is '巨额赎回处理标志';
comment on column ${iol_schema}.nfss_tbtransreq.red_mode is '赎回模式';
comment on column ${iol_schema}.nfss_tbtransreq.prd_price is '产品价格';
comment on column ${iol_schema}.nfss_tbtransreq.amt_ratio is '金额比例';
comment on column ${iol_schema}.nfss_tbtransreq.div_mode is '分红方式';
comment on column ${iol_schema}.nfss_tbtransreq.div_rate is '红利比例';
comment on column ${iol_schema}.nfss_tbtransreq.frozen_cause is '冻结原因';
comment on column ${iol_schema}.nfss_tbtransreq.transfer_cause is '过户原因';
comment on column ${iol_schema}.nfss_tbtransreq.conv_dir is '转换方向';
comment on column ${iol_schema}.nfss_tbtransreq.targ_prd_code is '目标产品代码';
comment on column ${iol_schema}.nfss_tbtransreq.targ_seller_code is '对方销售商代码';
comment on column ${iol_schema}.nfss_tbtransreq.targ_asset_acc is '对方理财账号';
comment on column ${iol_schema}.nfss_tbtransreq.targ_branch is '对方网点号';
comment on column ${iol_schema}.nfss_tbtransreq.targ_bank_acc is '目标银行帐号';
comment on column ${iol_schema}.nfss_tbtransreq.client_risk is '客户风险等级';
comment on column ${iol_schema}.nfss_tbtransreq.product_risk is '产品风险等级';
comment on column ${iol_schema}.nfss_tbtransreq.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_tbtransreq.cfm_no is 'ta确认流水号';
comment on column ${iol_schema}.nfss_tbtransreq.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_tbtransreq.to_host_serial is '发送主机流水号';
comment on column ${iol_schema}.nfss_tbtransreq.host_check_date is '主机对帐日期';
comment on column ${iol_schema}.nfss_tbtransreq.ori_host_chk_date is '原交易主机对帐日期';
comment on column ${iol_schema}.nfss_tbtransreq.host_trans_code is '主机交易码';
comment on column ${iol_schema}.nfss_tbtransreq.host_date is '主机日期';
comment on column ${iol_schema}.nfss_tbtransreq.host_serial is '主机流水号';
comment on column ${iol_schema}.nfss_tbtransreq.monitor_flag is '监管标志';
comment on column ${iol_schema}.nfss_tbtransreq.client_manager is '客户经理';
comment on column ${iol_schema}.nfss_tbtransreq.err_code is '返回码';
comment on column ${iol_schema}.nfss_tbtransreq.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_tbtransreq.status is '交易状态';
comment on column ${iol_schema}.nfss_tbtransreq.deal_mode is '受理方式';
comment on column ${iol_schema}.nfss_tbtransreq.summary is '摘要说明';
comment on column ${iol_schema}.nfss_tbtransreq.debit_account is '认申购账号';
comment on column ${iol_schema}.nfss_tbtransreq.fee_account is '外收费账号';
comment on column ${iol_schema}.nfss_tbtransreq.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbtransreq.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbtransreq.reserve1 is '保留域1';
comment on column ${iol_schema}.nfss_tbtransreq.reserve2 is '保留域2';
comment on column ${iol_schema}.nfss_tbtransreq.reserve3 is '保留域3';
comment on column ${iol_schema}.nfss_tbtransreq.reserve4 is '保留域4';
comment on column ${iol_schema}.nfss_tbtransreq.reserve5 is '保留域5';
comment on column ${iol_schema}.nfss_tbtransreq.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbtransreq.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbtransreq.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbtransreq.etl_timestamp is 'ETL处理时间戳';
