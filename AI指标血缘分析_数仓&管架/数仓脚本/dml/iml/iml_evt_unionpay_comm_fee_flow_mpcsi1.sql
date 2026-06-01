/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_unionpay_comm_fee_flow_mpcsi1
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
drop table ${iml_schema}.evt_unionpay_comm_fee_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_unionpay_comm_fee_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_unionpay_comm_fee_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_unionpay_comm_fee_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,unionpay_tran_type_cd -- 银联交易类型代码
    ,trader_type_cd -- 交易方类型代码
    ,tran_dt -- 交易日期
    ,int_paybl_amt -- 应付金额
    ,recvbl_amt -- 应收金额
    ,front_dt -- 前置日期
    ,front_flow_num -- 前置流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,unionpay_front_tran_status_cd -- 银联前置交易状态代码
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,paybl_exch_fee -- 应付交换费
    ,recvbl_exch_fee -- 应收交换费
    ,tran_clear_fee -- 转接清算费
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_unionpay_comm_fee_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a51ubhandchrg-1
insert into ${iml_schema}.evt_unionpay_comm_fee_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,unionpay_tran_type_cd -- 银联交易类型代码
    ,trader_type_cd -- 交易方类型代码
    ,tran_dt -- 交易日期
    ,int_paybl_amt -- 应付金额
    ,recvbl_amt -- 应收金额
    ,front_dt -- 前置日期
    ,front_flow_num -- 前置流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,unionpay_front_tran_status_cd -- 银联前置交易状态代码
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,paybl_exch_fee -- 应付交换费
    ,recvbl_exch_fee -- 应收交换费
    ,tran_clear_fee -- 转接清算费
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201020'||p1.brnnbr||p1.tranflag||p1.trantype||p1.trandate -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BRNNBR -- 机构编号
    ,P1.TRANFLAG -- 银联交易类型代码
    ,P1.TRANTYPE -- 交易方类型代码
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,P1.TRANAMT -- 应付金额
    ,P1.RECVAMT -- 应收金额
    ,${iml_schema}.dateformat_max2(P1.UNIODATE) -- 前置日期
    ,P1.UNIONBR -- 前置流水号
    ,P1.HOSTNBR -- 核心交易流水号
    ,${iml_schema}.dateformat_max2(P1.HOSTDATE) -- 核心交易日期
    ,P1.STATUS -- 银联前置交易状态代码
    ,P1.ERRCODE -- 错误码
    ,P1.ERRMSG -- 错误信息描述
    ,P1.TRANEXAMT -- 应付交换费
    ,P1.RECVEXAMT -- 应收交换费
    ,P1.COVAMT -- 转接清算费
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a51ubhandchrg' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ubhandchrg p1
where  1 = 1 
     and p1.uniodate = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_unionpay_comm_fee_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_unionpay_comm_fee_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_unionpay_comm_fee_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_unionpay_comm_fee_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_unionpay_comm_fee_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_unionpay_comm_fee_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);