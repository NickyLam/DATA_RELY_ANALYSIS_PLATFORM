/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ym_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ym_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ym_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ym_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,fe_req_flow_num varchar2(100) -- 前端请求流水号
    ,tran_cfm_cd varchar2(30) -- 交易确认代码
    ,tran_tm date -- 交易时间
    ,serv_plat_abbr varchar2(45) -- 服务平台简称
    ,mercht_id varchar2(100) -- 商户编号
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,cust_id varchar2(100) -- 交易客户编号
    ,ym_fund_acct_id varchar2(100) -- 盈米基金账户编号
    ,mode_pay_id varchar2(100) -- 支付方式编号
    ,prod_buy_type_cd varchar2(30) -- 产品购买类型代码
    ,fund_cd varchar2(100) -- 基金代码
    ,fund_name varchar2(750) -- 基金名称
    ,prod_charge_way_cd varchar2(30) -- 产品收费方式代码
    ,prod_divd_way_cd varchar2(30) -- 产品分红方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(18,6) -- 交易金额
    ,lot_id varchar2(100) -- 份额编号
    ,tran_lot number(30,8) -- 交易份额
    ,huge_redem_proc_flg_cd varchar2(30) -- 巨额赎回处理标志代码
    ,redem_ymb_flg varchar2(10) -- 赎回盈米宝标志
    ,tran_id varchar2(100) -- 交易编号
    ,tran_create_dt date -- 交易生成日期
    ,tran_appl_dt date -- 交易申请日期
    ,tran_expect_cfm_dt date -- 交易预计确认日期
    ,redem_money_pay_dt date -- 赎回款项支付日期
    ,upp_tran_code varchar2(45) -- UPP交易码
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,tran_out_acct_id varchar2(100) -- 转出方账户编号
    ,tran_out_acct_name varchar2(750) -- 转出方账户名称
    ,tran_out_org_id varchar2(100) -- 转出方机构编号
    ,tran_in_acct_id varchar2(100) -- 转入方账户编号
    ,tran_in_acct_name varchar2(750) -- 转入方账户名称
    ,tran_in_org_id varchar2(100) -- 转入方机构编号
    ,upp_stop_req_flow_num varchar2(100) -- UPP止付请求流水号
    ,clear_dt date -- 清算日期
    ,froz_id varchar2(100) -- 冻结编号
    ,upp_init_flow_num varchar2(100) -- UPP原流水号
    ,upp_host_dt date -- UPP主机日期
    ,upp_host_flow_num varchar2(100) -- UPP主机流水号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_revo_status_cd varchar2(30) -- 交易撤单状态代码
    ,tran_cfm_status_cd varchar2(30) -- 交易确认状态代码
    ,tran_flg_cd varchar2(30) -- 交易标志代码
    ,pay_rest_advise_sucs_cd varchar2(30) -- 支付结果通知成功代码
    ,sucsed_amt number(30,8) -- 已成功金额
    ,sucsed_lot number(30,8) -- 已成功份额
    ,err_cd varchar2(90) -- 错误码
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,indent_status_cd varchar2(30) -- 订单状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_ym_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ym_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ym_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ym_tran_flow is '盈米交易流水';
comment on column ${iml_schema}.evt_ym_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ym_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ym_tran_flow.fe_req_flow_num is '前端请求流水号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_cfm_cd is '交易确认代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ym_tran_flow.serv_plat_abbr is '服务平台简称';
comment on column ${iml_schema}.evt_ym_tran_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_ym_tran_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_ym_tran_flow.ym_fund_acct_id is '盈米基金账户编号';
comment on column ${iml_schema}.evt_ym_tran_flow.mode_pay_id is '支付方式编号';
comment on column ${iml_schema}.evt_ym_tran_flow.prod_buy_type_cd is '产品购买类型代码';
comment on column ${iml_schema}.evt_ym_tran_flow.fund_cd is '基金代码';
comment on column ${iml_schema}.evt_ym_tran_flow.fund_name is '基金名称';
comment on column ${iml_schema}.evt_ym_tran_flow.prod_charge_way_cd is '产品收费方式代码';
comment on column ${iml_schema}.evt_ym_tran_flow.prod_divd_way_cd is '产品分红方式代码';
comment on column ${iml_schema}.evt_ym_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ym_tran_flow.lot_id is '份额编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_ym_tran_flow.huge_redem_proc_flg_cd is '巨额赎回处理标志代码';
comment on column ${iml_schema}.evt_ym_tran_flow.redem_ymb_flg is '赎回盈米宝标志';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_id is '交易编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_create_dt is '交易生成日期';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_appl_dt is '交易申请日期';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_expect_cfm_dt is '交易预计确认日期';
comment on column ${iml_schema}.evt_ym_tran_flow.redem_money_pay_dt is '赎回款项支付日期';
comment on column ${iml_schema}.evt_ym_tran_flow.upp_tran_code is 'UPP交易码';
comment on column ${iml_schema}.evt_ym_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_out_acct_id is '转出方账户编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_out_acct_name is '转出方账户名称';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_out_org_id is '转出方机构编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_in_acct_id is '转入方账户编号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_in_acct_name is '转入方账户名称';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_in_org_id is '转入方机构编号';
comment on column ${iml_schema}.evt_ym_tran_flow.upp_stop_req_flow_num is 'UPP止付请求流水号';
comment on column ${iml_schema}.evt_ym_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_ym_tran_flow.froz_id is '冻结编号';
comment on column ${iml_schema}.evt_ym_tran_flow.upp_init_flow_num is 'UPP原流水号';
comment on column ${iml_schema}.evt_ym_tran_flow.upp_host_dt is 'UPP主机日期';
comment on column ${iml_schema}.evt_ym_tran_flow.upp_host_flow_num is 'UPP主机流水号';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_revo_status_cd is '交易撤单状态代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_cfm_status_cd is '交易确认状态代码';
comment on column ${iml_schema}.evt_ym_tran_flow.tran_flg_cd is '交易标志代码';
comment on column ${iml_schema}.evt_ym_tran_flow.pay_rest_advise_sucs_cd is '支付结果通知成功代码';
comment on column ${iml_schema}.evt_ym_tran_flow.sucsed_amt is '已成功金额';
comment on column ${iml_schema}.evt_ym_tran_flow.sucsed_lot is '已成功份额';
comment on column ${iml_schema}.evt_ym_tran_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_ym_tran_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_ym_tran_flow.indent_status_cd is '订单状态代码';
comment on column ${iml_schema}.evt_ym_tran_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ym_tran_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ym_tran_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ym_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ym_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ym_tran_flow.etl_timestamp is 'ETL处理时间戳';
