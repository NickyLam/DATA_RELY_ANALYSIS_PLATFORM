/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bdms_and_tgls_intrrcn_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bdms_and_tgls_intrrcn partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm purge;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op purge;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bdms_and_tgls_intrrcn partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bdms_and_tgls_intrrcn partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bdms_and_tgls_intrrcn partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_tbl_acct_trans_flow-1
insert into ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401032'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 交互流水号
    ,P1.SYSTID -- 系统编号
    ,P1.BSNSSQ -- 全局流水号
    ,P1.SERINO -- 序号
    ,P1.TRANSQ -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRANDT) -- 交易日期
    ,P1.TRANBR -- 交易机构编号
    ,nvl(trim(P1.EVETDN),'-') -- 交易方向代码
    ,nvl(trim(P1.CRCYCD),'-') -- 交易币种代码
    ,nvl(trim(P1.TRPRCD),'-') -- 交易金额类型代码
    ,to_number(P1.TRANAM) -- 交易金额
    ,${iml_schema}.dateformat_max2(P1.DATEX1) -- 原交易日期
    ,P1.ACCTNO -- 协议编号
    ,nvl(trim(P1.ASSIS0),'0000') -- 渠道编号
    ,P1.ASSIS1 -- 可售产品编号
    ,P1.CHREX3 -- 冲正流水号
    ,nvl(trim(P1.CHREX2),'-') -- 冲正业务状态代码
    ,P1.DATEX0 -- 冲正时间
    ,P1.DRAFT_NUMBER -- 票据编号
    ,P1.CONTRACT_NO -- 批次号
    ,P1.DETAILS_ID -- 明细编号
    ,P1.TGLSCNT -- 发送核算中台批次
    ,P1.TGLS_END_CNT -- 发送核算中台日终批次
    ,nvl(trim(P1.END_STATUS),'-') -- 日终反馈状态代码
    ,P1.FILE_NAME -- 发送核算中台文件名称
    ,P1.ERORCD -- 错误码
    ,P1.ERORTX -- 错误信息
    ,P1.ACCTBR -- 账务机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_tbl_acct_trans_flow' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.bdms_tbl_acct_trans_flow p1
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  ;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intrrcn_flow_num, o.intrrcn_flow_num) as intrrcn_flow_num -- 交互流水号
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.tran_curr_cd, o.tran_curr_cd) as tran_curr_cd -- 交易币种代码
    ,nvl(n.tran_amt_type_cd, o.tran_amt_type_cd) as tran_amt_type_cd -- 交易金额类型代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.init_tran_dt, o.init_tran_dt) as init_tran_dt -- 原交易日期
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.sellbl_prod_id, o.sellbl_prod_id) as sellbl_prod_id -- 可售产品编号
    ,nvl(n.revs_flow_num, o.revs_flow_num) as revs_flow_num -- 冲正流水号
    ,nvl(n.revs_bus_status_cd, o.revs_bus_status_cd) as revs_bus_status_cd -- 冲正业务状态代码
    ,nvl(n.revs_tm, o.revs_tm) as revs_tm -- 冲正时间
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.dtl_id, o.dtl_id) as dtl_id -- 明细编号
    ,nvl(n.send_tgls_batch, o.send_tgls_batch) as send_tgls_batch -- 发送核算中台批次
    ,nvl(n.send_tgls__end_day_batch, o.send_tgls__end_day_batch) as send_tgls__end_day_batch -- 发送核算中台日终批次
    ,nvl(n.end_day_feedback_status_cd, o.end_day_feedback_status_cd) as end_day_feedback_status_cd -- 日终反馈状态代码
    ,nvl(n.send_tgls__doc_name, o.send_tgls__doc_name) as send_tgls__doc_name -- 发送核算中台文件名称
    ,nvl(n.err_cd, o.err_cd) as err_cd -- 错误码
    ,nvl(n.err_info, o.err_info) as err_info -- 错误信息
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm n
    full join (select * from ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.intrrcn_flow_num <> n.intrrcn_flow_num
        or o.sys_id <> n.sys_id
        or o.ova_flow_num <> n.ova_flow_num
        or o.seq_num <> n.seq_num
        or o.tran_flow_num <> n.tran_flow_num
        or o.tran_dt <> n.tran_dt
        or o.tran_org_id <> n.tran_org_id
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.tran_curr_cd <> n.tran_curr_cd
        or o.tran_amt_type_cd <> n.tran_amt_type_cd
        or o.tran_amt <> n.tran_amt
        or o.init_tran_dt <> n.init_tran_dt
        or o.agt_id <> n.agt_id
        or o.chn_id <> n.chn_id
        or o.sellbl_prod_id <> n.sellbl_prod_id
        or o.revs_flow_num <> n.revs_flow_num
        or o.revs_bus_status_cd <> n.revs_bus_status_cd
        or o.revs_tm <> n.revs_tm
        or o.bill_id <> n.bill_id
        or o.batch_no <> n.batch_no
        or o.dtl_id <> n.dtl_id
        or o.send_tgls_batch <> n.send_tgls_batch
        or o.send_tgls__end_day_batch <> n.send_tgls__end_day_batch
        or o.end_day_feedback_status_cd <> n.end_day_feedback_status_cd
        or o.send_tgls__doc_name <> n.send_tgls__doc_name
        or o.err_cd <> n.err_cd
        or o.err_info <> n.err_info
        or o.acct_instit_id <> n.acct_instit_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intrrcn_flow_num -- 交互流水号
    ,sys_id -- 系统编号
    ,ova_flow_num -- 全局流水号
    ,seq_num -- 序号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt_type_cd -- 交易金额类型代码
    ,tran_amt -- 交易金额
    ,init_tran_dt -- 原交易日期
    ,agt_id -- 协议编号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,revs_flow_num -- 冲正流水号
    ,revs_bus_status_cd -- 冲正业务状态代码
    ,revs_tm -- 冲正时间
    ,bill_id -- 票据编号
    ,batch_no -- 批次号
    ,dtl_id -- 明细编号
    ,send_tgls_batch -- 发送核算中台批次
    ,send_tgls__end_day_batch -- 发送核算中台日终批次
    ,end_day_feedback_status_cd -- 日终反馈状态代码
    ,send_tgls__doc_name -- 发送核算中台文件名称
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,acct_instit_id -- 账务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.intrrcn_flow_num -- 交互流水号
    ,o.sys_id -- 系统编号
    ,o.ova_flow_num -- 全局流水号
    ,o.seq_num -- 序号
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_dt -- 交易日期
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_dir_cd -- 交易方向代码
    ,o.tran_curr_cd -- 交易币种代码
    ,o.tran_amt_type_cd -- 交易金额类型代码
    ,o.tran_amt -- 交易金额
    ,o.init_tran_dt -- 原交易日期
    ,o.agt_id -- 协议编号
    ,o.chn_id -- 渠道编号
    ,o.sellbl_prod_id -- 可售产品编号
    ,o.revs_flow_num -- 冲正流水号
    ,o.revs_bus_status_cd -- 冲正业务状态代码
    ,o.revs_tm -- 冲正时间
    ,o.bill_id -- 票据编号
    ,o.batch_no -- 批次号
    ,o.dtl_id -- 明细编号
    ,o.send_tgls_batch -- 发送核算中台批次
    ,o.send_tgls__end_day_batch -- 发送核算中台日终批次
    ,o.end_day_feedback_status_cd -- 日终反馈状态代码
    ,o.send_tgls__doc_name -- 发送核算中台文件名称
    ,o.err_cd -- 错误码
    ,o.err_info -- 错误信息
    ,o.acct_instit_id -- 账务机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_bk o
    left join ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_bdms_and_tgls_intrrcn;
--alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_bdms_and_tgls_intrrcn') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl;
alter table ${iml_schema}.evt_bdms_and_tgls_intrrcn exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bdms_and_tgls_intrrcn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_tm purge;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_op purge;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bdms_and_tgls_intrrcn', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
