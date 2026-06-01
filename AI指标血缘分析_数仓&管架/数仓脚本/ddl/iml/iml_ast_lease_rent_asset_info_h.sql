/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_lease_rent_asset_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_lease_rent_asset_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_lease_rent_asset_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_lease_rent_asset_info_h(
    lease_asset_ser_num varchar2(100) -- 承租资产序列号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_id varchar2(100) -- 资产编号
    ,asset_ser_num varchar2(100) -- 资产序列号
    ,lease_cont_ser_num varchar2(100) -- 承租合同序列号
    ,cont_id varchar2(100) -- 合同编号
    ,cont_name varchar2(375) -- 合同名称
    ,cont_effect_dt date -- 合同生效日期
    ,rent_ps_name varchar2(750) -- 出租人名称
    ,acct_b_id varchar2(100) -- 账簿编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,asset_name varchar2(750) -- 押品名称
    ,asset_cate_ser_num varchar2(100) -- 资产类别序列号
    ,asset_qtty varchar2(45) -- 资产数量
    ,asset_status_cd varchar2(30) -- 资产状态代码
    ,enter_acct_flg varchar2(30) -- 入账标志
    ,rent_start_dt date -- 租赁开始日期
    ,rent_exp_dt date -- 租赁到期日期
    ,rent_tenor varchar2(45) -- 租赁期限
    ,rent_tax_lmt number(30,2) -- 租赁税额
    ,plan_pay_pre_tax_tot number(30,2) -- 计划付款税前总额
    ,plan_pay_at_tot number(30,2) -- 计划付款税后总额
    ,year_disct_rat number(18,6) -- 年折现率
    ,day_disct_rat number(18,6) -- 日折现率
    ,effect_tm timestamp -- 生效时间
    ,invalid_tm timestamp -- 失效时间
    ,mtg_amt number(30,2) -- 抵押金额
    ,pay_freq_cd varchar2(60) -- 付款频率代码
    ,rent_cont_idtfy_ser_num varchar2(100) -- 租赁合同识别序列号
    ,rent_area number(30,2) -- 租赁面积
    ,inv_type_cd varchar2(500) -- 发票类型代码
    ,rent_usage_type_cd varchar2(500) -- 租赁用途类型代码
    ,mode_pay_cd varchar2(500) -- 支付方式代码
    ,dedu_flg varchar2(10) -- 可抵扣标志
    ,prepay_amorted_bal number(30,2) -- 预付待摊余额
    ,org_id varchar2(500) -- 机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_lease_rent_asset_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_lease_rent_asset_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_lease_rent_asset_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_lease_rent_asset_info_h is '承租租赁资产信息历史';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.lease_asset_ser_num is '承租资产序列号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_ser_num is '资产序列号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.lease_cont_ser_num is '承租合同序列号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.cont_name is '合同名称';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.cont_effect_dt is '合同生效日期';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_ps_name is '出租人名称';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.acct_b_id is '账簿编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_name is '押品名称';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_cate_ser_num is '资产类别序列号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_qtty is '资产数量';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.asset_status_cd is '资产状态代码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.enter_acct_flg is '入账标志';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_start_dt is '租赁开始日期';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_exp_dt is '租赁到期日期';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_tenor is '租赁期限';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_tax_lmt is '租赁税额';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.plan_pay_pre_tax_tot is '计划付款税前总额';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.plan_pay_at_tot is '计划付款税后总额';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.year_disct_rat is '年折现率';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.day_disct_rat is '日折现率';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.effect_tm is '生效时间';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.invalid_tm is '失效时间';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.mtg_amt is '抵押金额';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.pay_freq_cd is '付款频率代码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_cont_idtfy_ser_num is '租赁合同识别序列号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_area is '租赁面积';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.inv_type_cd is '发票类型代码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.rent_usage_type_cd is '租赁用途类型代码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.dedu_flg is '可抵扣标志';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.prepay_amorted_bal is '预付待摊余额';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.org_id is '机构编号';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_lease_rent_asset_info_h.etl_timestamp is 'ETL处理时间戳';
