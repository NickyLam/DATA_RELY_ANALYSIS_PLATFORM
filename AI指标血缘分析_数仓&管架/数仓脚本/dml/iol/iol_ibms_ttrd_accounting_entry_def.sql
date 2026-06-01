/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_entry_def
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
create table ${iol_schema}.ibms_ttrd_accounting_entry_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_accounting_entry_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_entry_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_entry_def where 0=1;

create table ${iol_schema}.ibms_ttrd_accounting_entry_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_entry_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_entry_def_cl(
            as_id -- 序号
            ,acting_entry_name_1 -- 一级科目名称
            ,acting_entry_name_2 -- 二级科目名称
            ,acting_entry_name_3 -- 三级科目名称
            ,acting_code -- 核算码
            ,property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
            ,entry_direction -- 科目方向 1：借 2：贷 0：未知
            ,acting_entry_code_1 -- 一级科目
            ,acting_entry_code_2 -- 二级科目
            ,acting_entry_code_3 -- 三级科目
            ,entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
            ,entry_type -- 分录类型
            ,entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
            ,entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
            ,entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
            ,entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
            ,gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
            ,acting_entry_name_4 -- 四级科目名称
            ,acting_entry_name_5 -- 五级科目名称
            ,acting_entry_code_4 -- 四级科目
            ,acting_entry_code_5 -- 五级科目
            ,entry_type_6 -- 
            ,entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
            ,property_m -- 科目类型,数据标准落标,触发器添加
            ,entry_direction_m -- 科目方向,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_entry_def_op(
            as_id -- 序号
            ,acting_entry_name_1 -- 一级科目名称
            ,acting_entry_name_2 -- 二级科目名称
            ,acting_entry_name_3 -- 三级科目名称
            ,acting_code -- 核算码
            ,property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
            ,entry_direction -- 科目方向 1：借 2：贷 0：未知
            ,acting_entry_code_1 -- 一级科目
            ,acting_entry_code_2 -- 二级科目
            ,acting_entry_code_3 -- 三级科目
            ,entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
            ,entry_type -- 分录类型
            ,entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
            ,entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
            ,entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
            ,entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
            ,gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
            ,acting_entry_name_4 -- 四级科目名称
            ,acting_entry_name_5 -- 五级科目名称
            ,acting_entry_code_4 -- 四级科目
            ,acting_entry_code_5 -- 五级科目
            ,entry_type_6 -- 
            ,entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
            ,property_m -- 科目类型,数据标准落标,触发器添加
            ,entry_direction_m -- 科目方向,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.as_id, o.as_id) as as_id -- 序号
    ,nvl(n.acting_entry_name_1, o.acting_entry_name_1) as acting_entry_name_1 -- 一级科目名称
    ,nvl(n.acting_entry_name_2, o.acting_entry_name_2) as acting_entry_name_2 -- 二级科目名称
    ,nvl(n.acting_entry_name_3, o.acting_entry_name_3) as acting_entry_name_3 -- 三级科目名称
    ,nvl(n.acting_code, o.acting_code) as acting_code -- 核算码
    ,nvl(n.property, o.property) as property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
    ,nvl(n.entry_direction, o.entry_direction) as entry_direction -- 科目方向 1：借 2：贷 0：未知
    ,nvl(n.acting_entry_code_1, o.acting_entry_code_1) as acting_entry_code_1 -- 一级科目
    ,nvl(n.acting_entry_code_2, o.acting_entry_code_2) as acting_entry_code_2 -- 二级科目
    ,nvl(n.acting_entry_code_3, o.acting_entry_code_3) as acting_entry_code_3 -- 三级科目
    ,nvl(n.entry_type_3, o.entry_type_3) as entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
    ,nvl(n.entry_type, o.entry_type) as entry_type -- 分录类型
    ,nvl(n.entry_type_1, o.entry_type_1) as entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
    ,nvl(n.entry_type_2, o.entry_type_2) as entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
    ,nvl(n.entry_type_4, o.entry_type_4) as entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
    ,nvl(n.entry_type_5, o.entry_type_5) as entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
    ,nvl(n.gzb_type, o.gzb_type) as gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
    ,nvl(n.acting_entry_name_4, o.acting_entry_name_4) as acting_entry_name_4 -- 四级科目名称
    ,nvl(n.acting_entry_name_5, o.acting_entry_name_5) as acting_entry_name_5 -- 五级科目名称
    ,nvl(n.acting_entry_code_4, o.acting_entry_code_4) as acting_entry_code_4 -- 四级科目
    ,nvl(n.acting_entry_code_5, o.acting_entry_code_5) as acting_entry_code_5 -- 五级科目
    ,nvl(n.entry_type_6, o.entry_type_6) as entry_type_6 -- 
    ,nvl(n.entry_type_7, o.entry_type_7) as entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
    ,nvl(n.property_m, o.property_m) as property_m -- 科目类型,数据标准落标,触发器添加
    ,nvl(n.entry_direction_m, o.entry_direction_m) as entry_direction_m -- 科目方向,数据标准落标,触发器添加
    ,case when
            n.as_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.as_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.as_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_accounting_entry_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_accounting_entry_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.as_id = n.as_id
where (
        o.as_id is null
    )
    or (
        n.as_id is null
    )
    or (
        o.acting_entry_name_1 <> n.acting_entry_name_1
        or o.acting_entry_name_2 <> n.acting_entry_name_2
        or o.acting_entry_name_3 <> n.acting_entry_name_3
        or o.acting_code <> n.acting_code
        or o.property <> n.property
        or o.entry_direction <> n.entry_direction
        or o.acting_entry_code_1 <> n.acting_entry_code_1
        or o.acting_entry_code_2 <> n.acting_entry_code_2
        or o.acting_entry_code_3 <> n.acting_entry_code_3
        or o.entry_type_3 <> n.entry_type_3
        or o.entry_type <> n.entry_type
        or o.entry_type_1 <> n.entry_type_1
        or o.entry_type_2 <> n.entry_type_2
        or o.entry_type_4 <> n.entry_type_4
        or o.entry_type_5 <> n.entry_type_5
        or o.gzb_type <> n.gzb_type
        or o.acting_entry_name_4 <> n.acting_entry_name_4
        or o.acting_entry_name_5 <> n.acting_entry_name_5
        or o.acting_entry_code_4 <> n.acting_entry_code_4
        or o.acting_entry_code_5 <> n.acting_entry_code_5
        or o.entry_type_6 <> n.entry_type_6
        or o.entry_type_7 <> n.entry_type_7
        or o.property_m <> n.property_m
        or o.entry_direction_m <> n.entry_direction_m
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_entry_def_cl(
            as_id -- 序号
            ,acting_entry_name_1 -- 一级科目名称
            ,acting_entry_name_2 -- 二级科目名称
            ,acting_entry_name_3 -- 三级科目名称
            ,acting_code -- 核算码
            ,property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
            ,entry_direction -- 科目方向 1：借 2：贷 0：未知
            ,acting_entry_code_1 -- 一级科目
            ,acting_entry_code_2 -- 二级科目
            ,acting_entry_code_3 -- 三级科目
            ,entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
            ,entry_type -- 分录类型
            ,entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
            ,entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
            ,entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
            ,entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
            ,gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
            ,acting_entry_name_4 -- 四级科目名称
            ,acting_entry_name_5 -- 五级科目名称
            ,acting_entry_code_4 -- 四级科目
            ,acting_entry_code_5 -- 五级科目
            ,entry_type_6 -- 
            ,entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
            ,property_m -- 科目类型,数据标准落标,触发器添加
            ,entry_direction_m -- 科目方向,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_entry_def_op(
            as_id -- 序号
            ,acting_entry_name_1 -- 一级科目名称
            ,acting_entry_name_2 -- 二级科目名称
            ,acting_entry_name_3 -- 三级科目名称
            ,acting_code -- 核算码
            ,property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
            ,entry_direction -- 科目方向 1：借 2：贷 0：未知
            ,acting_entry_code_1 -- 一级科目
            ,acting_entry_code_2 -- 二级科目
            ,acting_entry_code_3 -- 三级科目
            ,entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
            ,entry_type -- 分录类型
            ,entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
            ,entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
            ,entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
            ,entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
            ,gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
            ,acting_entry_name_4 -- 四级科目名称
            ,acting_entry_name_5 -- 五级科目名称
            ,acting_entry_code_4 -- 四级科目
            ,acting_entry_code_5 -- 五级科目
            ,entry_type_6 -- 
            ,entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
            ,property_m -- 科目类型,数据标准落标,触发器添加
            ,entry_direction_m -- 科目方向,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.as_id -- 序号
    ,o.acting_entry_name_1 -- 一级科目名称
    ,o.acting_entry_name_2 -- 二级科目名称
    ,o.acting_entry_name_3 -- 三级科目名称
    ,o.acting_code -- 核算码
    ,o.property -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
    ,o.entry_direction -- 科目方向 1：借 2：贷 0：未知
    ,o.acting_entry_code_1 -- 一级科目
    ,o.acting_entry_code_2 -- 二级科目
    ,o.acting_entry_code_3 -- 三级科目
    ,o.entry_type_3 -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
    ,o.entry_type -- 分录类型
    ,o.entry_type_1 -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
    ,o.entry_type_2 -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
    ,o.entry_type_4 -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
    ,o.entry_type_5 -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
    ,o.gzb_type -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他
    ,o.acting_entry_name_4 -- 四级科目名称
    ,o.acting_entry_name_5 -- 五级科目名称
    ,o.acting_entry_code_4 -- 四级科目
    ,o.acting_entry_code_5 -- 五级科目
    ,o.entry_type_6 -- 
    ,o.entry_type_7 -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
    ,o.property_m -- 科目类型,数据标准落标,触发器添加
    ,o.entry_direction_m -- 科目方向,数据标准落标,触发器添加
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
from ${iol_schema}.ibms_ttrd_accounting_entry_def_bk o
    left join ${iol_schema}.ibms_ttrd_accounting_entry_def_op n
        on
            o.as_id = n.as_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_accounting_entry_def_cl d
        on
            o.as_id = d.as_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_accounting_entry_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_accounting_entry_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_accounting_entry_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_accounting_entry_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_accounting_entry_def exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_accounting_entry_def_cl;
alter table ${iol_schema}.ibms_ttrd_accounting_entry_def exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_accounting_entry_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_accounting_entry_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_accounting_entry_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
