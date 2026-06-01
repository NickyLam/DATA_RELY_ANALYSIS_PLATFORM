/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_atms_retain_card_table
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
alter table ${itl_schema}.itl_edw_atms_retain_card_table drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_atms_retain_card_table drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_atms_retain_card_table add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_atms_retain_card_table partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,logic_id  -- 编号
    ,dev_no  -- 设备号
    ,retain_date  -- 吞卡日期
    ,retain_time  -- 吞卡时间
    ,account  -- 卡号
    ,reason  -- 原因
    ,period  -- 会计周期号
    ,card_stuck_org  -- 吞卡机构
    ,card_handle_org  -- 处理机构
    ,auto_flag  -- 自动录入标志
    ,check_op  -- 登记人
    ,check_date  -- 登记日期
    ,check_time  -- 登记时间
    ,op_no  -- 处理人
    ,op_date  -- 处理日期
    ,op_time  -- 处理时间
    ,op_address  -- 处理地点
    ,account_name  -- 客户姓名
    ,account_id  -- 客户证件号
    ,account_phome  -- 客户电话
    ,cert_type  -- 证件类型
    ,status  -- 吞卡状态
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.logic_id,chr(13),''),chr(10),'')  -- 编号
    ,replace(replace(t1.dev_no,chr(13),''),chr(10),'')  -- 设备号
    ,replace(replace(t1.retain_date,chr(13),''),chr(10),'')  -- 吞卡日期
    ,replace(replace(t1.retain_time,chr(13),''),chr(10),'')  -- 吞卡时间
    ,replace(replace(t1.account,chr(13),''),chr(10),'')  -- 卡号
    ,replace(replace(t1.reason,chr(13),''),chr(10),'')  -- 原因
    ,replace(replace(t1.period,chr(13),''),chr(10),'')  -- 会计周期号
    ,replace(replace(t1.card_stuck_org,chr(13),''),chr(10),'')  -- 吞卡机构
    ,replace(replace(t1.card_handle_org,chr(13),''),chr(10),'')  -- 处理机构
    ,replace(replace(t1.auto_flag,chr(13),''),chr(10),'')  -- 自动录入标志
    ,replace(replace(t1.check_op,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(t1.check_date,chr(13),''),chr(10),'')  -- 登记日期
    ,replace(replace(t1.check_time,chr(13),''),chr(10),'')  -- 登记时间
    ,replace(replace(t1.op_no,chr(13),''),chr(10),'')  -- 处理人
    ,replace(replace(t1.op_date,chr(13),''),chr(10),'')  -- 处理日期
    ,replace(replace(t1.op_time,chr(13),''),chr(10),'')  -- 处理时间
    ,replace(replace(t1.op_address,chr(13),''),chr(10),'')  -- 处理地点
    ,replace(replace(t1.account_name,chr(13),''),chr(10),'')  -- 客户姓名
    ,replace(replace(t1.account_id,chr(13),''),chr(10),'')  -- 客户证件号
    ,replace(replace(t1.account_phome,chr(13),''),chr(10),'')  -- 客户电话
    ,replace(replace(t1.cert_type,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 吞卡状态
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_atms_retain_card_table t1    --登录记录表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_atms_retain_card_table',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);