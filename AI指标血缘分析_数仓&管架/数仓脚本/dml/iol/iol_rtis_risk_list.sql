/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_risk_list
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
create table ${iol_schema}.rtis_risk_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_risk_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_risk_list_op purge;
drop table ${iol_schema}.rtis_risk_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_risk_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_risk_list where 0=1;

create table ${iol_schema}.rtis_risk_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_risk_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_risk_list_cl(
            list_id -- 风险触发记录列表ID
            ,order_id -- 交易单号
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,trans_time -- 交易时间
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已处理)
            ,oper_user_name -- 操作者
            ,verifi_strategy -- 验证策略
            ,notify_strategy -- 通知策略
            ,score -- 分值
            ,risk_flag_times -- 确认有风险次数
            ,riskless_flag_times -- 确认无风险次数
            ,pay_user_id -- 付款账号
            ,rec_user_id -- 收款账户，没有则默认为商户号
            ,biz_code -- 业务类型(代码)
            ,pay_user_name -- 支付方用户姓名
            ,rec_user_name -- 商户名
            ,risk_type -- 风险类型
            ,rule_code -- 规则编码
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,oper_ip -- 操作用户
            ,oper_ip_addr -- 操作人
            ,gps_info -- GPS地址
            ,base_station_info -- 基站地址
            ,succ_control -- 成功管控
            ,finger_print -- 设备指纹
            ,oper_chnl -- 标记人员
            ,develop_dept -- 运营机构
            ,deal_dept -- 处理机构
            ,order_status -- 交易状态：0-成功，1-失败，2-可疑
            ,merchant_id -- 商户号
            ,id_card_number -- 身份证号
            ,mobile_number -- 手机号
            ,list_strategy -- 名单策略
            ,oper_city -- 操作用户
            ,merchant_name -- 商户名称
            ,cust_id -- 客户号
            ,warn_id -- 预警ID
            ,verify_code -- 验证策略编码
            ,rule_count -- 触发规则数量
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,trade_remarks -- 交易备注
            ,trade_purpose -- 交易用途
            ,rec_bank_name -- 对手账户行名称
            ,trade_channel -- 交易渠道信息
            ,trans_data -- 交易日期
            ,cust_type -- 客户类型
            ,aum_m_avg_bal -- AUM月均值
            ,model_type -- 模型类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_risk_list_op(
            list_id -- 风险触发记录列表ID
            ,order_id -- 交易单号
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,trans_time -- 交易时间
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已处理)
            ,oper_user_name -- 操作者
            ,verifi_strategy -- 验证策略
            ,notify_strategy -- 通知策略
            ,score -- 分值
            ,risk_flag_times -- 确认有风险次数
            ,riskless_flag_times -- 确认无风险次数
            ,pay_user_id -- 付款账号
            ,rec_user_id -- 收款账户，没有则默认为商户号
            ,biz_code -- 业务类型(代码)
            ,pay_user_name -- 支付方用户姓名
            ,rec_user_name -- 商户名
            ,risk_type -- 风险类型
            ,rule_code -- 规则编码
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,oper_ip -- 操作用户
            ,oper_ip_addr -- 操作人
            ,gps_info -- GPS地址
            ,base_station_info -- 基站地址
            ,succ_control -- 成功管控
            ,finger_print -- 设备指纹
            ,oper_chnl -- 标记人员
            ,develop_dept -- 运营机构
            ,deal_dept -- 处理机构
            ,order_status -- 交易状态：0-成功，1-失败，2-可疑
            ,merchant_id -- 商户号
            ,id_card_number -- 身份证号
            ,mobile_number -- 手机号
            ,list_strategy -- 名单策略
            ,oper_city -- 操作用户
            ,merchant_name -- 商户名称
            ,cust_id -- 客户号
            ,warn_id -- 预警ID
            ,verify_code -- 验证策略编码
            ,rule_count -- 触发规则数量
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,trade_remarks -- 交易备注
            ,trade_purpose -- 交易用途
            ,rec_bank_name -- 对手账户行名称
            ,trade_channel -- 交易渠道信息
            ,trans_data -- 交易日期
            ,cust_type -- 客户类型
            ,aum_m_avg_bal -- AUM月均值
            ,model_type -- 模型类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.list_id, o.list_id) as list_id -- 风险触发记录列表ID
    ,nvl(n.order_id, o.order_id) as order_id -- 交易单号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.trans_vol, o.trans_vol) as trans_vol -- 交易金额
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险级别
    ,nvl(n.list_status, o.list_status) as list_status -- 受理状态(0待处理、1处理中、2已处理)
    ,nvl(n.oper_user_name, o.oper_user_name) as oper_user_name -- 操作者
    ,nvl(n.verifi_strategy, o.verifi_strategy) as verifi_strategy -- 验证策略
    ,nvl(n.notify_strategy, o.notify_strategy) as notify_strategy -- 通知策略
    ,nvl(n.score, o.score) as score -- 分值
    ,nvl(n.risk_flag_times, o.risk_flag_times) as risk_flag_times -- 确认有风险次数
    ,nvl(n.riskless_flag_times, o.riskless_flag_times) as riskless_flag_times -- 确认无风险次数
    ,nvl(n.pay_user_id, o.pay_user_id) as pay_user_id -- 付款账号
    ,nvl(n.rec_user_id, o.rec_user_id) as rec_user_id -- 收款账户，没有则默认为商户号
    ,nvl(n.biz_code, o.biz_code) as biz_code -- 业务类型(代码)
    ,nvl(n.pay_user_name, o.pay_user_name) as pay_user_name -- 支付方用户姓名
    ,nvl(n.rec_user_name, o.rec_user_name) as rec_user_name -- 商户名
    ,nvl(n.risk_type, o.risk_type) as risk_type -- 风险类型
    ,nvl(n.rule_code, o.rule_code) as rule_code -- 规则编码
    ,nvl(n.risk_qualitative, o.risk_qualitative) as risk_qualitative -- 风险定性（1有风险，2无风险）
    ,nvl(n.oper_ip, o.oper_ip) as oper_ip -- 操作用户
    ,nvl(n.oper_ip_addr, o.oper_ip_addr) as oper_ip_addr -- 操作人
    ,nvl(n.gps_info, o.gps_info) as gps_info -- GPS地址
    ,nvl(n.base_station_info, o.base_station_info) as base_station_info -- 基站地址
    ,nvl(n.succ_control, o.succ_control) as succ_control -- 成功管控
    ,nvl(n.finger_print, o.finger_print) as finger_print -- 设备指纹
    ,nvl(n.oper_chnl, o.oper_chnl) as oper_chnl -- 标记人员
    ,nvl(n.develop_dept, o.develop_dept) as develop_dept -- 运营机构
    ,nvl(n.deal_dept, o.deal_dept) as deal_dept -- 处理机构
    ,nvl(n.order_status, o.order_status) as order_status -- 交易状态：0-成功，1-失败，2-可疑
    ,nvl(n.merchant_id, o.merchant_id) as merchant_id -- 商户号
    ,nvl(n.id_card_number, o.id_card_number) as id_card_number -- 身份证号
    ,nvl(n.mobile_number, o.mobile_number) as mobile_number -- 手机号
    ,nvl(n.list_strategy, o.list_strategy) as list_strategy -- 名单策略
    ,nvl(n.oper_city, o.oper_city) as oper_city -- 操作用户
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.warn_id, o.warn_id) as warn_id -- 预警ID
    ,nvl(n.verify_code, o.verify_code) as verify_code -- 验证策略编码
    ,nvl(n.rule_count, o.rule_count) as rule_count -- 触发规则数量
    ,nvl(n.account_organ, o.account_organ) as account_organ -- 账户归属机构
    ,nvl(n.account_organ_id, o.account_organ_id) as account_organ_id -- 账户归属机构ID
    ,nvl(n.trade_remarks, o.trade_remarks) as trade_remarks -- 交易备注
    ,nvl(n.trade_purpose, o.trade_purpose) as trade_purpose -- 交易用途
    ,nvl(n.rec_bank_name, o.rec_bank_name) as rec_bank_name -- 对手账户行名称
    ,nvl(n.trade_channel, o.trade_channel) as trade_channel -- 交易渠道信息
    ,nvl(n.trans_data, o.trans_data) as trans_data -- 交易日期
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型
    ,nvl(n.aum_m_avg_bal, o.aum_m_avg_bal) as aum_m_avg_bal -- AUM月均值
    ,nvl(n.model_type, o.model_type) as model_type -- 模型类型
    ,case when
            n.list_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.list_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.list_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rtis_risk_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_risk_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.list_id = n.list_id
where (
        o.list_id is null
    )
    or (
        n.list_id is null
    )
    or (
        o.order_id <> n.order_id
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.trans_time <> n.trans_time
        or o.trans_vol <> n.trans_vol
        or o.risk_level <> n.risk_level
        or o.list_status <> n.list_status
        or o.oper_user_name <> n.oper_user_name
        or o.verifi_strategy <> n.verifi_strategy
        or o.notify_strategy <> n.notify_strategy
        or o.score <> n.score
        or o.risk_flag_times <> n.risk_flag_times
        or o.riskless_flag_times <> n.riskless_flag_times
        or o.pay_user_id <> n.pay_user_id
        or o.rec_user_id <> n.rec_user_id
        or o.biz_code <> n.biz_code
        or o.pay_user_name <> n.pay_user_name
        or o.rec_user_name <> n.rec_user_name
        or o.risk_type <> n.risk_type
        or o.rule_code <> n.rule_code
        or o.risk_qualitative <> n.risk_qualitative
        or o.oper_ip <> n.oper_ip
        or o.oper_ip_addr <> n.oper_ip_addr
        or o.gps_info <> n.gps_info
        or o.base_station_info <> n.base_station_info
        or o.succ_control <> n.succ_control
        or o.finger_print <> n.finger_print
        or o.oper_chnl <> n.oper_chnl
        or o.develop_dept <> n.develop_dept
        or o.deal_dept <> n.deal_dept
        or o.order_status <> n.order_status
        or o.merchant_id <> n.merchant_id
        or o.id_card_number <> n.id_card_number
        or o.mobile_number <> n.mobile_number
        or o.list_strategy <> n.list_strategy
        or o.oper_city <> n.oper_city
        or o.merchant_name <> n.merchant_name
        or o.cust_id <> n.cust_id
        or o.warn_id <> n.warn_id
        or o.verify_code <> n.verify_code
        or o.rule_count <> n.rule_count
        or o.account_organ <> n.account_organ
        or o.account_organ_id <> n.account_organ_id
        or o.trade_remarks <> n.trade_remarks
        or o.trade_purpose <> n.trade_purpose
        or o.rec_bank_name <> n.rec_bank_name
        or o.trade_channel <> n.trade_channel
        or o.trans_data <> n.trans_data
        or o.cust_type <> n.cust_type
        or o.aum_m_avg_bal <> n.aum_m_avg_bal
        or o.model_type <> n.model_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_risk_list_cl(
            list_id -- 风险触发记录列表ID
            ,order_id -- 交易单号
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,trans_time -- 交易时间
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已处理)
            ,oper_user_name -- 操作者
            ,verifi_strategy -- 验证策略
            ,notify_strategy -- 通知策略
            ,score -- 分值
            ,risk_flag_times -- 确认有风险次数
            ,riskless_flag_times -- 确认无风险次数
            ,pay_user_id -- 付款账号
            ,rec_user_id -- 收款账户，没有则默认为商户号
            ,biz_code -- 业务类型(代码)
            ,pay_user_name -- 支付方用户姓名
            ,rec_user_name -- 商户名
            ,risk_type -- 风险类型
            ,rule_code -- 规则编码
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,oper_ip -- 操作用户
            ,oper_ip_addr -- 操作人
            ,gps_info -- GPS地址
            ,base_station_info -- 基站地址
            ,succ_control -- 成功管控
            ,finger_print -- 设备指纹
            ,oper_chnl -- 标记人员
            ,develop_dept -- 运营机构
            ,deal_dept -- 处理机构
            ,order_status -- 交易状态：0-成功，1-失败，2-可疑
            ,merchant_id -- 商户号
            ,id_card_number -- 身份证号
            ,mobile_number -- 手机号
            ,list_strategy -- 名单策略
            ,oper_city -- 操作用户
            ,merchant_name -- 商户名称
            ,cust_id -- 客户号
            ,warn_id -- 预警ID
            ,verify_code -- 验证策略编码
            ,rule_count -- 触发规则数量
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,trade_remarks -- 交易备注
            ,trade_purpose -- 交易用途
            ,rec_bank_name -- 对手账户行名称
            ,trade_channel -- 交易渠道信息
            ,trans_data -- 交易日期
            ,cust_type -- 客户类型
            ,aum_m_avg_bal -- AUM月均值
            ,model_type -- 模型类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_risk_list_op(
            list_id -- 风险触发记录列表ID
            ,order_id -- 交易单号
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,trans_time -- 交易时间
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已处理)
            ,oper_user_name -- 操作者
            ,verifi_strategy -- 验证策略
            ,notify_strategy -- 通知策略
            ,score -- 分值
            ,risk_flag_times -- 确认有风险次数
            ,riskless_flag_times -- 确认无风险次数
            ,pay_user_id -- 付款账号
            ,rec_user_id -- 收款账户，没有则默认为商户号
            ,biz_code -- 业务类型(代码)
            ,pay_user_name -- 支付方用户姓名
            ,rec_user_name -- 商户名
            ,risk_type -- 风险类型
            ,rule_code -- 规则编码
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,oper_ip -- 操作用户
            ,oper_ip_addr -- 操作人
            ,gps_info -- GPS地址
            ,base_station_info -- 基站地址
            ,succ_control -- 成功管控
            ,finger_print -- 设备指纹
            ,oper_chnl -- 标记人员
            ,develop_dept -- 运营机构
            ,deal_dept -- 处理机构
            ,order_status -- 交易状态：0-成功，1-失败，2-可疑
            ,merchant_id -- 商户号
            ,id_card_number -- 身份证号
            ,mobile_number -- 手机号
            ,list_strategy -- 名单策略
            ,oper_city -- 操作用户
            ,merchant_name -- 商户名称
            ,cust_id -- 客户号
            ,warn_id -- 预警ID
            ,verify_code -- 验证策略编码
            ,rule_count -- 触发规则数量
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,trade_remarks -- 交易备注
            ,trade_purpose -- 交易用途
            ,rec_bank_name -- 对手账户行名称
            ,trade_channel -- 交易渠道信息
            ,trans_data -- 交易日期
            ,cust_type -- 客户类型
            ,aum_m_avg_bal -- AUM月均值
            ,model_type -- 模型类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.list_id -- 风险触发记录列表ID
    ,o.order_id -- 交易单号
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.trans_time -- 交易时间
    ,o.trans_vol -- 交易金额
    ,o.risk_level -- 风险级别
    ,o.list_status -- 受理状态(0待处理、1处理中、2已处理)
    ,o.oper_user_name -- 操作者
    ,o.verifi_strategy -- 验证策略
    ,o.notify_strategy -- 通知策略
    ,o.score -- 分值
    ,o.risk_flag_times -- 确认有风险次数
    ,o.riskless_flag_times -- 确认无风险次数
    ,o.pay_user_id -- 付款账号
    ,o.rec_user_id -- 收款账户，没有则默认为商户号
    ,o.biz_code -- 业务类型(代码)
    ,o.pay_user_name -- 支付方用户姓名
    ,o.rec_user_name -- 商户名
    ,o.risk_type -- 风险类型
    ,o.rule_code -- 规则编码
    ,o.risk_qualitative -- 风险定性（1有风险，2无风险）
    ,o.oper_ip -- 操作用户
    ,o.oper_ip_addr -- 操作人
    ,o.gps_info -- GPS地址
    ,o.base_station_info -- 基站地址
    ,o.succ_control -- 成功管控
    ,o.finger_print -- 设备指纹
    ,o.oper_chnl -- 标记人员
    ,o.develop_dept -- 运营机构
    ,o.deal_dept -- 处理机构
    ,o.order_status -- 交易状态：0-成功，1-失败，2-可疑
    ,o.merchant_id -- 商户号
    ,o.id_card_number -- 身份证号
    ,o.mobile_number -- 手机号
    ,o.list_strategy -- 名单策略
    ,o.oper_city -- 操作用户
    ,o.merchant_name -- 商户名称
    ,o.cust_id -- 客户号
    ,o.warn_id -- 预警ID
    ,o.verify_code -- 验证策略编码
    ,o.rule_count -- 触发规则数量
    ,o.account_organ -- 账户归属机构
    ,o.account_organ_id -- 账户归属机构ID
    ,o.trade_remarks -- 交易备注
    ,o.trade_purpose -- 交易用途
    ,o.rec_bank_name -- 对手账户行名称
    ,o.trade_channel -- 交易渠道信息
    ,o.trans_data -- 交易日期
    ,o.cust_type -- 客户类型
    ,o.aum_m_avg_bal -- AUM月均值
    ,o.model_type -- 模型类型
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
from ${iol_schema}.rtis_risk_list_bk o
    left join ${iol_schema}.rtis_risk_list_op n
        on
            o.list_id = n.list_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_risk_list_cl d
        on
            o.list_id = d.list_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rtis_risk_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_risk_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_risk_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_risk_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_risk_list exchange partition p_${batch_date} with table ${iol_schema}.rtis_risk_list_cl;
alter table ${iol_schema}.rtis_risk_list exchange partition p_20991231 with table ${iol_schema}.rtis_risk_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_risk_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_risk_list_op purge;
drop table ${iol_schema}.rtis_risk_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_risk_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_risk_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
