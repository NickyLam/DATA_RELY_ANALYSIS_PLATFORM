/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_salary_batch_flow
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
create table ${iol_schema}.tbps_cpr_salary_batch_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_salary_batch_flow;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_salary_batch_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_salary_batch_flow where 0=1;

create table ${iol_schema}.tbps_cpr_salary_batch_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_salary_batch_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_salary_batch_flow_cl(
            sbf_batchno -- 批次号
            ,sbf_trade_flowno -- 流水号
            ,sbf_month -- 月份
            ,sbf_ecifno -- 全行统一客户号
            ,sbf_userno -- 用户顺序号
            ,sbf_username -- 用户名
            ,sbf_payeracno -- 付款人账号
            ,sbf_payeracname -- 付款人户名
            ,sbf_currency -- 币种
            ,sbf_totalcount -- 总笔数
            ,sbf_totalamount -- 总金额
            ,sbf_uploadfilename -- 上传文件名
            ,sbf_filename -- 文件名
            ,sbf_orderflag -- 是否预约：0：否；1：是
            ,sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
            ,sbf_sysflag -- 行内外标识：0：行内 1：行外
            ,sbf_transdate -- 交易日期/提交日期
            ,sbf_transtime -- 交易时间/提交时间
            ,sbf_processendtime -- 中台处理时间
            ,sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
            ,sbf_successcount -- 成功笔数
            ,sbf_successamount -- 成功金额
            ,sbf_failcount -- 失败笔数
            ,sbf_failamount -- 失败金额
            ,sbf_remark -- 附言
            ,sbf_batchstate -- 状态
            ,sbf_returncode -- 返回码
            ,sbf_returnmsg -- 返回信息
            ,sbf_hostremark -- 核心附言
            ,sbf_hostbatchno -- 核心批次号
            ,sbf_showflag -- 是否显示明细
            ,sbf_parentlogno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_salary_batch_flow_op(
            sbf_batchno -- 批次号
            ,sbf_trade_flowno -- 流水号
            ,sbf_month -- 月份
            ,sbf_ecifno -- 全行统一客户号
            ,sbf_userno -- 用户顺序号
            ,sbf_username -- 用户名
            ,sbf_payeracno -- 付款人账号
            ,sbf_payeracname -- 付款人户名
            ,sbf_currency -- 币种
            ,sbf_totalcount -- 总笔数
            ,sbf_totalamount -- 总金额
            ,sbf_uploadfilename -- 上传文件名
            ,sbf_filename -- 文件名
            ,sbf_orderflag -- 是否预约：0：否；1：是
            ,sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
            ,sbf_sysflag -- 行内外标识：0：行内 1：行外
            ,sbf_transdate -- 交易日期/提交日期
            ,sbf_transtime -- 交易时间/提交时间
            ,sbf_processendtime -- 中台处理时间
            ,sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
            ,sbf_successcount -- 成功笔数
            ,sbf_successamount -- 成功金额
            ,sbf_failcount -- 失败笔数
            ,sbf_failamount -- 失败金额
            ,sbf_remark -- 附言
            ,sbf_batchstate -- 状态
            ,sbf_returncode -- 返回码
            ,sbf_returnmsg -- 返回信息
            ,sbf_hostremark -- 核心附言
            ,sbf_hostbatchno -- 核心批次号
            ,sbf_showflag -- 是否显示明细
            ,sbf_parentlogno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sbf_batchno, o.sbf_batchno) as sbf_batchno -- 批次号
    ,nvl(n.sbf_trade_flowno, o.sbf_trade_flowno) as sbf_trade_flowno -- 流水号
    ,nvl(n.sbf_month, o.sbf_month) as sbf_month -- 月份
    ,nvl(n.sbf_ecifno, o.sbf_ecifno) as sbf_ecifno -- 全行统一客户号
    ,nvl(n.sbf_userno, o.sbf_userno) as sbf_userno -- 用户顺序号
    ,nvl(n.sbf_username, o.sbf_username) as sbf_username -- 用户名
    ,nvl(n.sbf_payeracno, o.sbf_payeracno) as sbf_payeracno -- 付款人账号
    ,nvl(n.sbf_payeracname, o.sbf_payeracname) as sbf_payeracname -- 付款人户名
    ,nvl(n.sbf_currency, o.sbf_currency) as sbf_currency -- 币种
    ,nvl(n.sbf_totalcount, o.sbf_totalcount) as sbf_totalcount -- 总笔数
    ,nvl(n.sbf_totalamount, o.sbf_totalamount) as sbf_totalamount -- 总金额
    ,nvl(n.sbf_uploadfilename, o.sbf_uploadfilename) as sbf_uploadfilename -- 上传文件名
    ,nvl(n.sbf_filename, o.sbf_filename) as sbf_filename -- 文件名
    ,nvl(n.sbf_orderflag, o.sbf_orderflag) as sbf_orderflag -- 是否预约：0：否；1：是
    ,nvl(n.sbf_batchstyle, o.sbf_batchstyle) as sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
    ,nvl(n.sbf_sysflag, o.sbf_sysflag) as sbf_sysflag -- 行内外标识：0：行内 1：行外
    ,nvl(n.sbf_transdate, o.sbf_transdate) as sbf_transdate -- 交易日期/提交日期
    ,nvl(n.sbf_transtime, o.sbf_transtime) as sbf_transtime -- 交易时间/提交时间
    ,nvl(n.sbf_processendtime, o.sbf_processendtime) as sbf_processendtime -- 中台处理时间
    ,nvl(n.sbf_timerrule, o.sbf_timerrule) as sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
    ,nvl(n.sbf_successcount, o.sbf_successcount) as sbf_successcount -- 成功笔数
    ,nvl(n.sbf_successamount, o.sbf_successamount) as sbf_successamount -- 成功金额
    ,nvl(n.sbf_failcount, o.sbf_failcount) as sbf_failcount -- 失败笔数
    ,nvl(n.sbf_failamount, o.sbf_failamount) as sbf_failamount -- 失败金额
    ,nvl(n.sbf_remark, o.sbf_remark) as sbf_remark -- 附言
    ,nvl(n.sbf_batchstate, o.sbf_batchstate) as sbf_batchstate -- 状态
    ,nvl(n.sbf_returncode, o.sbf_returncode) as sbf_returncode -- 返回码
    ,nvl(n.sbf_returnmsg, o.sbf_returnmsg) as sbf_returnmsg -- 返回信息
    ,nvl(n.sbf_hostremark, o.sbf_hostremark) as sbf_hostremark -- 核心附言
    ,nvl(n.sbf_hostbatchno, o.sbf_hostbatchno) as sbf_hostbatchno -- 核心批次号
    ,nvl(n.sbf_showflag, o.sbf_showflag) as sbf_showflag -- 是否显示明细
    ,nvl(n.sbf_parentlogno, o.sbf_parentlogno) as sbf_parentlogno -- 父流水号
    ,case when
            n.sbf_batchno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sbf_batchno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sbf_batchno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_salary_batch_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_salary_batch_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sbf_batchno = n.sbf_batchno
where (
        o.sbf_batchno is null
    )
    or (
        n.sbf_batchno is null
    )
    or (
        o.sbf_trade_flowno <> n.sbf_trade_flowno
        or o.sbf_month <> n.sbf_month
        or o.sbf_ecifno <> n.sbf_ecifno
        or o.sbf_userno <> n.sbf_userno
        or o.sbf_username <> n.sbf_username
        or o.sbf_payeracno <> n.sbf_payeracno
        or o.sbf_payeracname <> n.sbf_payeracname
        or o.sbf_currency <> n.sbf_currency
        or o.sbf_totalcount <> n.sbf_totalcount
        or o.sbf_totalamount <> n.sbf_totalamount
        or o.sbf_uploadfilename <> n.sbf_uploadfilename
        or o.sbf_filename <> n.sbf_filename
        or o.sbf_orderflag <> n.sbf_orderflag
        or o.sbf_batchstyle <> n.sbf_batchstyle
        or o.sbf_sysflag <> n.sbf_sysflag
        or o.sbf_transdate <> n.sbf_transdate
        or o.sbf_transtime <> n.sbf_transtime
        or o.sbf_processendtime <> n.sbf_processendtime
        or o.sbf_timerrule <> n.sbf_timerrule
        or o.sbf_successcount <> n.sbf_successcount
        or o.sbf_successamount <> n.sbf_successamount
        or o.sbf_failcount <> n.sbf_failcount
        or o.sbf_failamount <> n.sbf_failamount
        or o.sbf_remark <> n.sbf_remark
        or o.sbf_batchstate <> n.sbf_batchstate
        or o.sbf_returncode <> n.sbf_returncode
        or o.sbf_returnmsg <> n.sbf_returnmsg
        or o.sbf_hostremark <> n.sbf_hostremark
        or o.sbf_hostbatchno <> n.sbf_hostbatchno
        or o.sbf_showflag <> n.sbf_showflag
        or o.sbf_parentlogno <> n.sbf_parentlogno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_salary_batch_flow_cl(
            sbf_batchno -- 批次号
            ,sbf_trade_flowno -- 流水号
            ,sbf_month -- 月份
            ,sbf_ecifno -- 全行统一客户号
            ,sbf_userno -- 用户顺序号
            ,sbf_username -- 用户名
            ,sbf_payeracno -- 付款人账号
            ,sbf_payeracname -- 付款人户名
            ,sbf_currency -- 币种
            ,sbf_totalcount -- 总笔数
            ,sbf_totalamount -- 总金额
            ,sbf_uploadfilename -- 上传文件名
            ,sbf_filename -- 文件名
            ,sbf_orderflag -- 是否预约：0：否；1：是
            ,sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
            ,sbf_sysflag -- 行内外标识：0：行内 1：行外
            ,sbf_transdate -- 交易日期/提交日期
            ,sbf_transtime -- 交易时间/提交时间
            ,sbf_processendtime -- 中台处理时间
            ,sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
            ,sbf_successcount -- 成功笔数
            ,sbf_successamount -- 成功金额
            ,sbf_failcount -- 失败笔数
            ,sbf_failamount -- 失败金额
            ,sbf_remark -- 附言
            ,sbf_batchstate -- 状态
            ,sbf_returncode -- 返回码
            ,sbf_returnmsg -- 返回信息
            ,sbf_hostremark -- 核心附言
            ,sbf_hostbatchno -- 核心批次号
            ,sbf_showflag -- 是否显示明细
            ,sbf_parentlogno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_salary_batch_flow_op(
            sbf_batchno -- 批次号
            ,sbf_trade_flowno -- 流水号
            ,sbf_month -- 月份
            ,sbf_ecifno -- 全行统一客户号
            ,sbf_userno -- 用户顺序号
            ,sbf_username -- 用户名
            ,sbf_payeracno -- 付款人账号
            ,sbf_payeracname -- 付款人户名
            ,sbf_currency -- 币种
            ,sbf_totalcount -- 总笔数
            ,sbf_totalamount -- 总金额
            ,sbf_uploadfilename -- 上传文件名
            ,sbf_filename -- 文件名
            ,sbf_orderflag -- 是否预约：0：否；1：是
            ,sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
            ,sbf_sysflag -- 行内外标识：0：行内 1：行外
            ,sbf_transdate -- 交易日期/提交日期
            ,sbf_transtime -- 交易时间/提交时间
            ,sbf_processendtime -- 中台处理时间
            ,sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
            ,sbf_successcount -- 成功笔数
            ,sbf_successamount -- 成功金额
            ,sbf_failcount -- 失败笔数
            ,sbf_failamount -- 失败金额
            ,sbf_remark -- 附言
            ,sbf_batchstate -- 状态
            ,sbf_returncode -- 返回码
            ,sbf_returnmsg -- 返回信息
            ,sbf_hostremark -- 核心附言
            ,sbf_hostbatchno -- 核心批次号
            ,sbf_showflag -- 是否显示明细
            ,sbf_parentlogno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sbf_batchno -- 批次号
    ,o.sbf_trade_flowno -- 流水号
    ,o.sbf_month -- 月份
    ,o.sbf_ecifno -- 全行统一客户号
    ,o.sbf_userno -- 用户顺序号
    ,o.sbf_username -- 用户名
    ,o.sbf_payeracno -- 付款人账号
    ,o.sbf_payeracname -- 付款人户名
    ,o.sbf_currency -- 币种
    ,o.sbf_totalcount -- 总笔数
    ,o.sbf_totalamount -- 总金额
    ,o.sbf_uploadfilename -- 上传文件名
    ,o.sbf_filename -- 文件名
    ,o.sbf_orderflag -- 是否预约：0：否；1：是
    ,o.sbf_batchstyle -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
    ,o.sbf_sysflag -- 行内外标识：0：行内 1：行外
    ,o.sbf_transdate -- 交易日期/提交日期
    ,o.sbf_transtime -- 交易时间/提交时间
    ,o.sbf_processendtime -- 中台处理时间
    ,o.sbf_timerrule -- 预约时间(行内和行外发工资的预约时间)
    ,o.sbf_successcount -- 成功笔数
    ,o.sbf_successamount -- 成功金额
    ,o.sbf_failcount -- 失败笔数
    ,o.sbf_failamount -- 失败金额
    ,o.sbf_remark -- 附言
    ,o.sbf_batchstate -- 状态
    ,o.sbf_returncode -- 返回码
    ,o.sbf_returnmsg -- 返回信息
    ,o.sbf_hostremark -- 核心附言
    ,o.sbf_hostbatchno -- 核心批次号
    ,o.sbf_showflag -- 是否显示明细
    ,o.sbf_parentlogno -- 父流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_salary_batch_flow_bk o
    left join ${iol_schema}.tbps_cpr_salary_batch_flow_op n
        on
            o.sbf_batchno = n.sbf_batchno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_salary_batch_flow_cl d
        on
            o.sbf_batchno = d.sbf_batchno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_salary_batch_flow;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_salary_batch_flow exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_salary_batch_flow_cl;
alter table ${iol_schema}.tbps_cpr_salary_batch_flow exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_salary_batch_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_salary_batch_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_salary_batch_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
