/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_contract_info_tb
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
create table ${iol_schema}.scps_bp_contract_info_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_contract_info_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_contract_info_tb_op purge;
drop table ${iol_schema}.scps_bp_contract_info_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_contract_info_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_contract_info_tb where 0=1;

create table ${iol_schema}.scps_bp_contract_info_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_contract_info_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_contract_info_tb_cl(
            id -- 主键id
            ,tx_branch_id -- 交易机构
            ,teller -- 柜员号
            ,tr_date -- 交易日期
            ,biz_code -- 交易码
            ,contract_tr_date -- 签约主机交易日期
            ,contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
            ,contract_tx_code -- 签约交易码
            ,chanel_flow_no -- 渠道流水号
            ,contractno -- 业务类型
            ,contract_flag -- 签约标志（0-成功，1-失败）
            ,contract_ret_code -- 签约返回值
            ,contract_ret_mess -- 签约信息
            ,check_flag -- 对账标志(1.邮寄2.面对面3.网银)
            ,task_id -- 任务号
            ,contract_msg -- 签约信息(用来重发)
            ,contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
            ,trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_contract_info_tb_op(
            id -- 主键id
            ,tx_branch_id -- 交易机构
            ,teller -- 柜员号
            ,tr_date -- 交易日期
            ,biz_code -- 交易码
            ,contract_tr_date -- 签约主机交易日期
            ,contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
            ,contract_tx_code -- 签约交易码
            ,chanel_flow_no -- 渠道流水号
            ,contractno -- 业务类型
            ,contract_flag -- 签约标志（0-成功，1-失败）
            ,contract_ret_code -- 签约返回值
            ,contract_ret_mess -- 签约信息
            ,check_flag -- 对账标志(1.邮寄2.面对面3.网银)
            ,task_id -- 任务号
            ,contract_msg -- 签约信息(用来重发)
            ,contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
            ,trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.tx_branch_id, o.tx_branch_id) as tx_branch_id -- 交易机构
    ,nvl(n.teller, o.teller) as teller -- 柜员号
    ,nvl(n.tr_date, o.tr_date) as tr_date -- 交易日期
    ,nvl(n.biz_code, o.biz_code) as biz_code -- 交易码
    ,nvl(n.contract_tr_date, o.contract_tr_date) as contract_tr_date -- 签约主机交易日期
    ,nvl(n.contract_flw_code, o.contract_flw_code) as contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
    ,nvl(n.contract_tx_code, o.contract_tx_code) as contract_tx_code -- 签约交易码
    ,nvl(n.chanel_flow_no, o.chanel_flow_no) as chanel_flow_no -- 渠道流水号
    ,nvl(n.contractno, o.contractno) as contractno -- 业务类型
    ,nvl(n.contract_flag, o.contract_flag) as contract_flag -- 签约标志（0-成功，1-失败）
    ,nvl(n.contract_ret_code, o.contract_ret_code) as contract_ret_code -- 签约返回值
    ,nvl(n.contract_ret_mess, o.contract_ret_mess) as contract_ret_mess -- 签约信息
    ,nvl(n.check_flag, o.check_flag) as check_flag -- 对账标志(1.邮寄2.面对面3.网银)
    ,nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.contract_msg, o.contract_msg) as contract_msg -- 签约信息(用来重发)
    ,nvl(n.contract_type, o.contract_type) as contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
    ,nvl(n.trans_status, o.trans_status) as trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_contract_info_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_contract_info_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.tx_branch_id <> n.tx_branch_id
        or o.teller <> n.teller
        or o.tr_date <> n.tr_date
        or o.biz_code <> n.biz_code
        or o.contract_tr_date <> n.contract_tr_date
        or o.contract_flw_code <> n.contract_flw_code
        or o.contract_tx_code <> n.contract_tx_code
        or o.chanel_flow_no <> n.chanel_flow_no
        or o.contractno <> n.contractno
        or o.contract_flag <> n.contract_flag
        or o.contract_ret_code <> n.contract_ret_code
        or o.contract_ret_mess <> n.contract_ret_mess
        or o.check_flag <> n.check_flag
        or o.task_id <> n.task_id
        or o.contract_msg <> n.contract_msg
        or o.contract_type <> n.contract_type
        or o.trans_status <> n.trans_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_contract_info_tb_cl(
            id -- 主键id
            ,tx_branch_id -- 交易机构
            ,teller -- 柜员号
            ,tr_date -- 交易日期
            ,biz_code -- 交易码
            ,contract_tr_date -- 签约主机交易日期
            ,contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
            ,contract_tx_code -- 签约交易码
            ,chanel_flow_no -- 渠道流水号
            ,contractno -- 业务类型
            ,contract_flag -- 签约标志（0-成功，1-失败）
            ,contract_ret_code -- 签约返回值
            ,contract_ret_mess -- 签约信息
            ,check_flag -- 对账标志(1.邮寄2.面对面3.网银)
            ,task_id -- 任务号
            ,contract_msg -- 签约信息(用来重发)
            ,contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
            ,trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_contract_info_tb_op(
            id -- 主键id
            ,tx_branch_id -- 交易机构
            ,teller -- 柜员号
            ,tr_date -- 交易日期
            ,biz_code -- 交易码
            ,contract_tr_date -- 签约主机交易日期
            ,contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
            ,contract_tx_code -- 签约交易码
            ,chanel_flow_no -- 渠道流水号
            ,contractno -- 业务类型
            ,contract_flag -- 签约标志（0-成功，1-失败）
            ,contract_ret_code -- 签约返回值
            ,contract_ret_mess -- 签约信息
            ,check_flag -- 对账标志(1.邮寄2.面对面3.网银)
            ,task_id -- 任务号
            ,contract_msg -- 签约信息(用来重发)
            ,contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
            ,trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.tx_branch_id -- 交易机构
    ,o.teller -- 柜员号
    ,o.tr_date -- 交易日期
    ,o.biz_code -- 交易码
    ,o.contract_tr_date -- 签约主机交易日期
    ,o.contract_flw_code -- 文件的签约平台流水号为表里的签约主机交易流水号
    ,o.contract_tx_code -- 签约交易码
    ,o.chanel_flow_no -- 渠道流水号
    ,o.contractno -- 业务类型
    ,o.contract_flag -- 签约标志（0-成功，1-失败）
    ,o.contract_ret_code -- 签约返回值
    ,o.contract_ret_mess -- 签约信息
    ,o.check_flag -- 对账标志(1.邮寄2.面对面3.网银)
    ,o.task_id -- 任务号
    ,o.contract_msg -- 签约信息(用来重发)
    ,o.contract_type -- 签约类型(个人：1000-个人网银、1001-短信通、1002-基金、1003-理财、1004-非柜面非同名限额签约、1005-个人扣款协议、1006-三方存管签约、1007-储蓄定投、1008-灵活盈、1009-云闪付；对公：2000-短信通、2001-非柜面非同名限额签约、2002-网银/手机银行、2003-银企对账)
    ,o.trans_status -- 处理状态(1-已重发成功 2-放弃 0-待重发)
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
from ${iol_schema}.scps_bp_contract_info_tb_bk o
    left join ${iol_schema}.scps_bp_contract_info_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_contract_info_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_contract_info_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_contract_info_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_contract_info_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_contract_info_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_contract_info_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_contract_info_tb_cl;
alter table ${iol_schema}.scps_bp_contract_info_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_contract_info_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_contract_info_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_contract_info_tb_op purge;
drop table ${iol_schema}.scps_bp_contract_info_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_contract_info_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_contract_info_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
