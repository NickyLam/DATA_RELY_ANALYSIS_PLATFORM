/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_batch_flow
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
create table ${iol_schema}.osbs_tps_batch_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_batch_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_batch_flow_op purge;
drop table ${iol_schema}.osbs_tps_batch_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_batch_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_batch_flow where 0=1;

create table ${iol_schema}.osbs_tps_batch_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_batch_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_batch_flow_cl(
            tbf_batchno -- 批次号
            ,tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
            ,tbf_ecifno -- 客户号
            ,tbf_userno -- 用户号
            ,tbf_deptid -- 部门ID
            ,tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
            ,tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
            ,tbf_totalcount -- 总笔数
            ,tbf_totalamount -- 总金额
            ,tbf_successcount -- 成功次数
            ,tbf_successamount -- 成功金额
            ,tbf_failcount -- 失败次数
            ,tbf_failamount -- 失败金额
            ,tbf_transdate -- 交易日期
            ,tbf_transtime -- 交易时间戳
            ,tbf_schedulestarttime -- 定时开始时间
            ,tbf_scheduleendtime -- 定时结束时间
            ,tbf_transcode -- 交易码
            ,tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
            ,tbf_filename -- 文件名
            ,tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
            ,tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
            ,tbf_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_batch_flow_op(
            tbf_batchno -- 批次号
            ,tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
            ,tbf_ecifno -- 客户号
            ,tbf_userno -- 用户号
            ,tbf_deptid -- 部门ID
            ,tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
            ,tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
            ,tbf_totalcount -- 总笔数
            ,tbf_totalamount -- 总金额
            ,tbf_successcount -- 成功次数
            ,tbf_successamount -- 成功金额
            ,tbf_failcount -- 失败次数
            ,tbf_failamount -- 失败金额
            ,tbf_transdate -- 交易日期
            ,tbf_transtime -- 交易时间戳
            ,tbf_schedulestarttime -- 定时开始时间
            ,tbf_scheduleendtime -- 定时结束时间
            ,tbf_transcode -- 交易码
            ,tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
            ,tbf_filename -- 文件名
            ,tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
            ,tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
            ,tbf_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tbf_batchno, o.tbf_batchno) as tbf_batchno -- 批次号
    ,nvl(n.tbf_flowno, o.tbf_flowno) as tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
    ,nvl(n.tbf_ecifno, o.tbf_ecifno) as tbf_ecifno -- 客户号
    ,nvl(n.tbf_userno, o.tbf_userno) as tbf_userno -- 用户号
    ,nvl(n.tbf_deptid, o.tbf_deptid) as tbf_deptid -- 部门ID
    ,nvl(n.tbf_transauthtype, o.tbf_transauthtype) as tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
    ,nvl(n.tbf_authtype, o.tbf_authtype) as tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
    ,nvl(n.tbf_totalcount, o.tbf_totalcount) as tbf_totalcount -- 总笔数
    ,nvl(n.tbf_totalamount, o.tbf_totalamount) as tbf_totalamount -- 总金额
    ,nvl(n.tbf_successcount, o.tbf_successcount) as tbf_successcount -- 成功次数
    ,nvl(n.tbf_successamount, o.tbf_successamount) as tbf_successamount -- 成功金额
    ,nvl(n.tbf_failcount, o.tbf_failcount) as tbf_failcount -- 失败次数
    ,nvl(n.tbf_failamount, o.tbf_failamount) as tbf_failamount -- 失败金额
    ,nvl(n.tbf_transdate, o.tbf_transdate) as tbf_transdate -- 交易日期
    ,nvl(n.tbf_transtime, o.tbf_transtime) as tbf_transtime -- 交易时间戳
    ,nvl(n.tbf_schedulestarttime, o.tbf_schedulestarttime) as tbf_schedulestarttime -- 定时开始时间
    ,nvl(n.tbf_scheduleendtime, o.tbf_scheduleendtime) as tbf_scheduleendtime -- 定时结束时间
    ,nvl(n.tbf_transcode, o.tbf_transcode) as tbf_transcode -- 交易码
    ,nvl(n.tbf_batchstate, o.tbf_batchstate) as tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,nvl(n.tbf_batchtype, o.tbf_batchtype) as tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
    ,nvl(n.tbf_filename, o.tbf_filename) as tbf_filename -- 文件名
    ,nvl(n.tbf_isnextday, o.tbf_isnextday) as tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
    ,nvl(n.tbf_transfertype, o.tbf_transfertype) as tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
    ,nvl(n.tbf_transferdate, o.tbf_transferdate) as tbf_transferdate -- 转出日期
    ,case when
            n.tbf_batchno is null
            and n.tbf_flowno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tbf_batchno is null
            and n.tbf_flowno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tbf_batchno is null
            and n.tbf_flowno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_batch_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_batch_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tbf_batchno = n.tbf_batchno
            and o.tbf_flowno = n.tbf_flowno
where (
        o.tbf_batchno is null
        and o.tbf_flowno is null
    )
    or (
        n.tbf_batchno is null
        and n.tbf_flowno is null
    )
    or (
        o.tbf_ecifno <> n.tbf_ecifno
        or o.tbf_userno <> n.tbf_userno
        or o.tbf_deptid <> n.tbf_deptid
        or o.tbf_transauthtype <> n.tbf_transauthtype
        or o.tbf_authtype <> n.tbf_authtype
        or o.tbf_totalcount <> n.tbf_totalcount
        or o.tbf_totalamount <> n.tbf_totalamount
        or o.tbf_successcount <> n.tbf_successcount
        or o.tbf_successamount <> n.tbf_successamount
        or o.tbf_failcount <> n.tbf_failcount
        or o.tbf_failamount <> n.tbf_failamount
        or o.tbf_transdate <> n.tbf_transdate
        or o.tbf_transtime <> n.tbf_transtime
        or o.tbf_schedulestarttime <> n.tbf_schedulestarttime
        or o.tbf_scheduleendtime <> n.tbf_scheduleendtime
        or o.tbf_transcode <> n.tbf_transcode
        or o.tbf_batchstate <> n.tbf_batchstate
        or o.tbf_batchtype <> n.tbf_batchtype
        or o.tbf_filename <> n.tbf_filename
        or o.tbf_isnextday <> n.tbf_isnextday
        or o.tbf_transfertype <> n.tbf_transfertype
        or o.tbf_transferdate <> n.tbf_transferdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_batch_flow_cl(
            tbf_batchno -- 批次号
            ,tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
            ,tbf_ecifno -- 客户号
            ,tbf_userno -- 用户号
            ,tbf_deptid -- 部门ID
            ,tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
            ,tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
            ,tbf_totalcount -- 总笔数
            ,tbf_totalamount -- 总金额
            ,tbf_successcount -- 成功次数
            ,tbf_successamount -- 成功金额
            ,tbf_failcount -- 失败次数
            ,tbf_failamount -- 失败金额
            ,tbf_transdate -- 交易日期
            ,tbf_transtime -- 交易时间戳
            ,tbf_schedulestarttime -- 定时开始时间
            ,tbf_scheduleendtime -- 定时结束时间
            ,tbf_transcode -- 交易码
            ,tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
            ,tbf_filename -- 文件名
            ,tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
            ,tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
            ,tbf_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_batch_flow_op(
            tbf_batchno -- 批次号
            ,tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
            ,tbf_ecifno -- 客户号
            ,tbf_userno -- 用户号
            ,tbf_deptid -- 部门ID
            ,tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
            ,tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
            ,tbf_totalcount -- 总笔数
            ,tbf_totalamount -- 总金额
            ,tbf_successcount -- 成功次数
            ,tbf_successamount -- 成功金额
            ,tbf_failcount -- 失败次数
            ,tbf_failamount -- 失败金额
            ,tbf_transdate -- 交易日期
            ,tbf_transtime -- 交易时间戳
            ,tbf_schedulestarttime -- 定时开始时间
            ,tbf_scheduleendtime -- 定时结束时间
            ,tbf_transcode -- 交易码
            ,tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
            ,tbf_filename -- 文件名
            ,tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
            ,tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
            ,tbf_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tbf_batchno -- 批次号
    ,o.tbf_flowno -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
    ,o.tbf_ecifno -- 客户号
    ,o.tbf_userno -- 用户号
    ,o.tbf_deptid -- 部门ID
    ,o.tbf_transauthtype -- 安全工具类型(1-U盾,2-手机动态密码)
    ,o.tbf_authtype -- 授权类型(R:自助注册,G:安全认证方式)
    ,o.tbf_totalcount -- 总笔数
    ,o.tbf_totalamount -- 总金额
    ,o.tbf_successcount -- 成功次数
    ,o.tbf_successamount -- 成功金额
    ,o.tbf_failcount -- 失败次数
    ,o.tbf_failamount -- 失败金额
    ,o.tbf_transdate -- 交易日期
    ,o.tbf_transtime -- 交易时间戳
    ,o.tbf_schedulestarttime -- 定时开始时间
    ,o.tbf_scheduleendtime -- 定时结束时间
    ,o.tbf_transcode -- 交易码
    ,o.tbf_batchstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,o.tbf_batchtype -- 批量类型(I-手工录入,F-文件导入)
    ,o.tbf_filename -- 文件名
    ,o.tbf_isnextday -- 是否下一日期(N/空-否,Y-是)
    ,o.tbf_transfertype -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
    ,o.tbf_transferdate -- 转出日期
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
from ${iol_schema}.osbs_tps_batch_flow_bk o
    left join ${iol_schema}.osbs_tps_batch_flow_op n
        on
            o.tbf_batchno = n.tbf_batchno
            and o.tbf_flowno = n.tbf_flowno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_batch_flow_cl d
        on
            o.tbf_batchno = d.tbf_batchno
            and o.tbf_flowno = d.tbf_flowno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_tps_batch_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_tps_batch_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_tps_batch_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_tps_batch_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_tps_batch_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_tps_batch_flow_cl;
alter table ${iol_schema}.osbs_tps_batch_flow exchange partition p_20991231 with table ${iol_schema}.osbs_tps_batch_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_batch_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_batch_flow_op purge;
drop table ${iol_schema}.osbs_tps_batch_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_batch_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_batch_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
