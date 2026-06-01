/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tir
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
create table ${iol_schema}.ibms_tir_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tir;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tir_op purge;
drop table ${iol_schema}.ibms_tir_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tir_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tir where 0=1;

create table ${iol_schema}.ibms_tir_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tir where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tir_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 国家
            ,q_type -- 报价方式
            ,r_daycount -- 计息基准
            ,r_name -- 名称
            ,r_term -- 期限
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,r_names_match -- 名字匹配
            ,chinesespell -- 中文简写
            ,settle_days -- 结算日偏移天数
            ,settle_bizday_conv -- 结算日偏移规则
            ,fixing_days -- 定盘日偏移天数
            ,fixing_bizday_conv -- 定盘日偏移规则
            ,quote_scale -- 报价精度
            ,imp_time -- 导入时间
            ,r_extsys_name -- 外部名称
            ,country -- 国家
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,acc_bizday_conv -- 计息调整规则
            ,endofmonth -- 月末规则，0：不是；1：是
            ,mm_index -- 是否货币市场基准，0：不是；1：是
            ,s_type -- 标准类型
            ,fixing_calendar -- 定盘日历
            ,financial_center_calendar -- 交易中心日历
            ,financial_center -- 交易中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tir_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 国家
            ,q_type -- 报价方式
            ,r_daycount -- 计息基准
            ,r_name -- 名称
            ,r_term -- 期限
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,r_names_match -- 名字匹配
            ,chinesespell -- 中文简写
            ,settle_days -- 结算日偏移天数
            ,settle_bizday_conv -- 结算日偏移规则
            ,fixing_days -- 定盘日偏移天数
            ,fixing_bizday_conv -- 定盘日偏移规则
            ,quote_scale -- 报价精度
            ,imp_time -- 导入时间
            ,r_extsys_name -- 外部名称
            ,country -- 国家
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,acc_bizday_conv -- 计息调整规则
            ,endofmonth -- 月末规则，0：不是；1：是
            ,mm_index -- 是否货币市场基准，0：不是；1：是
            ,s_type -- 标准类型
            ,fixing_calendar -- 定盘日历
            ,financial_center_calendar -- 交易中心日历
            ,financial_center -- 交易中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.currency, o.currency) as currency -- 国家
    ,nvl(n.q_type, o.q_type) as q_type -- 报价方式
    ,nvl(n.r_daycount, o.r_daycount) as r_daycount -- 计息基准
    ,nvl(n.r_name, o.r_name) as r_name -- 名称
    ,nvl(n.r_term, o.r_term) as r_term -- 期限
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入管道
    ,nvl(n.r_names_match, o.r_names_match) as r_names_match -- 名字匹配
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 中文简写
    ,nvl(n.settle_days, o.settle_days) as settle_days -- 结算日偏移天数
    ,nvl(n.settle_bizday_conv, o.settle_bizday_conv) as settle_bizday_conv -- 结算日偏移规则
    ,nvl(n.fixing_days, o.fixing_days) as fixing_days -- 定盘日偏移天数
    ,nvl(n.fixing_bizday_conv, o.fixing_bizday_conv) as fixing_bizday_conv -- 定盘日偏移规则
    ,nvl(n.quote_scale, o.quote_scale) as quote_scale -- 报价精度
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 导入时间
    ,nvl(n.r_extsys_name, o.r_extsys_name) as r_extsys_name -- 外部名称
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.acc_bizday_conv, o.acc_bizday_conv) as acc_bizday_conv -- 计息调整规则
    ,nvl(n.endofmonth, o.endofmonth) as endofmonth -- 月末规则，0：不是；1：是
    ,nvl(n.mm_index, o.mm_index) as mm_index -- 是否货币市场基准，0：不是；1：是
    ,nvl(n.s_type, o.s_type) as s_type -- 标准类型
    ,nvl(n.fixing_calendar, o.fixing_calendar) as fixing_calendar -- 定盘日历
    ,nvl(n.financial_center_calendar, o.financial_center_calendar) as financial_center_calendar -- 交易中心日历
    ,nvl(n.financial_center, o.financial_center) as financial_center -- 交易中心
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
from (select * from ${iol_schema}.ibms_tir_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tir where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.currency <> n.currency
        or o.q_type <> n.q_type
        or o.r_daycount <> n.r_daycount
        or o.r_name <> n.r_name
        or o.r_term <> n.r_term
        or o.imp_date <> n.imp_date
        or o.pipe_id <> n.pipe_id
        or o.r_names_match <> n.r_names_match
        or o.chinesespell <> n.chinesespell
        or o.settle_days <> n.settle_days
        or o.settle_bizday_conv <> n.settle_bizday_conv
        or o.fixing_days <> n.fixing_days
        or o.fixing_bizday_conv <> n.fixing_bizday_conv
        or o.quote_scale <> n.quote_scale
        or o.imp_time <> n.imp_time
        or o.r_extsys_name <> n.r_extsys_name
        or o.country <> n.country
        or o.p_class <> n.p_class
        or o.p_type <> n.p_type
        or o.acc_bizday_conv <> n.acc_bizday_conv
        or o.endofmonth <> n.endofmonth
        or o.mm_index <> n.mm_index
        or o.s_type <> n.s_type
        or o.fixing_calendar <> n.fixing_calendar
        or o.financial_center_calendar <> n.financial_center_calendar
        or o.financial_center <> n.financial_center
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tir_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 国家
            ,q_type -- 报价方式
            ,r_daycount -- 计息基准
            ,r_name -- 名称
            ,r_term -- 期限
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,r_names_match -- 名字匹配
            ,chinesespell -- 中文简写
            ,settle_days -- 结算日偏移天数
            ,settle_bizday_conv -- 结算日偏移规则
            ,fixing_days -- 定盘日偏移天数
            ,fixing_bizday_conv -- 定盘日偏移规则
            ,quote_scale -- 报价精度
            ,imp_time -- 导入时间
            ,r_extsys_name -- 外部名称
            ,country -- 国家
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,acc_bizday_conv -- 计息调整规则
            ,endofmonth -- 月末规则，0：不是；1：是
            ,mm_index -- 是否货币市场基准，0：不是；1：是
            ,s_type -- 标准类型
            ,fixing_calendar -- 定盘日历
            ,financial_center_calendar -- 交易中心日历
            ,financial_center -- 交易中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tir_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 国家
            ,q_type -- 报价方式
            ,r_daycount -- 计息基准
            ,r_name -- 名称
            ,r_term -- 期限
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,r_names_match -- 名字匹配
            ,chinesespell -- 中文简写
            ,settle_days -- 结算日偏移天数
            ,settle_bizday_conv -- 结算日偏移规则
            ,fixing_days -- 定盘日偏移天数
            ,fixing_bizday_conv -- 定盘日偏移规则
            ,quote_scale -- 报价精度
            ,imp_time -- 导入时间
            ,r_extsys_name -- 外部名称
            ,country -- 国家
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,acc_bizday_conv -- 计息调整规则
            ,endofmonth -- 月末规则，0：不是；1：是
            ,mm_index -- 是否货币市场基准，0：不是；1：是
            ,s_type -- 标准类型
            ,fixing_calendar -- 定盘日历
            ,financial_center_calendar -- 交易中心日历
            ,financial_center -- 交易中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.currency -- 国家
    ,o.q_type -- 报价方式
    ,o.r_daycount -- 计息基准
    ,o.r_name -- 名称
    ,o.r_term -- 期限
    ,o.imp_date -- 导入日期
    ,o.pipe_id -- 导入管道
    ,o.r_names_match -- 名字匹配
    ,o.chinesespell -- 中文简写
    ,o.settle_days -- 结算日偏移天数
    ,o.settle_bizday_conv -- 结算日偏移规则
    ,o.fixing_days -- 定盘日偏移天数
    ,o.fixing_bizday_conv -- 定盘日偏移规则
    ,o.quote_scale -- 报价精度
    ,o.imp_time -- 导入时间
    ,o.r_extsys_name -- 外部名称
    ,o.country -- 国家
    ,o.p_class -- 产品分类
    ,o.p_type -- 产品类型
    ,o.acc_bizday_conv -- 计息调整规则
    ,o.endofmonth -- 月末规则，0：不是；1：是
    ,o.mm_index -- 是否货币市场基准，0：不是；1：是
    ,o.s_type -- 标准类型
    ,o.fixing_calendar -- 定盘日历
    ,o.financial_center_calendar -- 交易中心日历
    ,o.financial_center -- 交易中心
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tir_bk o
    left join ${iol_schema}.ibms_tir_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tir_cl d
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
-- truncate table ${iol_schema}.ibms_tir;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tir exchange partition p_19000101 with table ${iol_schema}.ibms_tir_cl;
alter table ${iol_schema}.ibms_tir exchange partition p_20991231 with table ${iol_schema}.ibms_tir_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tir to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tir_op purge;
drop table ${iol_schema}.ibms_tir_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tir_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tir',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
