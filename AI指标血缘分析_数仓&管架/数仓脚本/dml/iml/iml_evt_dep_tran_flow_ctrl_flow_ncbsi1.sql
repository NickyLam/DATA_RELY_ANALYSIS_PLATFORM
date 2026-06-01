/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_tran_flow_ctrl_flow_ncbsi1
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
drop table ${iml_schema}.evt_dep_tran_flow_ctrl_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_tran_flow_ctrl_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_tran_flow_ctrl_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_tran_flow_ctrl_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,core_flow_num -- 核心流水号
    ,chn_tran_dt -- 渠道交易日期
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,src_module_type_cd -- 源模块类型代码
    ,core_tran_org_id -- 核心交易机构编号
    ,onl_bus_proc_status_cd -- 联机业务处理状态代码
    ,intfc_serv_type_cd -- 接口服务类型代码
    ,intfc_serv_id -- 接口服务编号
    ,bus_tran_dt -- 业务交易日期
    ,tran_tm -- 交易时间
    ,bus_subclass_cd -- 业务细类代码
    ,sys_init_sub_flow_num -- 系统原始子流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_tran_flow_ctrl_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_tran_control_hist
insert into ${iml_schema}.evt_dep_tran_flow_ctrl_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,core_flow_num -- 核心流水号
    ,chn_tran_dt -- 渠道交易日期
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,src_module_type_cd -- 源模块类型代码
    ,core_tran_org_id -- 核心交易机构编号
    ,onl_bus_proc_status_cd -- 联机业务处理状态代码
    ,intfc_serv_type_cd -- 接口服务类型代码
    ,intfc_serv_id -- 接口服务编号
    ,bus_tran_dt -- 业务交易日期
    ,tran_tm -- 交易时间
    ,bus_subclass_cd -- 业务细类代码
    ,sys_init_sub_flow_num -- 系统原始子流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102039'||P1.CHANNEL_SEQ_NO||P1.SOURCE_TYPE||P1.SUB_SEQ_NO||to_char（P1.CHANNEL_DATE） -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.CHANNEL_DATE -- 渠道交易日期
    ,P1.CLIENT_NO -- 客户编号
    ,P1.REFERENCE -- 交易参考号
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,P1.ONLINE_TRAN_STATUS -- 联机业务处理状态代码
    ,nvl(trim(P1.MESSAGE_TYPE),'-') -- 接口服务类型代码
    ,P1.MESSAGE_CODE -- 接口服务编号
    ,P1.TRAN_DATE -- 业务交易日期
    ,to_timestamp(P1.TRAN_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF6') -- 交易时间
    ,nvl(trim(P1.BUSI_SUB_CLASS),'-') -- 业务细类代码
    ,P1.CUSTOMER_SEQ_NO -- 系统原始子流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_tran_control_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_tran_control_hist p1
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_tran_flow_ctrl_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_tran_flow_ctrl_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_tran_flow_ctrl_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_tran_flow_ctrl_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_tran_flow_ctrl_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_tran_flow_ctrl_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);