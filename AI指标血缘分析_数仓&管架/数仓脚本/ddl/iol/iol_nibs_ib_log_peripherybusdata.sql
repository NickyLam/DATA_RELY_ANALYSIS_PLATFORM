/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_peripherybusdata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_peripherybusdata
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_peripherybusdata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_peripherybusdata(
    pty_id varchar2(255) -- 客户编号
    ,txn_dt varchar2(10) -- 交易日期
    ,seq_num varchar2(255) -- 流水号
    ,program_id varchar2(255) -- 交易代码
    ,txn_name varchar2(255) -- 交易名称
    ,txn_chn varchar2(255) -- 交易渠道
    ,ta_cd varchar2(255) -- TA代码
    ,ta_name varchar2(255) -- TA名称
    ,prd_cd varchar2(255) -- 产品代码
    ,prd_name varchar2(255) -- 产品名称
    ,bank_acct_num varchar2(255) -- 银行账号
    ,fin_acct_num varchar2(255) -- 理财账号
    ,lot varchar2(20) -- 份额
    ,ccy varchar2(255) -- 币种
    ,amt varchar2(20) -- 金额
    ,disct_rate varchar2(10) -- 折扣率
    ,txn_status varchar2(255) -- 交易状态
    ,memo varchar2(255) -- 摘要
    ,error_msg varchar2(255) -- 错误代码
    ,err_info varchar2(255) -- 错误信息
    ,adt varchar2(255) -- 附加信息
    ,frz_reas varchar2(255) -- 冻结原因
    ,huge_rede_flg varchar2(255) -- 巨额赎回标志
    ,divi_mode varchar2(255) -- 分红方式
    ,divi_mode_name varchar2(255) -- 分红方式名称
    ,txn_status_name varchar2(255) -- 交易状态名称
    ,txn_tm varchar2(14) -- 交易时间
    ,txn_med_typ varchar2(255) -- 交易介质类型
    ,txn_med varchar2(255) -- 交易介质
    ,pty_risk_rank varchar2(255) -- 客户风险等级
    ,prd_risk_rank varchar2(255) -- 产品风险等级
    ,contr_id varchar2(255) -- 合同编码、保单号
    ,xtra_chrg_fee varchar2(10) -- 外收手续费
    ,pty_name varchar2(255) -- 客户名称
    ,assoc_dt varchar2(10) -- 关联日期
    ,cash_remit_flg varchar2(255) -- 钞汇标志
    ,curt_bus_status varchar2(255) -- 帐务状态
    ,curt_bus_status_name varchar2(255) -- 帐务状态名称
    ,enter_prd_cd varchar2(255) -- 转入产品代码
    ,oppo_retl_cd varchar2(255) -- 对方销售商代码
    ,oppo_fin_acct_num varchar2(255) -- 对方理财账号
    ,tgt_bank_acct_num varchar2(255) -- 目标银行账号
    ,prd_templ_num varchar2(255) -- 产品模板号
    ,wthr_can_canc_flg varchar2(255) -- 是否可撤单标志
    ,scene_num varchar2(255) -- 场景码
    ,txn_org varchar2(255) -- 交易机构
    ,txn_tell varchar2(255) -- 交易柜员
    ,busitype varchar2(2) -- 类型|1-基金 2-信托 3-理财 4-保险
    ,compang_code varchar2(255) -- 公司代码
    ,issue_fee varchar2(255) -- 出单费
    ,blendingstatu varchar2(1) -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，3-手动勾兑不通过，4-自动勾兑不通过
    ,blendingtype varchar2(1) -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,blip_id varchar2(255) -- 影像编号
    ,blip_scndate varchar2(10) -- 影像采集日期-yyyyMMdd
    ,blendingdesc varchar2(1024) -- 勾兑说明
    ,syncdatestr varchar2(10) -- 同步日期-yyyyMMdd
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
grant select on ${iol_schema}.nibs_ib_log_peripherybusdata to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_peripherybusdata to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_peripherybusdata to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_peripherybusdata to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_peripherybusdata is '外围系统业务流水信息';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.pty_id is '客户编号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_dt is '交易日期';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.seq_num is '流水号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.program_id is '交易代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_name is '交易名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_chn is '交易渠道';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.ta_cd is 'TA代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.ta_name is 'TA名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.prd_cd is '产品代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.prd_name is '产品名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.bank_acct_num is '银行账号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.fin_acct_num is '理财账号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.lot is '份额';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.ccy is '币种';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.amt is '金额';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.disct_rate is '折扣率';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_status is '交易状态';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.memo is '摘要';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.error_msg is '错误代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.err_info is '错误信息';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.adt is '附加信息';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.frz_reas is '冻结原因';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.huge_rede_flg is '巨额赎回标志';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.divi_mode is '分红方式';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.divi_mode_name is '分红方式名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_status_name is '交易状态名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_tm is '交易时间';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_med_typ is '交易介质类型';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_med is '交易介质';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.pty_risk_rank is '客户风险等级';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.prd_risk_rank is '产品风险等级';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.contr_id is '合同编码、保单号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.xtra_chrg_fee is '外收手续费';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.pty_name is '客户名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.assoc_dt is '关联日期';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.cash_remit_flg is '钞汇标志';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.curt_bus_status is '帐务状态';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.curt_bus_status_name is '帐务状态名称';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.enter_prd_cd is '转入产品代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.oppo_retl_cd is '对方销售商代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.oppo_fin_acct_num is '对方理财账号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.tgt_bank_acct_num is '目标银行账号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.prd_templ_num is '产品模板号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.wthr_can_canc_flg is '是否可撤单标志';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.scene_num is '场景码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_org is '交易机构';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.txn_tell is '交易柜员';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.busitype is '类型|1-基金 2-信托 3-理财 4-保险';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.compang_code is '公司代码';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.issue_fee is '出单费';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.blendingstatu is '勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，3-手动勾兑不通过，4-自动勾兑不通过';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.blendingtype is '勾兑方式 0-手动，1-自动，2-手动+自动';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.blip_id is '影像编号';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.blip_scndate is '影像采集日期-yyyyMMdd';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.blendingdesc is '勾兑说明';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.syncdatestr is '同步日期-yyyyMMdd';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_peripherybusdata.etl_timestamp is 'ETL处理时间戳';
