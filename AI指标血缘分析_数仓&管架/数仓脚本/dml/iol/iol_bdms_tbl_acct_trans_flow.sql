/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_tbl_acct_trans_flow
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
create table ${iol_schema}.bdms_tbl_acct_trans_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_tbl_acct_trans_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow_op purge;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_tbl_acct_trans_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_tbl_acct_trans_flow where 0=1;

create table ${iol_schema}.bdms_tbl_acct_trans_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_tbl_acct_trans_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_tbl_acct_trans_flow_cl(
            id -- 主键
            ,systid -- 系统代号
            ,trandt -- 交易日期
            ,bsnssq -- 全局流水
            ,transq -- 交易流水
            ,serino -- 序号
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,prcscd -- 交易码
            ,prodcd -- 解析产品
            ,loanp1 -- 产品属性1
            ,loanp2 -- 产品属性2
            ,loanp3 -- 产品属性3
            ,loanp4 -- 产品属性4
            ,loanp5 -- 产品属性5
            ,loanp6 -- 产品属性6
            ,loanp7 -- 产品属性7
            ,loanp8 -- 产品属性8
            ,loanp9 -- 产品属性9
            ,evetdn -- 交易方向
            ,trprcd -- 金额类型
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,custcd -- 客户号
            ,acctno -- 协议编号
            ,assis0 -- 渠道
            ,assis1 -- 可售产品
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis9 -- 辅助核算9
            ,datex0 -- 交易时间
            ,chrex0 -- 交易用户
            ,chrex1 -- 授权用户
            ,chrex2 -- 冲正标志
            ,chrex3 -- 冲抹原交易流水号
            ,datex1 -- 冲抹原交易日期
            ,batchno -- 数据文件批次号
            ,status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
            ,erorcd -- 错误码
            ,erortx -- 错误信息
            ,loanpa -- 产品属性10
            ,contract_no -- 批次号
            ,details_id -- 明细ID
            ,tglscnt -- 发送核算中台批次
            ,tgls_end_cnt -- 发送核算中台日终批次
            ,end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
            ,file_name -- 发送核算中台文件名称
            ,draft_number -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_tbl_acct_trans_flow_op(
            id -- 主键
            ,systid -- 系统代号
            ,trandt -- 交易日期
            ,bsnssq -- 全局流水
            ,transq -- 交易流水
            ,serino -- 序号
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,prcscd -- 交易码
            ,prodcd -- 解析产品
            ,loanp1 -- 产品属性1
            ,loanp2 -- 产品属性2
            ,loanp3 -- 产品属性3
            ,loanp4 -- 产品属性4
            ,loanp5 -- 产品属性5
            ,loanp6 -- 产品属性6
            ,loanp7 -- 产品属性7
            ,loanp8 -- 产品属性8
            ,loanp9 -- 产品属性9
            ,evetdn -- 交易方向
            ,trprcd -- 金额类型
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,custcd -- 客户号
            ,acctno -- 协议编号
            ,assis0 -- 渠道
            ,assis1 -- 可售产品
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis9 -- 辅助核算9
            ,datex0 -- 交易时间
            ,chrex0 -- 交易用户
            ,chrex1 -- 授权用户
            ,chrex2 -- 冲正标志
            ,chrex3 -- 冲抹原交易流水号
            ,datex1 -- 冲抹原交易日期
            ,batchno -- 数据文件批次号
            ,status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
            ,erorcd -- 错误码
            ,erortx -- 错误信息
            ,loanpa -- 产品属性10
            ,contract_no -- 批次号
            ,details_id -- 明细ID
            ,tglscnt -- 发送核算中台批次
            ,tgls_end_cnt -- 发送核算中台日终批次
            ,end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
            ,file_name -- 发送核算中台文件名称
            ,draft_number -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.systid, o.systid) as systid -- 系统代号
    ,nvl(n.trandt, o.trandt) as trandt -- 交易日期
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水
    ,nvl(n.transq, o.transq) as transq -- 交易流水
    ,nvl(n.serino, o.serino) as serino -- 序号
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构编号
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账务机构编号
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 交易码
    ,nvl(n.prodcd, o.prodcd) as prodcd -- 解析产品
    ,nvl(n.loanp1, o.loanp1) as loanp1 -- 产品属性1
    ,nvl(n.loanp2, o.loanp2) as loanp2 -- 产品属性2
    ,nvl(n.loanp3, o.loanp3) as loanp3 -- 产品属性3
    ,nvl(n.loanp4, o.loanp4) as loanp4 -- 产品属性4
    ,nvl(n.loanp5, o.loanp5) as loanp5 -- 产品属性5
    ,nvl(n.loanp6, o.loanp6) as loanp6 -- 产品属性6
    ,nvl(n.loanp7, o.loanp7) as loanp7 -- 产品属性7
    ,nvl(n.loanp8, o.loanp8) as loanp8 -- 产品属性8
    ,nvl(n.loanp9, o.loanp9) as loanp9 -- 产品属性9
    ,nvl(n.evetdn, o.evetdn) as evetdn -- 交易方向
    ,nvl(n.trprcd, o.trprcd) as trprcd -- 金额类型
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.tranam, o.tranam) as tranam -- 交易金额
    ,nvl(n.custcd, o.custcd) as custcd -- 客户号
    ,nvl(n.acctno, o.acctno) as acctno -- 协议编号
    ,nvl(n.assis0, o.assis0) as assis0 -- 渠道
    ,nvl(n.assis1, o.assis1) as assis1 -- 可售产品
    ,nvl(n.assis2, o.assis2) as assis2 -- 辅助核算2
    ,nvl(n.assis3, o.assis3) as assis3 -- 辅助核算3
    ,nvl(n.assis4, o.assis4) as assis4 -- 辅助核算4
    ,nvl(n.assis5, o.assis5) as assis5 -- 辅助核算5
    ,nvl(n.assis6, o.assis6) as assis6 -- 辅助核算6
    ,nvl(n.assis7, o.assis7) as assis7 -- 辅助核算7
    ,nvl(n.assis9, o.assis9) as assis9 -- 辅助核算9
    ,nvl(n.datex0, o.datex0) as datex0 -- 交易时间
    ,nvl(n.chrex0, o.chrex0) as chrex0 -- 交易用户
    ,nvl(n.chrex1, o.chrex1) as chrex1 -- 授权用户
    ,nvl(n.chrex2, o.chrex2) as chrex2 -- 冲正标志
    ,nvl(n.chrex3, o.chrex3) as chrex3 -- 冲抹原交易流水号
    ,nvl(n.datex1, o.datex1) as datex1 -- 冲抹原交易日期
    ,nvl(n.batchno, o.batchno) as batchno -- 数据文件批次号
    ,nvl(n.status, o.status) as status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
    ,nvl(n.erorcd, o.erorcd) as erorcd -- 错误码
    ,nvl(n.erortx, o.erortx) as erortx -- 错误信息
    ,nvl(n.loanpa, o.loanpa) as loanpa -- 产品属性10
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.details_id, o.details_id) as details_id -- 明细ID
    ,nvl(n.tglscnt, o.tglscnt) as tglscnt -- 发送核算中台批次
    ,nvl(n.tgls_end_cnt, o.tgls_end_cnt) as tgls_end_cnt -- 发送核算中台日终批次
    ,nvl(n.end_status, o.end_status) as end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
    ,nvl(n.file_name, o.file_name) as file_name -- 发送核算中台文件名称
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
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
from (select * from ${iol_schema}.bdms_tbl_acct_trans_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_tbl_acct_trans_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.systid <> n.systid
        or o.trandt <> n.trandt
        or o.bsnssq <> n.bsnssq
        or o.transq <> n.transq
        or o.serino <> n.serino
        or o.tranbr <> n.tranbr
        or o.acctbr <> n.acctbr
        or o.prcscd <> n.prcscd
        or o.prodcd <> n.prodcd
        or o.loanp1 <> n.loanp1
        or o.loanp2 <> n.loanp2
        or o.loanp3 <> n.loanp3
        or o.loanp4 <> n.loanp4
        or o.loanp5 <> n.loanp5
        or o.loanp6 <> n.loanp6
        or o.loanp7 <> n.loanp7
        or o.loanp8 <> n.loanp8
        or o.loanp9 <> n.loanp9
        or o.evetdn <> n.evetdn
        or o.trprcd <> n.trprcd
        or o.crcycd <> n.crcycd
        or o.tranam <> n.tranam
        or o.custcd <> n.custcd
        or o.acctno <> n.acctno
        or o.assis0 <> n.assis0
        or o.assis1 <> n.assis1
        or o.assis2 <> n.assis2
        or o.assis3 <> n.assis3
        or o.assis4 <> n.assis4
        or o.assis5 <> n.assis5
        or o.assis6 <> n.assis6
        or o.assis7 <> n.assis7
        or o.assis9 <> n.assis9
        or o.datex0 <> n.datex0
        or o.chrex0 <> n.chrex0
        or o.chrex1 <> n.chrex1
        or o.chrex2 <> n.chrex2
        or o.chrex3 <> n.chrex3
        or o.datex1 <> n.datex1
        or o.batchno <> n.batchno
        or o.status <> n.status
        or o.erorcd <> n.erorcd
        or o.erortx <> n.erortx
        or o.loanpa <> n.loanpa
        or o.contract_no <> n.contract_no
        or o.details_id <> n.details_id
        or o.tglscnt <> n.tglscnt
        or o.tgls_end_cnt <> n.tgls_end_cnt
        or o.end_status <> n.end_status
        or o.file_name <> n.file_name
        or o.draft_number <> n.draft_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_tbl_acct_trans_flow_cl(
            id -- 主键
            ,systid -- 系统代号
            ,trandt -- 交易日期
            ,bsnssq -- 全局流水
            ,transq -- 交易流水
            ,serino -- 序号
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,prcscd -- 交易码
            ,prodcd -- 解析产品
            ,loanp1 -- 产品属性1
            ,loanp2 -- 产品属性2
            ,loanp3 -- 产品属性3
            ,loanp4 -- 产品属性4
            ,loanp5 -- 产品属性5
            ,loanp6 -- 产品属性6
            ,loanp7 -- 产品属性7
            ,loanp8 -- 产品属性8
            ,loanp9 -- 产品属性9
            ,evetdn -- 交易方向
            ,trprcd -- 金额类型
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,custcd -- 客户号
            ,acctno -- 协议编号
            ,assis0 -- 渠道
            ,assis1 -- 可售产品
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis9 -- 辅助核算9
            ,datex0 -- 交易时间
            ,chrex0 -- 交易用户
            ,chrex1 -- 授权用户
            ,chrex2 -- 冲正标志
            ,chrex3 -- 冲抹原交易流水号
            ,datex1 -- 冲抹原交易日期
            ,batchno -- 数据文件批次号
            ,status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
            ,erorcd -- 错误码
            ,erortx -- 错误信息
            ,loanpa -- 产品属性10
            ,contract_no -- 批次号
            ,details_id -- 明细ID
            ,tglscnt -- 发送核算中台批次
            ,tgls_end_cnt -- 发送核算中台日终批次
            ,end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
            ,file_name -- 发送核算中台文件名称
            ,draft_number -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_tbl_acct_trans_flow_op(
            id -- 主键
            ,systid -- 系统代号
            ,trandt -- 交易日期
            ,bsnssq -- 全局流水
            ,transq -- 交易流水
            ,serino -- 序号
            ,tranbr -- 交易机构编号
            ,acctbr -- 账务机构编号
            ,prcscd -- 交易码
            ,prodcd -- 解析产品
            ,loanp1 -- 产品属性1
            ,loanp2 -- 产品属性2
            ,loanp3 -- 产品属性3
            ,loanp4 -- 产品属性4
            ,loanp5 -- 产品属性5
            ,loanp6 -- 产品属性6
            ,loanp7 -- 产品属性7
            ,loanp8 -- 产品属性8
            ,loanp9 -- 产品属性9
            ,evetdn -- 交易方向
            ,trprcd -- 金额类型
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,custcd -- 客户号
            ,acctno -- 协议编号
            ,assis0 -- 渠道
            ,assis1 -- 可售产品
            ,assis2 -- 辅助核算2
            ,assis3 -- 辅助核算3
            ,assis4 -- 辅助核算4
            ,assis5 -- 辅助核算5
            ,assis6 -- 辅助核算6
            ,assis7 -- 辅助核算7
            ,assis9 -- 辅助核算9
            ,datex0 -- 交易时间
            ,chrex0 -- 交易用户
            ,chrex1 -- 授权用户
            ,chrex2 -- 冲正标志
            ,chrex3 -- 冲抹原交易流水号
            ,datex1 -- 冲抹原交易日期
            ,batchno -- 数据文件批次号
            ,status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
            ,erorcd -- 错误码
            ,erortx -- 错误信息
            ,loanpa -- 产品属性10
            ,contract_no -- 批次号
            ,details_id -- 明细ID
            ,tglscnt -- 发送核算中台批次
            ,tgls_end_cnt -- 发送核算中台日终批次
            ,end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
            ,file_name -- 发送核算中台文件名称
            ,draft_number -- 票据号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.systid -- 系统代号
    ,o.trandt -- 交易日期
    ,o.bsnssq -- 全局流水
    ,o.transq -- 交易流水
    ,o.serino -- 序号
    ,o.tranbr -- 交易机构编号
    ,o.acctbr -- 账务机构编号
    ,o.prcscd -- 交易码
    ,o.prodcd -- 解析产品
    ,o.loanp1 -- 产品属性1
    ,o.loanp2 -- 产品属性2
    ,o.loanp3 -- 产品属性3
    ,o.loanp4 -- 产品属性4
    ,o.loanp5 -- 产品属性5
    ,o.loanp6 -- 产品属性6
    ,o.loanp7 -- 产品属性7
    ,o.loanp8 -- 产品属性8
    ,o.loanp9 -- 产品属性9
    ,o.evetdn -- 交易方向
    ,o.trprcd -- 金额类型
    ,o.crcycd -- 币种
    ,o.tranam -- 交易金额
    ,o.custcd -- 客户号
    ,o.acctno -- 协议编号
    ,o.assis0 -- 渠道
    ,o.assis1 -- 可售产品
    ,o.assis2 -- 辅助核算2
    ,o.assis3 -- 辅助核算3
    ,o.assis4 -- 辅助核算4
    ,o.assis5 -- 辅助核算5
    ,o.assis6 -- 辅助核算6
    ,o.assis7 -- 辅助核算7
    ,o.assis9 -- 辅助核算9
    ,o.datex0 -- 交易时间
    ,o.chrex0 -- 交易用户
    ,o.chrex1 -- 授权用户
    ,o.chrex2 -- 冲正标志
    ,o.chrex3 -- 冲抹原交易流水号
    ,o.datex1 -- 冲抹原交易日期
    ,o.batchno -- 数据文件批次号
    ,o.status -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
    ,o.erorcd -- 错误码
    ,o.erortx -- 错误信息
    ,o.loanpa -- 产品属性10
    ,o.contract_no -- 批次号
    ,o.details_id -- 明细ID
    ,o.tglscnt -- 发送核算中台批次
    ,o.tgls_end_cnt -- 发送核算中台日终批次
    ,o.end_status -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
    ,o.file_name -- 发送核算中台文件名称
    ,o.draft_number -- 票据号码
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
from ${iol_schema}.bdms_tbl_acct_trans_flow_bk o
    left join ${iol_schema}.bdms_tbl_acct_trans_flow_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_tbl_acct_trans_flow_cl d
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
--truncate table ${iol_schema}.bdms_tbl_acct_trans_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_tbl_acct_trans_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_tbl_acct_trans_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_tbl_acct_trans_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_tbl_acct_trans_flow exchange partition p_${batch_date} with table ${iol_schema}.bdms_tbl_acct_trans_flow_cl;
alter table ${iol_schema}.bdms_tbl_acct_trans_flow exchange partition p_20991231 with table ${iol_schema}.bdms_tbl_acct_trans_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_tbl_acct_trans_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow_op purge;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_tbl_acct_trans_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
