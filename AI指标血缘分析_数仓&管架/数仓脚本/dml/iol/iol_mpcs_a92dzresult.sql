/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92dzresult
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
create table ${iol_schema}.mpcs_a92dzresult_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92dzresult
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92dzresult_op purge;
drop table ${iol_schema}.mpcs_a92dzresult_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92dzresult_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92dzresult where 0=1;

create table ${iol_schema}.mpcs_a92dzresult_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92dzresult where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92dzresult_cl(
            ztsdatetime -- 中台系统日期时间
            ,settldate -- 清算日期(交易日)
            ,ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
            ,acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
            ,fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
            ,fcdivtotcount -- 分红文件总笔数
            ,fcdivtotamt -- 分红文件总金额
            ,fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
            ,fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
            ,fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
            ,cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
            ,cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsdivcount -- 主机分红对账交易成功笔数
            ,cbsdivamt -- 主机分红对账交易成功金额
            ,dzerrmsg -- 对账错误描述信息
            ,isworkday -- 是否工作日  0-否 1-是
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,ordertotamt -- 盈米订单文件购买类委托成功总金额
            ,ordertotcount -- 盈米订单文件购买类委托成功总笔数
            ,confirmtotamt -- 盈米确认文件入账客户账总金额
            ,confirmtotcount -- 盈米确认文件入账客户账总笔数
            ,nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
            ,nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92dzresult_op(
            ztsdatetime -- 中台系统日期时间
            ,settldate -- 清算日期(交易日)
            ,ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
            ,acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
            ,fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
            ,fcdivtotcount -- 分红文件总笔数
            ,fcdivtotamt -- 分红文件总金额
            ,fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
            ,fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
            ,fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
            ,cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
            ,cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsdivcount -- 主机分红对账交易成功笔数
            ,cbsdivamt -- 主机分红对账交易成功金额
            ,dzerrmsg -- 对账错误描述信息
            ,isworkday -- 是否工作日  0-否 1-是
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,ordertotamt -- 盈米订单文件购买类委托成功总金额
            ,ordertotcount -- 盈米订单文件购买类委托成功总笔数
            ,confirmtotamt -- 盈米确认文件入账客户账总金额
            ,confirmtotcount -- 盈米确认文件入账客户账总笔数
            ,nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
            ,nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ztsdatetime, o.ztsdatetime) as ztsdatetime -- 中台系统日期时间
    ,nvl(n.settldate, o.settldate) as settldate -- 清算日期(交易日)
    ,nvl(n.ymstatus, o.ymstatus) as ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
    ,nvl(n.acctdatestatus, o.acctdatestatus) as acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
    ,nvl(n.fcdivstatus, o.fcdivstatus) as fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
    ,nvl(n.fcdivtotcount, o.fcdivtotcount) as fcdivtotcount -- 分红文件总笔数
    ,nvl(n.fcdivtotamt, o.fcdivtotamt) as fcdivtotamt -- 分红文件总金额
    ,nvl(n.fcintotcount, o.fcintotcount) as fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
    ,nvl(n.fcintotamt, o.fcintotamt) as fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
    ,nvl(n.fcouttotcount, o.fcouttotcount) as fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,nvl(n.fcouttotamt, o.fcouttotamt) as fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,nvl(n.cbsincount, o.cbsincount) as cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
    ,nvl(n.cbsinamt, o.cbsinamt) as cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
    ,nvl(n.cbsoutcount, o.cbsoutcount) as cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,nvl(n.cbsoutamt, o.cbsoutamt) as cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,nvl(n.cbsdivcount, o.cbsdivcount) as cbsdivcount -- 主机分红对账交易成功笔数
    ,nvl(n.cbsdivamt, o.cbsdivamt) as cbsdivamt -- 主机分红对账交易成功金额
    ,nvl(n.dzerrmsg, o.dzerrmsg) as dzerrmsg -- 对账错误描述信息
    ,nvl(n.isworkday, o.isworkday) as isworkday -- 是否工作日  0-否 1-是
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留域1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留域2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留域3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 保留域4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 保留域5
    ,nvl(n.ordertotamt, o.ordertotamt) as ordertotamt -- 盈米订单文件购买类委托成功总金额
    ,nvl(n.ordertotcount, o.ordertotcount) as ordertotcount -- 盈米订单文件购买类委托成功总笔数
    ,nvl(n.confirmtotamt, o.confirmtotamt) as confirmtotamt -- 盈米确认文件入账客户账总金额
    ,nvl(n.confirmtotcount, o.confirmtotcount) as confirmtotcount -- 盈米确认文件入账客户账总笔数
    ,nvl(n.nettingoutflg, o.nettingoutflg) as nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
    ,nvl(n.nettinginflg, o.nettinginflg) as nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
    ,case when
            n.settldate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.settldate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.settldate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92dzresult_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92dzresult where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.settldate = n.settldate
where (
        o.settldate is null
    )
    or (
        n.settldate is null
    )
    or (
        o.ztsdatetime <> n.ztsdatetime
        or o.ymstatus <> n.ymstatus
        or o.acctdatestatus <> n.acctdatestatus
        or o.fcdivstatus <> n.fcdivstatus
        or o.fcdivtotcount <> n.fcdivtotcount
        or o.fcdivtotamt <> n.fcdivtotamt
        or o.fcintotcount <> n.fcintotcount
        or o.fcintotamt <> n.fcintotamt
        or o.fcouttotcount <> n.fcouttotcount
        or o.fcouttotamt <> n.fcouttotamt
        or o.cbsincount <> n.cbsincount
        or o.cbsinamt <> n.cbsinamt
        or o.cbsoutcount <> n.cbsoutcount
        or o.cbsoutamt <> n.cbsoutamt
        or o.cbsdivcount <> n.cbsdivcount
        or o.cbsdivamt <> n.cbsdivamt
        or o.dzerrmsg <> n.dzerrmsg
        or o.isworkday <> n.isworkday
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.ordertotamt <> n.ordertotamt
        or o.ordertotcount <> n.ordertotcount
        or o.confirmtotamt <> n.confirmtotamt
        or o.confirmtotcount <> n.confirmtotcount
        or o.nettingoutflg <> n.nettingoutflg
        or o.nettinginflg <> n.nettinginflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92dzresult_cl(
            ztsdatetime -- 中台系统日期时间
            ,settldate -- 清算日期(交易日)
            ,ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
            ,acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
            ,fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
            ,fcdivtotcount -- 分红文件总笔数
            ,fcdivtotamt -- 分红文件总金额
            ,fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
            ,fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
            ,fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
            ,cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
            ,cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsdivcount -- 主机分红对账交易成功笔数
            ,cbsdivamt -- 主机分红对账交易成功金额
            ,dzerrmsg -- 对账错误描述信息
            ,isworkday -- 是否工作日  0-否 1-是
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,ordertotamt -- 盈米订单文件购买类委托成功总金额
            ,ordertotcount -- 盈米订单文件购买类委托成功总笔数
            ,confirmtotamt -- 盈米确认文件入账客户账总金额
            ,confirmtotcount -- 盈米确认文件入账客户账总笔数
            ,nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
            ,nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92dzresult_op(
            ztsdatetime -- 中台系统日期时间
            ,settldate -- 清算日期(交易日)
            ,ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
            ,acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
            ,fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
            ,fcdivtotcount -- 分红文件总笔数
            ,fcdivtotamt -- 分红文件总金额
            ,fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
            ,fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
            ,fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
            ,cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
            ,cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
            ,cbsdivcount -- 主机分红对账交易成功笔数
            ,cbsdivamt -- 主机分红对账交易成功金额
            ,dzerrmsg -- 对账错误描述信息
            ,isworkday -- 是否工作日  0-否 1-是
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,ordertotamt -- 盈米订单文件购买类委托成功总金额
            ,ordertotcount -- 盈米订单文件购买类委托成功总笔数
            ,confirmtotamt -- 盈米确认文件入账客户账总金额
            ,confirmtotcount -- 盈米确认文件入账客户账总笔数
            ,nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
            ,nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ztsdatetime -- 中台系统日期时间
    ,o.settldate -- 清算日期(交易日)
    ,o.ymstatus -- 盈米订单流水对账状态          0:未对账，1:成功，2:失败，8-勾兑完成（等待批次程序生成批次），9-正在对账（等待upp结果）
    ,o.acctdatestatus -- 资金到期日对账状态      0:未对账，1:成功，2:失败，8-勾兑完成（等待分红数据），9-正在对账（等待upp结果）
    ,o.fcdivstatus -- 基金公司分红数据对账状态      0:未对账，1:成功，2:失败，8-信息汇总完成（等待资金到期日数据），9-正在对账（等待upp结果）
    ,o.fcdivtotcount -- 分红文件总笔数
    ,o.fcdivtotamt -- 分红文件总金额
    ,o.fcintotcount -- 盈米对账交易流水转入总笔数(申购、认购、定投申购)
    ,o.fcintotamt -- 盈米对账交易流水转入总金额(申购、认购、定投申购)
    ,o.fcouttotcount -- 基金公司对账交易流水转出总笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,o.fcouttotamt -- 基金公司对账交易流水转出总金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,o.cbsincount -- 主机对账交易流水转入成功笔数(申购、认购、定投申购)
    ,o.cbsinamt -- 主机对账交易流水转入成功金额(申购、认购、定投申购)
    ,o.cbsoutcount -- 主机对账交易流水转出成功笔数(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,o.cbsoutamt -- 主机对账交易流水转出成功金额(申购确认失败、认购全比例确认失败、赎回成功、认购部分失败)
    ,o.cbsdivcount -- 主机分红对账交易成功笔数
    ,o.cbsdivamt -- 主机分红对账交易成功金额
    ,o.dzerrmsg -- 对账错误描述信息
    ,o.isworkday -- 是否工作日  0-否 1-是
    ,o.reserve1 -- 保留域1
    ,o.reserve2 -- 保留域2
    ,o.reserve3 -- 保留域3
    ,o.reserve4 -- 保留域4
    ,o.reserve5 -- 保留域5
    ,o.ordertotamt -- 盈米订单文件购买类委托成功总金额
    ,o.ordertotcount -- 盈米订单文件购买类委托成功总笔数
    ,o.confirmtotamt -- 盈米确认文件入账客户账总金额
    ,o.confirmtotcount -- 盈米确认文件入账客户账总笔数
    ,o.nettingoutflg -- 赎回清算户转出标记 0--正常或无校验 1--长款 2--短款 3--接口查询失败
    ,o.nettinginflg -- 申、认购清算户转入标记 0--正常或无校验 1--长款 3--接口查询失败
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
from ${iol_schema}.mpcs_a92dzresult_bk o
    left join ${iol_schema}.mpcs_a92dzresult_op n
        on
            o.settldate = n.settldate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92dzresult_cl d
        on
            o.settldate = d.settldate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a92dzresult;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a92dzresult') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a92dzresult drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a92dzresult add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a92dzresult exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a92dzresult_cl;
alter table ${iol_schema}.mpcs_a92dzresult exchange partition p_20991231 with table ${iol_schema}.mpcs_a92dzresult_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92dzresult to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92dzresult_op purge;
drop table ${iol_schema}.mpcs_a92dzresult_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92dzresult_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92dzresult',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
