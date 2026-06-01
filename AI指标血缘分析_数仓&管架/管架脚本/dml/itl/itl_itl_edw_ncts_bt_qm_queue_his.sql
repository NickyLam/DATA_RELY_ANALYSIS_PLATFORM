/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_bt_qm_queue_his
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_bt_qm_queue_his partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,work_date  -- 日期格式yyyymmdd pk
    ,queue_num  -- 队列号 前缀起始位三位队列数001开始递增 pk
    ,branch  -- 机构号 pk
    ,branch_name  -- 机构名
    ,transfer_num  -- 转移次数,未转移号码为0,每转移一次递增1 从而生成多个相同排队号
    ,qm_num  -- 排队机编号
    ,qm_ip  -- 排队机ip pk
    ,queue_seq  -- 排队机取号流水
    ,softcall_teller  -- 服务实体柜员号
    ,softcall_teller_name  -- 服务实体柜员名
    ,softcall_seq  -- 软叫号流水
    ,bs_id  -- 业务id
    ,bs_name_ch  -- 业务名称(中文)
    ,queuetype_id  -- 队列id
    ,queuetype_name  -- 队列名称
    ,custtype_i  -- 内部客户类型
    ,node_id  -- 节点id
    ,win_num  -- 处理窗口号
    ,window_ip  -- 处理窗口ip
    ,queuenum_type  -- 排队号类型,1-普通,2-转移,3-预约,4-指定叫号
    ,custinfo_type  -- 证件类型
    ,custtype_name  -- 客户类型名称
    ,custinfo_num  -- 证件号码
    ,queue_status  -- 状态 0-取号 1-业务办理中 2-业务办理结束 3-弃号 4-转移
    ,en_queue_time  -- 进队时间 hhmmss
    ,de_queue_time  -- 出队时间 hhmmss
    ,start_serv_time  -- 服务开始时间 hhmmss
    ,finish_serv_time  -- 服务结束时间 hhmmss
    ,assess_status  -- 客户评价结果 0-非常满意 1-一般满意 2-不满意
    ,reserv_flag  -- 预约标志 0-无 1-有
    ,reserv_id  -- 预约id
    ,remaind_flag  -- 提醒标志 0-否 1-是
    ,remaind_phone  -- 手机号
    ,noti_waitnum  -- 前面的等待人数
    ,noti_setnum  -- 设定的通知等待人数
    ,isnotify  -- 是否已经通知 0 未通知，1 已通知
    ,isbefore  -- 是否预填单
    ,beforestatus  -- 填单状态:0-未完成；1-已完成
    ,vcalltime  -- 虚拟叫号时间
    ,vcalltime_2  -- 按等待时间计算的虚拟时间
    ,vcalltime2  -- 虚拟叫号时间2
    ,check_queue_value  -- 排队号验证码
    ,client_no  -- 客户号
    ,custlevel  -- 客户持卡最高级别
    ,assess_code  -- 评价代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.work_date,chr(13),''),chr(10),'')  -- 日期格式yyyymmdd pk
    ,replace(replace(t1.queue_num,chr(13),''),chr(10),'')  -- 队列号 前缀起始位三位队列数001开始递增 pk
    ,replace(replace(t1.branch,chr(13),''),chr(10),'')  -- 机构号 pk
    ,replace(replace(t1.branch_name,chr(13),''),chr(10),'')  -- 机构名
    ,replace(replace(t1.transfer_num,chr(13),''),chr(10),'')  -- 转移次数,未转移号码为0,每转移一次递增1 从而生成多个相同排队号
    ,replace(replace(t1.qm_num,chr(13),''),chr(10),'')  -- 排队机编号
    ,replace(replace(t1.qm_ip,chr(13),''),chr(10),'')  -- 排队机ip pk
    ,replace(replace(t1.queue_seq,chr(13),''),chr(10),'')  -- 排队机取号流水
    ,replace(replace(t1.softcall_teller,chr(13),''),chr(10),'')  -- 服务实体柜员号
    ,replace(replace(t1.softcall_teller_name,chr(13),''),chr(10),'')  -- 服务实体柜员名
    ,replace(replace(t1.softcall_seq,chr(13),''),chr(10),'')  -- 软叫号流水
    ,replace(replace(t1.bs_id,chr(13),''),chr(10),'')  -- 业务id
    ,replace(replace(t1.bs_name_ch,chr(13),''),chr(10),'')  -- 业务名称(中文)
    ,replace(replace(t1.queuetype_id,chr(13),''),chr(10),'')  -- 队列id
    ,replace(replace(t1.queuetype_name,chr(13),''),chr(10),'')  -- 队列名称
    ,replace(replace(t1.custtype_i,chr(13),''),chr(10),'')  -- 内部客户类型
    ,replace(replace(t1.node_id,chr(13),''),chr(10),'')  -- 节点id
    ,replace(replace(t1.win_num,chr(13),''),chr(10),'')  -- 处理窗口号
    ,replace(replace(t1.window_ip,chr(13),''),chr(10),'')  -- 处理窗口ip
    ,replace(replace(t1.queuenum_type,chr(13),''),chr(10),'')  -- 排队号类型,1-普通,2-转移,3-预约,4-指定叫号
    ,replace(replace(t1.custinfo_type,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.custtype_name,chr(13),''),chr(10),'')  -- 客户类型名称
    ,replace(replace(t1.custinfo_num,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.queue_status,chr(13),''),chr(10),'')  -- 状态 0-取号 1-业务办理中 2-业务办理结束 3-弃号 4-转移
    ,replace(replace(t1.en_queue_time,chr(13),''),chr(10),'')  -- 进队时间 hhmmss
    ,replace(replace(t1.de_queue_time,chr(13),''),chr(10),'')  -- 出队时间 hhmmss
    ,replace(replace(t1.start_serv_time,chr(13),''),chr(10),'')  -- 服务开始时间 hhmmss
    ,replace(replace(t1.finish_serv_time,chr(13),''),chr(10),'')  -- 服务结束时间 hhmmss
    ,replace(replace(t1.assess_status,chr(13),''),chr(10),'')  -- 客户评价结果 0-非常满意 1-一般满意 2-不满意
    ,replace(replace(t1.reserv_flag,chr(13),''),chr(10),'')  -- 预约标志 0-无 1-有
    ,replace(replace(t1.reserv_id,chr(13),''),chr(10),'')  -- 预约id
    ,replace(replace(t1.remaind_flag,chr(13),''),chr(10),'')  -- 提醒标志 0-否 1-是
    ,replace(replace(t1.remaind_phone,chr(13),''),chr(10),'')  -- 手机号
    ,replace(replace(t1.noti_waitnum,chr(13),''),chr(10),'')  -- 前面的等待人数
    ,replace(replace(t1.noti_setnum,chr(13),''),chr(10),'')  -- 设定的通知等待人数
    ,replace(replace(t1.isnotify,chr(13),''),chr(10),'')  -- 是否已经通知 0 未通知，1 已通知
    ,replace(replace(t1.isbefore,chr(13),''),chr(10),'')  -- 是否预填单
    ,replace(replace(t1.beforestatus,chr(13),''),chr(10),'')  -- 填单状态:0-未完成；1-已完成
    ,replace(replace(t1.vcalltime,chr(13),''),chr(10),'')  -- 虚拟叫号时间
    ,replace(replace(t1.vcalltime_2,chr(13),''),chr(10),'')  -- 按等待时间计算的虚拟时间
    ,replace(replace(t1.vcalltime2,chr(13),''),chr(10),'')  -- 虚拟叫号时间2
    ,replace(replace(t1.check_queue_value,chr(13),''),chr(10),'')  -- 排队号验证码
    ,replace(replace(t1.client_no,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.custlevel,chr(13),''),chr(10),'')  -- 客户持卡最高级别
    ,replace(replace(t1.assess_code,chr(13),''),chr(10),'')  -- 评价代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_ncts_bt_qm_queue_his t1    --排队系统流水信息表-历史
where 1=1  ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_bt_qm_queue_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);