/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wrt_guat_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wrt_guat_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wrt_guat_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wrt_guat_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,cash_tran_seq_num varchar2(60) -- 现金交易序号
    ,cr_acct_id varchar2(100) -- 贷方账户编号
    ,cr_cust_acct_num varchar2(60) -- 贷方客户账号
    ,cr_acct_curr varchar2(30) -- 贷方账户币种代码
    ,cr_acct_sub_acct_num varchar2(60) -- 贷方账户子账号
    ,cr_acct_prod_id varchar2(100) -- 贷方账户产品编号
    ,cr_bal_type_cd varchar2(30) -- 贷方钞汇余额代码
    ,cr_tran_seq_num varchar2(60) -- 贷方交易序号
    ,dr_acct_id varchar2(100) -- 借方账户编号
    ,dr_cust_acct_num varchar2(60) -- 借方客户账号
    ,dr_acct_curr varchar2(30) -- 借方账户币种代码
    ,dr_acct_sub_acct_num varchar2(60) -- 借方账户子账号
    ,dr_acct_prod_id varchar2(100) -- 借方账户产品编号
    ,dr_bal_type_cd varchar2(30) -- 借方钞汇余额代码
    ,dr_tran_seq_num varchar2(60) -- 借方交易序号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_cd varchar2(30) -- 交易码
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,revs_dt date -- 冲正日期
    ,revs_tran_cd varchar2(30) -- 冲正交易码
    ,wrt_guat_tran_status_cd varchar2(30) -- 结售汇交易状态代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,quot_type_cd varchar2(30) -- 牌价类型代码
    ,exch_rat_type_cd varchar2(30) -- 汇率类型代码
    ,buy_amt number(30,2) -- 买入金额
    ,buy_curr_cd varchar2(30) -- 买入币种代码
    ,buyer_exch_rat number(18,8) -- 买方汇率
    ,sell_curr varchar2(30) -- 卖出币种代码
    ,sell_amt number(30,2) -- 卖出金额
    ,seller_exch_rat number(18,8) -- 卖方汇率
    ,exec_exch_rat number(18,8) -- 执行汇率
    ,float_int_rat number(18,8) -- 浮动利率
    ,base_quot_way_cd varchar2(30) -- 基础报价方式代码
    ,base_exch_rat_type_cd varchar2(30) -- 基础汇率类型代码
    ,base_exch_rat number(18,8) -- 基础汇率
    ,base_equvl_amt number(30,2) -- 基础等值金额
    ,cross_exch_rat number(18,8) -- 交叉汇率
    ,offset_cross_exch_rat number(18,8) -- 平盘交叉汇率
    ,intnal_price number(30,2) -- 内部价格
    ,change_equvl_amt number(30,2) -- 找零等值金额
    ,change_amt number(30,2) -- 找零金额
    ,change_base_int_rat number(18,8) -- 找零基础利率
    ,change_base_int_rat_type_cd varchar2(30) -- 找零基础利率类型代码
    ,change_int_rat number(18,8) -- 找零利率
    ,change_base_quot_way_cd varchar2(30) -- 找零基础报价方式代码
    ,change_quot_way_cd varchar2(30) -- 找零报价方式代码
    ,change_int_rat_type_cd varchar2(30) -- 找零利率类型代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,follow_ref_no varchar2(60) -- 跟踪参考号
    ,chn_id varchar2(100) -- 渠道编号
    ,bank_tran_seq_num varchar2(60) -- 银行交易序号
    ,tran_descb varchar2(500) -- 交易描述
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,tran_termn_id varchar2(100) -- 交易终端编号
    ,check_dt date -- 复核日期
    ,entry_dt date -- 记账日期
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,check_auth_teller_id varchar2(100) -- 复核授权柜员编号
    ,tran_auth_teller_id varchar2(100) -- 交易授权柜员编号
    ,revs_auth_teller_id varchar2(100) -- 冲正授权柜员编号
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,core_tran_teller_id varchar2(100) -- 核心交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,offset_status_cd varchar2(30) -- 平盘状态代码
    ,fcurr_hq_sys_in_suplm_amt number(30,2) -- 外币总行系统内平补金额
    ,sys_in_offset_flow_num varchar2(100) -- 系统内平盘流水号
    ,tran_market_offset_flow_num varchar2(100) -- 交易市场平盘流水号
    ,zero_proc_flg varchar2(10) -- 是否尾零处理标志
    ,float_spread number(18,8) -- 浮动点差
    ,exch_rat_quot_effect_tm varchar2(30) -- 汇率牌价生效时间
    ,exch_rat_quot_effect_dt date -- 汇率牌价生效日期
    ,sell_offset_exch_rat number(18,8) -- 卖出平盘汇率
    ,buy_offset_exch_rat number(18,8) -- 买入平盘汇率
    ,wg_bus_type_cd varchar2(30) -- 结售汇业务类型代码
    ,overser_proof_flg varchar2(10) -- 海外人才证明标志
    ,overser_proof_descb varchar2(500) -- 海外人才证明描述
    ,overser_remark varchar2(1000) -- 海外人才备注
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_wrt_guat_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wrt_guat_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wrt_guat_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wrt_guat_tran_flow is '结售汇交易流水';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cash_tran_seq_num is '现金交易序号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_acct_id is '贷方账户编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_cust_acct_num is '贷方客户账号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_acct_curr is '贷方账户币种代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_acct_sub_acct_num is '贷方账户子账号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_acct_prod_id is '贷方账户产品编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_bal_type_cd is '贷方钞汇余额代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cr_tran_seq_num is '贷方交易序号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_acct_id is '借方账户编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_cust_acct_num is '借方客户账号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_acct_curr is '借方账户币种代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_acct_sub_acct_num is '借方账户子账号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_acct_prod_id is '借方账户产品编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_bal_type_cd is '借方钞汇余额代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.dr_tran_seq_num is '借方交易序号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_cd is '交易码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.revs_dt is '冲正日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.revs_tran_cd is '冲正交易码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.wrt_guat_tran_status_cd is '结售汇交易状态代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.quot_type_cd is '牌价类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.exch_rat_type_cd is '汇率类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.buy_amt is '买入金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.buy_curr_cd is '买入币种代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.buyer_exch_rat is '买方汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.sell_curr is '卖出币种代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.sell_amt is '卖出金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.seller_exch_rat is '卖方汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.exec_exch_rat is '执行汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.float_int_rat is '浮动利率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.base_quot_way_cd is '基础报价方式代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.base_exch_rat_type_cd is '基础汇率类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.base_exch_rat is '基础汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.base_equvl_amt is '基础等值金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.cross_exch_rat is '交叉汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.offset_cross_exch_rat is '平盘交叉汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.intnal_price is '内部价格';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_equvl_amt is '找零等值金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_amt is '找零金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_base_int_rat is '找零基础利率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_base_int_rat_type_cd is '找零基础利率类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_int_rat is '找零利率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_base_quot_way_cd is '找零基础报价方式代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_quot_way_cd is '找零报价方式代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.change_int_rat_type_cd is '找零利率类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.follow_ref_no is '跟踪参考号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.bank_tran_seq_num is '银行交易序号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.check_dt is '复核日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.check_auth_teller_id is '复核授权柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_auth_teller_id is '交易授权柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.revs_auth_teller_id is '冲正授权柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.core_tran_teller_id is '核心交易柜员编号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.offset_status_cd is '平盘状态代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.fcurr_hq_sys_in_suplm_amt is '外币总行系统内平补金额';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.sys_in_offset_flow_num is '系统内平盘流水号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.tran_market_offset_flow_num is '交易市场平盘流水号';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.zero_proc_flg is '是否尾零处理标志';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.float_spread is '浮动点差';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.exch_rat_quot_effect_tm is '汇率牌价生效时间';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.exch_rat_quot_effect_dt is '汇率牌价生效日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.sell_offset_exch_rat is '卖出平盘汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.buy_offset_exch_rat is '买入平盘汇率';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.wg_bus_type_cd is '结售汇业务类型代码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.overser_proof_flg is '海外人才证明标志';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.overser_proof_descb is '海外人才证明描述';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.overser_remark is '海外人才备注';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wrt_guat_tran_flow.etl_timestamp is 'ETL处理时间戳';
