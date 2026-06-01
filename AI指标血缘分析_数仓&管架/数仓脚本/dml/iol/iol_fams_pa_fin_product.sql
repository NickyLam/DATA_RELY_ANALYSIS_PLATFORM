/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_pa_fin_product
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
create table ${iol_schema}.fams_pa_fin_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_pa_fin_product;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_pa_fin_product_op purge;
drop table ${iol_schema}.fams_pa_fin_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_pa_fin_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_pa_fin_product where 0=1;

create table ${iol_schema}.fams_pa_fin_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_pa_fin_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_pa_fin_product_cl(
            finprod_id -- 金融产品代码
            ,deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
            ,asset_source -- 资产来源，行内、行外
            ,asset_provider -- 资产提供行，多选，逗号分隔
            ,cash_out_no -- cms出账编号
            ,asset_source_unit -- 资产来源条线
            ,load_bank -- 放款分行
            ,settle_days -- 清算时效（工作日）
            ,proj_invest_industry -- 项目投向行业
            ,proj_invest_industry2 -- 项目投向行业二级分类
            ,bank_trust_code -- 人行信托代码
            ,actual_credit_provid -- 实际授信主体
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,investment_attributes -- 
            ,prod_series -- 产品系列
            ,prod_class -- 产品分类
            ,prod_feature -- 产品特点
            ,exclusive_prod -- 专属产品
            ,prod_manager -- 产品经理
            ,sale_type -- 销售类型
            ,same_org -- 同业机构
            ,investment_cycle -- 投资周期 单位：天
            ,target_customer_1 -- 目标客户一级分类
            ,target_customer_2 -- 目标客户二级分类
            ,asset_credit_name -- 资产授信名称
            ,is_interest -- 股息是否累计
            ,legal_mdate -- 法定到期日
            ,is_outs -- 是否委外
            ,series_name -- 系列名称
            ,asset_class -- 资产分类
            ,actual_manager -- 实际管理人
            ,bank_invest_code -- 人行投向产品代码
            ,rep_plan_prop -- 资管计划属性
            ,int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
            ,data_source -- 数据来源
            ,trial_no -- 法审编号
            ,base_rule -- 业绩基准
            ,overallocation -- 超额分成方式
            ,vat_tax_rate -- 增值税税率
            ,adt_tax_rate -- 附加税税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_pa_fin_product_op(
            finprod_id -- 金融产品代码
            ,deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
            ,asset_source -- 资产来源，行内、行外
            ,asset_provider -- 资产提供行，多选，逗号分隔
            ,cash_out_no -- cms出账编号
            ,asset_source_unit -- 资产来源条线
            ,load_bank -- 放款分行
            ,settle_days -- 清算时效（工作日）
            ,proj_invest_industry -- 项目投向行业
            ,proj_invest_industry2 -- 项目投向行业二级分类
            ,bank_trust_code -- 人行信托代码
            ,actual_credit_provid -- 实际授信主体
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,investment_attributes -- 
            ,prod_series -- 产品系列
            ,prod_class -- 产品分类
            ,prod_feature -- 产品特点
            ,exclusive_prod -- 专属产品
            ,prod_manager -- 产品经理
            ,sale_type -- 销售类型
            ,same_org -- 同业机构
            ,investment_cycle -- 投资周期 单位：天
            ,target_customer_1 -- 目标客户一级分类
            ,target_customer_2 -- 目标客户二级分类
            ,asset_credit_name -- 资产授信名称
            ,is_interest -- 股息是否累计
            ,legal_mdate -- 法定到期日
            ,is_outs -- 是否委外
            ,series_name -- 系列名称
            ,asset_class -- 资产分类
            ,actual_manager -- 实际管理人
            ,bank_invest_code -- 人行投向产品代码
            ,rep_plan_prop -- 资管计划属性
            ,int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
            ,data_source -- 数据来源
            ,trial_no -- 法审编号
            ,base_rule -- 业绩基准
            ,overallocation -- 超额分成方式
            ,vat_tax_rate -- 增值税税率
            ,adt_tax_rate -- 附加税税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
    ,nvl(n.asset_source, o.asset_source) as asset_source -- 资产来源，行内、行外
    ,nvl(n.asset_provider, o.asset_provider) as asset_provider -- 资产提供行，多选，逗号分隔
    ,nvl(n.cash_out_no, o.cash_out_no) as cash_out_no -- cms出账编号
    ,nvl(n.asset_source_unit, o.asset_source_unit) as asset_source_unit -- 资产来源条线
    ,nvl(n.load_bank, o.load_bank) as load_bank -- 放款分行
    ,nvl(n.settle_days, o.settle_days) as settle_days -- 清算时效（工作日）
    ,nvl(n.proj_invest_industry, o.proj_invest_industry) as proj_invest_industry -- 项目投向行业
    ,nvl(n.proj_invest_industry2, o.proj_invest_industry2) as proj_invest_industry2 -- 项目投向行业二级分类
    ,nvl(n.bank_trust_code, o.bank_trust_code) as bank_trust_code -- 人行信托代码
    ,nvl(n.actual_credit_provid, o.actual_credit_provid) as actual_credit_provid -- 实际授信主体
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.investment_attributes, o.investment_attributes) as investment_attributes -- 
    ,nvl(n.prod_series, o.prod_series) as prod_series -- 产品系列
    ,nvl(n.prod_class, o.prod_class) as prod_class -- 产品分类
    ,nvl(n.prod_feature, o.prod_feature) as prod_feature -- 产品特点
    ,nvl(n.exclusive_prod, o.exclusive_prod) as exclusive_prod -- 专属产品
    ,nvl(n.prod_manager, o.prod_manager) as prod_manager -- 产品经理
    ,nvl(n.sale_type, o.sale_type) as sale_type -- 销售类型
    ,nvl(n.same_org, o.same_org) as same_org -- 同业机构
    ,nvl(n.investment_cycle, o.investment_cycle) as investment_cycle -- 投资周期 单位：天
    ,nvl(n.target_customer_1, o.target_customer_1) as target_customer_1 -- 目标客户一级分类
    ,nvl(n.target_customer_2, o.target_customer_2) as target_customer_2 -- 目标客户二级分类
    ,nvl(n.asset_credit_name, o.asset_credit_name) as asset_credit_name -- 资产授信名称
    ,nvl(n.is_interest, o.is_interest) as is_interest -- 股息是否累计
    ,nvl(n.legal_mdate, o.legal_mdate) as legal_mdate -- 法定到期日
    ,nvl(n.is_outs, o.is_outs) as is_outs -- 是否委外
    ,nvl(n.series_name, o.series_name) as series_name -- 系列名称
    ,nvl(n.asset_class, o.asset_class) as asset_class -- 资产分类
    ,nvl(n.actual_manager, o.actual_manager) as actual_manager -- 实际管理人
    ,nvl(n.bank_invest_code, o.bank_invest_code) as bank_invest_code -- 人行投向产品代码
    ,nvl(n.rep_plan_prop, o.rep_plan_prop) as rep_plan_prop -- 资管计划属性
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源
    ,nvl(n.trial_no, o.trial_no) as trial_no -- 法审编号
    ,nvl(n.base_rule, o.base_rule) as base_rule -- 业绩基准
    ,nvl(n.overallocation, o.overallocation) as overallocation -- 超额分成方式
    ,nvl(n.vat_tax_rate, o.vat_tax_rate) as vat_tax_rate -- 增值税税率
    ,nvl(n.adt_tax_rate, o.adt_tax_rate) as adt_tax_rate -- 附加税税率
    ,case when
            n.finprod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_pa_fin_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_pa_fin_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
where (
        o.finprod_id is null
    )
    or (
        n.finprod_id is null
    )
    or (
        o.deal_mode <> n.deal_mode
        or o.asset_source <> n.asset_source
        or o.asset_provider <> n.asset_provider
        or o.cash_out_no <> n.cash_out_no
        or o.asset_source_unit <> n.asset_source_unit
        or o.load_bank <> n.load_bank
        or o.settle_days <> n.settle_days
        or o.proj_invest_industry <> n.proj_invest_industry
        or o.proj_invest_industry2 <> n.proj_invest_industry2
        or o.bank_trust_code <> n.bank_trust_code
        or o.actual_credit_provid <> n.actual_credit_provid
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.investment_attributes <> n.investment_attributes
        or o.prod_series <> n.prod_series
        or o.prod_class <> n.prod_class
        or o.prod_feature <> n.prod_feature
        or o.exclusive_prod <> n.exclusive_prod
        or o.prod_manager <> n.prod_manager
        or o.sale_type <> n.sale_type
        or o.same_org <> n.same_org
        or o.investment_cycle <> n.investment_cycle
        or o.target_customer_1 <> n.target_customer_1
        or o.target_customer_2 <> n.target_customer_2
        or o.asset_credit_name <> n.asset_credit_name
        or o.is_interest <> n.is_interest
        or o.legal_mdate <> n.legal_mdate
        or o.is_outs <> n.is_outs
        or o.series_name <> n.series_name
        or o.asset_class <> n.asset_class
        or o.actual_manager <> n.actual_manager
        or o.bank_invest_code <> n.bank_invest_code
        or o.rep_plan_prop <> n.rep_plan_prop
        or o.int_type <> n.int_type
        or o.data_source <> n.data_source
        or o.trial_no <> n.trial_no
        or o.base_rule <> n.base_rule
        or o.overallocation <> n.overallocation
        or o.vat_tax_rate <> n.vat_tax_rate
        or o.adt_tax_rate <> n.adt_tax_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_pa_fin_product_cl(
            finprod_id -- 金融产品代码
            ,deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
            ,asset_source -- 资产来源，行内、行外
            ,asset_provider -- 资产提供行，多选，逗号分隔
            ,cash_out_no -- cms出账编号
            ,asset_source_unit -- 资产来源条线
            ,load_bank -- 放款分行
            ,settle_days -- 清算时效（工作日）
            ,proj_invest_industry -- 项目投向行业
            ,proj_invest_industry2 -- 项目投向行业二级分类
            ,bank_trust_code -- 人行信托代码
            ,actual_credit_provid -- 实际授信主体
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,investment_attributes -- 
            ,prod_series -- 产品系列
            ,prod_class -- 产品分类
            ,prod_feature -- 产品特点
            ,exclusive_prod -- 专属产品
            ,prod_manager -- 产品经理
            ,sale_type -- 销售类型
            ,same_org -- 同业机构
            ,investment_cycle -- 投资周期 单位：天
            ,target_customer_1 -- 目标客户一级分类
            ,target_customer_2 -- 目标客户二级分类
            ,asset_credit_name -- 资产授信名称
            ,is_interest -- 股息是否累计
            ,legal_mdate -- 法定到期日
            ,is_outs -- 是否委外
            ,series_name -- 系列名称
            ,asset_class -- 资产分类
            ,actual_manager -- 实际管理人
            ,bank_invest_code -- 人行投向产品代码
            ,rep_plan_prop -- 资管计划属性
            ,int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
            ,data_source -- 数据来源
            ,trial_no -- 法审编号
            ,base_rule -- 业绩基准
            ,overallocation -- 超额分成方式
            ,vat_tax_rate -- 增值税税率
            ,adt_tax_rate -- 附加税税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_pa_fin_product_op(
            finprod_id -- 金融产品代码
            ,deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
            ,asset_source -- 资产来源，行内、行外
            ,asset_provider -- 资产提供行，多选，逗号分隔
            ,cash_out_no -- cms出账编号
            ,asset_source_unit -- 资产来源条线
            ,load_bank -- 放款分行
            ,settle_days -- 清算时效（工作日）
            ,proj_invest_industry -- 项目投向行业
            ,proj_invest_industry2 -- 项目投向行业二级分类
            ,bank_trust_code -- 人行信托代码
            ,actual_credit_provid -- 实际授信主体
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,investment_attributes -- 
            ,prod_series -- 产品系列
            ,prod_class -- 产品分类
            ,prod_feature -- 产品特点
            ,exclusive_prod -- 专属产品
            ,prod_manager -- 产品经理
            ,sale_type -- 销售类型
            ,same_org -- 同业机构
            ,investment_cycle -- 投资周期 单位：天
            ,target_customer_1 -- 目标客户一级分类
            ,target_customer_2 -- 目标客户二级分类
            ,asset_credit_name -- 资产授信名称
            ,is_interest -- 股息是否累计
            ,legal_mdate -- 法定到期日
            ,is_outs -- 是否委外
            ,series_name -- 系列名称
            ,asset_class -- 资产分类
            ,actual_manager -- 实际管理人
            ,bank_invest_code -- 人行投向产品代码
            ,rep_plan_prop -- 资管计划属性
            ,int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
            ,data_source -- 数据来源
            ,trial_no -- 法审编号
            ,base_rule -- 业绩基准
            ,overallocation -- 超额分成方式
            ,vat_tax_rate -- 增值税税率
            ,adt_tax_rate -- 附加税税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.deal_mode -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
    ,o.asset_source -- 资产来源，行内、行外
    ,o.asset_provider -- 资产提供行，多选，逗号分隔
    ,o.cash_out_no -- cms出账编号
    ,o.asset_source_unit -- 资产来源条线
    ,o.load_bank -- 放款分行
    ,o.settle_days -- 清算时效（工作日）
    ,o.proj_invest_industry -- 项目投向行业
    ,o.proj_invest_industry2 -- 项目投向行业二级分类
    ,o.bank_trust_code -- 人行信托代码
    ,o.actual_credit_provid -- 实际授信主体
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.investment_attributes -- 
    ,o.prod_series -- 产品系列
    ,o.prod_class -- 产品分类
    ,o.prod_feature -- 产品特点
    ,o.exclusive_prod -- 专属产品
    ,o.prod_manager -- 产品经理
    ,o.sale_type -- 销售类型
    ,o.same_org -- 同业机构
    ,o.investment_cycle -- 投资周期 单位：天
    ,o.target_customer_1 -- 目标客户一级分类
    ,o.target_customer_2 -- 目标客户二级分类
    ,o.asset_credit_name -- 资产授信名称
    ,o.is_interest -- 股息是否累计
    ,o.legal_mdate -- 法定到期日
    ,o.is_outs -- 是否委外
    ,o.series_name -- 系列名称
    ,o.asset_class -- 资产分类
    ,o.actual_manager -- 实际管理人
    ,o.bank_invest_code -- 人行投向产品代码
    ,o.rep_plan_prop -- 资管计划属性
    ,o.int_type -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
    ,o.data_source -- 数据来源
    ,o.trial_no -- 法审编号
    ,o.base_rule -- 业绩基准
    ,o.overallocation -- 超额分成方式
    ,o.vat_tax_rate -- 增值税税率
    ,o.adt_tax_rate -- 附加税税率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_pa_fin_product_bk o
    left join ${iol_schema}.fams_pa_fin_product_op n
        on
            o.finprod_id = n.finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_pa_fin_product_cl d
        on
            o.finprod_id = d.finprod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_pa_fin_product;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_pa_fin_product exchange partition p_19000101 with table ${iol_schema}.fams_pa_fin_product_cl;
alter table ${iol_schema}.fams_pa_fin_product exchange partition p_20991231 with table ${iol_schema}.fams_pa_fin_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_pa_fin_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_pa_fin_product_op purge;
drop table ${iol_schema}.fams_pa_fin_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_pa_fin_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_pa_fin_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
