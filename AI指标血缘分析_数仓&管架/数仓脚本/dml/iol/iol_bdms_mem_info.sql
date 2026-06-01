/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_mem_info
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
drop table ${iol_schema}.bdms_mem_info_ex purge;
alter table ${iol_schema}.bdms_mem_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_mem_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_mem_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_mem_info where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_mem_info_ex(
    id -- 主键ID
    ,mem_no -- 渠道代码
    ,mem_type -- 渠道类别： MT01 银行 MT02 非银行 MT03 资管类 MT04 存托类 MT05 供应链平台 MT06 B2B平台
    ,mem_name -- 渠道名称
    ,mem_status -- 渠道状态： ST01 活动 ST02 禁用
    ,mem_bank_no -- 大额支付系统行号
    ,clear_mode -- 清算模式:  CLE001 模式一(人行清算账户) CLE002 模式二(票交所资金账户-法人会员)  CLE003 模式三(票交所资金账户-资管类会员)
    ,is_clear_check -- 是否开通结算确认
    ,settle_confirm -- 财务公司ECDS线上清算权限： 1 有 2 无
    ,last_upd_time -- 最后修改时间
    ,social_credit_no -- 统一社会信用代码
    ,bank_authy_type -- 票据业务系统上线开关： ST00 票据业务系统未上线 ST01 票据业务系统已上线不可拆分票据 ST02 票据业务系统已上线可拆分票据
    ,batch_clearing_switch -- 批量清算开关： 00 关闭 01 开启
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,last_upd_opr -- 最后操作人
    ,msg_upd_time -- 报文更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,mem_no -- 渠道代码
    ,mem_type -- 渠道类别： MT01 银行 MT02 非银行 MT03 资管类 MT04 存托类 MT05 供应链平台 MT06 B2B平台
    ,mem_name -- 渠道名称
    ,mem_status -- 渠道状态： ST01 活动 ST02 禁用
    ,mem_bank_no -- 大额支付系统行号
    ,clear_mode -- 清算模式:  CLE001 模式一(人行清算账户) CLE002 模式二(票交所资金账户-法人会员)  CLE003 模式三(票交所资金账户-资管类会员)
    ,is_clear_check -- 是否开通结算确认
    ,settle_confirm -- 财务公司ECDS线上清算权限： 1 有 2 无
    ,last_upd_time -- 最后修改时间
    ,social_credit_no -- 统一社会信用代码
    ,bank_authy_type -- 票据业务系统上线开关： ST00 票据业务系统未上线 ST01 票据业务系统已上线不可拆分票据 ST02 票据业务系统已上线可拆分票据
    ,batch_clearing_switch -- 批量清算开关： 00 关闭 01 开启
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,last_upd_opr -- 最后操作人
    ,msg_upd_time -- 报文更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_mem_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_mem_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_mem_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_mem_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_mem_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_mem_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);