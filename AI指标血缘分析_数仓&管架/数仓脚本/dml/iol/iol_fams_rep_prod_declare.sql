/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_rep_prod_declare
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.fams_rep_prod_declare_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_rep_prod_declare
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_prod_declare_op purge;
drop table ${iol_schema}.fams_rep_prod_declare_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_prod_declare_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_prod_declare where 0=1;

create table ${iol_schema}.fams_rep_prod_declare_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_prod_declare where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_prod_declare_cl(
            rep_finprod_id -- 金融产品代码
            ,rep_finprod_name -- 金融产品名称
            ,rep_finprod_reg_id -- 产品登记编码
            ,rep_finprod_ins_id -- 行内标识码
            ,rep_finprod_brand -- 产品品牌
            ,rep_finprod_stage -- 产品期次
            ,rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
            ,rep_approver_id -- 产品审批人身份证号
            ,rep_approver_name -- 产品审批人姓名
            ,rep_designer_id -- 产品设计人身份证号
            ,rep_designer_name -- 产品设计人姓名
            ,rep_manager_id -- 投资经理身份证号
            ,rep_manager_name -- 投资经理姓名
            ,rep_liaison_name -- 业务联络人姓名
            ,rep_liaison_tel -- 业务联络人座机
            ,rep_liaison_mobile -- 业务联络人手机
            ,rep_liaison_email -- 业务联络人邮箱
            ,rep_profit_type -- 产品收益类型
            ,rep_term -- 产品期限
            ,rep_investor_type -- 投资者类型
            ,rep_invest_area -- 资金投向地区
            ,rep_invest_country -- 产品投资国家或地区
            ,rep_finan_ser_model -- 理财业务服务模式
            ,rep_operate_mode -- 产品运作模式
            ,rep_book_mode -- 会计核算方式
            ,rep_cmmode -- 产品资产配置方式
            ,rep_pmmode -- 产品管理模式
            ,rep_mname -- 实际管理人员名称
            ,rep_priced_mode -- 产品定价方式
            ,rep_inv_asset_type -- 投资资产类型
            ,rep_con_prd_traget -- 结构性产品挂钩标的
            ,rep_cont_mode -- 合作模式
            ,rep_coop_name -- 合作机构名称
            ,rep_inv_type_rat -- 投资资产种类及比例
            ,rep_is_yield -- 是否有预期收益率
            ,rep_high_yield -- 预计客户最高年收益率
            ,rep_low_yield -- 预计客户最低年收益率
            ,rep_is_yield_basis -- 是否有收益率测算依据
            ,rep_risk_type -- 投资者风险偏好
            ,rep_sale_area -- 产品销售区域
            ,rep_raise_ccy -- 募集币种
            ,rep_cash_prin_ccy -- 兑付本金币种
            ,rep_cash_prof_ccy -- 兑付收益币种
            ,rep_sale_amt_str -- 起点销售金额
            ,rep_raise_amt_plan -- 计划募集金额
            ,rep_raise_pstrdate -- 募集起始日期（从）
            ,rep_raise_penddate -- 募集起始日期（到）
            ,rep_invest_prin_date -- 投资本金到账日
            ,rep_invest_prof_date -- 投资收益到账日
            ,rep_sale_fee_rate -- 销售手续费
            ,rep_in_dep_name -- 境内托管机构名称
            ,rep_in_dep_code -- 境内托管机构代码
            ,rep_out_dep_ctry -- 境外托管机构国别
            ,rep_out_dep_name -- 境外托管机构名称
            ,rep_tru_fee_rate -- 托管费率
            ,rep_risk_level -- 产品风险等级
            ,rep_term_right_flag -- 发型机构提前终止权标识
            ,rep_cus_redeem_flag -- 客户赎回权标识
            ,rep_credit_flag -- 产品增信标识
            ,rep_credit_type -- 产品增信机构类型
            ,rep_credit_mode -- 产品增信形式
            ,rep_remark -- 备注
            ,rep_declare_date -- 报告登记日
            ,rep_send_status -- 报送状态
            ,rep_status_date -- 数据日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,exc_fin_sector -- 是否金融同业专属
            ,is_short_term -- 是否设置最短持有期限
            ,short_term -- 最短持有期限(天)
            ,is_free_redem -- 最短持有期后是否自由赎回
            ,customer_type -- 客户类型-人行报送
            ,rep_issue_type -- 产品募集方式
            ,rep_yield -- 业绩比较基准%
            ,rep_invest_nature -- 产品投资性质
            ,rep_is_cash_manage -- 是否现金管理类
            ,rep_invest_fee_rate -- 投资管理费率%
            ,rep_fiduciary_duty -- 是否收益权转让产品
            ,rep_fprod_id -- 母产品代码
            ,buy_place -- 销售区域
            ,customer_type1 -- 客户一级类型
            ,customer_type2 -- 客户二级类型
            ,prd_spec_property -- 产品特殊属性
            ,base_info_sign -- 基本信息公开标识
            ,change_reason -- 变更原因
            ,rep_extension_flag -- 产品展期标识
            ,rep_is_in_liquidation -- 是否处于清算中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_prod_declare_op(
            rep_finprod_id -- 金融产品代码
            ,rep_finprod_name -- 金融产品名称
            ,rep_finprod_reg_id -- 产品登记编码
            ,rep_finprod_ins_id -- 行内标识码
            ,rep_finprod_brand -- 产品品牌
            ,rep_finprod_stage -- 产品期次
            ,rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
            ,rep_approver_id -- 产品审批人身份证号
            ,rep_approver_name -- 产品审批人姓名
            ,rep_designer_id -- 产品设计人身份证号
            ,rep_designer_name -- 产品设计人姓名
            ,rep_manager_id -- 投资经理身份证号
            ,rep_manager_name -- 投资经理姓名
            ,rep_liaison_name -- 业务联络人姓名
            ,rep_liaison_tel -- 业务联络人座机
            ,rep_liaison_mobile -- 业务联络人手机
            ,rep_liaison_email -- 业务联络人邮箱
            ,rep_profit_type -- 产品收益类型
            ,rep_term -- 产品期限
            ,rep_investor_type -- 投资者类型
            ,rep_invest_area -- 资金投向地区
            ,rep_invest_country -- 产品投资国家或地区
            ,rep_finan_ser_model -- 理财业务服务模式
            ,rep_operate_mode -- 产品运作模式
            ,rep_book_mode -- 会计核算方式
            ,rep_cmmode -- 产品资产配置方式
            ,rep_pmmode -- 产品管理模式
            ,rep_mname -- 实际管理人员名称
            ,rep_priced_mode -- 产品定价方式
            ,rep_inv_asset_type -- 投资资产类型
            ,rep_con_prd_traget -- 结构性产品挂钩标的
            ,rep_cont_mode -- 合作模式
            ,rep_coop_name -- 合作机构名称
            ,rep_inv_type_rat -- 投资资产种类及比例
            ,rep_is_yield -- 是否有预期收益率
            ,rep_high_yield -- 预计客户最高年收益率
            ,rep_low_yield -- 预计客户最低年收益率
            ,rep_is_yield_basis -- 是否有收益率测算依据
            ,rep_risk_type -- 投资者风险偏好
            ,rep_sale_area -- 产品销售区域
            ,rep_raise_ccy -- 募集币种
            ,rep_cash_prin_ccy -- 兑付本金币种
            ,rep_cash_prof_ccy -- 兑付收益币种
            ,rep_sale_amt_str -- 起点销售金额
            ,rep_raise_amt_plan -- 计划募集金额
            ,rep_raise_pstrdate -- 募集起始日期（从）
            ,rep_raise_penddate -- 募集起始日期（到）
            ,rep_invest_prin_date -- 投资本金到账日
            ,rep_invest_prof_date -- 投资收益到账日
            ,rep_sale_fee_rate -- 销售手续费
            ,rep_in_dep_name -- 境内托管机构名称
            ,rep_in_dep_code -- 境内托管机构代码
            ,rep_out_dep_ctry -- 境外托管机构国别
            ,rep_out_dep_name -- 境外托管机构名称
            ,rep_tru_fee_rate -- 托管费率
            ,rep_risk_level -- 产品风险等级
            ,rep_term_right_flag -- 发型机构提前终止权标识
            ,rep_cus_redeem_flag -- 客户赎回权标识
            ,rep_credit_flag -- 产品增信标识
            ,rep_credit_type -- 产品增信机构类型
            ,rep_credit_mode -- 产品增信形式
            ,rep_remark -- 备注
            ,rep_declare_date -- 报告登记日
            ,rep_send_status -- 报送状态
            ,rep_status_date -- 数据日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,exc_fin_sector -- 是否金融同业专属
            ,is_short_term -- 是否设置最短持有期限
            ,short_term -- 最短持有期限(天)
            ,is_free_redem -- 最短持有期后是否自由赎回
            ,customer_type -- 客户类型-人行报送
            ,rep_issue_type -- 产品募集方式
            ,rep_yield -- 业绩比较基准%
            ,rep_invest_nature -- 产品投资性质
            ,rep_is_cash_manage -- 是否现金管理类
            ,rep_invest_fee_rate -- 投资管理费率%
            ,rep_fiduciary_duty -- 是否收益权转让产品
            ,rep_fprod_id -- 母产品代码
            ,buy_place -- 销售区域
            ,customer_type1 -- 客户一级类型
            ,customer_type2 -- 客户二级类型
            ,prd_spec_property -- 产品特殊属性
            ,base_info_sign -- 基本信息公开标识
            ,change_reason -- 变更原因
            ,rep_extension_flag -- 产品展期标识
            ,rep_is_in_liquidation -- 是否处于清算中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rep_finprod_id, o.rep_finprod_id) as rep_finprod_id -- 金融产品代码
    ,nvl(n.rep_finprod_name, o.rep_finprod_name) as rep_finprod_name -- 金融产品名称
    ,nvl(n.rep_finprod_reg_id, o.rep_finprod_reg_id) as rep_finprod_reg_id -- 产品登记编码
    ,nvl(n.rep_finprod_ins_id, o.rep_finprod_ins_id) as rep_finprod_ins_id -- 行内标识码
    ,nvl(n.rep_finprod_brand, o.rep_finprod_brand) as rep_finprod_brand -- 产品品牌
    ,nvl(n.rep_finprod_stage, o.rep_finprod_stage) as rep_finprod_stage -- 产品期次
    ,nvl(n.rep_issue_party_id, o.rep_issue_party_id) as rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
    ,nvl(n.rep_approver_id, o.rep_approver_id) as rep_approver_id -- 产品审批人身份证号
    ,nvl(n.rep_approver_name, o.rep_approver_name) as rep_approver_name -- 产品审批人姓名
    ,nvl(n.rep_designer_id, o.rep_designer_id) as rep_designer_id -- 产品设计人身份证号
    ,nvl(n.rep_designer_name, o.rep_designer_name) as rep_designer_name -- 产品设计人姓名
    ,nvl(n.rep_manager_id, o.rep_manager_id) as rep_manager_id -- 投资经理身份证号
    ,nvl(n.rep_manager_name, o.rep_manager_name) as rep_manager_name -- 投资经理姓名
    ,nvl(n.rep_liaison_name, o.rep_liaison_name) as rep_liaison_name -- 业务联络人姓名
    ,nvl(n.rep_liaison_tel, o.rep_liaison_tel) as rep_liaison_tel -- 业务联络人座机
    ,nvl(n.rep_liaison_mobile, o.rep_liaison_mobile) as rep_liaison_mobile -- 业务联络人手机
    ,nvl(n.rep_liaison_email, o.rep_liaison_email) as rep_liaison_email -- 业务联络人邮箱
    ,nvl(n.rep_profit_type, o.rep_profit_type) as rep_profit_type -- 产品收益类型
    ,nvl(n.rep_term, o.rep_term) as rep_term -- 产品期限
    ,nvl(n.rep_investor_type, o.rep_investor_type) as rep_investor_type -- 投资者类型
    ,nvl(n.rep_invest_area, o.rep_invest_area) as rep_invest_area -- 资金投向地区
    ,nvl(n.rep_invest_country, o.rep_invest_country) as rep_invest_country -- 产品投资国家或地区
    ,nvl(n.rep_finan_ser_model, o.rep_finan_ser_model) as rep_finan_ser_model -- 理财业务服务模式
    ,nvl(n.rep_operate_mode, o.rep_operate_mode) as rep_operate_mode -- 产品运作模式
    ,nvl(n.rep_book_mode, o.rep_book_mode) as rep_book_mode -- 会计核算方式
    ,nvl(n.rep_cmmode, o.rep_cmmode) as rep_cmmode -- 产品资产配置方式
    ,nvl(n.rep_pmmode, o.rep_pmmode) as rep_pmmode -- 产品管理模式
    ,nvl(n.rep_mname, o.rep_mname) as rep_mname -- 实际管理人员名称
    ,nvl(n.rep_priced_mode, o.rep_priced_mode) as rep_priced_mode -- 产品定价方式
    ,nvl(n.rep_inv_asset_type, o.rep_inv_asset_type) as rep_inv_asset_type -- 投资资产类型
    ,nvl(n.rep_con_prd_traget, o.rep_con_prd_traget) as rep_con_prd_traget -- 结构性产品挂钩标的
    ,nvl(n.rep_cont_mode, o.rep_cont_mode) as rep_cont_mode -- 合作模式
    ,nvl(n.rep_coop_name, o.rep_coop_name) as rep_coop_name -- 合作机构名称
    ,nvl(n.rep_inv_type_rat, o.rep_inv_type_rat) as rep_inv_type_rat -- 投资资产种类及比例
    ,nvl(n.rep_is_yield, o.rep_is_yield) as rep_is_yield -- 是否有预期收益率
    ,nvl(n.rep_high_yield, o.rep_high_yield) as rep_high_yield -- 预计客户最高年收益率
    ,nvl(n.rep_low_yield, o.rep_low_yield) as rep_low_yield -- 预计客户最低年收益率
    ,nvl(n.rep_is_yield_basis, o.rep_is_yield_basis) as rep_is_yield_basis -- 是否有收益率测算依据
    ,nvl(n.rep_risk_type, o.rep_risk_type) as rep_risk_type -- 投资者风险偏好
    ,nvl(n.rep_sale_area, o.rep_sale_area) as rep_sale_area -- 产品销售区域
    ,nvl(n.rep_raise_ccy, o.rep_raise_ccy) as rep_raise_ccy -- 募集币种
    ,nvl(n.rep_cash_prin_ccy, o.rep_cash_prin_ccy) as rep_cash_prin_ccy -- 兑付本金币种
    ,nvl(n.rep_cash_prof_ccy, o.rep_cash_prof_ccy) as rep_cash_prof_ccy -- 兑付收益币种
    ,nvl(n.rep_sale_amt_str, o.rep_sale_amt_str) as rep_sale_amt_str -- 起点销售金额
    ,nvl(n.rep_raise_amt_plan, o.rep_raise_amt_plan) as rep_raise_amt_plan -- 计划募集金额
    ,nvl(n.rep_raise_pstrdate, o.rep_raise_pstrdate) as rep_raise_pstrdate -- 募集起始日期（从）
    ,nvl(n.rep_raise_penddate, o.rep_raise_penddate) as rep_raise_penddate -- 募集起始日期（到）
    ,nvl(n.rep_invest_prin_date, o.rep_invest_prin_date) as rep_invest_prin_date -- 投资本金到账日
    ,nvl(n.rep_invest_prof_date, o.rep_invest_prof_date) as rep_invest_prof_date -- 投资收益到账日
    ,nvl(n.rep_sale_fee_rate, o.rep_sale_fee_rate) as rep_sale_fee_rate -- 销售手续费
    ,nvl(n.rep_in_dep_name, o.rep_in_dep_name) as rep_in_dep_name -- 境内托管机构名称
    ,nvl(n.rep_in_dep_code, o.rep_in_dep_code) as rep_in_dep_code -- 境内托管机构代码
    ,nvl(n.rep_out_dep_ctry, o.rep_out_dep_ctry) as rep_out_dep_ctry -- 境外托管机构国别
    ,nvl(n.rep_out_dep_name, o.rep_out_dep_name) as rep_out_dep_name -- 境外托管机构名称
    ,nvl(n.rep_tru_fee_rate, o.rep_tru_fee_rate) as rep_tru_fee_rate -- 托管费率
    ,nvl(n.rep_risk_level, o.rep_risk_level) as rep_risk_level -- 产品风险等级
    ,nvl(n.rep_term_right_flag, o.rep_term_right_flag) as rep_term_right_flag -- 发型机构提前终止权标识
    ,nvl(n.rep_cus_redeem_flag, o.rep_cus_redeem_flag) as rep_cus_redeem_flag -- 客户赎回权标识
    ,nvl(n.rep_credit_flag, o.rep_credit_flag) as rep_credit_flag -- 产品增信标识
    ,nvl(n.rep_credit_type, o.rep_credit_type) as rep_credit_type -- 产品增信机构类型
    ,nvl(n.rep_credit_mode, o.rep_credit_mode) as rep_credit_mode -- 产品增信形式
    ,nvl(n.rep_remark, o.rep_remark) as rep_remark -- 备注
    ,nvl(n.rep_declare_date, o.rep_declare_date) as rep_declare_date -- 报告登记日
    ,nvl(n.rep_send_status, o.rep_send_status) as rep_send_status -- 报送状态
    ,nvl(n.rep_status_date, o.rep_status_date) as rep_status_date -- 数据日期
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.exc_fin_sector, o.exc_fin_sector) as exc_fin_sector -- 是否金融同业专属
    ,nvl(n.is_short_term, o.is_short_term) as is_short_term -- 是否设置最短持有期限
    ,nvl(n.short_term, o.short_term) as short_term -- 最短持有期限(天)
    ,nvl(n.is_free_redem, o.is_free_redem) as is_free_redem -- 最短持有期后是否自由赎回
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 客户类型-人行报送
    ,nvl(n.rep_issue_type, o.rep_issue_type) as rep_issue_type -- 产品募集方式
    ,nvl(n.rep_yield, o.rep_yield) as rep_yield -- 业绩比较基准%
    ,nvl(n.rep_invest_nature, o.rep_invest_nature) as rep_invest_nature -- 产品投资性质
    ,nvl(n.rep_is_cash_manage, o.rep_is_cash_manage) as rep_is_cash_manage -- 是否现金管理类
    ,nvl(n.rep_invest_fee_rate, o.rep_invest_fee_rate) as rep_invest_fee_rate -- 投资管理费率%
    ,nvl(n.rep_fiduciary_duty, o.rep_fiduciary_duty) as rep_fiduciary_duty -- 是否收益权转让产品
    ,nvl(n.rep_fprod_id, o.rep_fprod_id) as rep_fprod_id -- 母产品代码
    ,nvl(n.buy_place, o.buy_place) as buy_place -- 销售区域
    ,nvl(n.customer_type1, o.customer_type1) as customer_type1 -- 客户一级类型
    ,nvl(n.customer_type2, o.customer_type2) as customer_type2 -- 客户二级类型
    ,nvl(n.prd_spec_property, o.prd_spec_property) as prd_spec_property -- 产品特殊属性
    ,nvl(n.base_info_sign, o.base_info_sign) as base_info_sign -- 基本信息公开标识
    ,nvl(n.change_reason, o.change_reason) as change_reason -- 变更原因
    ,nvl(n.rep_extension_flag, o.rep_extension_flag) as rep_extension_flag -- 产品展期标识
    ,nvl(n.rep_is_in_liquidation, o.rep_is_in_liquidation) as rep_is_in_liquidation -- 是否处于清算中
    ,case when
            n.rep_finprod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rep_finprod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rep_finprod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_rep_prod_declare_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_rep_prod_declare where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rep_finprod_id = n.rep_finprod_id
where (
        o.rep_finprod_id is null
    )
    or (
        n.rep_finprod_id is null
    )
    or (
        o.rep_finprod_name <> n.rep_finprod_name
        or o.rep_finprod_reg_id <> n.rep_finprod_reg_id
        or o.rep_finprod_ins_id <> n.rep_finprod_ins_id
        or o.rep_finprod_brand <> n.rep_finprod_brand
        or o.rep_finprod_stage <> n.rep_finprod_stage
        or o.rep_issue_party_id <> n.rep_issue_party_id
        or o.rep_approver_id <> n.rep_approver_id
        or o.rep_approver_name <> n.rep_approver_name
        or o.rep_designer_id <> n.rep_designer_id
        or o.rep_designer_name <> n.rep_designer_name
        or o.rep_manager_id <> n.rep_manager_id
        or o.rep_manager_name <> n.rep_manager_name
        or o.rep_liaison_name <> n.rep_liaison_name
        or o.rep_liaison_tel <> n.rep_liaison_tel
        or o.rep_liaison_mobile <> n.rep_liaison_mobile
        or o.rep_liaison_email <> n.rep_liaison_email
        or o.rep_profit_type <> n.rep_profit_type
        or o.rep_term <> n.rep_term
        or o.rep_investor_type <> n.rep_investor_type
        or o.rep_invest_area <> n.rep_invest_area
        or o.rep_invest_country <> n.rep_invest_country
        or o.rep_finan_ser_model <> n.rep_finan_ser_model
        or o.rep_operate_mode <> n.rep_operate_mode
        or o.rep_book_mode <> n.rep_book_mode
        or o.rep_cmmode <> n.rep_cmmode
        or o.rep_pmmode <> n.rep_pmmode
        or o.rep_mname <> n.rep_mname
        or o.rep_priced_mode <> n.rep_priced_mode
        or o.rep_inv_asset_type <> n.rep_inv_asset_type
        or o.rep_con_prd_traget <> n.rep_con_prd_traget
        or o.rep_cont_mode <> n.rep_cont_mode
        or o.rep_coop_name <> n.rep_coop_name
        or o.rep_inv_type_rat <> n.rep_inv_type_rat
        or o.rep_is_yield <> n.rep_is_yield
        or o.rep_high_yield <> n.rep_high_yield
        or o.rep_low_yield <> n.rep_low_yield
        or o.rep_is_yield_basis <> n.rep_is_yield_basis
        or o.rep_risk_type <> n.rep_risk_type
        or o.rep_sale_area <> n.rep_sale_area
        or o.rep_raise_ccy <> n.rep_raise_ccy
        or o.rep_cash_prin_ccy <> n.rep_cash_prin_ccy
        or o.rep_cash_prof_ccy <> n.rep_cash_prof_ccy
        or o.rep_sale_amt_str <> n.rep_sale_amt_str
        or o.rep_raise_amt_plan <> n.rep_raise_amt_plan
        or o.rep_raise_pstrdate <> n.rep_raise_pstrdate
        or o.rep_raise_penddate <> n.rep_raise_penddate
        or o.rep_invest_prin_date <> n.rep_invest_prin_date
        or o.rep_invest_prof_date <> n.rep_invest_prof_date
        or o.rep_sale_fee_rate <> n.rep_sale_fee_rate
        or o.rep_in_dep_name <> n.rep_in_dep_name
        or o.rep_in_dep_code <> n.rep_in_dep_code
        or o.rep_out_dep_ctry <> n.rep_out_dep_ctry
        or o.rep_out_dep_name <> n.rep_out_dep_name
        or o.rep_tru_fee_rate <> n.rep_tru_fee_rate
        or o.rep_risk_level <> n.rep_risk_level
        or o.rep_term_right_flag <> n.rep_term_right_flag
        or o.rep_cus_redeem_flag <> n.rep_cus_redeem_flag
        or o.rep_credit_flag <> n.rep_credit_flag
        or o.rep_credit_type <> n.rep_credit_type
        or o.rep_credit_mode <> n.rep_credit_mode
        or o.rep_remark <> n.rep_remark
        or o.rep_declare_date <> n.rep_declare_date
        or o.rep_send_status <> n.rep_send_status
        or o.rep_status_date <> n.rep_status_date
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.exc_fin_sector <> n.exc_fin_sector
        or o.is_short_term <> n.is_short_term
        or o.short_term <> n.short_term
        or o.is_free_redem <> n.is_free_redem
        or o.customer_type <> n.customer_type
        or o.rep_issue_type <> n.rep_issue_type
        or o.rep_yield <> n.rep_yield
        or o.rep_invest_nature <> n.rep_invest_nature
        or o.rep_is_cash_manage <> n.rep_is_cash_manage
        or o.rep_invest_fee_rate <> n.rep_invest_fee_rate
        or o.rep_fiduciary_duty <> n.rep_fiduciary_duty
        or o.rep_fprod_id <> n.rep_fprod_id
        or o.buy_place <> n.buy_place
        or o.customer_type1 <> n.customer_type1
        or o.customer_type2 <> n.customer_type2
        or o.prd_spec_property <> n.prd_spec_property
        or o.base_info_sign <> n.base_info_sign
        or o.change_reason <> n.change_reason
        or o.rep_extension_flag <> n.rep_extension_flag
        or o.rep_is_in_liquidation <> n.rep_is_in_liquidation
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_prod_declare_cl(
            rep_finprod_id -- 金融产品代码
            ,rep_finprod_name -- 金融产品名称
            ,rep_finprod_reg_id -- 产品登记编码
            ,rep_finprod_ins_id -- 行内标识码
            ,rep_finprod_brand -- 产品品牌
            ,rep_finprod_stage -- 产品期次
            ,rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
            ,rep_approver_id -- 产品审批人身份证号
            ,rep_approver_name -- 产品审批人姓名
            ,rep_designer_id -- 产品设计人身份证号
            ,rep_designer_name -- 产品设计人姓名
            ,rep_manager_id -- 投资经理身份证号
            ,rep_manager_name -- 投资经理姓名
            ,rep_liaison_name -- 业务联络人姓名
            ,rep_liaison_tel -- 业务联络人座机
            ,rep_liaison_mobile -- 业务联络人手机
            ,rep_liaison_email -- 业务联络人邮箱
            ,rep_profit_type -- 产品收益类型
            ,rep_term -- 产品期限
            ,rep_investor_type -- 投资者类型
            ,rep_invest_area -- 资金投向地区
            ,rep_invest_country -- 产品投资国家或地区
            ,rep_finan_ser_model -- 理财业务服务模式
            ,rep_operate_mode -- 产品运作模式
            ,rep_book_mode -- 会计核算方式
            ,rep_cmmode -- 产品资产配置方式
            ,rep_pmmode -- 产品管理模式
            ,rep_mname -- 实际管理人员名称
            ,rep_priced_mode -- 产品定价方式
            ,rep_inv_asset_type -- 投资资产类型
            ,rep_con_prd_traget -- 结构性产品挂钩标的
            ,rep_cont_mode -- 合作模式
            ,rep_coop_name -- 合作机构名称
            ,rep_inv_type_rat -- 投资资产种类及比例
            ,rep_is_yield -- 是否有预期收益率
            ,rep_high_yield -- 预计客户最高年收益率
            ,rep_low_yield -- 预计客户最低年收益率
            ,rep_is_yield_basis -- 是否有收益率测算依据
            ,rep_risk_type -- 投资者风险偏好
            ,rep_sale_area -- 产品销售区域
            ,rep_raise_ccy -- 募集币种
            ,rep_cash_prin_ccy -- 兑付本金币种
            ,rep_cash_prof_ccy -- 兑付收益币种
            ,rep_sale_amt_str -- 起点销售金额
            ,rep_raise_amt_plan -- 计划募集金额
            ,rep_raise_pstrdate -- 募集起始日期（从）
            ,rep_raise_penddate -- 募集起始日期（到）
            ,rep_invest_prin_date -- 投资本金到账日
            ,rep_invest_prof_date -- 投资收益到账日
            ,rep_sale_fee_rate -- 销售手续费
            ,rep_in_dep_name -- 境内托管机构名称
            ,rep_in_dep_code -- 境内托管机构代码
            ,rep_out_dep_ctry -- 境外托管机构国别
            ,rep_out_dep_name -- 境外托管机构名称
            ,rep_tru_fee_rate -- 托管费率
            ,rep_risk_level -- 产品风险等级
            ,rep_term_right_flag -- 发型机构提前终止权标识
            ,rep_cus_redeem_flag -- 客户赎回权标识
            ,rep_credit_flag -- 产品增信标识
            ,rep_credit_type -- 产品增信机构类型
            ,rep_credit_mode -- 产品增信形式
            ,rep_remark -- 备注
            ,rep_declare_date -- 报告登记日
            ,rep_send_status -- 报送状态
            ,rep_status_date -- 数据日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,exc_fin_sector -- 是否金融同业专属
            ,is_short_term -- 是否设置最短持有期限
            ,short_term -- 最短持有期限(天)
            ,is_free_redem -- 最短持有期后是否自由赎回
            ,customer_type -- 客户类型-人行报送
            ,rep_issue_type -- 产品募集方式
            ,rep_yield -- 业绩比较基准%
            ,rep_invest_nature -- 产品投资性质
            ,rep_is_cash_manage -- 是否现金管理类
            ,rep_invest_fee_rate -- 投资管理费率%
            ,rep_fiduciary_duty -- 是否收益权转让产品
            ,rep_fprod_id -- 母产品代码
            ,buy_place -- 销售区域
            ,customer_type1 -- 客户一级类型
            ,customer_type2 -- 客户二级类型
            ,prd_spec_property -- 产品特殊属性
            ,base_info_sign -- 基本信息公开标识
            ,change_reason -- 变更原因
            ,rep_extension_flag -- 产品展期标识
            ,rep_is_in_liquidation -- 是否处于清算中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_prod_declare_op(
            rep_finprod_id -- 金融产品代码
            ,rep_finprod_name -- 金融产品名称
            ,rep_finprod_reg_id -- 产品登记编码
            ,rep_finprod_ins_id -- 行内标识码
            ,rep_finprod_brand -- 产品品牌
            ,rep_finprod_stage -- 产品期次
            ,rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
            ,rep_approver_id -- 产品审批人身份证号
            ,rep_approver_name -- 产品审批人姓名
            ,rep_designer_id -- 产品设计人身份证号
            ,rep_designer_name -- 产品设计人姓名
            ,rep_manager_id -- 投资经理身份证号
            ,rep_manager_name -- 投资经理姓名
            ,rep_liaison_name -- 业务联络人姓名
            ,rep_liaison_tel -- 业务联络人座机
            ,rep_liaison_mobile -- 业务联络人手机
            ,rep_liaison_email -- 业务联络人邮箱
            ,rep_profit_type -- 产品收益类型
            ,rep_term -- 产品期限
            ,rep_investor_type -- 投资者类型
            ,rep_invest_area -- 资金投向地区
            ,rep_invest_country -- 产品投资国家或地区
            ,rep_finan_ser_model -- 理财业务服务模式
            ,rep_operate_mode -- 产品运作模式
            ,rep_book_mode -- 会计核算方式
            ,rep_cmmode -- 产品资产配置方式
            ,rep_pmmode -- 产品管理模式
            ,rep_mname -- 实际管理人员名称
            ,rep_priced_mode -- 产品定价方式
            ,rep_inv_asset_type -- 投资资产类型
            ,rep_con_prd_traget -- 结构性产品挂钩标的
            ,rep_cont_mode -- 合作模式
            ,rep_coop_name -- 合作机构名称
            ,rep_inv_type_rat -- 投资资产种类及比例
            ,rep_is_yield -- 是否有预期收益率
            ,rep_high_yield -- 预计客户最高年收益率
            ,rep_low_yield -- 预计客户最低年收益率
            ,rep_is_yield_basis -- 是否有收益率测算依据
            ,rep_risk_type -- 投资者风险偏好
            ,rep_sale_area -- 产品销售区域
            ,rep_raise_ccy -- 募集币种
            ,rep_cash_prin_ccy -- 兑付本金币种
            ,rep_cash_prof_ccy -- 兑付收益币种
            ,rep_sale_amt_str -- 起点销售金额
            ,rep_raise_amt_plan -- 计划募集金额
            ,rep_raise_pstrdate -- 募集起始日期（从）
            ,rep_raise_penddate -- 募集起始日期（到）
            ,rep_invest_prin_date -- 投资本金到账日
            ,rep_invest_prof_date -- 投资收益到账日
            ,rep_sale_fee_rate -- 销售手续费
            ,rep_in_dep_name -- 境内托管机构名称
            ,rep_in_dep_code -- 境内托管机构代码
            ,rep_out_dep_ctry -- 境外托管机构国别
            ,rep_out_dep_name -- 境外托管机构名称
            ,rep_tru_fee_rate -- 托管费率
            ,rep_risk_level -- 产品风险等级
            ,rep_term_right_flag -- 发型机构提前终止权标识
            ,rep_cus_redeem_flag -- 客户赎回权标识
            ,rep_credit_flag -- 产品增信标识
            ,rep_credit_type -- 产品增信机构类型
            ,rep_credit_mode -- 产品增信形式
            ,rep_remark -- 备注
            ,rep_declare_date -- 报告登记日
            ,rep_send_status -- 报送状态
            ,rep_status_date -- 数据日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,exc_fin_sector -- 是否金融同业专属
            ,is_short_term -- 是否设置最短持有期限
            ,short_term -- 最短持有期限(天)
            ,is_free_redem -- 最短持有期后是否自由赎回
            ,customer_type -- 客户类型-人行报送
            ,rep_issue_type -- 产品募集方式
            ,rep_yield -- 业绩比较基准%
            ,rep_invest_nature -- 产品投资性质
            ,rep_is_cash_manage -- 是否现金管理类
            ,rep_invest_fee_rate -- 投资管理费率%
            ,rep_fiduciary_duty -- 是否收益权转让产品
            ,rep_fprod_id -- 母产品代码
            ,buy_place -- 销售区域
            ,customer_type1 -- 客户一级类型
            ,customer_type2 -- 客户二级类型
            ,prd_spec_property -- 产品特殊属性
            ,base_info_sign -- 基本信息公开标识
            ,change_reason -- 变更原因
            ,rep_extension_flag -- 产品展期标识
            ,rep_is_in_liquidation -- 是否处于清算中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rep_finprod_id -- 金融产品代码
    ,o.rep_finprod_name -- 金融产品名称
    ,o.rep_finprod_reg_id -- 产品登记编码
    ,o.rep_finprod_ins_id -- 行内标识码
    ,o.rep_finprod_brand -- 产品品牌
    ,o.rep_finprod_stage -- 产品期次
    ,o.rep_issue_party_id -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
    ,o.rep_approver_id -- 产品审批人身份证号
    ,o.rep_approver_name -- 产品审批人姓名
    ,o.rep_designer_id -- 产品设计人身份证号
    ,o.rep_designer_name -- 产品设计人姓名
    ,o.rep_manager_id -- 投资经理身份证号
    ,o.rep_manager_name -- 投资经理姓名
    ,o.rep_liaison_name -- 业务联络人姓名
    ,o.rep_liaison_tel -- 业务联络人座机
    ,o.rep_liaison_mobile -- 业务联络人手机
    ,o.rep_liaison_email -- 业务联络人邮箱
    ,o.rep_profit_type -- 产品收益类型
    ,o.rep_term -- 产品期限
    ,o.rep_investor_type -- 投资者类型
    ,o.rep_invest_area -- 资金投向地区
    ,o.rep_invest_country -- 产品投资国家或地区
    ,o.rep_finan_ser_model -- 理财业务服务模式
    ,o.rep_operate_mode -- 产品运作模式
    ,o.rep_book_mode -- 会计核算方式
    ,o.rep_cmmode -- 产品资产配置方式
    ,o.rep_pmmode -- 产品管理模式
    ,o.rep_mname -- 实际管理人员名称
    ,o.rep_priced_mode -- 产品定价方式
    ,o.rep_inv_asset_type -- 投资资产类型
    ,o.rep_con_prd_traget -- 结构性产品挂钩标的
    ,o.rep_cont_mode -- 合作模式
    ,o.rep_coop_name -- 合作机构名称
    ,o.rep_inv_type_rat -- 投资资产种类及比例
    ,o.rep_is_yield -- 是否有预期收益率
    ,o.rep_high_yield -- 预计客户最高年收益率
    ,o.rep_low_yield -- 预计客户最低年收益率
    ,o.rep_is_yield_basis -- 是否有收益率测算依据
    ,o.rep_risk_type -- 投资者风险偏好
    ,o.rep_sale_area -- 产品销售区域
    ,o.rep_raise_ccy -- 募集币种
    ,o.rep_cash_prin_ccy -- 兑付本金币种
    ,o.rep_cash_prof_ccy -- 兑付收益币种
    ,o.rep_sale_amt_str -- 起点销售金额
    ,o.rep_raise_amt_plan -- 计划募集金额
    ,o.rep_raise_pstrdate -- 募集起始日期（从）
    ,o.rep_raise_penddate -- 募集起始日期（到）
    ,o.rep_invest_prin_date -- 投资本金到账日
    ,o.rep_invest_prof_date -- 投资收益到账日
    ,o.rep_sale_fee_rate -- 销售手续费
    ,o.rep_in_dep_name -- 境内托管机构名称
    ,o.rep_in_dep_code -- 境内托管机构代码
    ,o.rep_out_dep_ctry -- 境外托管机构国别
    ,o.rep_out_dep_name -- 境外托管机构名称
    ,o.rep_tru_fee_rate -- 托管费率
    ,o.rep_risk_level -- 产品风险等级
    ,o.rep_term_right_flag -- 发型机构提前终止权标识
    ,o.rep_cus_redeem_flag -- 客户赎回权标识
    ,o.rep_credit_flag -- 产品增信标识
    ,o.rep_credit_type -- 产品增信机构类型
    ,o.rep_credit_mode -- 产品增信形式
    ,o.rep_remark -- 备注
    ,o.rep_declare_date -- 报告登记日
    ,o.rep_send_status -- 报送状态
    ,o.rep_status_date -- 数据日期
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.exc_fin_sector -- 是否金融同业专属
    ,o.is_short_term -- 是否设置最短持有期限
    ,o.short_term -- 最短持有期限(天)
    ,o.is_free_redem -- 最短持有期后是否自由赎回
    ,o.customer_type -- 客户类型-人行报送
    ,o.rep_issue_type -- 产品募集方式
    ,o.rep_yield -- 业绩比较基准%
    ,o.rep_invest_nature -- 产品投资性质
    ,o.rep_is_cash_manage -- 是否现金管理类
    ,o.rep_invest_fee_rate -- 投资管理费率%
    ,o.rep_fiduciary_duty -- 是否收益权转让产品
    ,o.rep_fprod_id -- 母产品代码
    ,o.buy_place -- 销售区域
    ,o.customer_type1 -- 客户一级类型
    ,o.customer_type2 -- 客户二级类型
    ,o.prd_spec_property -- 产品特殊属性
    ,o.base_info_sign -- 基本信息公开标识
    ,o.change_reason -- 变更原因
    ,o.rep_extension_flag -- 产品展期标识
    ,o.rep_is_in_liquidation -- 是否处于清算中
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_rep_prod_declare_bk o
    left join ${iol_schema}.fams_rep_prod_declare_op n
        on
            o.rep_finprod_id = n.rep_finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_rep_prod_declare_cl d
        on
            o.rep_finprod_id = d.rep_finprod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_rep_prod_declare;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_rep_prod_declare') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_rep_prod_declare drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_rep_prod_declare add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_rep_prod_declare exchange partition p_${batch_date} with table ${iol_schema}.fams_rep_prod_declare_cl;
alter table ${iol_schema}.fams_rep_prod_declare exchange partition p_20991231 with table ${iol_schema}.fams_rep_prod_declare_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_rep_prod_declare to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_prod_declare_op purge;
drop table ${iol_schema}.fams_rep_prod_declare_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_rep_prod_declare_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_rep_prod_declare',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
