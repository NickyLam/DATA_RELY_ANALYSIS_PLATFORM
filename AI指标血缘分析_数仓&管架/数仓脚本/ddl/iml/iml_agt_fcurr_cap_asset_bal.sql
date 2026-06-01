/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fcurr_cap_asset_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fcurr_cap_asset_bal
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fcurr_cap_asset_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fcurr_cap_asset_bal(
    asset_bal_id varchar2(60) -- 资产余额编号
    ,lp_id varchar2(60) -- 法人编号
    ,agt_id varchar2(60) -- 协议编号
    ,bal_dtl_id varchar2(60) -- 余额明细编号
    ,dept_id varchar2(60) -- 部门编号
    ,acct_b_id varchar2(60) -- 账簿编号
    ,bus_dt date -- 业务日期
    ,asset_cate_name varchar2(150) -- 资产类别名称
    ,bus_cate_name varchar2(150) -- 业务类别名称
    ,main_asset_id varchar2(100) -- 主资产编号
    ,minor_asset_id varchar2(100) -- 次资产编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,hold_pos number(30,2) -- 持有仓位
    ,hold_denom number(30,2) -- 持有面额
    ,net_price_cost number(30,2) -- 净价成本
    ,int_adj number(30,2) -- 利息调整
    ,evha_val_chag number(30,2) -- 公允价值变动
    ,int_cost number(30,2) -- 利息成本
    ,full_price_cost number(30,2) -- 全价成本
    ,impam_prep number(30,2) -- 减值准备
    ,spd_prft number(30,2) -- 价差收益
    ,amort_prft number(30,2) -- 摊销收益
    ,int_prft number(30,2) -- 利息收益
    ,evha_val_chag_pl number(30,2) -- 公允价值变动损益
    ,impam_loss number(30,2) -- 减值损失
    ,tran_fee number(30,2) -- 交易费用
    ,actl_int_rat number(30,2) -- 实际利率
    ,comm_fee_inco number(30,2) -- 手续费收入
    ,comm_fee_expns number(30,2) -- 手续费支出
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,happ_amt number(30,2) -- 发生金额
    ,amort_adj_fact number(18,0) -- 摊销调整因子
    ,init_asset_bal_id varchar2(60) -- 原资产余额编号
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,pric_subj_id varchar2(100) -- 本金科目编号
    ,int_cost_subj_id varchar2(100) -- 利息成本科目编号
    ,int_adj_subj_id varchar2(100) -- 利息调整科目编号
    ,evha_val_chag_subj_id varchar2(100) -- 公允价值变动科目编号
    ,int_income_subj_id varchar2(100) -- 利息收入科目编号
    ,amort_prft_subj_id varchar2(100) -- 摊销收益科目编号
    ,evha_val_chag_pl_subj_id varchar2(100) -- 公允价值变动损益科目编号
    ,spd_prft_subj_id varchar2(100) -- 价差收益科目编号
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
grant select on ${iml_schema}.agt_fcurr_cap_asset_bal to ${icl_schema};
grant select on ${iml_schema}.agt_fcurr_cap_asset_bal to ${idl_schema};
grant select on ${iml_schema}.agt_fcurr_cap_asset_bal to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fcurr_cap_asset_bal is '外币资金资产余额';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.asset_bal_id is '资产余额编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.bal_dtl_id is '余额明细编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.dept_id is '部门编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.bus_dt is '业务日期';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.asset_cate_name is '资产类别名称';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.bus_cate_name is '业务类别名称';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.main_asset_id is '主资产编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.minor_asset_id is '次资产编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.hold_pos is '持有仓位';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.hold_denom is '持有面额';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.net_price_cost is '净价成本';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_adj is '利息调整';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_cost is '利息成本';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.full_price_cost is '全价成本';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.impam_prep is '减值准备';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.spd_prft is '价差收益';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.amort_prft is '摊销收益';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_prft is '利息收益';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.evha_val_chag_pl is '公允价值变动损益';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.impam_loss is '减值损失';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.tran_fee is '交易费用';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.actl_int_rat is '实际利率';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.comm_fee_inco is '手续费收入';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.comm_fee_expns is '手续费支出';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.value_dt is '起息日期';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.happ_amt is '发生金额';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.amort_adj_fact is '摊销调整因子';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.init_asset_bal_id is '原资产余额编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.strk_bal_flg is '冲账标志';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.pric_subj_id is '本金科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_cost_subj_id is '利息成本科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_adj_subj_id is '利息调整科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.evha_val_chag_subj_id is '公允价值变动科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.int_income_subj_id is '利息收入科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.amort_prft_subj_id is '摊销收益科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.evha_val_chag_pl_subj_id is '公允价值变动损益科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.spd_prft_subj_id is '价差收益科目编号';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fcurr_cap_asset_bal.etl_timestamp is 'ETL处理时间戳';
