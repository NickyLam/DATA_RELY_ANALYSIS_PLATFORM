/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_product
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
create table ${iol_schema}.fams_fin_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_product;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_op purge;
drop table ${iol_schema}.fams_fin_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product where 0=1;

create table ${iol_schema}.fams_fin_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_cl(
            finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算）
            ,finprod_type2 -- 金融产品类型（投管分类）
            ,finprod_abbr -- 金融产品简称
            ,finprod_name -- 金融产品全称
            ,profit_type -- 收益类型
            ,coupon_species -- 息票品种
            ,chl_finprod_id -- 通道代码
            ,finprod_market_id -- 市场代码
            ,issue_id -- 发行认购代码
            ,issue_price -- 发行价
            ,issue_amt -- 发行规模
            ,ccy -- 币种
            ,bln_area -- 境内外
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,issue_type -- 发行方式/募集方式
            ,operation_type -- 运作模式
            ,entrust_type -- 委托方式
            ,entruster -- 委托方
            ,trustee_id -- 托管人
            ,issuer -- 发行人
            ,manager -- 管理人
            ,financier -- 融资人
            ,idate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term_days -- 期限天数
            ,actmdate -- 实际到期日
            ,liquidation_date -- 清盘日
            ,is_chl -- 是否通道
            ,is_sus -- 是否永续
            ,sustainable_remark -- 永续条款
            ,is_right -- 是否含权
            ,capi_income_feature -- 本金收益特征
            ,p_finprod_id -- 母金融产品代码
            ,o_finprod_id -- 原金融产品代码
            ,regist_org -- 登记托管机构
            ,exe_date -- 含权债摊销日
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,contract_no -- 合同编号
            ,is_fin_org -- 是否金融机构发行
            ,sponsor -- 担保人
            ,invest_adviser -- 投资顾问
            ,liquidation_yesno -- 是否轧差清算
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_op(
            finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算）
            ,finprod_type2 -- 金融产品类型（投管分类）
            ,finprod_abbr -- 金融产品简称
            ,finprod_name -- 金融产品全称
            ,profit_type -- 收益类型
            ,coupon_species -- 息票品种
            ,chl_finprod_id -- 通道代码
            ,finprod_market_id -- 市场代码
            ,issue_id -- 发行认购代码
            ,issue_price -- 发行价
            ,issue_amt -- 发行规模
            ,ccy -- 币种
            ,bln_area -- 境内外
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,issue_type -- 发行方式/募集方式
            ,operation_type -- 运作模式
            ,entrust_type -- 委托方式
            ,entruster -- 委托方
            ,trustee_id -- 托管人
            ,issuer -- 发行人
            ,manager -- 管理人
            ,financier -- 融资人
            ,idate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term_days -- 期限天数
            ,actmdate -- 实际到期日
            ,liquidation_date -- 清盘日
            ,is_chl -- 是否通道
            ,is_sus -- 是否永续
            ,sustainable_remark -- 永续条款
            ,is_right -- 是否含权
            ,capi_income_feature -- 本金收益特征
            ,p_finprod_id -- 母金融产品代码
            ,o_finprod_id -- 原金融产品代码
            ,regist_org -- 登记托管机构
            ,exe_date -- 含权债摊销日
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,contract_no -- 合同编号
            ,is_fin_org -- 是否金融机构发行
            ,sponsor -- 担保人
            ,invest_adviser -- 投资顾问
            ,liquidation_yesno -- 是否轧差清算
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算）
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类）
    ,nvl(n.finprod_abbr, o.finprod_abbr) as finprod_abbr -- 金融产品简称
    ,nvl(n.finprod_name, o.finprod_name) as finprod_name -- 金融产品全称
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 收益类型
    ,nvl(n.coupon_species, o.coupon_species) as coupon_species -- 息票品种
    ,nvl(n.chl_finprod_id, o.chl_finprod_id) as chl_finprod_id -- 通道代码
    ,nvl(n.finprod_market_id, o.finprod_market_id) as finprod_market_id -- 市场代码
    ,nvl(n.issue_id, o.issue_id) as issue_id -- 发行认购代码
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 发行规模
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.bln_area, o.bln_area) as bln_area -- 境内外
    ,nvl(n.trade_market, o.trade_market) as trade_market -- 交易场所
    ,nvl(n.calendar_id, o.calendar_id) as calendar_id -- 交易日历
    ,nvl(n.issue_type, o.issue_type) as issue_type -- 发行方式/募集方式
    ,nvl(n.operation_type, o.operation_type) as operation_type -- 运作模式
    ,nvl(n.entrust_type, o.entrust_type) as entrust_type -- 委托方式
    ,nvl(n.entruster, o.entruster) as entruster -- 委托方
    ,nvl(n.trustee_id, o.trustee_id) as trustee_id -- 托管人
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人
    ,nvl(n.manager, o.manager) as manager -- 管理人
    ,nvl(n.financier, o.financier) as financier -- 融资人
    ,nvl(n.idate, o.idate) as idate -- 发行日
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.term_days, o.term_days) as term_days -- 期限天数
    ,nvl(n.actmdate, o.actmdate) as actmdate -- 实际到期日
    ,nvl(n.liquidation_date, o.liquidation_date) as liquidation_date -- 清盘日
    ,nvl(n.is_chl, o.is_chl) as is_chl -- 是否通道
    ,nvl(n.is_sus, o.is_sus) as is_sus -- 是否永续
    ,nvl(n.sustainable_remark, o.sustainable_remark) as sustainable_remark -- 永续条款
    ,nvl(n.is_right, o.is_right) as is_right -- 是否含权
    ,nvl(n.capi_income_feature, o.capi_income_feature) as capi_income_feature -- 本金收益特征
    ,nvl(n.p_finprod_id, o.p_finprod_id) as p_finprod_id -- 母金融产品代码
    ,nvl(n.o_finprod_id, o.o_finprod_id) as o_finprod_id -- 原金融产品代码
    ,nvl(n.regist_org, o.regist_org) as regist_org -- 登记托管机构
    ,nvl(n.exe_date, o.exe_date) as exe_date -- 含权债摊销日
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.is_fin_org, o.is_fin_org) as is_fin_org -- 是否金融机构发行
    ,nvl(n.sponsor, o.sponsor) as sponsor -- 担保人
    ,nvl(n.invest_adviser, o.invest_adviser) as invest_adviser -- 投资顾问
    ,nvl(n.liquidation_yesno, o.liquidation_yesno) as liquidation_yesno -- 是否轧差清算
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
from (select * from ${iol_schema}.fams_fin_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
where (
        o.finprod_id is null
    )
    or (
        n.finprod_id is null
    )
    or (
        o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.finprod_abbr <> n.finprod_abbr
        or o.finprod_name <> n.finprod_name
        or o.profit_type <> n.profit_type
        or o.coupon_species <> n.coupon_species
        or o.chl_finprod_id <> n.chl_finprod_id
        or o.finprod_market_id <> n.finprod_market_id
        or o.issue_id <> n.issue_id
        or o.issue_price <> n.issue_price
        or o.issue_amt <> n.issue_amt
        or o.ccy <> n.ccy
        or o.bln_area <> n.bln_area
        or o.trade_market <> n.trade_market
        or o.calendar_id <> n.calendar_id
        or o.issue_type <> n.issue_type
        or o.operation_type <> n.operation_type
        or o.entrust_type <> n.entrust_type
        or o.entruster <> n.entruster
        or o.trustee_id <> n.trustee_id
        or o.issuer <> n.issuer
        or o.manager <> n.manager
        or o.financier <> n.financier
        or o.idate <> n.idate
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.term_days <> n.term_days
        or o.actmdate <> n.actmdate
        or o.liquidation_date <> n.liquidation_date
        or o.is_chl <> n.is_chl
        or o.is_sus <> n.is_sus
        or o.sustainable_remark <> n.sustainable_remark
        or o.is_right <> n.is_right
        or o.capi_income_feature <> n.capi_income_feature
        or o.p_finprod_id <> n.p_finprod_id
        or o.o_finprod_id <> n.o_finprod_id
        or o.regist_org <> n.regist_org
        or o.exe_date <> n.exe_date
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.contract_no <> n.contract_no
        or o.is_fin_org <> n.is_fin_org
        or o.sponsor <> n.sponsor
        or o.invest_adviser <> n.invest_adviser
        or o.liquidation_yesno <> n.liquidation_yesno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_cl(
            finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算）
            ,finprod_type2 -- 金融产品类型（投管分类）
            ,finprod_abbr -- 金融产品简称
            ,finprod_name -- 金融产品全称
            ,profit_type -- 收益类型
            ,coupon_species -- 息票品种
            ,chl_finprod_id -- 通道代码
            ,finprod_market_id -- 市场代码
            ,issue_id -- 发行认购代码
            ,issue_price -- 发行价
            ,issue_amt -- 发行规模
            ,ccy -- 币种
            ,bln_area -- 境内外
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,issue_type -- 发行方式/募集方式
            ,operation_type -- 运作模式
            ,entrust_type -- 委托方式
            ,entruster -- 委托方
            ,trustee_id -- 托管人
            ,issuer -- 发行人
            ,manager -- 管理人
            ,financier -- 融资人
            ,idate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term_days -- 期限天数
            ,actmdate -- 实际到期日
            ,liquidation_date -- 清盘日
            ,is_chl -- 是否通道
            ,is_sus -- 是否永续
            ,sustainable_remark -- 永续条款
            ,is_right -- 是否含权
            ,capi_income_feature -- 本金收益特征
            ,p_finprod_id -- 母金融产品代码
            ,o_finprod_id -- 原金融产品代码
            ,regist_org -- 登记托管机构
            ,exe_date -- 含权债摊销日
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,contract_no -- 合同编号
            ,is_fin_org -- 是否金融机构发行
            ,sponsor -- 担保人
            ,invest_adviser -- 投资顾问
            ,liquidation_yesno -- 是否轧差清算
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_op(
            finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算）
            ,finprod_type2 -- 金融产品类型（投管分类）
            ,finprod_abbr -- 金融产品简称
            ,finprod_name -- 金融产品全称
            ,profit_type -- 收益类型
            ,coupon_species -- 息票品种
            ,chl_finprod_id -- 通道代码
            ,finprod_market_id -- 市场代码
            ,issue_id -- 发行认购代码
            ,issue_price -- 发行价
            ,issue_amt -- 发行规模
            ,ccy -- 币种
            ,bln_area -- 境内外
            ,trade_market -- 交易场所
            ,calendar_id -- 交易日历
            ,issue_type -- 发行方式/募集方式
            ,operation_type -- 运作模式
            ,entrust_type -- 委托方式
            ,entruster -- 委托方
            ,trustee_id -- 托管人
            ,issuer -- 发行人
            ,manager -- 管理人
            ,financier -- 融资人
            ,idate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,term_days -- 期限天数
            ,actmdate -- 实际到期日
            ,liquidation_date -- 清盘日
            ,is_chl -- 是否通道
            ,is_sus -- 是否永续
            ,sustainable_remark -- 永续条款
            ,is_right -- 是否含权
            ,capi_income_feature -- 本金收益特征
            ,p_finprod_id -- 母金融产品代码
            ,o_finprod_id -- 原金融产品代码
            ,regist_org -- 登记托管机构
            ,exe_date -- 含权债摊销日
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,contract_no -- 合同编号
            ,is_fin_org -- 是否金融机构发行
            ,sponsor -- 担保人
            ,invest_adviser -- 投资顾问
            ,liquidation_yesno -- 是否轧差清算
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.finprod_type -- 金融产品类型（估值核算）
    ,o.finprod_type2 -- 金融产品类型（投管分类）
    ,o.finprod_abbr -- 金融产品简称
    ,o.finprod_name -- 金融产品全称
    ,o.profit_type -- 收益类型
    ,o.coupon_species -- 息票品种
    ,o.chl_finprod_id -- 通道代码
    ,o.finprod_market_id -- 市场代码
    ,o.issue_id -- 发行认购代码
    ,o.issue_price -- 发行价
    ,o.issue_amt -- 发行规模
    ,o.ccy -- 币种
    ,o.bln_area -- 境内外
    ,o.trade_market -- 交易场所
    ,o.calendar_id -- 交易日历
    ,o.issue_type -- 发行方式/募集方式
    ,o.operation_type -- 运作模式
    ,o.entrust_type -- 委托方式
    ,o.entruster -- 委托方
    ,o.trustee_id -- 托管人
    ,o.issuer -- 发行人
    ,o.manager -- 管理人
    ,o.financier -- 融资人
    ,o.idate -- 发行日
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.term_days -- 期限天数
    ,o.actmdate -- 实际到期日
    ,o.liquidation_date -- 清盘日
    ,o.is_chl -- 是否通道
    ,o.is_sus -- 是否永续
    ,o.sustainable_remark -- 永续条款
    ,o.is_right -- 是否含权
    ,o.capi_income_feature -- 本金收益特征
    ,o.p_finprod_id -- 母金融产品代码
    ,o.o_finprod_id -- 原金融产品代码
    ,o.regist_org -- 登记托管机构
    ,o.exe_date -- 含权债摊销日
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.contract_no -- 合同编号
    ,o.is_fin_org -- 是否金融机构发行
    ,o.sponsor -- 担保人
    ,o.invest_adviser -- 投资顾问
    ,o.liquidation_yesno -- 是否轧差清算
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_product_bk o
    left join ${iol_schema}.fams_fin_product_op n
        on
            o.finprod_id = n.finprod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_product_cl d
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
-- truncate table ${iol_schema}.fams_fin_product;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_fin_product exchange partition p_19000101 with table ${iol_schema}.fams_fin_product_cl;
alter table ${iol_schema}.fams_fin_product exchange partition p_20991231 with table ${iol_schema}.fams_fin_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_op purge;
drop table ${iol_schema}.fams_fin_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
