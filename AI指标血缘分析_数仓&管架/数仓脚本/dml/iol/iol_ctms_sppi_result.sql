/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_sppi_result
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
create table ${iol_schema}.ctms_sppi_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_sppi_result;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_sppi_result_op purge;
drop table ${iol_schema}.ctms_sppi_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_sppi_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_sppi_result where 0=1;

create table ${iol_schema}.ctms_sppi_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_sppi_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_sppi_result_cl(
            sppi_result_id -- 
            ,cus_num -- 机构代码
            ,aspclient_id -- 部门ID
            ,sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
            ,sppi_code -- 资产代码
            ,exam_type -- 0 输入 1导入
            ,write_down -- 减记条款
            ,equity_swap -- 转股权
            ,convertible -- 可调换
            ,abs_abn -- abs券或abn券
            ,abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
            ,abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
            ,abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
            ,abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
            ,abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
            ,extend_call_put -- 展期选择权，可赎回，可回售
            ,extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
            ,extend_option -- 展期选择权
            ,call_option -- 发行人可赎回权
            ,put_option -- 投资人可回售权
            ,rate_type -- 利率方式
            ,rate_type_judge -- 利率方式人工判断
            ,variable_rate -- 变动利率相关判断
            ,benchmark -- 基准利率
            ,benchmark_type -- 基准利率类别
            ,benchmark_judge -- 基准利率人工判断
            ,frequency_uniformity -- 利率调整周期与基准利率期限是否一致
            ,frequency_adj -- 利率调整周期
            ,benchmark_freq -- 基准利率期限
            ,frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
            ,currency_uniformity -- 本金跟利率是否有相同的货币基础
            ,currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
            ,rate_method -- 重置日计息基准日调整
            ,close_to_start -- 重置利率起息日与定息日是否相近
            ,close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
            ,close_day -- 不超过n个工作日
            ,rate_avg_range -- 平均利率取值天数是否在预设范围内
            ,rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
            ,rate_avg_day -- 平均利率取值不超过n个工作日
            ,first_result -- 初步试算结果
            ,final_result -- 最终测试结果
            ,note -- 
            ,modify_date -- 修改日期
            ,modify_user_id -- 修改人
            ,modify_user_name -- 修改人名
            ,perpetual -- 永续债
            ,perpetual_judge -- 永续债人工判断
            ,test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
            ,datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
            ,perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
            ,lastmodified -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_sppi_result_op(
            sppi_result_id -- 
            ,cus_num -- 机构代码
            ,aspclient_id -- 部门ID
            ,sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
            ,sppi_code -- 资产代码
            ,exam_type -- 0 输入 1导入
            ,write_down -- 减记条款
            ,equity_swap -- 转股权
            ,convertible -- 可调换
            ,abs_abn -- abs券或abn券
            ,abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
            ,abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
            ,abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
            ,abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
            ,abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
            ,extend_call_put -- 展期选择权，可赎回，可回售
            ,extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
            ,extend_option -- 展期选择权
            ,call_option -- 发行人可赎回权
            ,put_option -- 投资人可回售权
            ,rate_type -- 利率方式
            ,rate_type_judge -- 利率方式人工判断
            ,variable_rate -- 变动利率相关判断
            ,benchmark -- 基准利率
            ,benchmark_type -- 基准利率类别
            ,benchmark_judge -- 基准利率人工判断
            ,frequency_uniformity -- 利率调整周期与基准利率期限是否一致
            ,frequency_adj -- 利率调整周期
            ,benchmark_freq -- 基准利率期限
            ,frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
            ,currency_uniformity -- 本金跟利率是否有相同的货币基础
            ,currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
            ,rate_method -- 重置日计息基准日调整
            ,close_to_start -- 重置利率起息日与定息日是否相近
            ,close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
            ,close_day -- 不超过n个工作日
            ,rate_avg_range -- 平均利率取值天数是否在预设范围内
            ,rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
            ,rate_avg_day -- 平均利率取值不超过n个工作日
            ,first_result -- 初步试算结果
            ,final_result -- 最终测试结果
            ,note -- 
            ,modify_date -- 修改日期
            ,modify_user_id -- 修改人
            ,modify_user_name -- 修改人名
            ,perpetual -- 永续债
            ,perpetual_judge -- 永续债人工判断
            ,test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
            ,datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
            ,perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
            ,lastmodified -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sppi_result_id, o.sppi_result_id) as sppi_result_id -- 
    ,nvl(n.cus_num, o.cus_num) as cus_num -- 机构代码
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.sppi_type, o.sppi_type) as sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
    ,nvl(n.sppi_code, o.sppi_code) as sppi_code -- 资产代码
    ,nvl(n.exam_type, o.exam_type) as exam_type -- 0 输入 1导入
    ,nvl(n.write_down, o.write_down) as write_down -- 减记条款
    ,nvl(n.equity_swap, o.equity_swap) as equity_swap -- 转股权
    ,nvl(n.convertible, o.convertible) as convertible -- 可调换
    ,nvl(n.abs_abn, o.abs_abn) as abs_abn -- abs券或abn券
    ,nvl(n.abs_abn_judge, o.abs_abn_judge) as abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
    ,nvl(n.abs_abn_a, o.abs_abn_a) as abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
    ,nvl(n.abs_abn_b, o.abs_abn_b) as abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
    ,nvl(n.abs_abn_c, o.abs_abn_c) as abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
    ,nvl(n.abs_abn_d, o.abs_abn_d) as abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
    ,nvl(n.extend_call_put, o.extend_call_put) as extend_call_put -- 展期选择权，可赎回，可回售
    ,nvl(n.extend_call_put_judge, o.extend_call_put_judge) as extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
    ,nvl(n.extend_option, o.extend_option) as extend_option -- 展期选择权
    ,nvl(n.call_option, o.call_option) as call_option -- 发行人可赎回权
    ,nvl(n.put_option, o.put_option) as put_option -- 投资人可回售权
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率方式
    ,nvl(n.rate_type_judge, o.rate_type_judge) as rate_type_judge -- 利率方式人工判断
    ,nvl(n.variable_rate, o.variable_rate) as variable_rate -- 变动利率相关判断
    ,nvl(n.benchmark, o.benchmark) as benchmark -- 基准利率
    ,nvl(n.benchmark_type, o.benchmark_type) as benchmark_type -- 基准利率类别
    ,nvl(n.benchmark_judge, o.benchmark_judge) as benchmark_judge -- 基准利率人工判断
    ,nvl(n.frequency_uniformity, o.frequency_uniformity) as frequency_uniformity -- 利率调整周期与基准利率期限是否一致
    ,nvl(n.frequency_adj, o.frequency_adj) as frequency_adj -- 利率调整周期
    ,nvl(n.benchmark_freq, o.benchmark_freq) as benchmark_freq -- 基准利率期限
    ,nvl(n.frequency_uniformity_judge, o.frequency_uniformity_judge) as frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
    ,nvl(n.currency_uniformity, o.currency_uniformity) as currency_uniformity -- 本金跟利率是否有相同的货币基础
    ,nvl(n.currency_uniformity_judge, o.currency_uniformity_judge) as currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
    ,nvl(n.rate_method, o.rate_method) as rate_method -- 重置日计息基准日调整
    ,nvl(n.close_to_start, o.close_to_start) as close_to_start -- 重置利率起息日与定息日是否相近
    ,nvl(n.close_to_start_judge, o.close_to_start_judge) as close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
    ,nvl(n.close_day, o.close_day) as close_day -- 不超过n个工作日
    ,nvl(n.rate_avg_range, o.rate_avg_range) as rate_avg_range -- 平均利率取值天数是否在预设范围内
    ,nvl(n.rate_avg_rage_judge, o.rate_avg_rage_judge) as rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
    ,nvl(n.rate_avg_day, o.rate_avg_day) as rate_avg_day -- 平均利率取值不超过n个工作日
    ,nvl(n.first_result, o.first_result) as first_result -- 初步试算结果
    ,nvl(n.final_result, o.final_result) as final_result -- 最终测试结果
    ,nvl(n.note, o.note) as note -- 
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改日期
    ,nvl(n.modify_user_id, o.modify_user_id) as modify_user_id -- 修改人
    ,nvl(n.modify_user_name, o.modify_user_name) as modify_user_name -- 修改人名
    ,nvl(n.perpetual, o.perpetual) as perpetual -- 永续债
    ,nvl(n.perpetual_judge, o.perpetual_judge) as perpetual_judge -- 永续债人工判断
    ,nvl(n.test_date, o.test_date) as test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
    ,nvl(n.datasymbolconfig_id, o.datasymbolconfig_id) as datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
    ,nvl(n.perpetual_method, o.perpetual_method) as perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 
    ,case when
            n.sppi_result_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sppi_result_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sppi_result_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_sppi_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_sppi_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sppi_result_id = n.sppi_result_id
where (
        o.sppi_result_id is null
    )
    or (
        n.sppi_result_id is null
    )
    or (
        o.cus_num <> n.cus_num
        or o.aspclient_id <> n.aspclient_id
        or o.sppi_type <> n.sppi_type
        or o.sppi_code <> n.sppi_code
        or o.exam_type <> n.exam_type
        or o.write_down <> n.write_down
        or o.equity_swap <> n.equity_swap
        or o.convertible <> n.convertible
        or o.abs_abn <> n.abs_abn
        or o.abs_abn_judge <> n.abs_abn_judge
        or o.abs_abn_a <> n.abs_abn_a
        or o.abs_abn_b <> n.abs_abn_b
        or o.abs_abn_c <> n.abs_abn_c
        or o.abs_abn_d <> n.abs_abn_d
        or o.extend_call_put <> n.extend_call_put
        or o.extend_call_put_judge <> n.extend_call_put_judge
        or o.extend_option <> n.extend_option
        or o.call_option <> n.call_option
        or o.put_option <> n.put_option
        or o.rate_type <> n.rate_type
        or o.rate_type_judge <> n.rate_type_judge
        or o.variable_rate <> n.variable_rate
        or o.benchmark <> n.benchmark
        or o.benchmark_type <> n.benchmark_type
        or o.benchmark_judge <> n.benchmark_judge
        or o.frequency_uniformity <> n.frequency_uniformity
        or o.frequency_adj <> n.frequency_adj
        or o.benchmark_freq <> n.benchmark_freq
        or o.frequency_uniformity_judge <> n.frequency_uniformity_judge
        or o.currency_uniformity <> n.currency_uniformity
        or o.currency_uniformity_judge <> n.currency_uniformity_judge
        or o.rate_method <> n.rate_method
        or o.close_to_start <> n.close_to_start
        or o.close_to_start_judge <> n.close_to_start_judge
        or o.close_day <> n.close_day
        or o.rate_avg_range <> n.rate_avg_range
        or o.rate_avg_rage_judge <> n.rate_avg_rage_judge
        or o.rate_avg_day <> n.rate_avg_day
        or o.first_result <> n.first_result
        or o.final_result <> n.final_result
        or o.note <> n.note
        or o.modify_date <> n.modify_date
        or o.modify_user_id <> n.modify_user_id
        or o.modify_user_name <> n.modify_user_name
        or o.perpetual <> n.perpetual
        or o.perpetual_judge <> n.perpetual_judge
        or o.test_date <> n.test_date
        or o.datasymbolconfig_id <> n.datasymbolconfig_id
        or o.perpetual_method <> n.perpetual_method
        or o.lastmodified <> n.lastmodified
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_sppi_result_cl(
            sppi_result_id -- 
            ,cus_num -- 机构代码
            ,aspclient_id -- 部门ID
            ,sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
            ,sppi_code -- 资产代码
            ,exam_type -- 0 输入 1导入
            ,write_down -- 减记条款
            ,equity_swap -- 转股权
            ,convertible -- 可调换
            ,abs_abn -- abs券或abn券
            ,abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
            ,abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
            ,abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
            ,abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
            ,abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
            ,extend_call_put -- 展期选择权，可赎回，可回售
            ,extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
            ,extend_option -- 展期选择权
            ,call_option -- 发行人可赎回权
            ,put_option -- 投资人可回售权
            ,rate_type -- 利率方式
            ,rate_type_judge -- 利率方式人工判断
            ,variable_rate -- 变动利率相关判断
            ,benchmark -- 基准利率
            ,benchmark_type -- 基准利率类别
            ,benchmark_judge -- 基准利率人工判断
            ,frequency_uniformity -- 利率调整周期与基准利率期限是否一致
            ,frequency_adj -- 利率调整周期
            ,benchmark_freq -- 基准利率期限
            ,frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
            ,currency_uniformity -- 本金跟利率是否有相同的货币基础
            ,currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
            ,rate_method -- 重置日计息基准日调整
            ,close_to_start -- 重置利率起息日与定息日是否相近
            ,close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
            ,close_day -- 不超过n个工作日
            ,rate_avg_range -- 平均利率取值天数是否在预设范围内
            ,rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
            ,rate_avg_day -- 平均利率取值不超过n个工作日
            ,first_result -- 初步试算结果
            ,final_result -- 最终测试结果
            ,note -- 
            ,modify_date -- 修改日期
            ,modify_user_id -- 修改人
            ,modify_user_name -- 修改人名
            ,perpetual -- 永续债
            ,perpetual_judge -- 永续债人工判断
            ,test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
            ,datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
            ,perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
            ,lastmodified -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_sppi_result_op(
            sppi_result_id -- 
            ,cus_num -- 机构代码
            ,aspclient_id -- 部门ID
            ,sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
            ,sppi_code -- 资产代码
            ,exam_type -- 0 输入 1导入
            ,write_down -- 减记条款
            ,equity_swap -- 转股权
            ,convertible -- 可调换
            ,abs_abn -- abs券或abn券
            ,abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
            ,abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
            ,abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
            ,abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
            ,abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
            ,extend_call_put -- 展期选择权，可赎回，可回售
            ,extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
            ,extend_option -- 展期选择权
            ,call_option -- 发行人可赎回权
            ,put_option -- 投资人可回售权
            ,rate_type -- 利率方式
            ,rate_type_judge -- 利率方式人工判断
            ,variable_rate -- 变动利率相关判断
            ,benchmark -- 基准利率
            ,benchmark_type -- 基准利率类别
            ,benchmark_judge -- 基准利率人工判断
            ,frequency_uniformity -- 利率调整周期与基准利率期限是否一致
            ,frequency_adj -- 利率调整周期
            ,benchmark_freq -- 基准利率期限
            ,frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
            ,currency_uniformity -- 本金跟利率是否有相同的货币基础
            ,currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
            ,rate_method -- 重置日计息基准日调整
            ,close_to_start -- 重置利率起息日与定息日是否相近
            ,close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
            ,close_day -- 不超过n个工作日
            ,rate_avg_range -- 平均利率取值天数是否在预设范围内
            ,rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
            ,rate_avg_day -- 平均利率取值不超过n个工作日
            ,first_result -- 初步试算结果
            ,final_result -- 最终测试结果
            ,note -- 
            ,modify_date -- 修改日期
            ,modify_user_id -- 修改人
            ,modify_user_name -- 修改人名
            ,perpetual -- 永续债
            ,perpetual_judge -- 永续债人工判断
            ,test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
            ,datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
            ,perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
            ,lastmodified -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sppi_result_id -- 
    ,o.cus_num -- 机构代码
    ,o.aspclient_id -- 部门ID
    ,o.sppi_type -- 资产类别 0 表示公共券 9 自定义券 7资产
    ,o.sppi_code -- 资产代码
    ,o.exam_type -- 0 输入 1导入
    ,o.write_down -- 减记条款
    ,o.equity_swap -- 转股权
    ,o.convertible -- 可调换
    ,o.abs_abn -- abs券或abn券
    ,o.abs_abn_judge -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
    ,o.abs_abn_a -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
    ,o.abs_abn_b -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
    ,o.abs_abn_c -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
    ,o.abs_abn_d -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
    ,o.extend_call_put -- 展期选择权，可赎回，可回售
    ,o.extend_call_put_judge -- 展期选择权，可赎回，可回售人工判断
    ,o.extend_option -- 展期选择权
    ,o.call_option -- 发行人可赎回权
    ,o.put_option -- 投资人可回售权
    ,o.rate_type -- 利率方式
    ,o.rate_type_judge -- 利率方式人工判断
    ,o.variable_rate -- 变动利率相关判断
    ,o.benchmark -- 基准利率
    ,o.benchmark_type -- 基准利率类别
    ,o.benchmark_judge -- 基准利率人工判断
    ,o.frequency_uniformity -- 利率调整周期与基准利率期限是否一致
    ,o.frequency_adj -- 利率调整周期
    ,o.benchmark_freq -- 基准利率期限
    ,o.frequency_uniformity_judge -- 利率调整周期与基准利率期限是否一致人工判断
    ,o.currency_uniformity -- 本金跟利率是否有相同的货币基础
    ,o.currency_uniformity_judge -- 本金跟利率是否有相同的货币基础人工判断
    ,o.rate_method -- 重置日计息基准日调整
    ,o.close_to_start -- 重置利率起息日与定息日是否相近
    ,o.close_to_start_judge -- 重置利率起息日与定息日是否相近人工判断
    ,o.close_day -- 不超过n个工作日
    ,o.rate_avg_range -- 平均利率取值天数是否在预设范围内
    ,o.rate_avg_rage_judge -- 平均利率取值天数是否在预设范围内人工判断
    ,o.rate_avg_day -- 平均利率取值不超过n个工作日
    ,o.first_result -- 初步试算结果
    ,o.final_result -- 最终测试结果
    ,o.note -- 
    ,o.modify_date -- 修改日期
    ,o.modify_user_id -- 修改人
    ,o.modify_user_name -- 修改人名
    ,o.perpetual -- 永续债
    ,o.perpetual_judge -- 永续债人工判断
    ,o.test_date -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
    ,o.datasymbolconfig_id -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
    ,o.perpetual_method -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
    ,o.lastmodified -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_sppi_result_bk o
    left join ${iol_schema}.ctms_sppi_result_op n
        on
            o.sppi_result_id = n.sppi_result_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_sppi_result_cl d
        on
            o.sppi_result_id = d.sppi_result_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_sppi_result;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_sppi_result exchange partition p_19000101 with table ${iol_schema}.ctms_sppi_result_cl;
alter table ${iol_schema}.ctms_sppi_result exchange partition p_20991231 with table ${iol_schema}.ctms_sppi_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_sppi_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_sppi_result_op purge;
drop table ${iol_schema}.ctms_sppi_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_sppi_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_sppi_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
