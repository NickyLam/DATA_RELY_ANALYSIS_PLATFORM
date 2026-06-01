/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_trpt_tbnd_ext
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
create table ${iol_schema}.ibms_trpt_tbnd_ext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_trpt_tbnd_ext
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_trpt_tbnd_ext_op purge;
drop table ${iol_schema}.ibms_trpt_tbnd_ext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_trpt_tbnd_ext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_trpt_tbnd_ext where 0=1;

create table ${iol_schema}.ibms_trpt_tbnd_ext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_trpt_tbnd_ext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_trpt_tbnd_ext_cl(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,hx_is_green_finance -- 
            ,hx_first_option_type -- 
            ,hx_second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_trpt_tbnd_ext_op(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,hx_is_green_finance -- 
            ,hx_first_option_type -- 
            ,hx_second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 债券代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.p_class_ext, o.p_class_ext) as p_class_ext -- 产品分类
    ,nvl(n.hx_businessmiddle, o.hx_businessmiddle) as hx_businessmiddle -- 业务中类
    ,nvl(n.hx_businesssmall, o.hx_businesssmall) as hx_businesssmall -- 业务小类
    ,nvl(n.hx_investcategory, o.hx_investcategory) as hx_investcategory -- 投向行业门类
    ,nvl(n.hx_investbroheading, o.hx_investbroheading) as hx_investbroheading -- 投向行业大类
    ,nvl(n.hx_islocfinanc, o.hx_islocfinanc) as hx_islocfinanc -- 是否地方政府融资平台
    ,nvl(n.hx_isdistbus, o.hx_isdistbus) as hx_isdistbus -- 是否异地业务
    ,nvl(n.hx_isgover_fund, o.hx_isgover_fund) as hx_isgover_fund -- 是否政府投资基金
    ,nvl(n.hx_isvc_fund, o.hx_isvc_fund) as hx_isvc_fund -- 是否创业投资基金
    ,nvl(n.hx_incredit_type, o.hx_incredit_type) as hx_incredit_type -- 增信方式
    ,nvl(n.hx_cremainname, o.hx_cremainname) as hx_cremainname -- 增信主体名称
    ,nvl(n.hxabs_invest1_type, o.hxabs_invest1_type) as hxabs_invest1_type -- 投资分类1
    ,nvl(n.hxabs_invest2_type, o.hxabs_invest2_type) as hxabs_invest2_type -- 投资分类2
    ,nvl(n.hxabs_investamount, o.hxabs_investamount) as hxabs_investamount -- 原投资产总金额（万元）
    ,nvl(n.hxabs_investinfeamount, o.hxabs_investinfeamount) as hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
    ,nvl(n.hxabs_creditassecu, o.hxabs_creditassecu) as hxabs_creditassecu -- 信贷资产支持证券
    ,nvl(n.hxabs_csrcalloassecu, o.hxabs_csrcalloassecu) as hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
    ,nvl(n.hx_creditpartyid, o.hx_creditpartyid) as hx_creditpartyid -- 授信主体
    ,nvl(n.hx_basictrader, o.hx_basictrader) as hx_basictrader -- 基础资产客户
    ,nvl(n.hx_undatype, o.hx_undatype) as hx_undatype -- 底层资产类型
    ,nvl(n.hxabs_penetration_type, o.hxabs_penetration_type) as hxabs_penetration_type -- 穿透类型
    ,nvl(n.hxabs_isdebt_for_equity, o.hxabs_isdebt_for_equity) as hxabs_isdebt_for_equity -- 是否投向市场化债转股
    ,nvl(n.hxabs_isconsumer_financing, o.hxabs_isconsumer_financing) as hxabs_isconsumer_financing -- 是否为消费服务类融资
    ,nvl(n.hxabs_againabs, o.hxabs_againabs) as hxabs_againabs -- 是否再资产证券化(1:是,0否)
    ,nvl(n.hx_amount_level, o.hx_amount_level) as hx_amount_level -- 该档次总金额
    ,nvl(n.hx_blc, o.hx_blc) as hx_blc -- 产品当期总余额(亿)
    ,nvl(n.hx_blc_level, o.hx_blc_level) as hx_blc_level -- 持有档次当期余额(亿)
    ,nvl(n.hx_grade_date_bond, o.hx_grade_date_bond) as hx_grade_date_bond -- 评级日期(债项)
    ,nvl(n.hx_grade_date_inst, o.hx_grade_date_inst) as hx_grade_date_inst -- 评级日期(主体)
    ,nvl(n.hx_inst_grade, o.hx_inst_grade) as hx_inst_grade -- 主体评级
    ,nvl(n.hx_inst_grade_org, o.hx_inst_grade_org) as hx_inst_grade_org -- 主体评级机构
    ,nvl(n.hx_is_stc, o.hx_is_stc) as hx_is_stc -- 是否stc
    ,nvl(n.hx_priority_level, o.hx_priority_level) as hx_priority_level -- 优先档次，优先|非优先
    ,nvl(n.hx_estate_bond_type, o.hx_estate_bond_type) as hx_estate_bond_type -- 房地产债券类型
    ,nvl(n.hx_is_green_finance, o.hx_is_green_finance) as hx_is_green_finance -- 
    ,nvl(n.hx_first_option_type, o.hx_first_option_type) as hx_first_option_type -- 
    ,nvl(n.hx_second_option_type, o.hx_second_option_type) as hx_second_option_type -- 
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_trpt_tbnd_ext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_trpt_tbnd_ext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.p_class_ext <> n.p_class_ext
        or o.hx_businessmiddle <> n.hx_businessmiddle
        or o.hx_businesssmall <> n.hx_businesssmall
        or o.hx_investcategory <> n.hx_investcategory
        or o.hx_investbroheading <> n.hx_investbroheading
        or o.hx_islocfinanc <> n.hx_islocfinanc
        or o.hx_isdistbus <> n.hx_isdistbus
        or o.hx_isgover_fund <> n.hx_isgover_fund
        or o.hx_isvc_fund <> n.hx_isvc_fund
        or o.hx_incredit_type <> n.hx_incredit_type
        or o.hx_cremainname <> n.hx_cremainname
        or o.hxabs_invest1_type <> n.hxabs_invest1_type
        or o.hxabs_invest2_type <> n.hxabs_invest2_type
        or o.hxabs_investamount <> n.hxabs_investamount
        or o.hxabs_investinfeamount <> n.hxabs_investinfeamount
        or o.hxabs_creditassecu <> n.hxabs_creditassecu
        or o.hxabs_csrcalloassecu <> n.hxabs_csrcalloassecu
        or o.hx_creditpartyid <> n.hx_creditpartyid
        or o.hx_basictrader <> n.hx_basictrader
        or o.hx_undatype <> n.hx_undatype
        or o.hxabs_penetration_type <> n.hxabs_penetration_type
        or o.hxabs_isdebt_for_equity <> n.hxabs_isdebt_for_equity
        or o.hxabs_isconsumer_financing <> n.hxabs_isconsumer_financing
        or o.hxabs_againabs <> n.hxabs_againabs
        or o.hx_amount_level <> n.hx_amount_level
        or o.hx_blc <> n.hx_blc
        or o.hx_blc_level <> n.hx_blc_level
        or o.hx_grade_date_bond <> n.hx_grade_date_bond
        or o.hx_grade_date_inst <> n.hx_grade_date_inst
        or o.hx_inst_grade <> n.hx_inst_grade
        or o.hx_inst_grade_org <> n.hx_inst_grade_org
        or o.hx_is_stc <> n.hx_is_stc
        or o.hx_priority_level <> n.hx_priority_level
        or o.hx_estate_bond_type <> n.hx_estate_bond_type
        or o.hx_is_green_finance <> n.hx_is_green_finance
        or o.hx_first_option_type <> n.hx_first_option_type
        or o.hx_second_option_type <> n.hx_second_option_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_trpt_tbnd_ext_cl(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,hx_is_green_finance -- 
            ,hx_first_option_type -- 
            ,hx_second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_trpt_tbnd_ext_op(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,hx_is_green_finance -- 
            ,hx_first_option_type -- 
            ,hx_second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 债券代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.p_class_ext -- 产品分类
    ,o.hx_businessmiddle -- 业务中类
    ,o.hx_businesssmall -- 业务小类
    ,o.hx_investcategory -- 投向行业门类
    ,o.hx_investbroheading -- 投向行业大类
    ,o.hx_islocfinanc -- 是否地方政府融资平台
    ,o.hx_isdistbus -- 是否异地业务
    ,o.hx_isgover_fund -- 是否政府投资基金
    ,o.hx_isvc_fund -- 是否创业投资基金
    ,o.hx_incredit_type -- 增信方式
    ,o.hx_cremainname -- 增信主体名称
    ,o.hxabs_invest1_type -- 投资分类1
    ,o.hxabs_invest2_type -- 投资分类2
    ,o.hxabs_investamount -- 原投资产总金额（万元）
    ,o.hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
    ,o.hxabs_creditassecu -- 信贷资产支持证券
    ,o.hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
    ,o.hx_creditpartyid -- 授信主体
    ,o.hx_basictrader -- 基础资产客户
    ,o.hx_undatype -- 底层资产类型
    ,o.hxabs_penetration_type -- 穿透类型
    ,o.hxabs_isdebt_for_equity -- 是否投向市场化债转股
    ,o.hxabs_isconsumer_financing -- 是否为消费服务类融资
    ,o.hxabs_againabs -- 是否再资产证券化(1:是,0否)
    ,o.hx_amount_level -- 该档次总金额
    ,o.hx_blc -- 产品当期总余额(亿)
    ,o.hx_blc_level -- 持有档次当期余额(亿)
    ,o.hx_grade_date_bond -- 评级日期(债项)
    ,o.hx_grade_date_inst -- 评级日期(主体)
    ,o.hx_inst_grade -- 主体评级
    ,o.hx_inst_grade_org -- 主体评级机构
    ,o.hx_is_stc -- 是否stc
    ,o.hx_priority_level -- 优先档次，优先|非优先
    ,o.hx_estate_bond_type -- 房地产债券类型
    ,o.hx_is_green_finance -- 
    ,o.hx_first_option_type -- 
    ,o.hx_second_option_type -- 
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
from ${iol_schema}.ibms_trpt_tbnd_ext_bk o
    left join ${iol_schema}.ibms_trpt_tbnd_ext_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_trpt_tbnd_ext_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_trpt_tbnd_ext;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_trpt_tbnd_ext') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_trpt_tbnd_ext drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_trpt_tbnd_ext add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_trpt_tbnd_ext exchange partition p_${batch_date} with table ${iol_schema}.ibms_trpt_tbnd_ext_cl;
alter table ${iol_schema}.ibms_trpt_tbnd_ext exchange partition p_20991231 with table ${iol_schema}.ibms_trpt_tbnd_ext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_trpt_tbnd_ext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_trpt_tbnd_ext_op purge;
drop table ${iol_schema}.ibms_trpt_tbnd_ext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_trpt_tbnd_ext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_trpt_tbnd_ext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
