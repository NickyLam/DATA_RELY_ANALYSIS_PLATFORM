/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_asset_secu_tran_cont_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_asset_secu_tran_cont_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_asset_secu_tran_cont_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_asset_secu_tran_cont_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(100) -- 合同编号
    ,prod_id varchar2(60) -- 产品编号
    ,asset_pool_id varchar2(60) -- 资产池编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,prod_bus_status_cd varchar2(30) -- 产品业务状态代码
    ,prod_mode_cd varchar2(30) -- 产品模式代码
    ,asset_pool_type_cd varchar2(30) -- 资产池类型代码
    ,asset_pool_char_cd varchar2(30) -- 资产池性质代码
    ,asset_pool_status_cd varchar2(30) -- 资产池状态代码
    ,tran_calc_way_cd varchar2(30) -- 转让计算方式代码
    ,cntpty_org_type_cd varchar2(30) -- 交易对手机构类型代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(90) -- 交易对手名称
    ,cntpty_cert_type varchar2(60) -- 交易对手证件类型
    ,cntpty_cert_no varchar2(60) -- 交易对手证件号码
    ,cntpty_acct_num varchar2(60) -- 交易对手账号
    ,cntpty_open_bank_name varchar2(150) -- 交易对手开户行名称
    ,cntpty_tran_dt date -- 交易对手转账日期
    ,cntpty_pay_amt number(30,2) -- 交易对手已支付金额
    ,pay_dt_rule_cd varchar2(60) -- 支付日期规则代码
    ,ts_cd varchar2(30) -- 暂存代码
    ,user_def_coll_ped_flg varchar2(30) -- 自定义归集周期标志
    ,clearup_repo_flg varchar2(30) -- 清仓回购标志
    ,non_asset_flg varchar2(10) -- 不良资产标志
    ,tran_plat_name varchar2(45) -- 交易平台名称
    ,prod_name varchar2(300) -- 产品名称
    ,pkg_dt date -- 封包日期
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,asset_tot_amt number(30,2) -- 资产总金额
    ,issue_tot_amt number(30,2) -- 发行总金额
    ,asset_tran_consideration_amt number(30,8) -- 资产转让对价金额
    ,asset_tran_comm_fee number(30,2) -- 资产转让手续费
    ,prod_self_hold_amt number(30,8) -- 产品自持金额
    ,issue_qtty varchar2(60) -- 发行数量
    ,bank_rgst_center_amt number(30,2) -- 银登中心登记金额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_asset_secu_tran_cont_info to ${idl_schema};
grant select on ${icl_schema}.cmm_asset_secu_tran_cont_info to ${iel_schema};
grant select on ${icl_schema}.cmm_asset_secu_tran_cont_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_asset_secu_tran_cont_info is '资产证券化转让合同信息';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_pool_id is '资产池编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_status_cd is '产品状态代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_bus_status_cd is '产品业务状态代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_mode_cd is '产品模式代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_pool_type_cd is '资产池类型代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_pool_char_cd is '资产池性质代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_pool_status_cd is '资产池状态代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.tran_calc_way_cd is '转让计算方式代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_org_type_cd is '交易对手机构类型代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_cert_type is '交易对手证件类型';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_cert_no is '交易对手证件号码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_acct_num is '交易对手账号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_open_bank_name is '交易对手开户行名称';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_tran_dt is '交易对手转账日期';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.cntpty_pay_amt is '交易对手已支付金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.pay_dt_rule_cd is '支付日期规则代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.ts_cd is '暂存代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.user_def_coll_ped_flg is '自定义归集周期标志';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.clearup_repo_flg is '清仓回购标志';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.non_asset_flg is '不良资产标志';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.tran_plat_name is '交易平台名称';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.pkg_dt is '封包日期';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.begin_dt is '起始日期';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.rgst_teller_id is '登记柜员编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.rgst_org_id is '登记机构编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_tot_amt is '资产总金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.issue_tot_amt is '发行总金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_tran_consideration_amt is '资产转让对价金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.asset_tran_comm_fee is '资产转让手续费';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.prod_self_hold_amt is '产品自持金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.issue_qtty is '发行数量';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.bank_rgst_center_amt is '银登中心登记金额';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_asset_secu_tran_cont_info.etl_timestamp is 'ETL处理时间戳';
