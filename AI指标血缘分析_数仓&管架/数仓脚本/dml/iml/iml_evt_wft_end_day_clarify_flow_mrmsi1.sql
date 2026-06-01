/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wft_end_day_clarify_flow_mrmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_wft_end_day_clarify_flow_mrmsi1_tm purge;
alter table ${iml_schema}.evt_wft_end_day_clarify_flow add partition p_mrmsi1 values ('mrmsi1')(
        subpartition p_mrmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wft_end_day_clarify_flow modify partition p_mrmsi1
    add subpartition p_mrmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wft_end_day_clarify_flow_mrmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clarify_dt -- 清分日期
    ,clarify_flow_num -- 清分流水号
    ,mercht_id -- 商户编号
    ,ibank_no -- 联行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,clarify_amt -- 清分金额
    ,memo -- 摘要
    ,return_flow_num -- 返回流水号
    ,return_sucs_flg -- 返回成功标志
    ,return_info -- 返回信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wft_end_day_clarify_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mrms_bth_wft_pay_settle-1
insert into ${iml_schema}.evt_wft_end_day_clarify_flow_mrmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clarify_dt -- 清分日期
    ,clarify_flow_num -- 清分流水号
    ,mercht_id -- 商户编号
    ,ibank_no -- 联行号
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,clarify_amt -- 清分金额
    ,memo -- 摘要
    ,return_flow_num -- 返回流水号
    ,return_sucs_flg -- 返回成功标志
    ,return_info -- 返回信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401028'||P1.CLEAN_ID||P1.CLEAN_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(P1.CLEAN_DATE) -- 清分日期
    ,P1.CLEAN_ID -- 清分流水号
    ,P1.MCHT_CHANNEL -- 商户编号
    ,P1.BRANCH_NO -- 联行号
    ,P1.RECEIPT_NAME -- 收款人名称
    ,P1.RECEIPT_ACCOUNT -- 收款人账户编号
    ,decode(P1.RECEIPT_ACCTYPE,'0','A123','1','A124','2','A007',' ','-',P1.RECEIPT_ACCTYPE) -- 收款账户类型代码
    ,to_number(nvl(P1.CLEAN_AMT,'0')) -- 清分金额
    ,P1.RESEVEL -- 摘要
    ,P1.RET_SERIAL_NO -- 返回流水号
    ,case when P1.RET_CODE = '000' then '1'
       else '0'
     end -- 返回成功标志
    ,P1.RET_MSG -- 返回信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_bth_wft_pay_settle' -- 源表名称
    ,'mrmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.mrms_bth_wft_pay_settle p1
 where 1 = 1
   and p1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   ;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wft_end_day_clarify_flow truncate subpartition p_mrmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wft_end_day_clarify_flow exchange subpartition p_mrmsi1_${batch_date} with table ${iml_schema}.evt_wft_end_day_clarify_flow_mrmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wft_end_day_clarify_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wft_end_day_clarify_flow_mrmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wft_end_day_clarify_flow', partname => 'p_mrmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);