/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbhissquare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbhissquare
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbhissquare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbhissquare(
    square_no varchar2(48) -- 清算流水号
    ,seq_no number(22,0) -- 清算顺序号
    ,trans_date number(22,0) -- 交易日期
    ,clear_date number(22,0) -- 清算日期
    ,square_date number(22,0) -- 实际入帐日期
    ,old_square_date number(22,0) -- 变动前square_date
    ,serial_no varchar2(48) -- 流水号
    ,asso_serial varchar2(48) -- 关联流水号
    ,from_flag varchar2(2) -- 发起方
    ,trans_code varchar2(32) -- 交易代码
    ,busin_code varchar2(9) -- 业务代码
    ,client_type varchar2(2) -- 客户类型
    ,in_client_no varchar2(30) -- 内部客户编号
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户编号
    ,bank_acc varchar2(64) -- 银行账号
    ,bank_acc_kind varchar2(2) -- 银行帐户类型
    ,channel varchar2(2) -- 交易渠道
    ,oper_no varchar2(48) -- 交易柜员
    ,term_no varchar2(24) -- 终端编号
    ,branch_no varchar2(24) -- 交易机构
    ,open_branch varchar2(80) -- 交易所属机构
    ,ta_code varchar2(18) -- ta代码
    ,prd_code varchar2(32) -- 产品代码
    ,liqu_dir varchar2(2) -- 帐务方向
    ,amt number(18,2) -- 清算金额
    ,curr_type varchar2(5) -- 币种
    ,cash_flag varchar2(2) -- 钞汇标志
    ,unfrozen_amt number(18,2) -- 解冻金额
    ,host_trans_code varchar2(9) -- 主机交易码
    ,host_date number(22,0) -- 主机日期
    ,host_serial varchar2(48) -- 主机流水号
    ,frozen_amt number(18,2) -- 冻结金额
    ,check_status varchar2(2) -- 勾对确认标志
    ,distrib_flag varchar2(2) -- 上帐金额来源类型
    ,amt_flag varchar2(32) -- 资金类别
    ,cost_income_flag varchar2(2) -- 本金收益标志
    ,cfm_vol number(18,3) -- 确认份额
    ,cost number(18,2) -- 本金
    ,cfm_income number(18,2) -- 确认收益
    ,vol_cumulate number(18,3) -- 份额累积积数#
    ,prd_account varchar2(48) -- 产品账号
    ,prd_account_kind varchar2(2) -- 产品帐户类型
    ,summary varchar2(375) -- 摘要说明
    ,status varchar2(2) -- 状态
    ,old_square_no varchar2(48) -- 原清算流水号
    ,err_code varchar2(12) -- 返回码
    ,err_msg varchar2(512) -- 错误信息
    ,deal_status varchar2(2) -- 接口处理标志
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(22,4) -- 备用金额2
    ,amt3 number(22,4) -- 备用金额3
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
grant select on ${iol_schema}.nfss_tbhissquare to ${iml_schema};
grant select on ${iol_schema}.nfss_tbhissquare to ${icl_schema};
grant select on ${iol_schema}.nfss_tbhissquare to ${idl_schema};
grant select on ${iol_schema}.nfss_tbhissquare to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbhissquare is '资金清算历史表';
comment on column ${iol_schema}.nfss_tbhissquare.square_no is '清算流水号';
comment on column ${iol_schema}.nfss_tbhissquare.seq_no is '清算顺序号';
comment on column ${iol_schema}.nfss_tbhissquare.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_tbhissquare.clear_date is '清算日期';
comment on column ${iol_schema}.nfss_tbhissquare.square_date is '实际入帐日期';
comment on column ${iol_schema}.nfss_tbhissquare.old_square_date is '变动前square_date';
comment on column ${iol_schema}.nfss_tbhissquare.serial_no is '流水号';
comment on column ${iol_schema}.nfss_tbhissquare.asso_serial is '关联流水号';
comment on column ${iol_schema}.nfss_tbhissquare.from_flag is '发起方';
comment on column ${iol_schema}.nfss_tbhissquare.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_tbhissquare.busin_code is '业务代码';
comment on column ${iol_schema}.nfss_tbhissquare.client_type is '客户类型';
comment on column ${iol_schema}.nfss_tbhissquare.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_tbhissquare.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbhissquare.client_no is '客户编号';
comment on column ${iol_schema}.nfss_tbhissquare.bank_acc is '银行账号';
comment on column ${iol_schema}.nfss_tbhissquare.bank_acc_kind is '银行帐户类型';
comment on column ${iol_schema}.nfss_tbhissquare.channel is '交易渠道';
comment on column ${iol_schema}.nfss_tbhissquare.oper_no is '交易柜员';
comment on column ${iol_schema}.nfss_tbhissquare.term_no is '终端编号';
comment on column ${iol_schema}.nfss_tbhissquare.branch_no is '交易机构';
comment on column ${iol_schema}.nfss_tbhissquare.open_branch is '交易所属机构';
comment on column ${iol_schema}.nfss_tbhissquare.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbhissquare.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbhissquare.liqu_dir is '帐务方向';
comment on column ${iol_schema}.nfss_tbhissquare.amt is '清算金额';
comment on column ${iol_schema}.nfss_tbhissquare.curr_type is '币种';
comment on column ${iol_schema}.nfss_tbhissquare.cash_flag is '钞汇标志';
comment on column ${iol_schema}.nfss_tbhissquare.unfrozen_amt is '解冻金额';
comment on column ${iol_schema}.nfss_tbhissquare.host_trans_code is '主机交易码';
comment on column ${iol_schema}.nfss_tbhissquare.host_date is '主机日期';
comment on column ${iol_schema}.nfss_tbhissquare.host_serial is '主机流水号';
comment on column ${iol_schema}.nfss_tbhissquare.frozen_amt is '冻结金额';
comment on column ${iol_schema}.nfss_tbhissquare.check_status is '勾对确认标志';
comment on column ${iol_schema}.nfss_tbhissquare.distrib_flag is '上帐金额来源类型';
comment on column ${iol_schema}.nfss_tbhissquare.amt_flag is '资金类别';
comment on column ${iol_schema}.nfss_tbhissquare.cost_income_flag is '本金收益标志';
comment on column ${iol_schema}.nfss_tbhissquare.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_tbhissquare.cost is '本金';
comment on column ${iol_schema}.nfss_tbhissquare.cfm_income is '确认收益';
comment on column ${iol_schema}.nfss_tbhissquare.vol_cumulate is '份额累积积数#';
comment on column ${iol_schema}.nfss_tbhissquare.prd_account is '产品账号';
comment on column ${iol_schema}.nfss_tbhissquare.prd_account_kind is '产品帐户类型';
comment on column ${iol_schema}.nfss_tbhissquare.summary is '摘要说明';
comment on column ${iol_schema}.nfss_tbhissquare.status is '状态';
comment on column ${iol_schema}.nfss_tbhissquare.old_square_no is '原清算流水号';
comment on column ${iol_schema}.nfss_tbhissquare.err_code is '返回码';
comment on column ${iol_schema}.nfss_tbhissquare.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_tbhissquare.deal_status is '接口处理标志';
comment on column ${iol_schema}.nfss_tbhissquare.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbhissquare.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbhissquare.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_tbhissquare.reserve1 is '保留域1';
comment on column ${iol_schema}.nfss_tbhissquare.reserve2 is '保留域2';
comment on column ${iol_schema}.nfss_tbhissquare.reserve3 is '保留域3';
comment on column ${iol_schema}.nfss_tbhissquare.reserve4 is '保留域4';
comment on column ${iol_schema}.nfss_tbhissquare.reserve5 is '保留域5';
comment on column ${iol_schema}.nfss_tbhissquare.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbhissquare.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbhissquare.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbhissquare.etl_timestamp is 'ETL处理时间戳';
