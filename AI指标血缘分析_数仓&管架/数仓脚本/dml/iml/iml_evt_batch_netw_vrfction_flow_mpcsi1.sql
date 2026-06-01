/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_netw_vrfction_flow_mpcsi1
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
drop table ${iml_schema}.evt_batch_netw_vrfction_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_batch_netw_vrfction_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_netw_vrfction_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_netw_vrfction_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 批次日期
    ,batch_id -- 批次编号
    ,batch_seq_num -- 批次序号
    ,netw_vrfction_ser_num -- 联网核查序列号
    ,netw_vrfction_dt -- 联网核查日期
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_name -- 证件姓名
    ,msg_id -- 报文编号
    ,sys_cd -- 系统代码
    ,ibank_no -- 联行号
    ,org_id -- 机构编号
    ,vrfction_pass_cd -- 核查通道代码
    ,vrfction_dept_cd -- 核查部门代码
    ,vrfction_type_cd -- 核查类型代码
    ,bus_kind_cd -- 业务种类代码
    ,midgrod_flow_num -- 中台流水号
    ,check_rest_cd -- 验证结果代码
    ,check_status_cd -- 验证状态代码
    ,valid_rec_flg -- 有效记录标志
    ,export_status_cd -- 导出状态代码
    ,vrfction_status_cd -- 核查状态代码
    ,aldy_stat_flg -- 已统计标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_netw_vrfction_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a60tchkbatdetail-1
insert into ${iml_schema}.evt_batch_netw_vrfction_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dt -- 批次日期
    ,batch_id -- 批次编号
    ,batch_seq_num -- 批次序号
    ,netw_vrfction_ser_num -- 联网核查序列号
    ,netw_vrfction_dt -- 联网核查日期
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_name -- 证件姓名
    ,msg_id -- 报文编号
    ,sys_cd -- 系统代码
    ,ibank_no -- 联行号
    ,org_id -- 机构编号
    ,vrfction_pass_cd -- 核查通道代码
    ,vrfction_dept_cd -- 核查部门代码
    ,vrfction_type_cd -- 核查类型代码
    ,bus_kind_cd -- 业务种类代码
    ,midgrod_flow_num -- 中台流水号
    ,check_rest_cd -- 验证结果代码
    ,check_status_cd -- 验证状态代码
    ,valid_rec_flg -- 有效记录标志
    ,export_status_cd -- 导出状态代码
    ,vrfction_status_cd -- 核查状态代码
    ,aldy_stat_flg -- 已统计标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401031'||p1.batdt||p1.batno||p1.batseqno -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(p1.batdt) -- 批次日期
    ,p1.batno -- 批次编号
    ,p1.batseqno -- 批次序号
    ,p1.trannbr -- 联网核查序列号
    ,${iml_schema}.dateformat_max2(p1.trandate||p1.trantime) -- 联网核查日期
    ,nvl(trim(p1.identype),'0000') -- 证件类型代码
    ,p1.idennbr -- 证件号码
    ,p1.cltname -- 证件姓名
    ,p1.srcseqno -- 报文编号
    ,nvl(trim(p1.srcsysid),'-') -- 系统代码
    ,p1.bnakcode -- 联行号
    ,p1.brcno -- 机构编号
    ,nvl(trim(p1.checkchnl),'-') -- 核查通道代码
    ,nvl(trim(p1.checkdept),'00') -- 核查部门代码
    ,nvl(trim(p1.checktype),'-') -- 核查类型代码
    ,nvl(trim(p1.businesstype),'-') -- 业务种类代码
    ,p1.transeqno -- 中台流水号
    ,nvl(trim(p1.chkresult),'-') -- 验证结果代码
    ,nvl(trim(p1.status),'-') -- 验证状态代码
    ,nvl(trim(p1.recordstat),'-') -- 有效记录标志
    ,nvl(trim(p1.loadflg),'-') -- 导出状态代码
    ,nvl(trim(p1.dealflg),'-') -- 核查状态代码
    ,nvl(trim(p1.feecntflg),'-') -- 已统计标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a60tchkbatdetail' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.mpcs_a60tchkbatdetail p1
 where 1 = 1
   and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
  ;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_netw_vrfction_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_netw_vrfction_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_batch_netw_vrfction_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_netw_vrfction_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_netw_vrfction_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_netw_vrfction_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);