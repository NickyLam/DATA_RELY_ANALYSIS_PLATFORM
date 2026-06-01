/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dc_cap_asset_bal_chg_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bal_chg_dtl_id varchar2(60) -- 余额变动明细编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_tab_name varchar2(375) -- 业务表名
    ,dept_id varchar2(60) -- 部门编号
    ,acct_b_id varchar2(60) -- 账簿编号
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,bus_cate_name varchar2(150) -- 业务类别名称
    ,main_asset_id varchar2(100) -- 主资产编号
    ,minor_asset_id varchar2(100) -- 次资产编号
    ,actl_acpt_pay_dt date -- 实际收付日期
    ,hold_pos number(38,8) -- 持有仓位
    ,hold_denom number(38,8) -- 持有面额
    ,net_price_cost number(38,8) -- 净价成本
    ,int_adj number(38,8) -- 利息调整
    ,evha_val_chag number(38,8) -- 公允价值变动
    ,int_cost number(38,8) -- 利息成本
    ,full_price_cost number(38,8) -- 全价成本
    ,impam_prep number(38,8) -- 减值准备
    ,spd_prft number(38,8) -- 价差收益
    ,amort_prft number(38,8) -- 摊销收益
    ,int_prft number(38,8) -- 利息收益
    ,evha_val_chag_pl number(38,8) -- 公允价值变动损益
    ,impam_loss number(38,8) -- 减值损失
    ,tran_fee number(38,8) -- 交易费用
    ,actl_int_rat number(38,8) -- 实际利率
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,final_update_tm timestamp -- 最后更新时间
    ,happ_amt number(38,8) -- 发生金额
    ,last_bal_chg_dtl_id varchar2(60) -- 上次余额变动明细编号
    ,strk_bal_flg varchar2(30) -- 冲账标志
    ,comm_fee_inco number(18,8) -- 手续费收入
    ,comm_fee_expns number(18,8) -- 手续费支出
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
grant select on ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl is '本币资金资产余额变动明细';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.bal_chg_dtl_id is '余额变动明细编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.bus_id is '业务编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.bus_tab_name is '业务表名';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.dept_id is '部门编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.bus_cate_name is '业务类别名称';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.main_asset_id is '主资产编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.minor_asset_id is '次资产编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.actl_acpt_pay_dt is '实际收付日期';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.hold_pos is '持有仓位';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.hold_denom is '持有面额';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.net_price_cost is '净价成本';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.int_adj is '利息调整';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.evha_val_chag is '公允价值变动';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.int_cost is '利息成本';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.full_price_cost is '全价成本';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.impam_prep is '减值准备';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.spd_prft is '价差收益';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.amort_prft is '摊销收益';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.int_prft is '利息收益';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.evha_val_chag_pl is '公允价值变动损益';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.impam_loss is '减值损失';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.tran_fee is '交易费用';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.actl_int_rat is '实际利率';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.value_dt is '起息日期';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.happ_amt is '发生金额';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.last_bal_chg_dtl_id is '上次余额变动明细编号';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.strk_bal_flg is '冲账标志';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.comm_fee_inco is '手续费收入';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.comm_fee_expns is '手续费支出';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dc_cap_asset_bal_chg_dtl.etl_timestamp is 'ETL处理时间戳';
