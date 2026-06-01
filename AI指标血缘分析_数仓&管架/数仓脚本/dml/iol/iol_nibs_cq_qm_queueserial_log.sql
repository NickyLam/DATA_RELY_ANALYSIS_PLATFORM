/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_cq_qm_queueserial_log
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_cq_qm_queueserial_log_ex purge;
alter table ${iol_schema}.nibs_cq_qm_queueserial_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_cq_qm_queueserial_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_cq_qm_queueserial_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_cq_qm_queueserial_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_cq_qm_queueserial_log_ex(
    workdate -- 工作日
    ,brno -- 机构编号
    ,deviceno -- 设备编号
    ,queuegetserno -- 队列号取号流水
    ,queuegetchannel -- 队列号取号渠道编号
    ,queuegettime -- 取号时间
    ,queuetppreletter -- 队列号前缀字母
    ,queuetpprenum -- 队列号数字
    ,queueno -- 队列号
    ,queuetpchkcode -- 队列号校验码
    ,queuetpstatus -- 队列号状态 0- 取号,1- 业务办理中,2-业务办理结束,3-弃号,4-转移,5-休眠
    ,bsid -- 业务ID A-个人现金, B-个人非现金, C-对公现金, D-对公非现金, E-小面额, T-特殊取号
    ,queuetpid -- 队列ID
    ,custgrd -- 客户综合评级 0-公司用户, 1-普通用户, 2-VIP用户, 3-私人银行用户, 99-特殊取号
    ,idtype -- 证件类型
    ,idcode -- 证件号码
    ,custname -- 客户名称
    ,custno -- 客户编号
    ,telno -- 手机号或电话号码
    ,cardno -- 卡号
    ,reserveflag -- 预约标志 0-无 1-有
    ,reserveid -- 预约ID
    ,isbill -- 是否预填单 0否 1是
    ,waittime -- 客户等待时间（分钟）
    ,transfertime -- 转移时间
    ,billno -- 填单批次号
    ,sleeptime -- 休眠更新时间
    ,assdqueueno -- 关联队列号
    ,queuecallseq -- 叫号流水
    ,queuecalltime -- 叫号时间
    ,winno -- 处理窗口号
    ,queuecalltp -- 队列号叫号类型1-普通,2-转移,3-指定叫号
    ,transfernum -- 转移次数
    ,startservtime -- 开始办理业务时间
    ,finishservtime -- 结束办理业务时间
    ,servetime -- 服务时间（秒）
    ,queuecalltlrno -- 服务实体柜员编号
    ,custphoto -- 客户照片路径
    ,tlrno -- 客户经理
    ,wddeviceno -- 穿戴设备编号
    ,queueadjtime -- 
    ,usernum -- 柜员号
    ,holidayfalg -- 节假日标识0-否 1-是
    ,custserialnum -- 客户服务流水
    ,minwaitnum -- 最小等待人数
    ,handlewinno -- 可办理窗口
    ,note1 -- 备用1
    ,note2 -- 备用2
    ,noticeflag -- 是否通知
    ,bsname -- 业务名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    workdate -- 工作日
    ,brno -- 机构编号
    ,deviceno -- 设备编号
    ,queuegetserno -- 队列号取号流水
    ,queuegetchannel -- 队列号取号渠道编号
    ,queuegettime -- 取号时间
    ,queuetppreletter -- 队列号前缀字母
    ,queuetpprenum -- 队列号数字
    ,queueno -- 队列号
    ,queuetpchkcode -- 队列号校验码
    ,queuetpstatus -- 队列号状态 0- 取号,1- 业务办理中,2-业务办理结束,3-弃号,4-转移,5-休眠
    ,bsid -- 业务ID A-个人现金, B-个人非现金, C-对公现金, D-对公非现金, E-小面额, T-特殊取号
    ,queuetpid -- 队列ID
    ,custgrd -- 客户综合评级 0-公司用户, 1-普通用户, 2-VIP用户, 3-私人银行用户, 99-特殊取号
    ,idtype -- 证件类型
    ,idcode -- 证件号码
    ,custname -- 客户名称
    ,custno -- 客户编号
    ,telno -- 手机号或电话号码
    ,cardno -- 卡号
    ,reserveflag -- 预约标志 0-无 1-有
    ,reserveid -- 预约ID
    ,isbill -- 是否预填单 0否 1是
    ,waittime -- 客户等待时间（分钟）
    ,transfertime -- 转移时间
    ,billno -- 填单批次号
    ,sleeptime -- 休眠更新时间
    ,assdqueueno -- 关联队列号
    ,queuecallseq -- 叫号流水
    ,queuecalltime -- 叫号时间
    ,winno -- 处理窗口号
    ,queuecalltp -- 队列号叫号类型1-普通,2-转移,3-指定叫号
    ,transfernum -- 转移次数
    ,startservtime -- 开始办理业务时间
    ,finishservtime -- 结束办理业务时间
    ,servetime -- 服务时间（秒）
    ,queuecalltlrno -- 服务实体柜员编号
    ,custphoto -- 客户照片路径
    ,tlrno -- 客户经理
    ,wddeviceno -- 穿戴设备编号
    ,queueadjtime -- 
    ,usernum -- 柜员号
    ,holidayfalg -- 节假日标识0-否 1-是
    ,custserialnum -- 客户服务流水
    ,minwaitnum -- 最小等待人数
    ,handlewinno -- 可办理窗口
    ,note1 -- 备用1
    ,note2 -- 备用2
    ,noticeflag -- 是否通知
    ,bsname -- 业务名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_cq_qm_queueserial_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_cq_qm_queueserial_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_cq_qm_queueserial_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_cq_qm_queueserial_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_cq_qm_queueserial_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_cq_qm_queueserial_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);