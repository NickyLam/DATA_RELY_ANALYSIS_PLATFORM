/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fin_instm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fin_instm
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fin_instm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,curr_cd varchar2(10) -- 币种代码
    ,fin_instm_name varchar2(750) -- 金融工具名称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_cls varchar2(150) -- 产品分类
    ,prod_tenor_cls_cd varchar2(10) -- 产品期限分类代码
    ,exp_dt date -- 到期日期
    ,src_tenor_cd varchar2(10) -- 源期限代码
    ,tenor varchar2(15) -- 期限
    ,tenor_type_cd varchar2(10) -- 期限类型代码
    ,underly_fin_instm_id varchar2(60) -- 标的金融工具编号
    ,un_asset_type_id varchar2(60) -- 标的资产类型编号
    ,underly_market_type_id varchar2(60) -- 标的市场类型编号
    ,coupon_type_cd varchar2(10) -- 息票类型代码
    ,issue_mode_cd varchar2(10) -- 发行模式代码
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,pay_int_ped_freq varchar2(10) -- 付息周期频率
    ,pay_int_ped_corp_cd varchar2(15) -- 期限单位
    ,pay_int_cnt number(18,0) -- 付息次数
    ,payoff_level_cd varchar2(10) -- 清偿等级代码
    ,issue_org_id varchar2(60) -- 发行机构编号
    ,cn_abbr varchar2(150) -- 中文简写
    ,agent_name varchar2(150) -- 经办人名称
    ,oper_dt date -- 经办日期
    ,checker_name varchar2(90) -- 复核人名称
    ,check_dt date -- 复核日期
    ,issue_denom number(38,8) -- 发行面额
    ,fwd_int_rat_curve varchar2(750) -- 远期利率曲线
    ,disct_int_rat_curve varchar2(750) -- 折现利率曲线
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,last_exp_dt date -- 上次到期日期
    ,tenor_days number(18,0) -- 期限天数
    ,value_dt date -- 起息日期
    ,risk_wt number(18,6) -- 风险权重
    ,cust_cls_name varchar2(750) -- 客户分类名称
    ,acctnt_prod_name varchar2(150) -- 会计产品名称
    ,issuer_id varchar2(60) -- 发行人编号
    ,guartor_id varchar2(60) -- 担保人编号
    ,issuer_cust_cls_name varchar2(375) -- 发行人客户分类名称
    ,bond_actl_exp_dt date -- 债券实际到期日期
    ,reg_core_acct_id varchar2(60) -- 定期核心账户编号
    ,valuation_curr_cd varchar2(10) -- 计价币种代码
    ,spv_asset_flg varchar2(10) -- SPV资产标志
    ,pric_amt number(38,8) -- 本金金额
    ,fir_pay_int_dt date -- 首次付息日期
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,crdt_cls_cd varchar2(30) -- 授信分类代码
    ,ocup_crdt_flg varchar2(10) -- 占用授信标志
    ,crdt_wt number(18,6) -- 授信权重
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,renew_flg varchar2(10) -- 续期标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.prd_fin_instm to ${icl_schema};
grant select on ${iml_schema}.prd_fin_instm to ${idl_schema};
grant select on ${iml_schema}.prd_fin_instm to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fin_instm is '金融工具表';
comment on column ${iml_schema}.prd_fin_instm.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_fin_instm.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fin_instm.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fin_instm.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fin_instm.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_fin_instm.fin_instm_name is '金融工具名称';
comment on column ${iml_schema}.prd_fin_instm.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_fin_instm.prod_cls is '产品分类';
comment on column ${iml_schema}.prd_fin_instm.prod_tenor_cls_cd is '产品期限分类代码';
comment on column ${iml_schema}.prd_fin_instm.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_fin_instm.src_tenor_cd is '源期限代码';
comment on column ${iml_schema}.prd_fin_instm.tenor is '期限';
comment on column ${iml_schema}.prd_fin_instm.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.prd_fin_instm.underly_fin_instm_id is '标的金融工具编号';
comment on column ${iml_schema}.prd_fin_instm.un_asset_type_id is '标的资产类型编号';
comment on column ${iml_schema}.prd_fin_instm.underly_market_type_id is '标的市场类型编号';
comment on column ${iml_schema}.prd_fin_instm.coupon_type_cd is '息票类型代码';
comment on column ${iml_schema}.prd_fin_instm.issue_mode_cd is '发行模式代码';
comment on column ${iml_schema}.prd_fin_instm.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${iml_schema}.prd_fin_instm.pay_int_ped_freq is '付息周期频率';
comment on column ${iml_schema}.prd_fin_instm.pay_int_ped_corp_cd is '期限单位';
comment on column ${iml_schema}.prd_fin_instm.pay_int_cnt is '付息次数';
comment on column ${iml_schema}.prd_fin_instm.payoff_level_cd is '清偿等级代码';
comment on column ${iml_schema}.prd_fin_instm.issue_org_id is '发行机构编号';
comment on column ${iml_schema}.prd_fin_instm.cn_abbr is '中文简写';
comment on column ${iml_schema}.prd_fin_instm.agent_name is '经办人名称';
comment on column ${iml_schema}.prd_fin_instm.oper_dt is '经办日期';
comment on column ${iml_schema}.prd_fin_instm.checker_name is '复核人名称';
comment on column ${iml_schema}.prd_fin_instm.check_dt is '复核日期';
comment on column ${iml_schema}.prd_fin_instm.issue_denom is '发行面额';
comment on column ${iml_schema}.prd_fin_instm.fwd_int_rat_curve is '远期利率曲线';
comment on column ${iml_schema}.prd_fin_instm.disct_int_rat_curve is '折现利率曲线';
comment on column ${iml_schema}.prd_fin_instm.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.prd_fin_instm.last_exp_dt is '上次到期日期';
comment on column ${iml_schema}.prd_fin_instm.tenor_days is '期限天数';
comment on column ${iml_schema}.prd_fin_instm.value_dt is '起息日期';
comment on column ${iml_schema}.prd_fin_instm.risk_wt is '风险权重';
comment on column ${iml_schema}.prd_fin_instm.cust_cls_name is '客户分类名称';
comment on column ${iml_schema}.prd_fin_instm.acctnt_prod_name is '会计产品名称';
comment on column ${iml_schema}.prd_fin_instm.issuer_id is '发行人编号';
comment on column ${iml_schema}.prd_fin_instm.guartor_id is '担保人编号';
comment on column ${iml_schema}.prd_fin_instm.issuer_cust_cls_name is '发行人客户分类名称';
comment on column ${iml_schema}.prd_fin_instm.bond_actl_exp_dt is '债券实际到期日期';
comment on column ${iml_schema}.prd_fin_instm.reg_core_acct_id is '定期核心账户编号';
comment on column ${iml_schema}.prd_fin_instm.valuation_curr_cd is '计价币种代码';
comment on column ${iml_schema}.prd_fin_instm.spv_asset_flg is 'SPV资产标志';
comment on column ${iml_schema}.prd_fin_instm.pric_amt is '本金金额';
comment on column ${iml_schema}.prd_fin_instm.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.prd_fin_instm.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.prd_fin_instm.crdt_cls_cd is '授信分类代码';
comment on column ${iml_schema}.prd_fin_instm.ocup_crdt_flg is '占用授信标志';
comment on column ${iml_schema}.prd_fin_instm.crdt_wt is '授信权重';
comment on column ${iml_schema}.prd_fin_instm.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.prd_fin_instm.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_fin_instm.renew_flg is '续期标志';
comment on column ${iml_schema}.prd_fin_instm.create_dt is '创建日期';
comment on column ${iml_schema}.prd_fin_instm.update_dt is '更新日期';
comment on column ${iml_schema}.prd_fin_instm.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_fin_instm.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fin_instm.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fin_instm.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fin_instm.etl_timestamp is 'ETL处理时间戳';
